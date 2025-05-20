---
title: Optimization and Coding for Speed
hyperjump:
    -   type: Topic
inline-css: |
    #memtypetbl {
        
    }
---
# Optimization and Coding for Speed
{:no_toc}

<img src="/common/construction.gif" alt="This subpage is under construction." class="dark-invert">

- placeholder
{:toc}

## High-level advice

- The compilers aren't all-powerful, don't place too much trust in them
  - Hand-written ASM is king (or queen, as it were)
- There is no hardware FPU, so design your code around integer and fixed point arithmetic
- [Multiply is about as slow as Divide, Trigonometry is fast!](cordic.html)

The rest of this page will assume a basic understanding of assembly language.

## Branching

Mind the Branch!

All [branch instructions](branch.html), when taken, consume **4 cycles** when _the target_ lies in Cog RAM or LUT RAM, twice as much as a normal instruction. They are **much slower** when the target is in Hub RAM: _At least_ **13 cycles**!!!

So the following rules of thumb emerge:

### Code placement

Code that is frequently jumped _to_ should be placed in Cog or LUT memory, whereas code that runs mostly straight through without branching can be placed in Hub memory with little penalty.

### Loops

Tight loops should always be in Cog or LUT RAM.
Use the [REP instruction](branch.html#rep) to implement the innermost loop where possible.

### \_RET\_ over RET

Where possible (no WCZ or other conditon code), use the [\_RET\_ Condition Code](branch.html#ret-condition-code) where possible instead of the [RET instruction](https://p2docs.github.io/branch.html#ret) - this saves 2 cycles!

## Arithmetic

### Avoiding QMUL

When multiplying small values, use the ALU's [MUL](alu.html#mul) and [MULS](alu.html#muls) instructions. These only perform 16x16 multiplication, but they are _much_ quicker than the CORDIC unit's [QMUL](cordic.html#qmul) instruction.

When multiplying by powers of two, use the bit-shift instructions! (that's an old hat, isn't it?)

In cases where latency matters, it is often better to construct a larger multiply from multiple MUL(S) and/or shift operations. See also: [32x16 multiply idiom](idiom.html#x16-multiply)

### CORDIC pipelining (Easy Mode)

[GETQX](cordic.html#getqx) (and GETQY) can take a very long time (**up to 58 cycles!**) when used immediately after a CORDIC operation has been submitted. Luckily, you don't have to put up with that! Since the CORDIC unit operates independently in the background, any amount of other work you can do between submitting the command and grabbing the result subtracts from GETQX's blocking time. [It's free real estate!](https://github.com/totalspectrum/spin2cpp/pull/222). If the result is already available, GETQX takes the minimum 2 cycles.

~~~
        QMUL a,b
        RDLONG ur ' <- this instruction executes "for free" ...
        GETQX c   ' ...because this one has to wait less for its data to become available
~~~

### CORDIC pipelining (Advanced Mode)

The CORDIC unit allows submitting a command **every 8 cycles**. This means that multiple commands can be in flight at once. (They don't have to be the same kind of command, either). This can cause a huge increase in performance! But take care: The CORDIC X/Y result buffers **only hold one value**. If you don't grab a result in time, it will be **overwritten!**. So it becomes important to mind the cycle counts!

Slow and nasty:

~~~
        QMUL a,b
        GETQX v
        QMUL c,d
        GETQX w
~~~

The same thing, but almost **twice as fast** with overlapped instructions:

~~~
        QMUL a,b
        QMUL c,d
        GETQX v
        GETQX w
~~~

Due to the aforementioned 8-cycle rhythm, the second QMUL and GETQX in the above example will each have 6 additional wait cycles in which other work could be done:

~~~
        QMUL a,b
        WAITX #6-2 ' <- do other work here (6 cycles = 3 instructions!!!)
        QMUL c,d
        WAITX #46-2 ' <- do other work here (TODO verify max safe cycle count here)
        GETQX v
        WAITX #6-2 ' <- do other work here
        GETQX w
~~~

(of course only 4 cycles are available if both GETQX and GETQY are used)

### CORDIC pipelining (HARDCORE MODE)

The true master class. Pipelined CORDIC operations in loops. It becomes very important to maintain exact cycle counts and alignments.
To hide the initial latency, the loop needs to be pre-heated, i.e. the inital commands need to be sent before the loop proper (and conversely, extra results are left unused afterwards, but this is usually not a problem: **TODO** document precise GETQX blocking behaviour).

A basic example might look like

~~~
        ' Pre-heat
        QDIV rasL,rasZ
        ADD rasL,stepL
        ADD rasZ,stepZ
        WAITX #56-8-2 ' Waiting the right amount of time here is essential!
        ' actual loop
        REP @.loop,#123
        QDIV rasL,rasZ
        GETQX perpL
        ADD rasL,stepL
        ADD rasZ,stepZ
        WAITX #56-8-2

.loop
        ' loop is left with dummular processing in progredd
~~~

**TODO more on this and verify the example**

## Memory access

With 3 different memory types (4 if [external PSRAM](psram.html) is considered), it is not always obviosu to decide which should be used.
The following table tries (and likely fails) to explain the strengths and weaknesses in short:

|      |Cog RAM   |LUT RAM|Hub RAM|Ext. PSRAM (on P2EDGE)|
|------|:----------:|:-------:|:-------:|:----------:|
|Size  |2016 bytes<br>(as 504 longs)|2048 bytes<br>(as 504 longs)|512 KiB|32 MiB|
|Special Feature|Can be directly used as operands.|Can be synchronized between pairs of Cogs. ([SETLUTS](lutmem.html#setluts))<br>Can hold streamer lookup data.<br>Can hold XBYTE tables.|Fast block transfers.<br>Fast FIFO interface.<br>Byte-masked writes ([WMLONG](hubmem.html#wmlong))|HUGE!|
|Code Execution|YES|YES|YES<br>(slow branches, FIFO tied up)|**NO**|
|Random Read|4 cycles (with MOV or GETBYTE/etc)<br>2 cycles (ALTS immediately consumed)|3 cycles (RDLUT)|**9..17 cycles** (RDLONG)<br>2 cycles (**FIFO**)<br>4+(13) cycles (RDFAST random access trick, see below)|~100 cylces (depends on implementation)|
|Random Write|4 cycles (with MOV or SETBYTE/etc)<br>2 cycles (ALTD/ALTR from operation)|2 cycles (WRLUT)|**3..11 cycles** (WRLONG)<br>2 cycles (**FIFO**)<br>4 cycles (RDFAST random access trick, see below)|~80 cylces (depends on implementation)|
|Block copy<br>**to Cog RAM**|**SLOW**<br>4\*N cycles (REP/ALTI/MOV)<br>2\*N cycles (Hub round-trip)|**SLOW**<br>5\*N cycles (REP/ALTD/RDLUT)<br>2\*N cycles (Hub round-trip)|**FAST**<br>1\*N cylces (SETQ+RDLONG)|N/A|
|Block copy<br>**to LUT RAM**|**SLOW**<br>4\*N cycles (REP/ALTS/WRLUT)<br>2\*N cycles (Hub round-trip)|**SLOW**<br>5\*N cycles (REP/RDLUT/WRLUT)<br>2\*N cycles (Hub round-trip)|**FAST**<br>1\*N cylces (SETQ2+RDLONG)|N/A|
|Block copy<br>**to Hub RAM**|**FAST**<br>1\*N cycles (SETQ+WRLONG)|**FAST**<br>1\*N cycles (SETQ2+WRLONG)|**SLOW**<br>(must round-trip through Cog/LUT, 2\*N cycles _asymptotically_)|4\*N cycles (Streamer DMA)|
{: #memtypetbl}


Note 1: Block copy speeds are given for N **longs** and without setup overhead. All copies involving Hub RAM incur the usual latency, etc.

This really doesn't tell the whole story, but hopefully hints at the complexity enough for you to start forming your own mental model.

### Avoid Hub stacks

[CALLA](branch.html#calla) and [RETA](branch.html#reta) (and their PTRB equivalents) should be avoided.

### Use the FIFO!

The [FIFO](fifo.html) allows quick reading or writing of sequential data streams in Hub RAM by buffering the data and thus hiding the bus latency.
It should always be used for such when possible. Do keep in mind that branching to code in Hub RAM (HUBEXEC) always resets the FIFO state!

#### RFVAR

The [RFVAR](fifo.html#rfvar) and [RFVARS](fifo.html#rfvars) instructions allow natively reading a variable-length integer format from the FIFO. _There are no corresponding write instructions_. Do with that knowledge what you will.

#### FIFO random access trick

While the FIFO is designed for sequential access, using the **non-blocking mode** of RDFAST/WRFAST, even random access can be accelerated beyond the regular Hub access instructions. FIFO operations also have fully stable timing, so it's easier to time them alongside, e.g. CORDIC operations.

The key is to do other work while the FIFO performs memory access in the background. Here this is illustrated by WAITX instructions, but to reap the benefits, this time must be filled with **useful non-memory instructions**. (Other Hub RAM access is not allowed! See also: [RDFAST Startup Bug](errata.html#rdfast-startup-bug)). Exceeding the neccessary wait time is fine and causes no problems.

Writing is easy:

~~~
        WRFAST bit31, address
        WFBYTE data
        WAITX #10-2 ' wait for it to get flushed (TODO: verify minimum safe timing)
~~~

Reading is trickier, since **reading the data too early will cause zeroes to be read**:

~~~
        RDFAST bit31, address
        WAITX #13-2 ' wait for FIFO to become ready, 13 cycles.
        RDBYTE data
~~~

In either case a constant (named `bit31` by convention) must be created in Cog RAM:

~~~
bit31   long 1<<31
~~~

This trick has proven itself to be essential to super-heavy random read use-cases such as texture mapping.
