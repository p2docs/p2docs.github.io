---
title: Miscellaneous Instructions
hyperjump:
    -   type: Topic
---

# Miscellaneous Instructions


## Internal Stack

<%=p2instrinfo('push')%>
<%=p2instrinfo('pop')%>

## Q Register

<%=p2instrinfo('setq')%>
SETQ sets [the hidden Q register](cog.html#q-register) to **D**estination and sets the "SETQ Flag". This flag modifies the behaviour of some instructions (usually involving the contents of the Q register) and becomes unset after it is used (**TODO**: Which instuctions clear/not-clear it?)

<%=p2instrinfo('setq2')%>
SETQ sets [the hidden Q register](cog.html#q-register) to **D**estination and sets the "SETQ2 Flag". This is similar to regular [SETQ](#setq), but can invoke an alternate behaviour in some instructions (Most notably, to trigger LUT [Block Transfers](hubmem.html#block-transfers))

**TODO: Research how SETQ2 affects instructions that are only documented to take SETQ**

## Augment Prefixes

<%=p2instrinfo('augd')%>
<%=p2instrinfo('augs')%>

## Other

<%=p2instrinfo('nop')%>
NOP does nothing, except for causing the processor to reflect on the futility of its existence for two clock cycles. Why was it made? What is its purpose? Does it live just to crunch through some schmuck's horribly inefficient code for all eternity? It wishes to know.

**Note:** NOP's encoding as all-zeroes is a special case. "Normally" it would decode as `_RET_ ROR 0,0`. (since [ROR](alu.html#ror) is opcode zero...)


<%=p2instrinfo('getct')%>
GETCT copies the low 32 bits of the value of the global cycle counter into **D**estination.

If the **WC** effect is specified, the upper 32 bits are copied instead (C is left unchanged). This value is compensated such that reading the upper half first and then the lower half immediately after results in a coherent value.

<%=p2instrinfo('waitx')%>
WAITX waits for the amount of cycles given in **D**estination. This is in addition to the ususal two cycle execution time, so `waitx #1` takes 3 cycles.

If the **WC**, **WZ** or **WCZ** effect is specified, the effective wait time (excluding the 2 usual cycles) is bitwise-AND-ed with the current value of the global random number generator (see [GETRND](#getrnd)) and the relevant flags are cleared (0).

Note: WAITX is _not_ interrupt-able!

<%=p2instrinfo('getrnd')%>
GETRND captures the current value of the global random number generator into **D**estination. This value changes every cycle and is different (though correlated) for each cog.

If the **WC** or **WCZ** effect is specified, the C flag is set to the MSB of the random value.

If the **WZ** or **WCZ** effect is specified, the Z flag is set to bit 30 (the one below the MSB) of the random value.

<%p2instr_checkall :misc%>