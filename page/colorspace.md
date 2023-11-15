---
title: Colorspace Converter
hyperjump:
    -   type: Topic
---
# Colorspace Converter

Make color go brr.

## Instructions

<%=p2instrinfo('setcmod')%>
SETCMOD sets the CMOD register. This register has 9 bits that control the general behaviour of the colorspace converter:

|Bits |Function                 |
|:---:|-------------------------|
|0    |Sync polarity invert (mode 01 only)|
|1    |Add DAC 0 into Y term    |
|2    |Add DAC 0 into I term    |
|3    |Add DAC 0 into Q term    |
|4    |Sign-extend coefficents (zero-extend otherwise)  |
|6:5  |Mode selection           |
|7    |Reverse TMDS pin order   |
|8    |Enable TMDS mode (replaces pin outputs)|

**TODO explain modes.**


<%=p2instrinfo('setcy')%>
<%=p2instrinfo('setci')%>
<%=p2instrinfo('setcq')%>
<%=p2instrinfo('setcfrq')%>

<%p2instr_checkall :colorspace%>