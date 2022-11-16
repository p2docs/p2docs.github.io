---
title: Register Indirection
hyperjump:
    -   type: Topic
---

# Register Indirection

TODO: Explain pipeline quirks and general concept

## Simple Indirection

<%=p2instrinfo('alts')%>
ALTS inserts (**S**ource + **D**estination) & $1FF into the pipeline in place of the next instruction's **S**ource _field_ (i.e. the given address or immediate). The next instruction is not modified in RAM. Additionally, after the indirection, the signed value in **S**ource[17:9] is summed into **D**estination.

ALTS can be used to index into an Array in [Cog Memory](cog.html#cog-memory), with **S**ource being the base address (and optionally, auto-increment amount) and **D**estination being the index.

ALTS' **S**ource can be omitted, in which case it defaults to `#0`.


<%=p2instrinfo('altd')%>
ALTD inserts (**S**ource + **D**estination) & $1FF into the pipeline in place of the next instruction's **D**estination _field_ (i.e. the given address or immediate). The next instruction is not modified in RAM. Additionally, after the indirection, the signed value in **S**ource[17:9] is summed into **D**estination.

ALTD can be used to index into an Array in [Cog Memory](cog.html#cog-memory), with **S**ource being the base address (and optionally, auto-increment amount) and **D**estination being the index.

ALTD's **S**ource can be omitted, in which case it defaults to `#0`.

<%=p2instrinfo('altr')%>
ALTR inserts (**S**ource + **D**estination) & $1FF into the pipeline in place of the next instruction's "Result Field", which is normally always equal to the **D**estination field. This allows the result of an instruction to be written to a location other than its given **D**estination. Additionally, after the indirection, the signed value in **S**ource[17:9] is summed into **D**estination.

ALTR can be used to index into an Array in [Cog Memory](cog.html#cog-memory), with **S**ource being the base address (and optionally, auto-increment amount) and **D**estination being the index.

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