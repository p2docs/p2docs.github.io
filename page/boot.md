---
title: Boot Process
hyperjump:
    -   type: Topic
    -   id: boot-selection
        name: Boot Selection
        type: Topic
    -   id: serial-boot
        name: Serial Boot
        type: Topic
    -   id: spi-flash-boot
        name: SPI Flash Boot
        type: Topic
    -   id: sd-card-boot
        name: SD Card Boot
        type: Topic
    -   id: propchk
        name: Prop_Chk
        type: Serial Boot Command
    -   id: propclk
        name: Prop_Clk
        type: Serial Boot Command
    -   id: prophex
        name: Prop_Hex
        type: Serial Boot Command
    -   id: proptxt
        name: Prop_Txt
        type: Serial Boot Command

---
# Boot Process
{:no_toc}

Since the Propeller 2 contains no internal flash storage, it always needs to boot from an external source, which can either be an SPI flash chip, an SD card or [the serial interface](#serial-boot). This is handled by a 16K built-in mask ROM, which is open-source and [may be found on Github](https://github.com/parallaxinc/propeller/blob/master/resources/FPGA%20Examples/ROM_Booter_v33k.spin2).

- placeholder
{:toc}

## Boot Selection
{:.anchor}

The boot source is selected by the presence of pull-up or pull-down resistors on various pins:

|Boot Pattern Set By Resistors|P61|P60|P59|
|-|-|-|-|
|Serial window of 60s, default.|none|none|none|
|Serial window of 60s, overrides SPI and SD.|ignored|ignored|pull-up|
|Serial window of 100ms, then SPI flash.<br>If SPI flash fails then serial window of 60s.|pull-up|ignored|none|
|SPI flash only (fast boot), no serial window.<br>If SPI flash fails then shutdown.|pull-up|ignored|pull-down|
|SD card with serial window on failure.<br>If SD card fails then serial window of 60s.|no pull-up|pull-up<br>(built into SD card)|none|
|SD card only, no serial window.<br>If SD card fails then shutdown.|no pull-up|pull-up<br>(built into SD card)|pull-down|


**TODO Flowchart**

In summary, the pins used by the various boot sources:

|Pin|Serial      |SD Card           |Flash            |
|---|------------|------------------|-----------------|
|P58|            |Data device -> P2 |Data device -> P2|
|P59|            |Data P2 -> device |Data P2 -> device|
|P60|            |Select            |Clock            |
|P61|            |Clock             |Select           |
|P62|TX (to PC)  |                  |                 |
|P63|RX (from PC)|                  |                 |


## Serial Boot
{:.anchor}

The built-in serial loader allows Propeller 2 chips to be loaded via 8-N-1 asynchronous serial into P63, where START=low and STOP=high, at any rate the sender uses, between 9,600 baud and 2,000,000 baud.

The loader automatically adapts to the sender's baud rate from every ">" character ($3E) it receives. It is necessary to initially send "> " ($3E, $20) before the first command, and then use ">" characters periodically throughout your data to keep the baud rate tightly calibrated to the internal RC oscillator that the loader uses during boot ROM execution. Received ">" characters are not passed to the command parser, so they can be placed anywhere.

The loader's response messages are sent back serially over P62 at the same baud rate that the sender is using. P62 is normally driven continuously during the serial protocol, but will go into open-drain mode when either the INA or INB mask of a command is non-0 (masking is explained below).

Unless preempted by a program in a SPI memory chip with a pull-up resistor on P60 (SPI_CK), the serial loader becomes active within 15ms of reset being released.

Between command keywords and data, whitespace is required. The following characters, in any contiguous combination, constitute a single whitespace:

- `$09` (Tab)
- `$0A` (Line Feed)
- `$0D` (Carriage Return)
- `$20` (Space)
- `$3D` (Equals Sign `=`, may be present in Base64 data)

There are four commands which the sender can issue:

1. Request Propeller type: `Prop_Chk <INAmask> <INAdata> <INBmask> <INBdata>`
2. Change clock setting: `Prop_Clk <INAmask> <INAdata> <INBmask> <INBdata> <HUBSETclocksetting>`
3. Load and execute hex data, with and without sum checking: `Prop_Hex <INAmask> <INAdata> <INBmask> <INBdata> <hexdatabytes> ?` or `Prop_Hex <INAmask> <INAdata> <INBmask> <INBdata> <hexdatabytes> ~`
4. Load and execute Base64 data, with and without sum checking: `Prop_Txt <INAmask> <INAdata> <INBmask> <INBdata> <base64chrs> ?` or `Prop_Txt <INAmask> <INAdata> <INBmask> <INBdata> <base64chrs> ~`

Each command keyword is followed by four 32-bit hex values which allow selection of certain chips by their INA and INB states. If you wanted to talk to any and all chips that are connected, you would use zeroes for these values. In case multiple chips are being loaded from the same serial line, you would probably want to differentiate each download by unique INA and INB mask and data values. When the serial loader receives data and mask values which do not match its own INA and INB ports, it waits for another command. Note that you cannot use INA[1:0] for this purpose, since they are configured as smart pins used for automatic baud detection by the loader. Because the command keywords all contain an underscore ("_"), they cannot be mistaken by intervening data belonging to a command destined for another chip, while a new command is being waited for.

If, at any time, a character is received which does not comport with expectations (i.e. an "x" is received when hex digits are expected), the loader aborts the current command and waits for a new command.

### Prop_Chk
{:.anchor}

The Prop_Chk command returns CR+LF+"Prop_Ver"+SP+VerChr+CR+LF. VerChr is "A".."Z" and indicates the version of Propeller chip. The Rev B/C silicon responds with "G":

> Sender:   "`> Prop_Chk 0 0 0 0`"+CR  
> Loader:   CR+LF+"`Prop_Ver G`"+CR+LF

### Prop_Clk
{:.anchor}
The Prop_Clk command is used to update the chip's clock source, as if a `HUBSET ##$0xxxxxxx` instruction were being executed. For details (and caveats), see [Set Clock Mode](hubctrl.html#set-clock-mode). Upon receiving a valid Prop_Clk command, the loader immediately echoes a "." character and then performs the following steps:

1. Switches to the internal 20MHz source.
2. Sets the desired configuration (except mode).
3. Waits ~5ms for the clock hardware to settle to the new configuration.
4. Enables the desired clock mode.

**NOTE:** After the command is sent, the sender should wait an ~10ms, then send "> " ($3E, $20) auto-baud sequence to adjust for the new clock configuration.

**NOTE:** If an image is loaded (see Prop_Hex/Prop_Txt) after switching to a PLL clock mode that is different than the mode used by that image, the uploaded image may need to issue a "HUBSET #$F0" before switching to the desired clock mode.  See the warning in Configuring the Clock Generator for more details.  An alternative approach is to use the same clock configuration as used by the image.  This means that the image's call to HUBSET will effectively be a NOP, but always safe to perform.

#### PLL Example
To update the clock source per PLL Example:

> Sender:   "`> Prop_Clk 0 0 0 0 19D28F8`"+CR  
> Loader:   "`.`"  
> Sender:   (wait ~10ms)  
> Sender:   "`> Prop_Clk 0 0 0 0 19D28FB`"+CR  
> Loader:   "`.`" 

#### Reset to Boot Clock Configuration
To return to the clock configuration on bootup:

> Sender:   "`> Prop_Clk 0 0 0 0 F0`"+CR  
> Loader:   "`.`"

### Prop_Hex
{:.anchor}
The Prop_Hex command is used to load byte data into the hub, starting at $00000, and then execute them. Hex bytes must be separated by whitespaces. Only the bottom 8 bits of hex values are used as data.

If the command is terminated with a "~" character, the loader will do a `COGINIT #0,#0` to relaunch cog 0 (currently running the booter program) with the new program starting at $00000.

If the command is terminated with a "?" character, the loader will send either a "." character to signify that the embedded checksum was correct, in which case it will run the program as "~" would have. Or, it will send a "!" character to signify that the checksum was incorrect, after which it will wait for a new command.

To demonstrate hex loading, consider this small program:

```
DAT           ORG
              not       dirb                    'all outputs
.lp           not       outb                    'toggle states (blinks leds on Prop123 & P2 Eval boards)
              waitx     ##20_000_000/4          'wait ¼ second
              jmp #.lp                          'loop
```

It assembles to:
```
00000- FB F7 23 F6 FD FB 23 F6 25 26 80 FF 1F 80 66 FD F0 FF 9F FD
```

Here is how you would run this program from the serial loader:

> Sender:   "`> Prop_Hex 0 0 0 0 FB F7 23 F6 FD FB 23 F6 25 26 80 FF 1F 80 66 FD F0 FF 9F FD ~`"

In the case of our assembled program, there are 5 little-endian longs which sum to $E6CE9A2C. To generate an embedded checksum long, you would compute $706F7250 ("Prop") minus the sum $E6CE9A2C, which results in $89A0D824. Those four bytes could be appended to the data as follows. Note that it doesn't matter where your embedded checksum long is placed, only that it be long-aligned within your data:

> Sender:   "`> Prop_Hex 0 0 0 0 FB F7 23 F6 FD FB 23 F6 25 26 80 FF 1F 80 66 FD F0 FF 9F FD 24 D8 A0 89 ?`"  
> Loader:   "`.`"

It's a good idea to start each hex data line with a  ">" character, to keep the baud rate tightly calibrated.

### Prop_Txt
{:.anchor}

The Prop_Txt command is like Prop_Hex, but with one difference: Instead of hex bytes separated by whitespaces, it takes in Base64 data, which are text characters that convey six bits, each, and get assembled into bytes as they are received. This format is 2.25x denser than hex, and so minimizes transmission size and time.

These are the characters that make up the Base64 alphabet:
```
"A".."Z"   = $00..$19
"a".."z"   = $1A..$33
"0".."9"   = $34..$3D
"+"        = $3E
"/"        = $3F
```
Whitespaces are ignored among Base64 characters.

To load and run the program used in the [Prop_Hex](#prophex) example:
> Sender:   "`> Prop_Txt 0 0 0 0 +/cj9v37I/YlJoD/H4Bm/fD/n/0 ~`"  

To add the embedded checksum:

> Sender:   "`> Prop_Txt 0 0 0 0 +/cj9v37I/YlJoD/H4Bm/fD/n/0k2KCJ ?`"  
> Loader:   "`.`"

It's a good idea to start each Base64 data line with a ">" character, to keep the baud rate tightly calibrated.

### Summary
It is possible to uniquely load many Propeller chips from the same serial signal by giving them each a different INA/INB signature and not connecting SPI memory chips or SD cards to P61..P58.

To try out the serial loader, just open a terminal program on your PC with the Propeller 2 connected and type: "> Prop_Chk 0 0 0 0"+CR. You can also cut and paste those Prop_Hex and Prop_Txt example lines to load the blinker program. A simple Propeller 2 development tool needs no special serial signalling, just simple text output that needn't worry about PC/Mac/Unix new-line differences, whitespace conventions, or generating non-standard characters.


## SPI Flash Boot
{:.anchor}

**TODO**

## SD Card Boot
{:.anchor}

The P2 can boot from an attached SD card. The bootloader will try to locate executable code in a number of ways:

- If the first sector contains the signature "Prop" ($706F7250) at offset $17C, the MBR is loaded into [Cog RAM](cog.html#cog-memory) and executed starting at address $20 (byte offset $80 in the MBR)
- If the first sector instead contains the signature "ProP" ($506F7250) at offset $17C, the long at offset $174 is used as the sector number that the boot file starts in and the long at offset $178 is used as its lenght in bytes (max. 496KB). The file is loaded and started normally (`coginit #0,#0`).
- If the MBR has a valid structure and partition 1 is marked as bootable, its VBR is loaded and checked for the same signatures as the MBR.
- If the VBR is that of a valid FAT32 volume, its root directory is scanned for a file named `_BOOT_P2.BIX` (max. 496K), which will be loaded and started normally  (`coginit #0,#0`). **This file _must not_ be fragmented!**
- Alternatively, a file named `_BOOT_P2.BIY` will be started in the same manner if `_BOOT_P2.BIX` is not found.


For more details, [look here](https://forums.parallax.com/discussion/170637/p2-sd-boot-code-rev-2-silicon/p1).
