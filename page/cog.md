---
title: Cog Resources
hyperjump:
    -   type: Topic
    -   id: q-register
        name: Q Register
        type: Topic
        hidden: Q
    -   id: cog-memory
        name: Cog Memory
        type: Topic
        hidden: Cog RAM Registers
---
# Cog Resources

**TODO**

## Cog Memory

Each Cog has 512 longs (= 2 kiB) of **Cog RAM**. The first 496 can be used for any purpose, the next 8 have some special purposes and the final 8 are hardware I/O registers. The normal RAM locations are also often referred to as "Registers" due to them being directly addressible by most instructions.

|Address (Dec)|Address (Hex)|Symbol|Description|
|-:|-:|:-:|-|
|0 - 495|$000-$1EF||Normal RAM|
|496|$1F0|**IJMP3**|[INT3](irq.html) call address|
|497|$1F1|**IRET3**|[INT3](irq.html) return address|
|498|$1F2|**IJMP2**|[INT2](irq.html) call address|
|499|$1F3|**IRET2**|[INT2](irq.html) return address|
|500|$1F4|**IJMP1**|[INT1](irq.html) call address|
|501|$1F5|**IRET1**|[INT1](irq.html) return address|
|502|$1F6|**PA**|Used with [CALLPA](branch.html#callpa), [CALLD](branch.html#calld) and [LOC](alu.html#loc)|
|503|$1F7|**PB**|Used with [CALLPB](branch.html#callpb), [CALLD](branch.html#calld) and [LOC](alu.html#loc)|
|504|$1F8|**PTRA**|[Pointer A](hubmem.html#pointer-expressions) register|
|505|$1F9|**PTRB**|[Pointer B](hubmem.html#pointer-expressions) register|
|506|$1FA|**DIRA**|I/O port A direction register|
|507|$1FB|**DIRB**|I/O port B direction register|
|508|$1FC|**OUTA**|I/O port A output register|
|509|$1FD|**OUTB**|I/O port B output register|
|510|$1FE|**INA**|I/O port A input register|
|511|$1FF|**INB**|I/O port B input register|

Note that the interrupt call/return locations can be used for other purposes when the respective interrupt is not in use.

Similarily, PTRA/PTRB/PA/PB are normal general-purpose registers aside from their special uses.


## Q Register

Each Cog contains a hidden "**Q**" register that is used for certain operations.

The following instructions can **set Q**:

- [SETQ](misc.html#setq) and [SETQ2](misc.html#setq2): Q is set to the given D value.
- [RDLUT](lutmem.html#rdlut): Q is set to data read from lookup memory.
- [GETXACC](streamer.html#getxacc): Q is set to the Goertzel sine accumulator value.
- [CRCNIB](alu.html#crcnib): Q is shifted left by 4 bits.
- [COGINIT](hubctrl.html#coginit)/[QDIV](cordic.html#qdiv)/[QFRAC](cordic.html#qfrac)/[QROTATE](cordic.html#qrotate): Q is set to 0 if executed without SETQ.

The current Q value can be read (ab)using [MUXQ](alu.html#muxq) as such:

~~~
    MOV    qval,#0             'reset qval
    MUXQ   qval,##$FFFFFFFF    'for each '1' bit in Q, set the same bit in qval
~~~

