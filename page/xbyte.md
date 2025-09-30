---
title: Bytecode Engine (XBYTE)
hyperjump:
    -   type: Topic
---
# Bytecode Engine (XBYTE)

**TODO Improve text**

Bytecodes go brr.

Cogs can execute custom bytecodes from hub RAM using XBYTE. XBYTE is like a phantom instruction and it executes on a hardware stack return ([RET](branch.html#ret)/[\_RET\_](branch.html#ret-condition-code)) to `$1FF`. Such a return does not pop the stack, so that each additional RET/\_RET\_ causes another bytecode to be fetched and executed. This process has a total overhead of only 6 clocks, excluding the bytecode routine. The bytecode routine could be as short as a single 2-clock instruction with a \_RET\_ prefix, making the total XBYTE loop take only 8 clocks.

XBYTE performs the following steps to make a complete bytecode executor:

|Cycle|Phase|XBYTE activity                              |Description                                |
|:---:|:---:|--------------------------------------------|-------------------------------------------|
|1    |go   |RFBYTE bytecode<br>SKIPF #0                 |_Last clock of the RET/\_RET\_ to $1FF_<br>**Fetch bytecode from FIFO (initialized via prior RDFAST).**<br>**Cancel any SKIPF pattern in progress (from prior bytecode).**|
|2    |get  |MOV PA,bytecode<br>RDLUT (computed address) |_1st clock of 1st canceled instruction_<br>**Write bytecode to PA ($1F6).**<br>**Read lookup-table RAM according to bytecode and mode.**|
|3    |go   |RDLUT (data -> D)                           |_2nd clock of 1st canceled instruction_<br>**Get lookup RAM long into D for EXECF.**|
|4    |get  |EXECF D (begin)                             |_1st clock of 2nd canceled instruction_<br>**Execute EXECF.**|
|5    |go   |GETPTR PB<br>(Set flags)<br>EXECF D (branch)|_2nd clock of 2nd canceled instruction_<br>**Write FIFO pointer to PB ($1F7).**<br>**Write C,Z with bit1,bit0 of RDLUT address, if enabled.**<br>**Do EXECF branch.**|
|6    |get  |(Flush pipeline)                            |_1st clock of 3rd canceled instruction_|
|7    |go   |(Reload pipeline)                           |_2nd clock of 3rd canceled instruction_|
|8    |get  |(done)                                      |_1st clock of 1st instruction of bytecode routine_<br>**Loop to clock 1 if \_RET\_ or RET.**|

The bytecode translation table in LUT memory must consist of long data which [EXECF](branch.html#execf) would use, where the 10 LSBs are an address to jump to in cog/LUT RAM and the 22 MSBs are a [SKIPF](branch.html#skipf) pattern to be applied.

Starting XBYTE and establishing its operating mode is done all at once by a  `_RET_ SETQ {#}D` instruction, with the top of the hardware stack holding $1FF.

Additional `_RET_ SETQ {#}D` instructions can be executed to alter the XBYTE mode for subsequent bytecodes.

To alter the XBYTE mode for the next bytecode, only, a `_RET_ SETQ2 {#}D` instruction can be executed. This is useful for engaging singular bytecodes from alternate sets, without having to restore the original XBYTE mode afterwards.


|Bits|SETQ/SETQ2<br>D value|LUT base<br>address|LUT index<br>(b = bytecode)|LUT EXECF<br>address|
|:--:|:-------------------:|:-----------------:|:--------------------------|:------------------:|
|8   |%A000000xF           |%A00000000         |I = b[7:0]                 |%AIIIIIIII          |
|8   |%ABBBB00xF<br>(%BBBB > 0)|%A00000000     |if b[7:4] <&nbsp; %BBBB then I = b[7:0]<br>if b[7:4] >= %BBBB then I = b[7:4] - %BBBB|%AIIIIIIII<br>%ABBBBIIII|
|7   |%AAxx0010F           |%AA0000000         |I = b[6:0]                 |%AAIIIIIII          |
|7   |%AAxx0011F           |%AA0000000         |I = b[7:1]                 |%AAIIIIIII          |
|6   |%AAAx1010F           |%AAA000000         |I = b[5:0]                 |%AAAIIIIII          |
|6   |%AAAx1011F           |%AAA000000         |I = b[7:2]                 |%AAAIIIIII          |
|5   |%AAAAx100F           |%AAAA00000         |I = b[4:0]                 |%AAAAIIIII          |
|5   |%AAAAx100F           |%AAAA00000         |I = b[7:3]                 |%AAAAIIIII          |
|4   |%AAAAA110F           |%AAAAA0000         |I = b[3:0]                 |%AAAAAIIII          |
|4   |%AAAAA111F           |%AAAAA0000         |I = b[7:4]                 |%AAAAAIIII          |

The `%ABBBB00xF` setting allows sets of 16 bytecodes, which would use identical LUT values, to be represented by a single LUT value, effectively compressing blocks of 16 LUT values into single LUT values. This is useful when the bytecode, which is always written to PA, is used as an operand within the bytecode routine.

The `%F` bit of the SETQ/SETQ2 {#}D value enables C and Z to receive bits 1 and 0 of the index field of the bytecode. This is useful for having the flags differentiate behavior within a bytecode routine, especially in cases of conditional looping, where a SKIPF pattern would have been insufficient, on its own:

|SETQ/SETQ2<br>D value|Flag Writing                            |
|:-------------------:|----------------------------------------|
|%xxxxxxxx0           |Do not affect flags on XBYTE            |
|%xxxxxxxx1           |Write the bytecode index LSBs to C and Z|

To start executing bytecodes, use the following instruction sequence, but with the appropriate SETQ operand:

~~~
        PUSH    #$1FF       'push #$1FF onto the hardware stack
_RET_   SETQ    #$100       '256-long EXECF table at LUT $100, start XBYTE
~~~
