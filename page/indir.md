---
title: Register Indirection
hyperjump:
    -   type: Topic
        hidden: ALT
    -   id: order-of-prefix-instructions
        name: Order of Prefix Instructions
        type: Topic
---

# Register Indirection

TODO: Explain pipeline quirks and general concept

## Order of Prefix Instructions
{:.anchor}

When multiple prefix instructions (ALTx,[AUGS](misc.html#augs),[AUGD](misc.html#augd),[SETQ](misc.html#setq)) are used, the correct order is as follows:

 - SETQ or SETQ2 first
 - Then AUGS and/or AUGD
 - Then any ALTx
 - Finally, the main instruction

**Caution: hardware bug! When ALTx is used with an immediate Source, a preceding AUGS will affect _both_ the ALTx _and_ the main instruction!**

## Simple Indirection

<%=p2instrinfo('alts')%>
ALTS inserts (**S**ource + **D**estination) & $1FF into the pipeline in place of the next instruction's **S**ource _field_ (i.e. the given **S**ource address or immediate). The next instruction is not modified in RAM. Additionally, after the indirection, the signed value in **S**ource[17:9] is summed into **D**estination.

ALTS can be used to index into an Array in [Cog Memory](cog.html#cog-memory), with **S**ource being the base address (and optionally, auto-increment amount) and **D**estination being the index.

ALTS' **S**ource can be omitted, in which case it defaults to `#0`.


<%=p2instrinfo('altd')%>
ALTD inserts (**S**ource + **D**estination) & $1FF into the pipeline in place of the next instruction's **D**estination _field_ (i.e. the given **D**estination address or immediate). The next instruction is not modified in RAM. Additionally, after the indirection, the signed value in **S**ource[17:9] is summed into **D**estination.

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

**MEGA ULTRA MECHA TODO**

In the meantime, from Chip's doc:

~~~
S/# = %rrr_ddd_sss_RRR_DDD_SSS

%rrr		Result register field D[27..19] increment/decrement masking
%ddd		D register field D[17..9] increment/decrement masking
%sss		S register field D[8..0] increment/decrement masking

%rrr/%ddd/%sss:
000 = 9 bits increment/decrement (default, full span)
001 = 8 LSBs increment/decrement (256-register looped buffer)
010 = 7 LSBs increment/decrement (128-register looped buffer)
011 = 6 LSBs increment/decrement (64-register looped buffer)
100 = 5 LSBs increment/decrement (32-register looped buffer)
101 = 4 LSBs increment/decrement (16-register looped buffer)
110 = 3 LSBs increment/decrement (8-register looped buffer)
111 = 2 LSBs increment/decrement (4-register looped buffer)

%RRR		result register / instruction modification:
000 = D[27..19] stays same, no result register substitution
001 = D[27..19] stays same, but result register writing is canceled
010 = D[27..19] decrements per %rrr, no result register substitution
011 = D[27..19] increments per %rrr, no result register substitution
100 = D[27..19] sets next instruction's result register, stays same
101 = D[31..18] substitutes into next instruction's [31..18] (execute D)
110 = D[27..19] sets next instruction's result register, decrements per %rrr
111 = D[27..19] sets next instruction's result register, increments per %rrr

%DDD		D field modification:
x0x = D[17..9] stays same
x10 = D[17..9] decrements per %ddd
x11 = D[17..9] increments per %ddd
0xx = no D field substitution
1xx = D[17..9] substitutes into next instruction's D field [17..9]

%SSS		S field modification:
x0x = D[8..0] stays same
x10 = D[8..0] decrements per %sss
x11 = D[8..0] increments per %sss
0xx = no S field substitution
1xx = D[8..0] substitutes into next instruction's S field [8..0]

~~~

<%p2instr_checkall :indir%>