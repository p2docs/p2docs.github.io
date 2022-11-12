---
title: Hub Control
hyperjump:
    -   type: Topic
    -   id: software-reset
        name: Software Reset
        type: HUBSET configuration
        hidden: Hard Reset
    -   id: debug-irq-enable-and-hub-write-protection
        name: Debug IRQ Enable and Hub Write Protection
        type: HUBSET configuration
    -   id: digital-filter-configuration
        name: Digital Filter Configuration
        type: HUBSET configuration
    -   id: seeding-the-global-prng
        name: Seeding the global PRNG
        type: HUBSET configuration
---

# Hub Control

## Cog and System Control

<%=p2instrinfo('hubset')%>
HUBSET configures shared resources inside the P2 chip. The affected configuration depends on the top bits of **D**estination.

#### Set clock mode
~~~
        %0000_xxxE_DDDD_DDMM_MMMM_MMMM_PPPP_CCSS     Set clock generator mode
~~~
If HUBSET is used with the topmost 4 bits of **D**estination being zero (`%0000`), the clock generator configuration is updated.

**MEGA TODO**

#### Software Reset
~~~
        %0001_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx     Hard reset, reboots chip
~~~
If HUBSET is used with the topmost 4 bits of **D**estination being `%0001`, the chip hard-resets itself (as if the reset pin was triggered). Any further **D**estination bits are ignored.

#### Debug IRQ Enable and Hub Write Protection
~~~
        %0010_xxxx_xxxx_xxLW_DDDD_DDDD_DDDD_DDDD     Set write-protect and debug enables
~~~
If HUBSET is used with the topmost 4 bits of **D**estination being `%0010`, the cog debugging enble bits and hub write protection bits will be updated. 

Each of the bottom 16 bits (`%D`) corrosponds to a cog, for which debug interrupts (TODO LINK) will be enabled if set. (the actual chip of course only has 8 cogs)

If bit 16 (`%W`) is set, the last 16K of [Hub RAM](hubmem.html) becomes write-protected and only accessible in the `$FC000` mirror region.

If bit 17 (`%L`) is set, the debug enable and write-protect settings become locked until the chip is reset.

#### Digital Filter Configuration
~~~
        %0100_xxxx_xxxx_xxxx_xxxx_xxxR_RLLT_TTTT     Set filter R to length L and tap T
~~~
If HUBSET is used with the topmost 4 bits of **D**estination being `%0100`, one of the digital filters is configured.

There are four global digital filter settings which can be used by each [smart pin](pin.html) to low-pass filter its incoming pin states.

Each filter setting includes a filter length and a timing tap. The filter length is 2, 3, 5, or 8 flipflops, selected by values 0..3. The flipflops shift pin state data at the timing tap rate and must be unanimously high or low to change the filter output to high or low. The timing tap is one of the lower 32 bits of CT (the free-running 64-bit global counter), selected by values 0..31. Each time the selected tap transitions, the current pin state is shifted into the flipflops and if the flipflops are all in agreement, the filter output goes to that state. The filter will be reflected in the INA/INB bits if no smart pin mode is selected, or the filter states will be used by the smart pin mode as its inputs.

**TODO TODO TODO**

"Length" is 0..3 for 2, 3, 5, or 8 flipflops.

"Tap" is 0..31 for every single clock, every 2nd clock, every 4th clock,... every 2,147,483,648th clock.


The filters are set to the following defaults on reset:

|Filter #|Length<br>(flipflops)|Tap<br>(clocks per sample)|Low-pass time<br>(at 6.25ns/clock)|
|:-:|:-:|:-:|:-:|
|0|0<br>(2 flipflops)|0<br>(1:1)|12.5ns<br>(6.25ns * 2 * 1)|
|1|1<br>(3 flipflops)|5<br>(32:1)|600ns<br>(6.25ns * 3 * 32)|
|2|2<br>(5 flipflops)|19<br>(512K:1)|16.4ms<br>(6.25ns * 5 * 512K)|
|3|3<br>(8 flipflops)|22<br>(4M:1)|210ms<br>(6.25ns * 8 * 4M)|


#### Seeding the global PRNG
~~~
        %1DDD_DDDD_DDDD_DDDD_DDDD_DDDD_DDDD_DDDD     Seed Xoroshiro128** PRNG with D
~~~
If HUBSET is used with the MSB of **D**estination being set, **D**estination will be used replace 32 bits of the sate of the global Xoroshiro128\*\* PRNG. The MSB always being set ensures that the overall state will not go to zero. Because the PRNG's 128 state bits rotate, shift, and XOR against each other, they are thoroughly spread around within a few clocks, so seeding from a fixed set of 32 bits should not pose a limitation on seeding quality.


<%=p2instrinfo('cogid')%>
<%=p2instrinfo('coginit')%>
<%=p2instrinfo('cogstop')%>

## Locks

<%=p2instrinfo('locknew')%>
<%=p2instrinfo('lockret')%>
<%=p2instrinfo('locktry')%>
<%=p2instrinfo('lockrel')%>


<%p2instr_checkall :hubctrl%>

