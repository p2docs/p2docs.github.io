---
title: I/O Pins
hyperjump:
    -   type: Topic
---

# I/O Pins

**TODO**


## Diagram
<img src="pin-diagram.png">

**TODO: Transparent version**

## I/O Instructions
<%=p2instrinfo('drvl')%>
<%=p2instrinfo('drvh')%>
<%=p2instrinfo('drvnot')%>
<%=p2instrinfo('drvrnd')%>
<%=p2instrinfo('drvc')%>
<%=p2instrinfo('drvnc')%>
<%=p2instrinfo('drvz')%>
<%=p2instrinfo('drvnz')%>

<%=p2instrinfo('fltl')%>
<%=p2instrinfo('flth')%>
<%=p2instrinfo('fltnot')%>
<%=p2instrinfo('fltrnd')%>
<%=p2instrinfo('fltc')%>
<%=p2instrinfo('fltnc')%>
<%=p2instrinfo('fltz')%>
<%=p2instrinfo('fltnz')%>

<%=p2instrinfo('outl')%>
<%=p2instrinfo('outh')%>
<%=p2instrinfo('outnot')%>
<%=p2instrinfo('outrnd')%>
<%=p2instrinfo('outc')%>
<%=p2instrinfo('outnc')%>
<%=p2instrinfo('outz')%>
<%=p2instrinfo('outnz')%>

<%=p2instrinfo('dirl')%>
<%=p2instrinfo('dirh')%>
<%=p2instrinfo('dirnot')%>
<%=p2instrinfo('dirrnd')%>
<%=p2instrinfo('dirc')%>
<%=p2instrinfo('dirnc')%>
<%=p2instrinfo('dirz')%>
<%=p2instrinfo('dirnz')%>


<%=p2instrinfo('testp')%>
<%=p2instrinfo('testpn',joininstr:true)%>
<%=p2instrinfo('testp-and',joininstr:true)%>
<%=p2instrinfo('testpn-and',joininstr:true)%>
<%=p2instrinfo('testp-or',joininstr:true)%>
<%=p2instrinfo('testpn-or',joininstr:true)%>
<%=p2instrinfo('testp-xor',joininstr:true)%>
<%=p2instrinfo('testpn-xor',joininstr:true)%>



## Smart Pin Instructions

**TODO: AKPIN is an alias??????**

<%=p2instrinfo('wrpin')%>
<%=p2instrinfo('wxpin')%>
<%=p2instrinfo('wypin')%>
<%=p2instrinfo('rdpin')%>
<%=p2instrinfo('rqpin')%>

<%=p2instrinfo('akpin')%>
AKPIN is an alias for [WRPIN **#1**,{#}S](#wrpin) **TODO**


## Other

<%=p2instrinfo('setdacs')%>
<%=p2instrinfo('setscp')%>
<%=p2instrinfo('getscp')%>

<%p2instr_checkall :pin%>
