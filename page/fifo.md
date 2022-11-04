---
title: Hub FIFO
hyperjump:
    -   type: Topic
---
# Hub FIFO

Each Cog possesses a FIFO (First-In-First-Out) queue that can be used to read or write sequential data from/to [Hub RAM](hubmem.html).

It can either be used to feed the [Streamer](streamer.html), to execute code from Hub RAM (HubExec) or manually using the RFxxxx and WRxxxx instructions.

## Control Instructions

<%=p2instrinfo('rdfast')%>
<%=p2instrinfo('wrfast')%>
<%=p2instrinfo('fblock')%>
<%=p2instrinfo('getptr')%>

## Read Instructions

<%=p2instrinfo('rflong')%>
<%=p2instrinfo('rfword')%>
<%=p2instrinfo('rfbyte')%>
<%=p2instrinfo('rfvar')%>
<%=p2instrinfo('rfvars')%>

## Write Instructions

<%=p2instrinfo('wflong')%>
<%=p2instrinfo('wfword')%>
<%=p2instrinfo('wfbyte')%>

Very spicy!


<%p2instr_checkall :fifo%>