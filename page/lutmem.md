---
title: LUT Memory
hyperjump:
    -   type: Topic
        hidden: LUT RAM
    -   id: lut-sharing
        name: LUT Sharing
        type: Topic
---

# LUT Memory

Each of the Propeller 2's Cogs has 512 longs (=2 kiB) of "Lookup RAM".

Note that [Pointer Expressions](hubmem.html#pointer-expressions) can also be used in LUT memory.

## LUT Sharing

Pairs of even/odd cogs can "share" their LUT memory.

**TODO**

## Instructions


<%=p2instrinfo('rdlut')%>
<%=p2instrinfo('wrlut')%>
<%=p2instrinfo('setluts')%>

<%p2instr_checkall :lutmem%>