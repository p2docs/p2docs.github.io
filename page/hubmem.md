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
        hidden: --PTRB[]PTRA++[]ptrx Indexing
---

# Hub Memory
<iframe class="float-right" src="diagram-eggbeater.html" style="border:none;width:400px;max-width:100%;aspect-ratio:400/500"></iframe>

The Propeller 2 features 512 kiB of "Hub RAM" that is shared between all cogs. The architecture allows for up to 1024 kiB, but this additional space is unused in the current chip. Hub RAM is addressed in bytes, but an entire long (4 aligned bytes) can be read or written at once. All larger-than-byte memory operations are little-endian.

To facilitate the sharing of the memory, a round-robin access scheme is used. On each cycle, each cog has the potential to access a different "slice" of memory, consisting of all addresses where `(A>>2)&7 == N`. On the following cycle, the access windows "rotate" and each cog has access to the logically following slice.

**TODO: I suck at writing these**

## Block Transfers
{:.anchor}

By preceding [RDLONG](#rdlong) with either [SETQ](misc.html#setq) or [SETQ2](misc.html#setq2), multiple hub RAM longs can be read into either [Cog RAM](cog.html#cog-memory) or [Lookup RAM](lutmem.html). This transfer happens at the rate of one long per cycle, assuming the [hub FIFO interface](fifo.html) is not accessing the same hub RAM slice as RDLONG, on the same cycle, in which case the FIFO gets priority access and the block move must wait 8 cycles(?? TODO) for the hub RAM slice to come around again. If WC/WZ/WCZ are used with RDLONG, the flags will be set according to the last long read in the sequence.

Use [SETQ](misc.html#setq)+RDLONG to read multiple hub longs into cog register RAM:

~~~
    SETQ    #x                      'x = number of longs, minus 1, to read
    RDLONG  first_reg,S/#/PTRx      'read x+1 longs starting at first_reg
~~~

Use [SETQ2](misc.html#setq2)+RDLONG to read multiple hub longs into cog lookup RAM:

~~~
    SETQ2   #x                      'x = number of longs, minus 1, to read
    RDLONG  first_lut,S/#/PTRx      'read x+1 longs starting at first_lut
~~~
(TODO: LUT addressing is kinda curious, elaborate)

Similarly, [WRLONG](#wrlong) and [WMLONG](#wmlong) can be preceded by either [SETQ](misc.html#setq) or [SETQ2](misc.html#setq2) to write either multiple register RAM longs or lookup RAM longs into hub RAM. When WRLONG/WMLONG‘s **D**estination field is an immediate, it instead writes that immediate value to RAM, functioning as a memory filler. (**TODO I think I recall fill doesn't work with SETQ2**)

Use SETQ+WRLONG/WMLONG to write multiple register RAM longs into hub RAM:

~~~
    SETQ    #x                      'x = number of longs, minus 1, to write
    WRLONG  first_reg,S/#/PTRx      'write x+1 longs starting at first_reg
~~~

Use SETQ2+WRLONG/WMLONG to write multiple lookup RAM longs into hub RAM:

~~~
    SETQ2   #x                      'x = number of longs, minus 1, to write
    WRLONG  first_lut,S/#/PTRx      'write x+1 longs starting at first_lut
~~~

(TODO: LUT addressing is kinda curious, elaborate)

Use SETQ+WRLONG to fill multiple longs of hub RAM:

~~~
    SETQ    #x                      'x = number of longs, minus 1, to write
    WRLONG  ##$89ABCDEF,S/#/PTRx    'write x+1 longs of $89ABCDEF
~~~

For block transfers, [PTRx expressions](#pointer-expressions) cannot have arbitrary index values, since the index will be overridden with the number of longs. Only unindexed increment/decrement modes are allowed.

## Pointer Expressions
{:.anchor}

Instead of using a normal **S**ource register to provide the address, most Hub (and [LUT](lutmem.html)) access instructions allow a "pointer expression", using the PTRA or PTRB registers with an offset and/or automatic increment/decrement.

**TODO: More**

|Encoding |Syntax        |Accessed Address  |Post-Modify        |Block Transfers|
|---------|--------------|------------------|-------------------|---------------|
|0IIIIIIII|#immediate    |immediate         |                   |Valid          |
|1x0000000|PTRx          |PTRx              |                   |Valid          |
|1x0iiiiii|PTRx[INDEX6]  |PTRx + INDEX*SCALE|                   |Not Valid      |
|1x1100001|PTRx++        |PTRx,             |PTRx += SCALE      |Valid          |
|1x1111111|PTRx--        |PTRx,             |PTRx -= SCALE      |Valid          |
|1x1000001|++PTRx        |PTRx + SCALE,     |PTRx += SCALE      |Valid          |
|1x1011111|--PTRx        |PTRx - SCALE,     |PTRx -= SCALE      |Valid          |
|1x110NNNN|PTRx++[INDEX5]|PTRx,             |PTRx += INDEX*SCALE|Not Valid      |
|1x111nnnn|PTRx--[INDEX5]|PTRx,             |PTRx -= INDEX*SCALE|Not Valid      |
|1x100NNNN|++PTRx[INDEX5]|PTRx + INDEX*SCALE|PTRx += INDEX*SCALE|Not Valid      |
|1x101nnnn|--PTRx[INDEX5]|PTRx - INDEX*SCALE|PTRx -= INDEX*SCALE|Not Valid      |

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
RDLONG reads a long (32 bits) from the 4 consecutive Hub memory locations addressed by **S**ource or a [pointer expression](hubmem.html#pointer-expressions) into **D**estination. Only the bottom 20 bits of the effective address are considered, the rest are ignored. Unaligned reads are possible, but carry a one-cycle penalty. (See [Hub Timing](#hub-timing))

If the **WC** or **WCZ** effect is specified, the C flag is set to the MSB (bit 31) of the read value.

If the **WZ** or **WCZ** effect is specified, the Z flag is set (1) if the read value equals zero, or is cleared (0) if it is non-zero.

If prefixed with SETQ or SETQ2, a [block transfer](#block-transfers) is initiated.

<%=p2instrinfo('rdword')%>
RDWORD reads a word (16 bits) from the 2 consecutive Hub memory locations addressed by **S**ource or a [pointer expression](hubmem.html#pointer-expressions) into **D**estination (the upper 16 bits are set to zeroes). Only the bottom 20 bits of the effective address are considered, the rest are ignored. Unaligned reads are possible, but carry a one-cycle penalty if the word crosses a long boundary (i.e. the bottom two bits of the effective address are both set). (See [Hub Timing](#hub-timing))

If the **WC** or **WCZ** effect is specified, the C flag is set to the MSB (bit 15) of the read value.

If the **WZ** or **WCZ** effect is specified, the Z flag is set (1) if the read value equals zero, or is cleared (0) if it is non-zero.

RDWORD cannot initiate block transfers.

<%=p2instrinfo('rdbyte')%>
RDBYTE reads a byte (8 bits) from the Hub memory location addressed by **S**ource or a [pointer expression](hubmem.html#pointer-expressions) into **D**estination (the upper 24 bits are set to zeroes). Only the bottom 20 bits of the effective address are considered, the rest are ignored.

If the **WC** or **WCZ** effect is specified, the C flag is set to the MSB (bit 7) of the read value.

If the **WZ** or **WCZ** effect is specified, the Z flag is set (1) if the read value equals zero, or is cleared (0) if it is non-zero.

RDBYTE cannot be used for block transfers.

<%=p2instrinfo('wrlong')%>
WRLONG writes the 32 bits of **D**estination into the 4 consecutive Hub memory locations addressed by **S**ource or a [pointer expression](hubmem.html#pointer-expressions). Only the bottom 20 bits of the effective address are considered, the rest are ignored. Unaligned writes are possible, but carry a one-cycle penalty. (See [Hub Timing](#hub-timing))

If prefixed with SETQ or SETQ2, a [block transfer](#block-transfers) is initiated.

<%=p2instrinfo('wrword')%>
WRWORD writes the bottom 16 bits of **D**estination into the 2 consecutive Hub memory locations addressed by **S**ource or a [pointer expression](hubmem.html#pointer-expressions). Only the bottom 20 bits of the effective address are considered, the rest are ignored. Unaligned writes are possible, but carry a one-cycle penalty if the word crosses a long boundary (i.e. the bottom two bits of the effective address are both set). (See [Hub Timing](#hub-timing))

WRWORD cannot be used for block transfers.

<%=p2instrinfo('wrbyte')%>
WRBYTE writes the bottom 8 bits of **D**estination into the Hub memory location addressed by **S**ource or a [pointer expression](hubmem.html#pointer-expressions). Only the bottom 20 bits of the effective address are considered, the rest are ignored.

WRBYTE cannot be used for block transfers.

<%=p2instrinfo('wmlong')%>
WMLONG functions identically to [WRLONG](#wrlong), except that if any of the 4 bytes to be written is zero, that byte is not written and the previous value remains in memory. This is useful for masked blitting operations.

If prefixed with SETQ or SETQ2, a [block transfer](#block-transfers) is initiated.

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