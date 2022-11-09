---
title: Events
hyperjump:
    -   type: Topic
---
# Events

Brain hurt.

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
