---
title: Cog Resources
hyperjump:
    -   type: Topic
    -   id: q-register
        name: Q Register
        type: Topic
---
# Cog Resources

**TODO**

## Q Register

Each CPU contains a hidden "**Q**" register that is used for certain operations.

The following instructions can **set Q**:

- [SETQ](misc.html#setq) and [SETQ2](misc.html#setq2): Q is set to the given D value.
- [RDLUT](lutmem.html#rdlut): Q is set to data read from lookup memory.
- [GETXACC](streamer.html#getxacc): Q is set to the Goertzel sine accumulator value.
- [CRCNIB](alu.html#crcnib): Q is shifted left by 4 bits.
- [COGINIT](hubctrl.html#coginit)/[QDIV](cordic.html#qdiv)/[QFRAC](cordic.html#qfrac)/[QROTATE](cordic.html#qrotate): Q is set to 0 if executed with cleared "SETQ Flag"

The current Q value can be read (ab)using [MUXQ](alu.html#muxq) as such:

~~~
    MOV	   qval,#0             'reset qval
    MUXQ   qval,##$FFFFFFFF    'for each '1' bit in Q, set the same bit in qval
~~~

