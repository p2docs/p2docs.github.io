---
title: Interrupts
hyperjump:
    -   type: Topic
        hidden: IRQ
---
# Interrupts

Brain hurt.

<img src="/common/construction.gif" alt="This subpage is under construction." class="dark-invert">

The Propeller 2 features a 3-level interrupt system (int1 through int3), plus a "hidden" debugger interrupt (int0). Lower level interrupts take priority over higher-level interrupts.

**TODO further explain interrupt vectors/returns**

## Setup Instructions

<%=p2instrinfo('setint1')%>
<%=p2instrinfo('setint2',joinup:true)%>
<%=p2instrinfo('setint3',joinup:true)%>
SETINTx configures which [Event ID](event.html) triggers the respective interrupt based on **D**estination. An event ID of zero (or `INT_OFF`) disables the interrupt (`EVENT_INT` is not available).

## Control Instructions


<%=p2instrinfo('allowi')%>
<%=p2instrinfo('stalli')%>
<%=p2instrinfo('trgint1')%>
<%=p2instrinfo('trgint2',joinup:true)%>
<%=p2instrinfo('trgint3',joinup:true)%>
<%=p2instrinfo('nixint1')%>
<%=p2instrinfo('nixint2',joinup:true)%>
<%=p2instrinfo('nixint3',joinup:true)%>

## Interrupt Returns

<%=p2instrinfo('reti0')%>
<%=p2instrinfo('reti1',joinup:true)%>
<%=p2instrinfo('reti2',joinup:true)%>
<%=p2instrinfo('reti3',joinup:true)%>
**TODO**

RETI0, RETI1, RETI2 and RETI3 are used to return from the respective interrupt. The next time the intterupt is triggered, it will start again from the current value of IJMPx.

Technically aliases for [CALLD INB,IRETx WCZ](branch.html#calld-s). Use of the CALLD opcode with IRETx registers has the side-effect of clearing the interrupt state.


<%=p2instrinfo('resi0')%>
<%=p2instrinfo('resi1',joinup:true)%>
<%=p2instrinfo('resi2',joinup:true)%>
<%=p2instrinfo('resi3',joinup:true)%>
**TODO**

RESI0, RESI1, RESI2 and RETS3 are used to "resume" from the respective interrupt. The next time the intterupt is triggered, it will continue execution at the instruction _after_ the RESIx instruction.

Technically aliases for [CALLD IJMPx,IRETx WCZ](branch.html#calld-s). Use of the CALLD opcode with IRETx registers has the side-effect of clearing the interrupt state.

## Debug-Related

<%=p2instrinfo('brk')%>

BRK is used to programmatically trigger a debug interrupt. The value of D is latched and can be used by the debugger code.

**NOTE:** This instruction can not be used with a condition code. See the [relvant errata entry](errata.html#brk-ignores-condition-code).

<%=p2instrinfo('getbrk')%>
<%=p2instrinfo('cogbrk')%>

<%p2instr_checkall :irq%>