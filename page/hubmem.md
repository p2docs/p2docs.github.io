---
title: Hub Memory
hyperjump:
    -   type: Topic
        hidden: Hub RAM
    -   id: hub-timing
        name: Hub Memory Timing
        type: Topic
    -   id: block-transfers
        name: Block Transfers
        type: Topic
        hidden: setq rdlong setq wrlong
    -   id: pointer-expressions
        name: Pointer Expressions
        type: Topic
        hidden: --PTRB[]PTRA++[]ptrx
---

# Hub Memory
<iframe class="float-right" src="diagram-eggbeater.html" style="border:none;width:400px;max-width:100%;aspect-ratio:400/500"></iframe>

**TODO: I suck at writing these**

The Propeller 2 features 512 kiB of "Hub RAM" that is shared between all cogs. The architecture allows for up to 1024 kiB, but this additional space is unused in the current chip. Hub RAM is addressed in bytes, but an entire long (4 aligned bytes) can be read or written at once.

To facilitate the sharing of the memory, a round-robin access scheme is used. On each cycle, each cog has the potential to access a different "slice" of memory, consisting of all addresses where `(A>>2)&7 == N`. On the following cycle, the access windows "rotate" and each cog has access to the logically following slice.

## Block Transfers
{:.anchor}

TODO


## Pointer Expressions
{:.anchor}

TODO: Say something

|Encoding |Syntax        |Accessed Address  |Post-Modify        |
|---------|--------------|------------------|-------------------|
|1x0000000|PTRx          |PTRx              |                   |
|1x0iiiiii|PTRx[INDEX6]  |PTRx + INDEX*SCALE|                   |
|1x1100001|PTRx++        |PTRx,             |PTRx += SCALE      |
|1x1111111|PTRx--        |PTRx,             |PTRx -= SCALE      |
|1x1000001|++PTRx        |PTRx + SCALE,     |PTRx += SCALE      |
|1x1011111|--PTRx        |PTRx - SCALE,     |PTRx -= SCALE      |
|1x110NNNN|PTRx++[INDEX5]|PTRx,             |PTRx += INDEX*SCALE|
|1x111nnnn|PTRx--[INDEX5]|PTRx,             |PTRx -= INDEX*SCALE|
|1x100NNNN|++PTRx[INDEX5]|PTRx + INDEX*SCALE|PTRx += INDEX*SCALE|
|1x101nnnn|--PTRx[INDEX5]|PTRx - INDEX*SCALE|PTRx -= INDEX*SCALE|

- `SCALE` is 1 for BYTE and LUT operations, 2 for WORD operations and 4 for LONG operations. When using an augmented operand (##/AUGS), SCALE is always 1.
- The index value for `PTRx[INDEX6]` (denoted `iiiiii`) is a 6-bit value and can thus can range from -32 to 31.
- The index value for inc/dec expressions (denoted `0NNNN` or `1nnnn`) is a 5-bit signed value with a special case wherein `00000` means 16. It can thus range from 1 to 16 in either positive or negative direction.

## Hub Timing
{:.anchor}

Reading from Hub RAM takes at least **9 cycles**. Writing to Hub RAM takes at least **3 cycles**.

Up to 7 cycles are added to wait for relevant slice's access slot.

An additional cycle is added if the access crosses a long boundary. (i.e. any unaligned long access or a word access to the last byte of a long).

**TODO: Examples of optimal timing (research involved)**


<%=floatclear%>

## Instructions

<%=p2instrinfo('rdlong')%>
<%=p2instrinfo('rdword')%>
<%=p2instrinfo('rdbyte')%>
<%=p2instrinfo('wrlong')%>
<%=p2instrinfo('wrword')%>
<%=p2instrinfo('wrbyte')%>
<%=p2instrinfo('wmlong')%>
Very spicy!

## Alias Instructions

<%=p2instrinfo('pusha')%>
PUSHA is an alias for [WRLONG {#}D,**PTRA++**](#wrlong).

<%=p2instrinfo('pushb')%>
PUSHB is an alias for [WRLONG {#}D,**PTRB++**](#wrlong).

<%=p2instrinfo('popa')%>
POPA is an alias for [RDLONG D,**--PTRA**](#rdlong).

<%=p2instrinfo('popb')%>
POPB is an alias for [RDLONG D,**--PTRB**](#rdlong).

<%p2instr_checkall :hubmem%>