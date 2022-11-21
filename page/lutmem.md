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
{:.anchor}

Pairs of even/odd cogs can "share" their LUT memory. When this feature is enabled in the _even_ cog, all _writes_ the _odd_ cog does to its LUT memory are also applied to the _even_ cog's LUT. The same applies in the other direction if the _odd_ cog enables LUT sharing. The previous contents of either LUT are not affected. LUT sharing should not be enabled in a cog that is simultaneously using the LUT for [Streamer](streamer.html) purposes (Lookup or DDS modes).

**TODO: What happens if both cogs write the same location simultaneously?**

## LUT block transfers

It is possible to quickly transfer blocks of data between Hub and LUT memories. See [Block Transfers](hubmem.html#block-transfers).

## Instructions

<%=p2instrinfo('rdlut')%>
RDLUT reads the LUT memory location addressed by **S**ource or a [pointer expression](hubmem.html#pointer-expressions) into **D**estination (and as a side effect, also the [Q Register](cog.html#q-register)). Only the bottom 9 bits of the effective address are considered, the rest are ignored.

If the **WC** or **WCZ** effect is specified, the C flag is set to the MSB of the read value.

If the **WZ** or **WCZ** effect is specified, the Z flag is set (1) if the read value equals zero, or is cleared (0) if it is non-zero.

<%=p2instrinfo('wrlut')%>
WRLUT writes **D**estination into the LUT memory location addressed by **S**ource or a [pointer expression](hubmem.html#pointer-expressions). Only the bottom 9 bits of the effective address are considered, the rest are ignored.

<%=p2instrinfo('setluts')%>
SETLUTS configures a cog's LUT memory. If **D**estination[0] is set, [LUT Sharing](#lut-sharing) is enabled (and disabled otherwise). Other bits are currently unused and should probably be kept as zero.

<%p2instr_checkall :lutmem%>