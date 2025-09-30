---
title: Colorspace Converter
hyperjump:
    -   type: Topic
    -   id: tmds-encoder
        name: TMDS Encoder
        type: Topic
        hidden: HDMI DVI
---
# Colorspace Converter

Try the rainbow, taste the rainbow!

<img src="/common/construction.gif" alt="This subpage is under construction." class="dark-invert">

The Colorspace Converter is a unit that can be used to modify the DAC channel data (from [SETDACS](pin.html#setdacs) or the [Streamer](streamer.html)) before it is sent to the pins.

## TMDS Encoder
{:.anchor}

If bit 8 of CMOD is set, pin outputs from the streamer are converted into [TMDS format](https://en.wikipedia.org/wiki/Transition-minimized_differential_signaling) compatible with DVI or HDMI digital video standards.

|CMOD register|Mode             |Pin +31:8|Pin +7|Pin +6|Pin +5|Pin +4|Pin +3|Pin +2|Pin +1|Pin +0|
|------------:|:---------------:|:-------:|:----:|:----:|:----:|:----:|:----:|:----:|:----:|:----:|
|%0x_xxxxxxx  |Normal (TMDS off)|P\[31:8\]|P\[7\]|P\[6\]|P\[5\]|P\[4\]|P\[3\]|P\[2\]|P\[1\]|P\[0\]|
|%10_xxxxxxx  |TMDS forward     |$000000  |RED+  |RED-  |GRN+  |GRN-  |BLU+  |BLU-  |CLK+  |CLK-  |
|%11_xxxxxxx  |TMDS reverse     |$000000  |CLK-  |CLK+  |BLU-  |BLU+  |GRN-  |GRN+  |RED-  |RED+  |

Whether forward or reverse mode is appropriate depends on the PCB layout - all Parallax boards are designed for forward mode.

Depending on P[1], each character triplet is either TMDS 8-to-10 encoded or passed through as raw 10-bit codes. Each channel is then shifted out serially, LSB first. For this to work correctly, the streamer clock **has** to be 1/10th of the overall system clock! (XFREQ value $0CCCCCCD + periodic [XZERO](streamer.html#xzero))

|P\[31:0\]                           |RED+/-|GRN+/-|BLU+/-|
|:----------------------------------:|:-:|:-:|:-:|
|%RRRRRRRR_GGGGGGGG_BBBBBBBB_xxxxxx0x|%RRRRRRRR<br>gets encoded|%GGGGGGGG<br>gets encoded|%BBBBBBBB<br>gets encoded|
|%rrrrrrrrrr_gggggggggg_bbbbbbbbbb_1x|%rrrrrrrrrr<br>is sent literally|%gggggggggg<br>is sent literally|%bbbbbbbbbb<br>is sent literally|

The data-carrying pairs are named after the RGB channel they carry. For easier reference with specifications, refer to the following table:

|Wire pair|Channel no.|Control period|Video period<br>(RGB)|Video period<br>(YCbCr 4:4:4)|Data island period<br>(TERC4)|
|CLK+/-   |N/A        |Clock         |Clock                |Clock                        |Clock                        |
|BLU+/-   |Channel 0  |HSync+VSync   |Blue                 |Cb                           |HSync+VSync+Packet Headers   |
|GRN+/-   |Channel 1  |Preambles     |Green                |Y                            |(Sub-)Packet even bits       |
|RED+/-   |Channel 2  |Preambles     |Red                  |Cr                           |(Sub-)Packet odd bits        |


Important: **Other than being configured through the CMOD register, the TMDS encoder is independent from the colorspace converter!** The TMDS encoder only operates directly on the _pin outputs_ from the [Streamer](streamer.html)! No color transformation can be performed in the digital video pipeline!

### Simultaneous TMDS + analog RGBHV

It is possible to generate a VGA-compatible signal at the same time as a DVI/HDMI signal - this would be required to supply a proper DVI-I connector. **TODO**

## Instructions

<%=p2instrinfo('setcmod')%>
SETCMOD sets the CMOD register. This register has 9 bits that control the general behaviour of the colorspace converter:

|Bits |Function                 |
|:---:|-------------------------|
|0    |Sync polarity invert (mode 01 only)|
|1    |Add DAC0 into Y term     |
|2    |Add DAC0 into I term     |
|3    |Add DAC0 into Q term     |
|4    |Sign-extend coefficents (zero-extend otherwise)  |
|6:5  |Mode selection           |
|7    |Reverse TMDS pin order   |
|8    |Enable TMDS mode (replaces pin outputs)|

**TODO explain modes.**


<%=p2instrinfo('setcy')%>
<%=p2instrinfo('setci')%>
<%=p2instrinfo('setcq')%>

<%=p2instrinfo('setcfrq')%>
SETCFREQ sets the frequency of the NTSC/PAL chroma carrier to the value in **D**estination.

This frequency is expressed as a binary fraction of the system clock, so a value of `$1000000` would result in a 1/16 division.
You could calculate a correct value with an expression such as: `round(4_294_967_296.0*3_579_545.0/float(CLKFREQ_))` (for NTSC's 3.58 MHz carrier). If there is disturbing dot-crawl, it may be worth trying adjacent values (±1).

Though normally a constant CFRQ is set once before starting video signalling, the change is instantaneous and glitch-free, opening up [other uses](https://forums.parallax.com/discussion/174989/fm-radio-transmission-using-colorspace-converter) for this hardware.

<%p2instr_checkall :colorspace%>