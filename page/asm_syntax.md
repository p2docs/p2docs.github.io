---
title: Assembler Syntax
hyperjump:
    -   type: Topic
    -   id: condition-codes
        name: Condition Codes
        type: Topic
        hidden: IF_
    -   id: operators
        name: Operators
        type: Syntax Element
---
# Assembler Syntax

TODO.

<img src="/common/construction.gif" alt="This subpage is under construction." class="dark-invert">

## Case Sensitivity
The Spin2/PASM2 syntax is completely case-insensitive. That means not only that `addpix`, `AddPix` and `ADDPIX` are all valid spellings of the [ADDPIX](mixpix.html#addpix) instruction, but also that user defined labels and constants can be used with different casing than their definition.

For readability, documentation uses all-uppercase for any keywords, but any sane programmer uses all-lowercase in actual source files.

## Operators
{:.anchor}

**(TODO: Are float ops even relevant to DAT/CON?)**

### Unary Operators

|Operator|Term|Priority|Description|
|:-:|:-:|:-:|:-|
|!!, NOT|!!x|12|Logical NOT (0 → -1, non-0 → 0)|
|!|!x|2|Bitwise NOT (1's complement)|
|-|-x|2|Negate (2's complement)|
|-.|-.x|2|Floating-point negate (toggles MSB)|
|ABS|ABS x|2|Absolute value|
|FABS|FABS x|2|Floating-point absolute value (clears MSB)|
|ENCOD|ENCOD x|2|Encode MSB, 0..31|
|DECOD|DECOD x|2|Decode, 1 << (x & $1F)|
|BMASK|BMASK x|2|Bitmask, (2 << (x & $1F)) - 1|
|ONES|ONES x|2|Sum all '1' bits, 0..32|
|SQRT|SQRT x|2|Square root of unsigned value|
|FSQRT|FSQRT x|2|Floating-point square root|
|QLOG|QLOG x|2|Unsigned value to logarithm {5'whole, 27'fraction}|
|QEXP|QEXP x|2|Logarithm to unsigned value|

### Binary Operators

|Operator|Term|Priority|Description|
|:-:|:-:|:-:|:-|
|>>|x >> y|3|Shift x right by y bits, insert 0's|
|<<|x << y|3|Shift x left by y bits, insert 0's|
|SAR|x SAR y|3|Shift x right by y bits, insert MSB's|
|ROR|x ROR y|3|Rotate x right by y bits|
|ROL|x ROL y|3|Rotate x left by y bits|
|REV|x REV y|3|Reverse order of bits 0..y of x and zero-extend|
|ZEROX|x ZEROX y|3|Zero-extend above bit y|
|SIGNX|x SIGNX y|3|Sign-extend from bit y|
|&|x & y|4|Bitwise AND|
|^|x ^ y|5|Bitwise XOR|
|\||x \| y|6|Bitwise OR|
|*|x * y|7|Signed multiply|
|*.|x *. y|7|Floating-point multiply|
|/|x / y|7|Signed divide, return quotient|
|/.|x /. y|7|Floating-point divide|
|+/|x +/ y|7|Unsigned divide, return quotient|
|//|x // 7|7|Signed divide, return remainder|
|+//|x +// y|7|Unsigned divide, return remainder|
|SCA|x SCA y|7|Unsigned scale, (x * y) >> 32|
|SCAS|x SCAS y|7|Signed scale, (x * y) >> 30|
|FRAC|x FRAC y|7|Unsigned fraction, (x << 32) / y|
|+|x + y|8|Add|
|+.|x +. y|8|Floating-point add|
|-|x - y|8|Subtract|
|-.|x -. y|8|Floating-point subtract|
|#>|x #> y|9|Force x => y, signed|
|<#|x <# y|9|Force x <= y, signed|
|ADDBITS|x ADDBITS y|10|Make bitfield, (x & $1F) \| (y & $1F) << 5|
|ADDPINS|x ADDPINS y|10|Make pinfield, (x & $3F) \| (y & $1F) << 6|
|<|x < y|11|Signed less than (returns 0 or -1)|
|+<|x +< y|11|Unsigned less than (returns 0 or -1)|
|<.|x <. y|11|Floating-point less than (returns 0 or -1)|
|<=|x <= y|11|Signed less than or equal (returns 0 or -1)|
|+<=|x +<= y|11|Unsigned less than or equal (returns 0 or -1)|
|<=.|x <=. y|11|Floating-point less than or equal (returns 0 or -1)|
|==|x == y|11|Equal (returns 0 or -1)|
|==.|x ==. y|11|Floating-point equal (returns 0 or -1)|
|<>|x <> y|11|Not equal (returns 0 or -1)|
|<>.|x <>. y|11|Floating-point not equal (returns 0 or -1)|
|>=|x >= y|11|Signed greater than or equal (returns 0 or -1)|
|+>=|x +>= y|11|Unsigned greater than or equal (returns 0 or -1)|
|>=.|x >=. y|11|Floating-point greater than or equal (returns 0 or -1)|
|>|x > y|11|Signed greater than (returns 0 or -1)|
|+>|x +> y|11|Unsigned greater than (returns 0 or -1)|
|>.|x >. y|11|Floating-point greater than (returns 0 or -1)|
|<=>|x <=> y|11|Signed comparison (<,=,> returns -1,0,1)|
|&&, AND|x && y|13|Logical AND  (x <> 0 AND y <> 0, returns 0 or -1)|
|^^, XOR|x ^^ y|14|Logical XOR  (x <> 0 XOR y <> 0, returns 0 or -1)|
|\|\|, OR|x \|\| y|15|Logical OR   (x <> 0 OR  y <> 0, returns 0 or -1)|

### Ternary Operator

|Operator|Term|Priority|Description|
|:-:|:-:|:-:|:-|
|? :|x ? y : z|16|If x <> 0 then choose y, else choose z|


## Condition Codes
{:.anchor}
**TODO: Maybe move this**

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
