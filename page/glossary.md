---
title: Glossary
hyperjump:
    -   type: Topic
        hidden: Terms
---
# Glossary of Terms
{:.no_toc}

<img src="/common/construction.gif" alt="This subpage is under construction." class="dark-invert">

**Please raise an issue if there's any term you feel is missing here!**

- placeholder
{:toc}

## Boot ROM
{:.anchor}

The 16 KiB of mask ROM in the Propeller 2. This is not directly accessible, but when the chip starts up, it is copied into the last 16K of Hub RAM.

This contains:
 - The serial boot loader
 - The stage-0 flash boot loader
 - The SD card boot loader
 - The [TAQOZ](#taqoz) FORTH interpreter
 - The monitor program

**TODO:** further information on boot methods and built-in code.

## Catalina
{:.anchor}

Catalina is an ANSI C compiler (and much more) for the Propeller 1 and 2 by Ross Higson. It features limited self-hosting capability on the Propeller 2.

Check it out at its [Forum thread](https://forums.parallax.com/discussion/174158/catalina-ansi-c-and-lua-for-the-propeller-1-2/p1). 

## Cog
{:.anchor}

Cogs are the independent parallel processing units of the Propeller chips.

Each Propeller 2 cog, of which there are **eight**, contains:

 - a CPU
 - a block of Cog RAM
 - a block of [LUT RAM](#lut)
 - a [FIFO buffer](#fifo)
 - a [Streamer](#streamer)
 - a [Colorspace Converter](#colorspace-converter)
 - an interface to the [Hub](#hub) and the I/O Pins.

Each cog is independent from the others. It's execution can only be disturbed by the special-purpose [COGSTOP](hubctrl.html#cogstop) and [COGBRK](irq.html#cogbrk) instructions or conflicts over shared resources such as Hub RAM or I/O Pins.  
The Cog CPU's timing is fully deterministic and suitable for implementing hard real-time systems.


### Cog RAM
{:.anchor}

Cog RAM (also sometimes referred to as "register RAM") is the main local memory area in each Cog. It is addressed as 512 x 32-bit longwords. The last 8 locations are used as I/O registers and another 8 are used as special-purpose locations (Interrupt vectors and returns, etc), leaving 496 regular Cog RAM locations.

Cog RAM locations can be used directly as D/S operands for instructions. Code can also be stored in Cog RAM.

### COGEXEC
{:.anchor}

A Cog is in COGEXEC mode when it is executing code from [Cog RAM](#cog-ram) or [LUT RAM](#lut), as opposed to [HUBEXEC](#hubexec). This is generally the faster and more flexible execution mode, but code size is limited.

A Cog can freely switch between COGEXEC and HUBEXEC using regular branch instructions.

## Colorspace Converter
{:.anchor}

The colorspace converter is a hardware unit in each [Cog](#cog) that is designed to encode raw RGB data from the [Streamer](#streamer) into various common video formats, including VGA, NTSC/PAL composite video, YPbPr, HDMI and more.

See also: [CSC documentation](colorspace.html)

## FastSpin
{:.anchor}

Historical name of [FlexSpin](#flexspin) before version 5.0.0

## FCACHE

FCACHE is a technique employed by high-level language compilers (notably [FlexSpin](#flexspin)) to combine the benefits of [COGEXEC](#cogexec) and [HUBEXEC](#hubexec)/[LMM](#lmm) modes by dynamically copying code loops from [Hub RAM](#hub-ram) to [Cog RAM](#cog-ram) for faster execution.

## FIFO
{:.anchor}

**TODO**

See also: [FIFO documentation](fifo.html)

## FlexSpin
{:.anchor}

FlexSpin is a Spin1/Spin2/C/BASIC multi-language compiler by Eric Smith for Propeller 1 and 2. It features a best-in-class optimizing PASM backend, multi-language interactions (e.g. call Spin code from C and vice versa) and many useful language extensions.

Check out the [forum thread](https://forums.parallax.com/discussion/164187/flexspin-compiler-for-p2-assembly-spin-basic-and-c-in-one-compiler/p1) and [GitHub](https://github.com/totalspectrum/spin2cpp).

(It shares most of it's codebase with [spin2cpp](#spin2cpp), which came first, so that's what the Git repo is called)


### FlexC
{:.anchor}

The C dialect used by FlexSpin is sometimes called "FlexC". There also exists a `flexcc` alternative frontend to the compiler that attempts to be more CLI-compatible with other C compilers. But all frontends accept all languages.

## FlexProp
{:.anchor}

FlexProp is the official GUI IDE for [FlexSpin](#flexspin). However, you can also use the compiler as a standalone CLI tool.

Check out the [forum thread](https://forums.parallax.com/discussion/170730/flexprop-a-complete-programming-system-for-p2-and-p1/p1) and [GitHub](https://github.com/totalspectrum/flexprop).

## Hub
{:.anchor}

The Hub refers to all the resources that are shared between all cogs.

The Propeller 2's Hub contains:
 - 512 KiB of [Hub RAM](#hub-ram)
 - 16 lock bits
 - a 64-bit global cycle counter
 - a free-running PRNG (see: [GETRND](misc.html#getrnd))
 - The clock/PLL unit

(The [Smart Pins](#smart-pin) are generally not consided part of the Hub, even though they are shared as well).

Generally when referring to doing something "in Hub", the Hub RAM is what's being referred to.

### Hub RAM
{:.anchor}

**TODO**

### HUBEXEC
{:.anchor}

A Cog is in HUBEXEC mode when it is executing code from [Hub RAM](#hub-ram), as opposed to [COGEXEC](#cogexec). This mode allows larger code size, but disables certain features (most notably the [FIFO](#fifo)) and branches execute very slowly.

A Cog can freely switch between COGEXEC and HUBEXEC using regular branch instructions.

## loadp2
{:.anchor}

## LUT
{:.anchor}

LUT is short for "Look-up Table". On the Propeller 2, each [Cog](#cog) has a block of "LUT RAM".
This memory is organized as 512 x 32 bit longwords, similar to [Cog RAM](#cog-ram).

LUT RAM can be used in multiple ways:

 - As a lookup table for [XBYTE](#xbyte).
 - As a lookup table for certain [Streamer](#streamer) modes.
 - As additional [COGEXEC](#cogexec)-mode code storage. (this is most common)
 - Manually using [RDLUT](lutmem.html#rdlut) and [WRLUT](lutmem.html#wrlut) instructions.

## LMM
{:.anchor}

LMM means "Large Memory Model". This is a technique used on the Propeller 1 to achieve something similar to [HUBEXEC](#hubexec) (which does not exist on the P1).
On the P2 native HUBEXEC is available and the memory model is always "large".

## OBEX
{:.anchor}

**TODO**

[OBEX](https://obex.parallax.com)

## P2 / P1
{:.anchor}

Shorthand abbreviations for the Propeller 2 and [the original Propeller chip](#propeller-1).

## P2D2
{:.anchor}

Early P2 board by Peter Jakacki. No longer in production.

**TODO:** maybe put a picure

## P2docs
{:.anchor}

This very webpage (currently hosted at `p2docs.github.io`) that you are reading right now. It is written and maintained by community member Wuerfel_21 and placed under the watchful guard of the bootleg [Reimu](reimu.html) plushie.

P2docs is open to your contributions [on GitHub](https://github.com/p2docs/p2docs.github.io)! Feel free to raise issues or contribute content!  
(Imagine here, a standard-issue disclaimer here about how GitHub is owned by the generally odious, nasty and dispicable MicroSoft and our usage of the GitHub service is not an endorsement thereof)

## P2 EDGE
{:.anchor}

Also known by it's part number "P2EC", **TODO**

**TODO:** maybe put a picure

## P2 EVAL
{:.anchor}

The EVAL board... TODO

**TODO:** maybe put a picure

## P2Hot
{:.anchor}

Retronym for an early Propeller 2 design that was ultimately scrapped due to having unacceptably high power draw and heat dissapation. This was around April 2014, so any Propeller 2 discussions prior to that most likely refer to this scrapped design.

Approximately no one calls the actual [Propeller 2](#propeller-2) "P2Cool", though it is very (figuratively) cool.

## P2STAMP
{:.anchor}

### P2SwAP
{:.anchor}

## PNut
{:.anchor}

**TODO:** URL

## Propeller 1
{:.anchor}

Retronym for the first Propeller chip from 2006.
It is not directly compatible with the Propeller 2, but many of it's design principles have been carried over.
It is still produced and well-supported.
You can find it's excellent manual [re-hosted here](documents.html#p1-manual).

## Propeller 2
{:.anchor}

The Propeller 2 chip from Parallax. This whole page is dedicated to documenting it's oddball architecture. **TODO**

There exist 3 revisions of the Propeller 2 chip:

 - **Rev.A** is an obsolote preproduction sample. It is only found on Rev.A [EVAL boards](#p2-eval). All other boards (even if the _board_ is Rev.A of its type) contain Rev.C (or very rarely Rev.B) chips.
 - **Rev.B** is a full respin to fix bugs found in Rev. A and add some last-minute features.
 - **Rev.C** is the final production chip. The only change from Rev. B is to disable/modify an ADC-related feature that was causing crosstalk issues.

## Propeller Tool
{:.anchor}

**TODO:** URL

## PSRAM
{:.anchor}

### HyperRAM
{:.anchor}

## Silicon Doc
{:.anchor}

The "Silicon Doc" is the official Propeller 2 Hardware documentation by Chip Gracey. It is considered to be rather heavy literature.

Read [our mirror](mirror/p2silicon.html) or [the originals](documents.html#chips-google-docs).


## Smart Pin
{:.anchor}

## Spin
{:.anchor}

### Spin 1
{:.anchor}

### Spin 2
{:.anchor}

## Spin Tools
{:.anchor}

**TODO:** URL

## spin2cpp
{:.anchor}

**TODO:** URL

## Streamer
{:.anchor}

**TODO**

See also: [Streamer documentation](streamer.html)

## TAQOZ
{:.anchor}

TAQOZ is a FORTH interpreter by Peter Jakacki that has been included into the [Boot ROM](#boot-rom).

**TODO:** Link to TAQOZ docs.

## XBYTE

**TODO**

See also: [XBYTE documentation](xbyte.html)



