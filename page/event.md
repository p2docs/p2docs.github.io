---
title: Events
hyperjump:
    -   type: Topic
---
# Events

Brain hurt.

|Event|ID|Set when|Cleared by<br>(in addition to POLL/WAIT/J/JN)|
|---------|-:|-|-|
|EVENT_INT| 0|Interrupt occurs (except debug)||
|EVENT_CT1| 1|CT1 target reached|ADDCT1|
|EVENT_CT2| 2|CT2 target reached|ADDCT2|
|EVENT_CT3| 3|CT3 target reached|ADDCT3|
|EVENT_SE1| 4|SE1 selected event occurs|SETSE1|
|EVENT_SE2| 5|SE2 selected event occurs|SETSE2|
|EVENT_SE3| 6|SE3 selected event occurs|SETSE3|
|EVENT_SE4| 7|SE4 selected event occurs|SETSE4|
|EVENT_PAT| 8|Pattern match/mismatch occurs|SETPAT|
|EVENT_FBW| 9|FIFO Block wrapped|WRFAST,RDFAST,FBLOCK|
|EVENT_XMT|10|Streamer ready for command|XINIT,XZERO,XCONT|
|EVENT_XFI|11|Streamer runs out of commands|XINIT,XZERO,XCONT|
|EVENT_XRO|12|Streamer NCO rolls over|XINIT,XZERO,XCONT|
|EVENT_XRL|13|Streamer reads LUT address $1FF||
|EVENT_ATN|14|[COGATN](#cogatn) attention strobe occurs||
|EVENT_QMT|15|[GETQX](cordic.html#getqx)/[GETQY](cordic.html#getqy) executes without any CORDIC results available or in progress.||

## Setup Instructions

<%=p2instrinfo('setse1')%>
<%=p2instrinfo('setse2',joinup:true)%>
<%=p2instrinfo('setse3',joinup:true)%>
<%=p2instrinfo('setse4',joinup:true)%>
**TODO**

<%=p2instrinfo('addct1')%>
<%=p2instrinfo('addct2',joinup:true)%>
<%=p2instrinfo('addct3',joinup:true)%>
ADDCT1, ADDCT2, or ADDCT3 set the hidden CT1, CT2, or CT3 event trigger register (respectively) to the value of **D**estination + **S**ource. The result is also written to **D**estination.

The respective CTx event flag is set when the trigger register matches the bottom 32 bits of the global CT counter.

**TODO: Doesn't this instr clear the respective event flag?**

**TODO: More detail**

<%=p2instrinfo('setpat')%>

## Attention

<%=p2instrinfo('cogatn')%>
COGATN strobes the attention signal for one or more cogs. **D**estination bit positions 7:0 represent cogs 7 through 0; high (1) bits indicate the cog(s) to signal. The receiving cog(s) will have their ATN event flag set, and can use any of the attention monitor instructions ([JATN](branch.html#jatn), [JNATN](branch.html#jnatn), [POLLATN](#pollatn), [WAITATN](#waitatn)) or [interrupts](irq.html) to respond and clear the flag.

~~~
        COGATN #%00100010
~~~

In the intended use case, the cog receiving an attention request knows which other cog is strobing it and how to respond. In cases where multiple cogs may request the attention of a single cog, some messaging structure may need to be implemented in Hub RAM to differentiate requests. (**TODO: Perhaps mention lock SEs?**)


## Poll Instructions

<% P2Opdata::EVENTS.each_with_index do |ev,i| %>
<%=p2instrinfo("poll#{ev}",joinup:i!=0)%>
<%end%>

## Wait Instructions

<% P2Opdata::EVENTS.each_with_index do |ev,i| %>
<%next if ev=="qmt"%>
<%=p2instrinfo("wait#{ev}",joinup:i!=0)%>
<%end%>

<%p2instr_checkall :event%>
