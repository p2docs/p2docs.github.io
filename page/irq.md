---
title: Interrupts
hyperjump:
    -   type: Topic
        hidden: IRQ
---
# Interrupts

Brain hurt.

## Setup Instructions

<%=p2instrinfo('setint1')%>
<%=p2instrinfo('setint2',joinup:true)%>
<%=p2instrinfo('setint3',joinup:true)%>

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

Technically an alias for [CALLD INB,IRETx WCZ](branch.html#calld-s).


<%=p2instrinfo('resi0')%>
<%=p2instrinfo('resi1',joinup:true)%>
<%=p2instrinfo('resi2',joinup:true)%>
<%=p2instrinfo('resi3',joinup:true)%>
**TODO**

Technically an alias for [CALLD IJMPx,IRETx WCZ](branch.html#calld-s).

## Debug-Related

<%=p2instrinfo('brk')%>
<%=p2instrinfo('getbrk')%>
<%=p2instrinfo('cogbrk')%>

<%p2instr_checkall :irq%>