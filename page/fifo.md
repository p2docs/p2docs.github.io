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
RDFAST prepares the FIFO queue to read from the address given in **S**ource. Additionally, if **D**estination[13:0] is non-zero, it is used as a count of 64-byte blocks after which the FIFO read address wraps back around. If this is used, the address in **S**ource must be long-aligned.

Normally, RDFAST will block while the FIFO completes any pending writes and fills up with read data, but if **D**estination[31] is set, it doesn't. Attempting to use the FIFO while it is not yet ready may result in garbled data.

**TODO reword more detail**


<%=p2instrinfo('wrfast')%>
WRFAST prepares the FIFO queue to write to the address given in **S**ource. Additionally, if **D**estination[13:0] is non-zero, it is used as a count of 64-byte blocks after which the FIFO read address wraps back around. If this is used, the address in **S**ource must be long-aligned.

Normally, WRFAST will block while the FIFO completes any pending writes, but if **D**estination[31] is set, it doesn't. Attempting to use the FIFO while it is not yet ready may result in garbled data.

**TODO reword more detail**

<%=p2instrinfo('fblock')%>
FBLOCK sets the next wrap address and length for the FIFO queue.

**TODO**


<%=p2instrinfo('getptr')%>
GETPTR gets the current FIFO address (from/to which the next data will be read/written) into **D**estination.

**TODO: I think this only works right with RFxxxx/WFxxxx and XBYTE? (i.e. not with streamer or hubexec)**

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


<%p2instr_checkall :fifo%>