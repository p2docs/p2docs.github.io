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
<%=p2instrinfo('setint2',joininstr:true)%>
<%=p2instrinfo('setint3',joininstr:true)%>

## Control Instructions


<%=p2instrinfo('allowi')%>
<%=p2instrinfo('stalli')%>
<%=p2instrinfo('trgint1')%>
<%=p2instrinfo('trgint2',joininstr:true)%>
<%=p2instrinfo('trgint3',joininstr:true)%>
<%=p2instrinfo('nixint1')%>
<%=p2instrinfo('nixint2',joininstr:true)%>
<%=p2instrinfo('nixint3',joininstr:true)%>

## Interrupt Returns

<%=p2instrinfo('reti0')%>
<%=p2instrinfo('reti1',joininstr:true)%>
<%=p2instrinfo('reti2',joininstr:true)%>
<%=p2instrinfo('reti3',joininstr:true)%>


<%=p2instrinfo('resi0')%>
<%=p2instrinfo('resi1',joininstr:true)%>
<%=p2instrinfo('resi2',joininstr:true)%>
<%=p2instrinfo('resi3',joininstr:true)%>

## Debug-Related

<%=p2instrinfo('brk')%>
<%=p2instrinfo('getbrk')%>
<%=p2instrinfo('cogbrk')%>

<%p2instr_checkall :irq%>