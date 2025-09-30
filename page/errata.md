---
title: Hardware Bugs & Errata
hyperjump:
    -   type: Topic
---

# Hardware Bugs & Errata
{:.no_toc}

This is a list of known hardware bugs in the current Propeller 2 Hardware (P2X8C4M64P Rev. C)
All titles/headings are tenative.

- placeholder
{:toc}

## Incorrect PTRx update on Block Transfer with ALTx or AUGD

Intervening ALTx/AUGS/AUGD instructions between SETQ/SETQ2 and RDLONG/WRLONG/WMLONG-PTRx instructions will cancel the special-case block-size PTRx deltas. The expected number of longs will transfer, but PTRx will only be modified according to normal PTRx expression behavior:

~~~
	SETQ	#16-1		'ready to load 16 longs
	ALTD	start_reg	'alter start register (ALTD cancels block-size PTRx deltas)
	RDLONG	0,ptra++	'ptra will only be incremented by 4 (1 long), not 16*4 as anticipated!!!
~~~

(from official docs)

## ALTS + AUGS bug

Intervening ALTx instructions with an immediate #S operand, between AUGS and the AUGS' intended target instruction (which would have an immediate #S operand), will use the AUGS value, but not cancel it. So, the intended AUGS target instruction will use and cancel the AUGS value, as expected, but the intervening ALTx instruction will also use the AUGS value (if it has an immediate #S operand). To avoid problems in these circumstances, use a register for the S operand of the ALTx instruction, and not an immediate #S operand.

~~~
	AUGS	#$FFFFF123	'This AUGS is intended for the ADD instruction.
	ALTD	index,#base	'Look out! AUGS will affect #base, too. Use a register, instead.
	ADD	0-0,#$123	'#$123 will be augmented by the AUGS and cancel the AUGS.
~~~

(from offical docs)

## Crystal Oscillator crosstalk

When using a passive crystal oscillator across XO/XI, it is possible to introduce clock glitches by outputting high-frequency digital signals on the P28..P31 I/O group.

Can be worked around by using an active oscillator part instead.

See [forum post](https://forums.parallax.com/discussion/comment/1520712/#Comment_1520712)

## RDFAST startup bug

When [RDFAST](fifo.html#rdfast) is used in no-wait mode (**D**estination[31] set), other hub memory instructions like [RDLONG](hubmem.html#rdlong) can behave in unexpected ways while the FIFO is starting up in the background. It appears that read instructions can skip execution entirely.

See also: [Bypassing DEBUG protection](https://forums.parallax.com/discussion/175960/yes-a-silicon-bug-bypassing-debug-protection)

## Dual-Port RAM simultaneous read+write Hazard

The dual-port RAM blocks making up [Cog RAM](cog.md) can, when the same memory location is read and written at the same time, return an inderminate value to the reading port, where some bits belong to the newly written value and some belong to the previous one.
This effect depends on the exact RAM cell used and the current clock frequency.

In particular, this simultaneous read+write conditon is created in Cog RAM by self-modifying code with **exactly one** other instruction between the modification and the instruction being modified:

~~~
        SETD .x,#123 ' ----\
        NOP          '     | SETD result written on same cycle as ADD opcode fetch!!!
.x      ADD 0-0,#1 ' <-----/
~~~

This pattern is _very common_ in P1 code, so take care when porting!

## BRK ignores condition code

The [BRK](irq.html#brk) instruction always triggers an interrupt, regardless of any condition code applied to it.
If the condition code is false however, the break code in **D**estination is NOT latched and the previous value is retained.
Other cases where a BRK instruction is cancelled in the pipeline, such as a set [SKIP](branch.html#skip) bit or being placed after a taken branch do correctly avoid triggering the interrupt.

## Composite video encoder design flaws

While generally functional and of decent quality, there are a few issues affecting the composite video encoder (part of the [Colorspace Converter](colorspace.html)) that make it less than ideal.

### DAC range issue

The `P_DAC_75R_2V` 75Ω DAC mode only provides a 1V peak-to-peak range. This is ideal for a luminance+sync signal (as in S-Video/YPbPr/SoG), but composite modulation can exceed that range. In particular, 100% saturated yellow _should_ have its modulation peak slightly above white level.
This can be worked around by using the higher-impedance `P_DAC_124R_3V` mode.

### Clamping issue

None of the colorspace operations are internally clamped, including the final sum of luma+chroma in the composite video path.
Can be worked around by careful choice of coefficients.

### No simultaneous RGB+Composite video mode

This would be required for a spec-compliant SCART output.

### No crosstalk filter

Lack of luma/chroma crosstalk filters causes excessive dot crawl and false color artifacts.
Could be worked around by using S-Video mode in conjunction with external analog filters (untested).

