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
SETQ sets the hidden Q register to **D**estination and sets the "SETQ Flag". This flag modifies the behaviour of some instructions (usually involving the contents of the Q register) and becomes unset after it is used (**TODO**: Which instuctions clear/not-clear it?)

[MUXQ](alu.html#muxq) uses the Q register regardless of the current value of the "SETQ Flag".

<%=p2instrinfo('setq2')%>
SETQ sets the hidden Q register to **D**estination and sets the "SETQ2 Flag". This is similar to regular [SETQ](#setq), but can invoke an alternate behaviour in some instructions (Most notably, to trigger LUT [Block Transfers](hubmem.html#block-transfers))

**TODO: Research how SETQ2 affects instructions that are only documented to take SETQ**

## Augment Prefixes

<%=p2instrinfo('augd')%>
<%=p2instrinfo('augs')%>

## Other

<%=p2instrinfo('nop')%>
NOP does nothing, except for causing the processor to reflect on the futility of its existence for two clock cycles. Why was it made? What is its purpose? Does it live just to crunch through some schmuck's horribly inefficient code for all eternity? It wishes to know.

**Note:** NOP's encoding as all-zeroes is a special case. "Normally" it would decode as `_RET_ ROR 0,0`. (since [ROR](alu.html#ror) is opcode zero...)


<%=p2instrinfo('getct')%>
<%=p2instrinfo('waitx')%>
<%=p2instrinfo('getrnd')%>


<%p2instr_checkall :misc%>