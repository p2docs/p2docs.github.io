---
title: Boot Process
hyperjump:
    -   type: Topic
---
# Boot Process

Since the Propeller 2 contains no internal flash storage, it always needs to boot from an external source, which can either be an SPI flash chip, an SD card or the serial interface. This is handled by a 16K built-in mask ROM, which is open-source and [may be found on Github](https://github.com/parallaxinc/propeller/blob/master/resources/FPGA%20Examples/ROM_Booter_v33k.spin2).

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


