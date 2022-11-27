---
title: Assembler Syntax
hyperjump:
    -   type: Topic
    -   id: condition-codes
        name: Condition Codes
        type: Topic
        hidden: IF_
---
# Assembler Syntax

TODO.

## Case Sensitivity
The Spin2/PASM2 syntax is completely case-insensitive. That means not only that `addpix`, `AddPix` and `ADDPIX` are all valid spellings of the [ADDPIX](mixpix.html#addpix) instruction, but also that user defined labels and constants can be used with different casing than their definition.

For readability, documentation uses all-uppercase for any keywords, but any sane programmer uses all-lowercase in actual source files.

## Condition Codes
{:.anchor}
Each instruction can have a condition code. If the condition is not met, the instruction has no effect and takes 2 cycles. (Exception: [BRK](irq.html#brk) and [NOP](misc.html#nop) may not have condition codes applied to them)

|Encoding|Primary Name|Alternate 1|Alternate 2|Alternate 3|Description|
|-----|------------|------------|-----|-----|----------------------|
|%0000|\_RET\_     |            |     |     |Always execute and return ([More Info](branch.html#ret-condition-code))|
|%0001|IF_NC_AND_NZ|IF_NZ_AND_NC|IF_GT|IF_00|Execute if C=0 AND Z=0|
|%0010|IF_NC_AND_Z |IF_Z_AND_NC |     |IF_01|Execute if C=0 AND Z=1|
|%0011|IF_NC       |            |IF_GE|IF_0X|Execute if C=0        |
|%0100|IF_C_AND_NZ |IF_NZ_AND_C |     |IF_10|Execute if C=1 AND Z=0|
|%0101|IF_NZ       |            |IF_NE|IF_X0|Execute if Z=0        |
|%0110|IF_C_NE_Z   |IF_Z_NE_C   |     |     |Execute if C!=Z       |
|%0111|IF_NC_OR_NZ |IF_NZ_OR_NC |     |     |Execute if C=0 OR Z=0 |
|%1000|IF_C_AND_Z  |IF_Z_AND_C  |     |IF_11|Execute if C=1 AND Z=1|
|%1001|IF_C_EQ_Z   |IF_Z_EQ_C   |     |     |Execute if C=Z        |
|%1010|IF_Z        |            |IF_E |IF_X1|Execute if Z=1        |
|%1011|IF_NC_OR_Z  |IF_Z_OR_NC  |     |     |Execute if C=0 OR Z=1 |
|%1100|IF_C        |            |IF_LT|IF_1X|Execute if C=1        |
|%1101|IF_C_OR_NZ  |IF_NZ_OR_C  |     |     |Execute if C=1 OR Z=0 |
|%1110|IF_C_OR_Z   |IF_Z_OR_C   |     |     |Execute if C=1 OR Z=1 |
|%1111|(empty)     |IF_ALWAYS   |     |     |Always execute        |
