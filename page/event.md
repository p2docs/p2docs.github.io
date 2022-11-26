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

## Selectable Events
Each cog can track up to four selectable [pin](#Pin), [LUT](#LUT), or [Hub-lock](#Hub-lock) events.  This is accomplished by using the following SETSEx instruction

### Setup Instructions

<%=p2instrinfo('setse1')%>
<%=p2instrinfo('setse2',joinup:true)%>
<%=p2instrinfo('setse3',joinup:true)%>
<%=p2instrinfo('setse4',joinup:true)%>
SETSEn D/# accepts the following configuration values:
#### Pin
%001_PPPPPP = INA/INB bit of pin %PPPPPP rises
%010_PPPPPP = INA/INB bit of pin %PPPPPP falls
%011_PPPPPP = INA/INB bit of pin %PPPPPP changes

%10x_PPPPPP = INA/INB bit of pin %PPPPPP is low
%11x_PPPPPP = INA/INB bit of pin %PPPPPP is high

#### LUT
You can select $1FC..$1FF for the LUT read or write address event sensitivity with bits AA.
%000_00_00AA = this cog reads LUT address %1_1111_11AA
%000_00_01AA = this cog writes LUT address %1_1111_11AA
%000_00_10AA = odd/even companion cog reads LUT address %1_1111_11AA
%000_00_11AA = odd/even companion cog writes LUT address %1_1111_11AA

####Hub-lock
%000_01_LLLL = hub lock %LLLL rises
%000_10_LLLL = hub lock %LLLL falls
%000_11_LLLL = hub lock %LLLL changes

## Setup Instructions
<%=p2instrinfo('addct1')%>
<%=p2instrinfo('addct2',joinup:true)%>
<%=p2instrinfo('addct3',joinup:true)%>
ADDCT1, ADDCT2, or ADDCT3 must be used to establish a global CT counter target. This is done by first using 'GETCT D' to get the current CT value into a register, and then using ADDCTx to add **S**ource into that register. The result is also written to the hidden CT1, CT2, or CT3 event trigger register as target value. 
The respective CTx event flag is set when the trigger register matches the bottom 32 bits of the global CT counter.
By executing the ADDCTx-instruction the CTn flag is cleared to help with initialization and cycling.

<%=p2instrinfo('setpat')%>
Set pin pattern for 'Pattern match/mismatch' event. **C** flag selects INA/INB, **Z** flag selects match/mismatch, **D** provides mask value, **S** provides match value.
**TODO: More detail**

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
