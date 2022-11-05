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

Note that [Pointer Expressions](hubmem.html#pointer-expressions) can also be used for LUT memory operations.

## LUT Sharing

Pairs of even/odd cogs can "share" their LUT memory. When this feature is enabled in the _even_ cog, all _writes_ the _odd_ cog does to its LUT memory are also applied to the _even_ cog's LUT. The same applies in the other direction if the _odd_ cog enables LUT sharing. The previous contents of either LUT are not affected. LUT sharing should not be enabled in a cog that is simultaneously using the LUT for [Streamer](streamer.html) purposes.

**TODO: What happens if both cogs write the same location simultaneously?**

## Instructions


<%=p2instrinfo('rdlut')%>
<%=p2instrinfo('wrlut')%>
<%=p2instrinfo('setluts')%>

<%p2instr_checkall :lutmem%>