---
title: Register Indirection
hyperjump:
    -   type: Topic
---

# Register Indirection

TODO: Explain pipeline quirks and general concept

## Simple Indirection

<%=p2instrinfo('alts')%>
ALTS modifies the next instruction's **S**ource _field_ to be (**S**ource + **D**estination) & $1FF. Whether the next instruction's **S**ource is an address or an immediate is not affected. Additionally, after the indirection, the signed value in **S**ource[17:9] is summed into **D**estination.

ALTS' **S**ource can be omitted, in which case it defaults to `#0`.


<%=p2instrinfo('altd')%>
ALTD modifies the next instruction's **D**estination _field_ to be (**S**ource + **D**estination) & $1FF. Whether the next instruction's **S**ource is an address or an immediate is not affected. Additionally, after the indirection, the signed value in **S**ource[17:9] is summed into **D**estination.

ALTD's **S**ource can be omitted, in which case it defaults to `#0`.

<%=p2instrinfo('altr')%>
ALTR modifies the next instruction's "Result field" to be (**S**ource + **D**estination) & $1FF. This allows the result of an instruction to be written to a register other than it's **D**estination. Additionally, after the indirection, the signed value in **S**ource[17:9] is summed into **D**estination.

ALTR's **S**ource can be omitted, in which case it defaults to `#0`.


## Sub-long Indirection

<%=p2instrinfo('altb')%>
<%=p2instrinfo('altgn')%>
<%=p2instrinfo('altsn')%>
<%=p2instrinfo('altgb')%>
<%=p2instrinfo('altsb')%>
<%=p2instrinfo('altgw')%>
<%=p2instrinfo('altsw')%>

## Complex Indirection

<%=p2instrinfo('alti')%>


<%p2instr_checkall :indir%>