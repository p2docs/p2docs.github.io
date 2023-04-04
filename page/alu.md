---
title: Math and Logic Instructions
hyperjump:
    -   type: Topic
---
# Math and Logic Instructions

## Data movement
<%=p2instrinfo('mov')%>
MOV copies the **S**ource value into **D**estination.

If the **WC** or **WCZ** effect is specified, the C flag is updated to be **S**ource[31].

If the **WZ** or **WCZ** effect is specified, the Z flag is set (1) if the **D**estination result equals zero, or is cleared (0) if it is non-zero.



<%=p2instrinfo('movbyts')%>
MOVBYTS swizzles the bytes of **D**estination based on bottom 8 bits in **S**ource. Each bit pair in **S**ource[7:0] corrosponds to one byte slot of the result and selects which of the input bytes will appear there. It is useful to use base-4 literals (`%%0123`) with MOVBYTS, since each digit corrosponds to one bit pair.

- `MOVBYTS D,#%%3210` leaves D as-is.
- `MOVBYTS D,#%%0123` reverses the bytes of D ("endian swap").
- `MOVBYTS D,#%%0000` will copy the lowest byte into all four slots

<%=p2instrinfo('loc')%>
LOC moves a 20-bit address into either PA, PB, PTRA or PTRB. This address can be encoded as either absolute or relative.

---

<%=p2instrinfo('getnib')%>
GETNIB reads the **N**th nibble (4 bits) from **S**ource and moves it into **D**estination. The upper 28 bits of **D**estination are cleared.

**N** can be any constant between 0 and 7. **N** = 0 gets the least significant nibble (**S**[3:0]), **N** = 7 gets the most significant nibble (**S**[31:28]) 

GETNIB can have its **S**ource and **N** omitted, in which case they default to `0` and `#0`. This is intended for use with [ALTGN](indir.html#altgn).

<%=p2instrinfo('getbyte')%>
GETBYTE reads the **N**th byte (8 bits) from **S**ource and moves it into **D**estination. The upper 24 bits of **D**estination are cleared.

**N** can be any constant between 0 and 3. **N** = 0 gets the least significant byte (**S**[7:0]), **N** = 3 gets the most significant byte (**S**[31:24]) 

GETBYTE can have its **S**ource and **N** omitted, in which case they default to `0` and `#0`. This is intended for use with [ALTGB](indir.html#altgb).

<%=p2instrinfo('getword')%>
GETWORD reads the **N**th word (16 bits) from **S**ource and moves it into **D**estination. The upper 16 bits of **D**estination are cleared.

**N** can be the constants 0 and 1. **N** = 0 gets the least significant word (**S**[15:0]), **N** = 1 gets the most significant word (**S**[31:16]) 

GETWORD can have its **S**ource and **N** omitted, in which case they default to `0` and `#0`. This is intended for use with [ALTGW](indir.html#altgw).

---

<%=p2instrinfo('setnib')%>
SETNIB stores the least significant nibble (4 bits) of **S**ource into the **N**th nibble of **D**estination. All other bits are unaffected.

**N** can be any constant between 0 and 7. **N** = 0 sets the least significant nibble (**D**[3:0]), **N** = 7 sets the most significant nibble (**D**[31:28]) 

SETNIB can have its **D**estination and **N** omitted, in which case they default to `0` and `#0`. This is intended for use with [ALTSN](indir.html#altsn).

<%=p2instrinfo('setbyte')%>
SETBYTE stores the least significant byte (8 bits) of **S**ource into the **N**th byte of **D**estination. All other bits are unaffected.

**N** can be any constant between 0 and 3. **N** = 0 sets the least significant byte (**D**[7:0]), **N** = 3 sets the most significant byte (**D**[31:24]) 

SETBYTE can have its **D**estination and **N** omitted, in which case they default to `0` and `#0`. This is intended for use with [ALTSB](indir.html#altsb).

<%=p2instrinfo('setword')%>
SETWORD stores the least significant byte (16 bits) of **S**ource into the **N**th word of **D**estination. All other bits are unaffected.

**N** can be the constants 0 and 1. **N** = 0 sets the least significant word (**D**[15:0]), **N** = 1 sets the most significant word (**D**[31:16]) 

SETWORD can have its **D**estination and **N** omitted, in which case they default to `0` and `#0`. This is intended for use with [ALTSW](indir.html#altsw).

---

<%=p2instrinfo('rolnib')%>
ROLNIB reads the **N**th nibble (4 bits) from **S**ource and shifts it into **D**estination. The lower 28 bits of **D**estination are shifted up by 4 and the top 4 bits are discarded.

**N** can be any constant between 0 and 7. **N** = 0 gets the least significant nibble (**S**[3:0]), **N** = 7 gets the most significant nibble (**S**[31:28]) 

ROLNIB can have its **S**ource and **N** omitted, in which case they default to `0` and `#0`. This is intended for use with [ALTGN](indir.html#altgn).

<%=p2instrinfo('rolbyte')%>
ROLBYTE reads the **N**th byte (8 bits) from **S**ource and shifts it into **D**estination. The lower 24 bits of **D**estination are shifted up by 8 and the top 8 bits are discarded.

**N** can be any constant between 0 and 3. **N** = 0 gets the least significant byte (**S**[7:0]), **N** = 3 gets the most significant byte (**S**[31:24]) 

ROLBYTE can have its **S**ource and **N** omitted, in which case they default to `0` and `#0`. This is intended for use with [ALTGB](indir.html#altgb).


<%=p2instrinfo('rolword')%>
ROLWORD reads the **N**th word (16 bits) from **S**ource and shifts it into **D**estination. The lower 16 bits of **D**estination are shifted up by 16 and the top 16 bits are discarded.

**N** can be the constants 0 and 1. **N** = 0 gets the least significant word (**S**[15:0]), **N** = 1 gets the most significant word (**S**[31:16]) 

ROLWORD can have its **S**ource and **N** omitted, in which case they default to `0` and `#0`. This is intended for use with [ALTGW](indir.html#altgw).

---

<%=p2instrinfo('sets')%>
SETS copies **S**ource[8:0] into **D**estination[8:0]. Other bits remain unaffected. This is useful to set up the S-field for [ALTI](indir.html#alti) or to set the S-field of an instruction in memory (See: Self-Modifying Code **TODO Link**).

<%=p2instrinfo('setd')%>
SETD copies **S**ource[8:0] into **D**estination[17:9]. Other bits remain unaffected. This is useful to set up the D field for [ALTI](indir.html#alti) or to set the D field of an instruction in memory (See: Self-Modifying Code **TODO Link**).

<%=p2instrinfo('setr')%>
SETR copies **S**ource[8:0] into **D**estination[27:19]. Other bits remain unaffected. This is useful to set up the R field for [ALTI](indir.html#alti) or to modify the opcode and flag effects of an instruction in memory (See: Self-Modifying Code **TODO Link**).

## Arithmetic

<%=p2instrinfo('add')%>
ADD sums the two unsigned values of **D**estination and **S**ource together and stores the result into the **D**estination register.

If the **WC** or **WCZ** effect is specified, the C flag is set (1) if the summation resulted in an unsigned carry (= 32-bit overflow), or is cleared (0) if no carry.

If the **WZ** or **WCZ** effect is specified, the Z flag is set (1) if the result stored into **D**estination is zero, or is cleared (0) if it is non-zero.

To add unsigned, multi-long values, use ADD followed by [ADDX](#addx) as described in Adding Two Multi-Long Values(**TODO LINK**). ADD and ADDX are also used in adding signed, multi-long values with [ADDSX](#addsx) ending the sequence.

<%=p2instrinfo('adds')%>
ADDS sums the two signed values of **D**estination and **S**ource together and stores the result into the **D**estination register. If **S**ource is a 9-bit literal, its value is interpreted as positive (0-511; it is not sign-extended) — use ##Value (or insert a prior [AUGS](misc.html#augs) instruction) for a 32-bit signed value; negative or positive.

If the **WC** or **WCZ** effect is specified, the C flag is set (1) if the summation, _signed overflow nonwithstanding_, produced a negative result. Overflow occured if C is _not_ equal to the result's MSB (see [TJV](branch.html#tjv)).

If the **WZ** or **WCZ** effect is specified, the Z flag is set (1) if the result stored into **D**estination is zero, or is cleared (0) if it is non-zero.

To add signed, multi-long values, use [ADD](#add) (not ADDS) followed possibly by [ADDX](#addx), and finally [ADDSX](#addsx) as described in Adding Two Multi-Long Values(**TODO LINK**).

<%=p2instrinfo('addx')%>
ADDX sums the unsigned values of **D**estination and **S**ource plus C together and stores the result into the **D**estination register. The ADDX instruction is used to perform unsigned multi-long (extended) addition, such as 64-bit addition.

If the **WC** or **WCZ** effect is specified, the C flag is set (1) if the summation resulted in an unsigned carry, or is cleared (0) if no carry.

If the **WZ** or **WCZ** effect is specified, the Z flag is set (1) if Z was previously set _and_ the  result stored into **D**estination is zero, or it is cleared (0) if non-zero or if Z was not previously set. Use **WCZ** on preceding ADD and ADDX instructions for proper final Z flag.

To add unsigned multi-long values, use ADD followed by one or more ADDX instructions as described in Adding Two Multi-Long Values(**TODO LINK**).

<%=p2instrinfo('addsx')%>
ADDSX sums the signed values of **D**estination and **S**ource plus C together and stores the result into the **D**estination register. The ADDSX instruction is used to perform signed multi-long (extended) addition, such as 64-bit addition.

If the **WC** or **WCZ** effect is specified, the C flag is set (1) if the summation, _signed overflow nonwithstanding_, produced a negative result. Overflow occured if C is _not_ equal to the result's MSB (see [TJV](branch.html#tjv)).

If the **WZ** or **WCZ** effect is specified, the Z flag is set (1) if Z was previously set _and_ the  result stored into **D**estination is zero, or it is cleared (0) if non-zero or if Z was not previously set. Use **WCZ** on preceding ADD and ADDX instructions for proper final Z flag.

To add signed multi-long values, use [ADD](#add) (not [ADDS](#adds)) followed possibly by [ADDX](#addx), and finally ADDSX as described in Adding Two Multi-Long Values(**TODO LINK**).

---

<%=p2instrinfo('sub')%>
SUB subtracts the unsigned **S**ource from the unsigned **D**estination and stores the result into the **D**estination register.

If the **WC** or **WCZ** effect is specified, the C flag is set (1) if the subtraction results in an unsigned borrow (= 32-bit underflow), or is cleared (0) if no borrow.

If the **WZ** or **WCZ** effect is specified, the Z flag is set (1) if the result stored into **D**estination is zero, or is cleared (0) if it is non-zero.

To subtract unsigned, multi-long values, use SUB followed by [SUBX](#subx) as described in Subtracting Two Multi-Long Values(**TODO LINK**). SUB and [SUBX](#subx) are also used in subtracting _signed_, multi-long values with [SUBSX](#subsx) ending the sequence.

<%=p2instrinfo('subr')%>
SUBR subtracts the unsigned **D**estination from the unsigned **S**ource and stores the result into the **D**estination register. This is the reverse of the subtraction order of [SUB](#sub).

If the **WC** or **WCZ** effect is specified, the C flag is set (1) if the subtraction results in an unsigned borrow (= 32-bit underflow), or is cleared (0) if no borrow.

If the **WZ** or **WCZ** effect is specified, the Z flag is set (1) if the result stored into **D**estination is zero, or is cleared (0) if it is non-zero.

<%=p2instrinfo('subs')%>
SUBS subtracts the signed **S**ource from the signed **D**estination and stores the result into the **D**estination register. If **S**ource is a 9-bit literal, its value is interpreted as positive (0-511; it is not sign-extended) — use ##Value (or insert a prior [AUGS](#augs) instruction) for a 32-bit signed value; negative or positive.

If the **WC** or **WCZ** effect is specified, the C flag is set (1) if the subtraction, _signed overflow nonwithstanding_, produced a negative result. Overflow occured if C is _not_ equal to the result's MSB (see [TJV](branch.html#tjv)).

If the **WZ** or **WCZ** effect is specified, the Z flag is set (1) if the result stored into **D**estination is zero, or is cleared (0) if it is non-zero.

To subtract signed, multi-long values, use [SUB](#sub) (not [SUBS](#subs)) followed possibly by [SUBX](#subx), and finally [SUBSX](#subsx) as described in Subtracting Two Multi-Long Values(**TODO LINK**).

<%=p2instrinfo('subx')%>
SUBX subtracts the unsigned value of **S**ource plus C from the unsigned **D**estination and stores the result into the **D**estination register. The SUBX instruction is used to perform unsigned multi-long (extended) subtraction, such as 64-bit subtraction.

If the **WC** or **WCZ** effect is specified, the C flag is set (1) if the subtraction resulted in an unsigned borrow, or is cleared (0) if no carry.

If the **WZ** or **WCZ** effect is specified, the Z flag is set (1) if Z was previously set _and_ the  result stored into **D**estination is zero, or it is cleared (0) if non-zero or if Z was not previously set. Use **WCZ** on preceding SUB and SUBX instructions for proper final Z flag.

<%=p2instrinfo('subsx')%>
SUBSX subtracts the signed value of **S**ource plus C from the signed **D**estination and stores the result into the **D**estination register. The SUBSX instruction is used to perform signed multi-long (extended) subtraction, such as 64-bit subtraction.

If the **WC** or **WCZ** effect is specified, the C flag is set (1) if the subtraction, _signed overflow nonwithstanding_, produced a negative result. Overflow occured if C is _not_ equal to the result's MSB (see [TJV](branch.html#tjv)).

If the **WZ** or **WCZ** effect is specified, the Z flag is set (1) if Z was previously set _and_ the  result stored into **D**estination is zero, or it is cleared (0) if non-zero or if Z was not previously set. Use **WCZ** on preceding SUB and SUBX instructions for proper final Z flag.

To subtract signed multi-long values, use [SUB](#sub) (not [SUBS](#subs)) followed possibly by [SUBX](#subx), and finally SUBSX as described in Subtracting Two Multi-Long Values(**TODO LINK**).

---

<%=p2instrinfo('cmp')%>
CMP compares the _unsigned_ values of **D**estination and **S**ource (by subtracting **S**ource from **D**estination) and optionally setting the C and Z flags accordingly.

If the **WC** or **WCZ** effect is specified, the C flag is set (1) if **D**estination is less than **S**ource.

If the **WZ** or **WCZ** effect is specified, the Z flag is set (1) if **D**estination equals **S**ource.

**Note that it is possible to encode CMP without any effects, which is entirely pointless.**

<%=p2instrinfo('cmpr')%>
CMPR compares the _unsigned_ values of **D**estination and **S**ource (by subtracting **D**estination from **S**ource) and optionally setting the C and Z flags accordingly.

If the **WC** or **WCZ** effect is specified, the C flag is set (1) if **S**ource is less than **D**estination.

If the **WZ** or **WCZ** effect is specified, the Z flag is set (1) if **D**estination equals **S**ource.

**Note that it is possible to encode CMP without any effects, which is entirely pointless.**

<%=p2instrinfo('cmps')%>
CMPS compares the _signed_ values of **D**estination and **S**ource (by subtracting **S**ource from **D**estination) and optionally setting the C and Z flags accordingly.

If the **WC** or **WCZ** effect is specified, the C flag is set (1) if **D**estination is less than **S**ource.

If the **WZ** or **WCZ** effect is specified, the Z flag is set (1) if **D**estination equals **S**ource.

**Note that it is possible to encode CMPS without any effects, which is entirely pointless.**

<%=p2instrinfo('cmpm')%>
CMPM compares the values of **D**estination and **S**ource (by subtracting **S**ource from **D**estination) and optionally setting the C and Z flags accordingly.

If the **WC** or **WCZ** effect is specified, the C flag is updated to the MSB (bit 31) of (**D**estination - **S**ource)

If the **WZ** or **WCZ** effect is specified, the Z flag is set (1) if **D**estination equals **S**ource.

**Note that it is possible to encode CMPM without any effects, which is entirely pointless.**


<%=p2instrinfo('cmpsub')%>
CMPSUB compares the unsigned values of **D**estination and **S**ource, and, if **S**ource is less than or equal to **D**estination, it is subtracted from **D**estination. Optionally, the C and Z flags are set to indicate the comparison and operation results.

If the **WC** or **WCZ** effect is specified, the C flag is set (1) if **D**estination was greater than or equal to **S**ource.

If the **WZ** or **WCZ** effect is specified, the Z flag is set (1) if the result equals 0 (including if **D**estination was 0 to begin with).

<%=p2instrinfo('cmpx')%>

<%=p2instrinfo('cmpsx')%>

---

<%=p2instrinfo('abs')%>
ABS determines the absolute value of **S**ource and writes the result into **D**estination.

If the **WC** or **WCZ** effect is specified, the C flag is set (1) if the original **S**ource value was negative, or is cleared
(0) if it was positive.

If the **WZ** or **WCZ** effect is specified, the Z flag is set (1) if the result is zero, or is cleared (0) if it is non-zero.

Literal **S**ource values are zero-extended, so ABS is really best used with register **S**ource (or augmented **S**ource) values.

ABS's **S**ource can be omitted, in which case it defaults to being the same as its **D**estination.

<%=p2instrinfo('neg')%>
NEG negates **S**ource and stores the result in the **D**estination register. The negation flips the
value's sign; ex: 78 becomes -78, or -306 becomes 306.

If the **WC** or **WCZ** effect is specified, the C flag is set (1) if the result is negative, or is cleared (0) if positive.

If the **WZ** or **WCZ** effect is specified, the Z flag is set (1) if the result is zero, or is cleared (0) if it is non-zero.

NEG's **S**ource can be omitted, in which case it defaults to being the same as its **D**estination.

<%=p2instrinfo('negc')%>
NEGC negates **S**ource if the C flag is _set_ and stores the result in the **D**estination register. If the C flag is clear, the **S**ource value is left as-is (not negated) and is stored into **D**estination.

If the **WC** or **WCZ** effect is specified, the C flag is set (1) if the result is negative, or is cleared (0) if positive.

If the **WZ** or **WCZ** effect is specified, the Z flag is set (1) if the result is zero, or is cleared (0) if it is non-zero.


<%=p2instrinfo('negnc')%>
NEGNC negates **S**ource if the C flag is _not set_ and stores the result in the **D**estination register. If the C flag is set, the **S**ource value is left as-is (not negated) and is stored into **D**estination.

If the **WC** or **WCZ** effect is specified, the C flag is set (1) if the result is negative, or is cleared (0) if positive.

If the **WZ** or **WCZ** effect is specified, the Z flag is set (1) if the result is zero, or is cleared (0) if it is non-zero.

<%=p2instrinfo('negz')%>
NEGZ negates **S**ource if the C flag is _set_ and stores the result in the **D**estination register. If the Z flag is clear, the **S**ource value is left as-is (not negated) and is stored into **D**estination.

If the **WC** or **WCZ** effect is specified, the C flag is set (1) if the result is negative, or is cleared (0) if positive.

If the **WZ** or **WCZ** effect is specified, the Z flag is set (1) if the result is zero, or is cleared (0) if it is non-zero.

<%=p2instrinfo('negnz')%>
NEGNZ negates **S**ource if the Z flag is _not set_ and stores the result in the **D**estination register. If the Z flag is set, the **S**ource value is left as-is (not negated) and is stored into **D**estination.

If the **WC** or **WCZ** effect is specified, the C flag is set (1) if the result is negative, or is cleared (0) if positive.

If the **WZ** or **WCZ** effect is specified, the Z flag is set (1) if the result is zero, or is cleared (0) if it is non-zero.

---

<%=p2instrinfo('sumc')%>
NEGC subtracts **S**ource from **D**estination if the C flag is _set_ and stores the result in the **D**estination register. If the C flag is clear, **S**ource is instead added to **D**estination.

If the **WC** or **WCZ** effect is specified, the C flag is set (1) if the result is negative, or is cleared (0) if positive.

If the **WZ** or **WCZ** effect is specified, the Z flag is set (1) if the result is zero, or is cleared (0) if it is non-zero.

<%=p2instrinfo('sumnc')%>
NEGNC subtracts **S**ource from **D**estination if the C flag is _not set_ and stores the result in the **D**estination register. If the C flag is set, **S**ource is instead added to **D**estination.

If the **WC** or **WCZ** effect is specified, the C flag is set (1) if the result is negative, or is cleared (0) if positive.

If the **WZ** or **WCZ** effect is specified, the Z flag is set (1) if the result is zero, or is cleared (0) if it is non-zero.

<%=p2instrinfo('sumz')%>
NEGZ subtracts **S**ource from **D**estination if the Z flag is _set_ and stores the result in the **D**estination register. If the Z flag is clear, **S**ource is instead added to **D**estination.

If the **WC** or **WCZ** effect is specified, the C flag is set (1) if the result is negative, or is cleared (0) if positive.

If the **WZ** or **WCZ** effect is specified, the Z flag is set (1) if the result is zero, or is cleared (0) if it is non-zero.

<%=p2instrinfo('sumnz')%>
NEGNZ subtracts **S**ource from **D**estination if the Z flag is _not set_ and stores the result in the **D**estination register. If the Z flag is set, **S**ource is instead added to **D**estination.

If the **WC** or **WCZ** effect is specified, the C flag is set (1) if the result is negative, or is cleared (0) if positive.

If the **WZ** or **WCZ** effect is specified, the Z flag is set (1) if the result is zero, or is cleared (0) if it is non-zero.

---

<%=p2instrinfo('mul')%>
MUL performs an _unsigned_ multiplication of the lower 16-bits of **D**estination and **S**ource and stores the 32-bit product result into the **D**estination register. This is a fast (2-clock) 16 x 16 bit multiplication operation - to multiply larger factors, use [the CORDIC Solver QMUL instruction](cordic.html#qmul).

If the **WZ** effect is specified, the Z flag is set (1) if either the **D**estination or **S**ource values are zero, or is cleared (0) if both are
non-zero. **TODO: is the entire register checked or just the bottom 16 bits?**

<%=p2instrinfo('muls')%>
MULS performs a _signed_ multiplication of the lower 16-bits of **D**estination and **S**ource and stores the 32-bit signed product
result into the **D**estination register. This is a fast (2-clock) signed 16 x 16 bit multiplication operation - to multiply larger factors, use [the CORDIC Solver QMUL instruction](cordic.html#qmul).

If the **WZ** effect is specified, the Z flag is set (1) if either the **D**estination or **S**ource values are zero, or is cleared (0) if both are
non-zero. **TODO: same question as MUL**

<%=p2instrinfo('sca')%>
SCA performs an _unsigned_ multiplication of the lower 16-bits of **D**estination and **S**ource, shifts the 32-bit product right by 16 (to scale
down the result), and substitutes this value as the next instruction's **S**ource value.

If the **WZ** effect is specified, the Z flag is set (1) if the product (before scaling down) is zero, or is cleared (0) if
non-zero.

<%=p2instrinfo('scas')%>
SCAS performs a _signed_ multiplication of the lower 16-bits of **D**estination and **S**ource, right shifts the 32-bit product by **14** (to
scale down the result), and substitutes this value as the next instruction's **S**ource value.

In this 2.14 fixed point scheme, a factor of $4000 will pass the the other factor through unchanged and a factor of $C000 will negate it.

If the **WZ** effect is specified, the Z flag is set (1) if the product (before scaling down) is zero, or is cleared (0) if
non-zero.

---

<%=p2instrinfo('incmod')%>
INCMOD compares **D**estination with **S**ource - if not equal, it increments **D**estination; otherwise it sets **D**estination to 0. If **D**estination begins in the range 0 to **S**ource, iterations of INCMOD will increment **D**estination repetitively from 0 to **S**ource.

If the **WC** or **WCZ** effect is specified, the C flag is set (1) if **D**estination was equal to **S**ource and subsequently reset to 0; or is
cleared (0) if not reset.

If the **WZ** or **WCZ** effect is specified, the Z flag is set (1) if the result is zero, or is cleared (0) if it is non-zero.

INCMOD does not limit **D**estination within the specified range - if **D**estination begins as greater than **S**ource, iterations of INCMOD
will continue to increment it through the 32-bit rollover point (back to 0) before it will effectively cycle from 0 to
**S**ource.


<%=p2instrinfo('decmod')%>
DECMOD compares **D**estination with 0 - if not equal, it decrements **D**estination; otherwise it sets **D**estination to **S**ource. If **D**estination begins in the range 0 to **S**ource, iterations of DECMOD will decrement **D**estination repetitively from **S**ource to 0.

If the **WC** or **WCZ** effect is specified, the C flag is set (1) if **D**estination was equal to 0 and subsequently reset to **S**ource; or is
cleared (0) if not reset.

If the **WZ** or **WCZ** effect is specified, the Z flag is set (1) if the result is zero, or is cleared (0) if it is non-zero.

DECMOD does not limit **D**estination within the specified range - if **D**estination begins as greater than **S**ource, iterations of DECMOD
will continue to decrement it down through **S**ource before it will effectively cycle from **S**ource to 0.


---

<%=p2instrinfo('fge')%>
FGE sets **D**estination to **S**ource if **D**estination is less than **S**ource by _unsigned_ comparsion. This is also known as a limit minimum function; preventing **D**estination from sinking below **S**ource.

If the **WC** or **WCZ** effect is specified, the C flag is set (1) if **D**estination was limited (**D**estination was less than **S**ource and now **D**estination is equal to **S**ource), or is cleared (0) if not limited.

If the **WZ** or **WCZ** effect is specified, the Z flag is set (1) if the result is zero, or is cleared (0) if it is non-zero.

<%=p2instrinfo('fges')%>
FGES sets **D**estination to **S**ource if **D**estination is less than **S**ource by _signed_ comparsion. This is also known as a limit minimum function; preventing **D**estination from sinking below **S**ource.

If the **WC** or **WCZ** effect is specified, the C flag is set (1) if **D**estination was limited (**D**estination was less than **S**ource and now **D**estination is equal to **S**ource), or is cleared (0) if not limited.

If the **WZ** or **WCZ** effect is specified, the Z flag is set (1) if the result is zero, or is cleared (0) if it is non-zero.

<%=p2instrinfo('fle')%>
FLE sets **D**estination to **S**ource if **D**estination is greater than **S**ource by _unsigned_ comparsion. This is also known as a limit maximum function; preventing **D**estination from rising above **S**ource.

If the **WC** or **WCZ** effect is specified, the C flag is set (1) if **D**estination was limited (**D**estination was greater than **S**ource and now **D**estination is equal to **S**ource), or is cleared (0) if not limited.

If the **WZ** or **WCZ** effect is specified, the Z flag is set (1) if the result is zero, or is cleared (0) if it is non-zero.

<%=p2instrinfo('fles')%>
FLES sets **D**estination to **S**ource if **D**estination is greater than **S**ource by _signed_ comparsion. This is also known as a limit maximum function; preventing **D**estination from rising above **S**ource.

If the **WC** or **WCZ** effect is specified, the C flag is set (1) if **D**estination was limited (**D**estination was greater than **S**ource and now **D**estination is equal to **S**ource), or is cleared (0) if not limited.

If the **WZ** or **WCZ** effect is specified, the Z flag is set (1) if the result is zero, or is cleared (0) if it is non-zero.

## Bit operations

<%=p2instrinfo('shl')%>
SHL shifts **D**estination's binary value left by **S**ource places (0–31 bits) and sets the new LSBs to 0. This is useful for
bit-stream manipulation as well as for swift multiplication; signed or unsigned 32-bit integer multiplication by a
power-of-two. Care must be taken for power-of-two multiplications since upper bits will shift through the MSB
(sign bit); mangling large signed values.

If the **WC** or **WCZ** effect is specified, the C flag is updated to the value of the last bit shifted out (effectively C =
result bit "32") if **S**ource is 1–31, or to **D**estination[31] if **S**ource is 0.

If the **WZ** or **WCZ** effect is specified, the Z flag is set (1) if the **D**estination result equals zero, or is cleared (0) if it is
non-zero.

<%=p2instrinfo('shr')%>
SHR shifts **D**estination's binary value right by **S**ource places (0–31 bits) and sets the new MSBs to 0. This is useful for
bit-stream manipulation as well as for swift division; unsigned 32-bit integer division by a power-of-two. For
similar division of a signed value, use [SAR](#sar) instead.

If the **WC** or **WCZ** effect is specified, the C flag is updated to the value of the last bit shifted out (effectively C =
result bit "-1") if **S**ource is 1–31, or to **D**estination[0] if **S**ource is 0.

If the **WZ** or **WCZ** effect is specified, the Z flag is set (1) if the **D**estination result equals zero, or is cleared (0) if it is
non-zero.

<%=p2instrinfo('sal')%>
SAL shifts **D**estination's binary value left by **S**ource places (0–31 bits) and sets the new LSBs to that of the original **D**estination[0].
SAL is the complement of [SAR](#sar) for bit streams but not for math operations - use [SHL](#shl) instead for swift 32-bit
integer multiplication by a power-of-two.

If the **WC** or **WCZ** effect is specified, the C flag is updated to the value of the last bit shifted out (effectively C =
result bit "32") if **S**ource is 1–31, or to **D**estination[31] if **S**ource is 0.

If the **WZ** or **WCZ** effect is specified, the Z flag is set (1) if the **D**estination result equals zero, or is cleared (0) if it is
non-zero.

<%=p2instrinfo('sar')%>
SAR shifts **D**estination's binary value right by **S**ource places (0–31 bits) and sets the new MSBs to that of the original
**D**estination[31]; preserving the sign of a signed integer. This is useful for bit stream manipulation and for swift division -
it is similar to [SHR](#shr) for swift division by a power-of-two, but is safe for both signed and unsigned integers. (Note that the rounding behaviour for negative numbers is different to a real division - **TODO: Describe this better**)

If the **WC** or **WCZ** effect is specified, the C flag is updated to the value of the last bit shifted out (effectively C =
result bit "-1") if **S**ource is 1–31, or to **D**estination[0] if **S**ource is 0.

If the **WZ** or **WCZ** effect is specified, the Z flag is set (1) if the **D**estination result equals zero, or is cleared (0) if it is
non-zero.


<%=p2instrinfo('rol')%>
ROL rotates **D**estination's binary value left by **S**ource places (0–31 bits). All MSBs rotated out are moved into the new LSBs.

If the **WC** or **WCZ** effect is specified, the C flag is updated to the value of the last bit rotated out (effectively C = result bit "0") if **S**ource is 1–31, or to **D**estination[31] if **S**ource is 0.

If the **WZ** or **WCZ** effect is specified, the Z flag is set (1) if the **D**estination result equals zero, or is cleared (0) if it is
non-zero. Since no bits are lost by this operation, the result will only be zero if **D**estination started at zero.

<%=p2instrinfo('ror')%>
ROR rotates **D**estination's binary value right by **S**ource places (0–31 bits). All LSBs rotated out are moved into the new MSBs.

If the **WC** or **WCZ** effect is specified, the C flag is updated to the value of the last bit rotated out (effectively C = result bit "31") if **S**ource is 1–31, or to **D**estination[0] if **S**ource is 0.

If the **WZ** or **WCZ** effect is specified, the Z flag is set (1) if the **D**estination result equals zero, or is cleared (0) if it is
non-zero. Since no bits are lost by this operation, the result will only be zero if **D**estination started at zero.

<%=p2instrinfo('rcl')%>
RCL shifts **D**estination's binary value left by **S**ource places (0–31 bits) and sets the new LSBs to C.

If the **WC** or **WCZ** effect is specified, the C flag is updated to the value of the last bit shifted out if **S**ource is 1–31, or to
**D**estination[31] if **S**ource is 0.

If the **WZ** or **WCZ** effect is specified, the Z flag is set (1) if the **D**estination result equals zero, or is cleared (0) if it is
non-zero.

<%=p2instrinfo('rcr')%>
RCR shifts **D**estination's binary value right by **S**ource places (0–31 bits) and sets the new MSBs to C.

If the **WC** or **WCZ** effect is specified, the C flag is updated to the value of the last bit shifted out if **S**ource is 1–31, or to
**D**estination[0] if **S**ource is 0.

If the **WZ** or **WCZ** effect is specified, the Z flag is set (1) if the **D**estination result equals zero, or is cleared (0) if it is
non-zero.

<%=p2instrinfo('rczl')%>
RCZL shifts **D**estination's binary value left by two places and sets **D**estination[1] to C and **D**estination[0] to Z.

If the **WC** or **WCZ** effect is specified, the C flag is updated to the original **D**estination[31] state.

If the **WZ** or **WCZ** effect is specified, the Z is flag is updated to the original **D**estination[30] state.

<%=p2instrinfo('rczr')%>
RCZR shifts **D**estination's binary value right by two places and sets **D**estination[31] to C and **D**estination[30] to Z.

If the **WC** or **WCZ** effect is specified, the C flag is updated to the original **D**estination[1] state.

If the **WZ** or **WCZ** effect is specified, the Z is flag is updated to the original **D**estination[0] state.

<%=p2instrinfo('signx')%>
SIGNX fills the bits of **D**estination, _above_ the bit indicated by **S**ource[4:0], with the value of that identified bit; i.e. sign-extending the value. This is handy when converting encoded or received signed values from a small bit width to a large bit with; i.e. 32 bits.

**Note:** To extend an N-bit value, **S**ource[4:0] has to be **N-1**. **(TODO: Clarify this in a less confusing way)**

If the **WC** or **WCZ** effect is specified, the C flag is set to the result's MSB value.

If the **WZ** or **WCZ** effect is specified, the Z flag is set (1) if the result is zero, or is cleared (0) if it is non-zero.

<%=p2instrinfo('zerox')%>
ZEROX fills the bits of **D**estination, _above_ the bit indicated by **S**ource[4:0], with zeroes; i.e. zero-extending the value. This is handy when converting encoded or received unsigned values from a small bit width to a large bit with; i.e. 32 bits.

**Note:** To extend an N-bit value, **S**ource[4:0] has to be **N-1**. **(TODO: Clarify this in a less confusing way)**

If the **WC** or **WCZ** effect is specified, the C flag is set to the result's MSB value. This is always zero unless **S**ource[4:0] == 31.

If the **WZ** or **WCZ** effect is specified, the Z flag is set (1) if the result is zero, or is cleared (0) if it is non-zero.



---

<%=p2instrinfo('not')%>
NOT performs a bitwise NOT (inverting all bits) of the value in **S**ource and stores the result into **D**estination.

If the **WC** or **WCZ** effect is specified, the C flag value is replaced by the inverse of either S[31].

If the **WZ** or **WCZ** effect is specified, the Z flag is set (1) if the result (of !**S**ource) equals zero, or is cleared (0) if it is non-zero.

<%=p2instrinfo('ones')%>
ONES tallies the number of high bits of **S**ource, or **D**estination, and stores the count into **D**estination. This is also known as a "Population Count" ("popcount") function.

If the **WC** or **WCZ** effect is specified, the C flag is set (1) if the count is odd, or is cleared (0) if it is even.

If the **WZ** or **WCZ** effect is specified, the Z flag is set (1) if the result equals zero, or is cleared (0) if not zero.

ONES' **S**ource can be omitted, in which case it defaults to being the same as its **D**estination.

<%=p2instrinfo('encod')%>
ENCOD stores the bit position value (0—31) of the top-most high bit (1) of **S**ource into **D**estination. If the value to encode is all zeroes, the resulting **D**estination will be 0 - use the **WC** or **WCZ** effect and check the resulting C flag to distinguish between the cases of **S**ource == 1 vs. **S**ource == 0.

If the **WC** or **WCZ** effect is specified, the C flag is set (1) if **S**ource was not zero, or is cleared (0) if it was zero.

If the **WZ** or **WCZ** effect is specified, the Z flag is set (1) if the result equals zero, or is cleared (0) if not zero.

- A long of `%00000000_00000000_00000000_00000001` encodes to 0.
- A long of `%00000000_00000000_00000000_00100000` encodes to 5.
- A long of `%00000000_00000000_10000001_01000000` encodes to 15.
- A long of `%00000000_00000000_00000000_00000000` encodes to 0 with optional C cleared to 0.

ENCOD is the complement of [DECOD](#decod).

ENCOD's **S**ource can be omitted, in which case it defaults to being the same as its **D**estination.

<%=p2instrinfo('decod')%>
DECOD generates a 32-bit value with just one bit high, corresponding to **S**ource[4:0] (0—31) and stores
that result in **D**estination.

In effect, **D**estination becomes `1 << value` via the DECOD instruction; where value is **S**ource[4:0].

- A value of 0 generates `%00000000_00000000_00000000_00000001`.
- A value of 5 generates `%00000000_00000000_00000000_00100000`.
- A value of 15 generates `%00000000_00000000_10000000_00000000`.

DECOD is the complement of [ENCOD](#encod)

DECOD's **S**ource can be omitted, in which case it defaults to being the same as its **D**estination.

<%=p2instrinfo('bmask')%>
BMASK generates an LSB-justified bit mask (all ones) of **S**ource[4:0]+1 bits and stores it in **D**estination. The size
value, specified by **S**ource[4:0], is in the range 0—31 to generate 1 to 32 bits of bit mask.

In effect, **D**estination becomes (%10 << size) - 1 via the BMASK instruction.

- A size value of 0 generates a bit mask of `%00000000_00000000_00000000_00000001`.
- A size value of 5 generates a bit mask of `%00000000_00000000_00000000_00111111`.
- A size value of 15 generates a bit mask of `%00000000_00000000_11111111_11111111`.

A bit mask is often useful in bitwise operations (AND, OR, XOR) to filter out or affect special groups of bits.

BMASK's **S**ource can be omitted, in which case it defaults to being the same as its **D**estination.

---

<%=p2instrinfo('rev')%>
REV performs a bitwise reverse (bits 31:0 -> bits 0:31) of the value in **D**estination and stores the result back into **D**estination.
This is useful for processing binary data in a different MSB/LSB order than it is transmitted with.

<%=p2instrinfo('splitb')%>
<%=p2instrinfo('mergeb',joinup:true)%>
SPLITB and MERGEB reorder the bits within **D**estination in a complementary pattern.
<%=permute_diagram("SPLITB","MERGEB","Splits groups of four bits in D into four bytes.","Merges four bytes in D into groups of four bits."){|i|next i,((i&3)<<3)+((i&28)>>2),%w[magenta blue lime red][i&3]}%>
**TODO more text**

<%=p2instrinfo('splitw')%>
<%=p2instrinfo('mergew',joinup:true)%>
SPLITW and MERGEW reorder the bits within **D**estination in a complementary pattern.
<%=permute_diagram("SPLITW","MERGEW","Splits odd/even bits in D into high/low words.","Merges high/low words in D into odd/even bits."){|i|next i,((i&1)<<4)+((i&30)>>1),%w[blue red][i&1]}%>
**TODO more text**

<%=p2instrinfo('rgbexp')%>
<%=p2instrinfo('rgbsqz',joinup:true)%>
RGBEXP and RGBSQZ convert between RGBx8888 and RGB565 color values.

<%=permute_diagram("RGBEXP","RGBSQZ","Expands RGB Color.","Squeezes RGB Color."){|i|if i>=16 then next nil elsif i>=11 then next i,i+16,"#f00",[i+11].reject{|i|i<24} elsif i>=5 then next i,i+13,"#0f0",[i+7].reject{|i|i<16} else next i,i+11,"#00f",[i+6].reject{|i|i<8} end}%>
**TODO RGBEXP text**

RGBSQZ converts a 32-bit color in **D**estination into a 16-bit color. This can be described as moving **D**estination[15:11] to **D**estination[4:0], **D**estination[23:18] into **D**estination[10:5], **D**estination[31:27] into **D**estination[15:11] and clearing the remaining 16 bits.




<%=p2instrinfo('seussf')%>
<%=p2instrinfo('seussr',joinup:true)%>
SEUSSF and SEUSSR are TODO weird. What are these actually good for?
<%=permute_diagram("SEUSSF","SEUSSR","Moves and flips bits in a 'forward' pattern.","Moves and flips bits in a 'reverse' pattern.",custom:%Q<<text x=0 y=5.5 style="font-size:0.7px;fill:lime;font-weight:bold;">TRUE</text><text x=0 y=6.5 style="font-size:0.7px;fill:red;font-weight:bold;">INVERSE</text>>){|i|next i,[22,6,4,14,10,17,29,0,31,9,1,15,2,16,12,13,23,7,8,3,25,21,26,28,30,20,19,27,24,18,5,11][31-i],%w[lime red][0b11101011010101010000001100101101[i]]}%>

SEUSSF bit permutation in text form:

<%="<ul>"%>
<%32.times do |i|%><%="<li>"%>bit <%=i%> -> bit <%=[22,6,4,14,10,17,29,0,31,9,1,15,2,16,12,13,23,7,8,3,25,21,26,28,30,20,19,27,24,18,5,11][31-i]%>, <%=%w[non-inverted inverted][0b11101011010101010000001100101101[i]]%><%="</li>"%><%end%>
<%="</ul>"%>

---

<%=p2instrinfo('test')%>
TEST performs a bitwise AND of the value in **S**ource into that of **D**estination, but discards the result (**D**estination remains unchanged). **Note that it is possible to encode TEST without any effects, which is entirely pointless.**

If the **WC** or **WCZ** effect is specified, the C flag is set (1) if the result has odd parity (contains an odd number of high (1) bits), or is cleared (0) if it has even parity (contains an even number of high bits).

If the **WZ** or **WCZ** effect is specified, the Z flag is set (1) if the **D**estination OR **S**ource result equals zero, or is cleared (0) if it is non-zero.

**Warning:** Easy to confuse with [TESTB](#testb)

<%=p2instrinfo('testn')%>
TESTN performs a bitwise AND of the _inverse_ of the value in **S**ource into that of **D**estination, but discards the result (**D**estination remains unchanged). **Note that it is possible to encode TESTN without any effects, which is entirely pointless.**

If the **WC** or **WCZ** effect is specified, the C flag is set (1) if the result has odd parity (contains an odd number of high (1) bits), or is cleared (0) if it has even parity (contains an even number of high bits).

If the **WZ** or **WCZ** effect is specified, the Z flag is set (1) if the **D**estination OR **S**ource result equals zero, or is cleared (0) if it is non-zero.

**Warning:** Easy to confuse with [TESTBN](#testbn)

<%=p2instrinfo('and')%>
AND performs a bitwise AND of the value in **S**ource into that of **D**estination.

If the **WC** or **WCZ** effect is specified, the C flag is set (1) if the result has odd parity (contains an odd number of high (1) bits), or is cleared (0) if it has even parity (contains an even number of high bits).

If the **WZ** or **WCZ** effect is specified, the Z flag is set (1) if the result equals zero, or is cleared (0) if it is non-zero.

<%=p2instrinfo('andn')%>
ANDN performs a bitwise AND of the _inverse_ of the value in **S**ource into that of **D**estination. That is, each high bit in **S**ource will become low in **D**estination.

If the **WC** or **WCZ** effect is specified, the C flag is set (1) if the result has odd parity (contains an odd number of high (1) bits), or is cleared (0) if it has even parity (contains an even number of high bits).

If the **WZ** or **WCZ** effect is specified, the Z flag is set (1) if the result equals zero, or is cleared (0) if it is non-zero.

<%=p2instrinfo('or')%>
OR performs a bitwise OR of the value in **S**ource into that of **D**estination.

If the **WC** or **WCZ** effect is specified, the C flag is set (1) if the result has odd parity (contains an odd number of high (1) bits), or is cleared (0) if it has even parity (contains an even number of high bits).

If the **WZ** or **WCZ** effect is specified, the Z flag is set (1) if the result equals zero, or is cleared (0) if it is non-zero.

<%=p2instrinfo('xor')%>
XOR performs a bitwise XOR of the value in **S**ource into that of **D**estination.

If the **WC** or **WCZ** effect is specified, the C flag is set (1) if the result has odd parity (contains an odd number of high (1) bits), or is cleared (0) if it has even parity (contains an even number of high bits).

If the **WZ** or **WCZ** effect is specified, the Z flag is set (1) if the result equals zero, or is cleared (0) if it is non-zero.

---

<%=p2instrinfo('testb')%>
<%=p2instrinfo('testb-and',joinup:true)%>
<%=p2instrinfo('testb-or',joinup:true)%>
<%=p2instrinfo('testb-xor',joinup:true)%>
TESTB reads the state (0/1) of a bit in **D**estination designated by **S**ource and either stores it as-is, or bitwise ANDs, ORs, or XORs it into the C or Z flag.

**S**ource[4:0] indicates the bit number (0–31) to test.

If the **WC** or **WZ** effect is specified, the C or Z flag is overwritten with the state of the bit.

If the **ANDC** or **ANDZ** effect is specified, the C or Z flag is bitwise ANDed with the state of the bit. If the **ORC** or **ORZ** effect is specified, the C or Z flag is bitwise ORed with the state of the bit.

If the **XORC** or **XORZ** effect is specified, the C or Z flag is bitwise XORed with the state of the bit.

See also [TESTBN](#testbn).

**Warning:** Easy to confuse with [TEST](#test).

<%=p2instrinfo('testbn')%>
<%=p2instrinfo('testbn-and',joinup:true)%>
<%=p2instrinfo('testbn-or',joinup:true)%>
<%=p2instrinfo('testbn-xor',joinup:true)%>
TESTBN reads the state (0/1) of a bit in **D**estination designated by **S**ource, inverts the result, and either stores it (the inverse value) as-is, or bitwise ANDs, ORs, or XORs it into the C or Z flag.

**S**ource[4:0] indicates the bit number (0–31) to test and invert.

If the **WC** or **WZ** effect is specified, the C or Z flag is overwritten with the inverse state of the bit.

If the **ANDC** or **ANDZ** effect is specified, the C or Z flag is bitwise ANDed with the inverse state of the bit. If the **ORC** or **ORZ** effect is specified, the C or Z flag is bitwise ORed with the inverse state of the bit.

If the **XORC** or **XORZ** effect is specified, the C or Z flag is bitwise XORed with the inverse state of the bit.

See also [TESTB](#testb).

**Warning:** Easy to confuse with [TESTN](#testn).

<%=p2instrinfo('bitl')%>
<%=p2instrinfo('bith')%>
<%=p2instrinfo('bitnot')%>
<%=p2instrinfo('bitrnd')%>
<%=p2instrinfo('bitc')%>
<%=p2instrinfo('bitnc')%>
<%=p2instrinfo('bitz')%>
<%=p2instrinfo('bitnz')%>

---

<%=p2instrinfo('muxc')%>
<%=p2instrinfo('muxnc')%>
<%=p2instrinfo('muxz')%>
<%=p2instrinfo('muxnz')%>

<%=p2instrinfo('muxq')%>
MUXQ copies all bits from **S**ource corresponding to high (1) bits of the [Q Register](cog.html#q-register) into the corresponding bits of **D**estination. All other **D**estination bits are left as-is.

The current Q value is always used, regardless of whether MUXQ is directly preceded by SETQ (i.e. whether the "SETQ Flag" is set) or not.

<%=p2instrinfo('muxnibs')%>
MUXNIBS copies any non-zero nibbles from **S**ource into the corresponding nibbles of **D**estination and leaves the rest of **D**estination's nibbles as-is.

**TODO more detail**

<%=p2instrinfo('muxnits')%>
MUXNITS copies any non-zero bit pairs from **S**ource into the corresponding bit pairs of **D**estination and leaves the rest of **D**estination's bit pairs as-is.

**TODO more detail**

## Flag manipulation

<%=p2instrinfo('modcz')%>
MODC, MODZ, or MODCZ sets or clears the C and/or Z flag based on the mode described by the given modifier symbols and the current state of the C and Z flags. The **WC**, **WZ**, and **WCZ** effects are required to affect the designated flag. **Note that it is possible to encode MODCZ without any effects, which is entirely pointless.**

These flag modifier instructions allow code to preset flags to a desired state which may be required for entry into certain code routines, or to set a special state based on multiple events that are otherwise not possible to realize with a single instruction.

The possible modifiers are:

|Encoding|Primary Name|Alternate 1|Alternate 2|Description|
|-----|----------|----------|---|-----------------------|
|%0000|_CLR      |          |   |Always clear flag      |
|%0001|_NC_AND_NZ|_NZ_AND_NC|_GT|Set flag if C=0 AND Z=0|
|%0010|_NC_AND_Z |_Z_AND_NC |   |Set flag if C=0 AND Z=1|
|%0011|_NC       |          |_GE|Set flag if C=0        |
|%0100|_C_AND_NZ |_NZ_AND_C |   |Set flag if C=1 AND Z=0|
|%0101|_NZ       |          |_NE|Set flag if Z=0        |
|%0110|_C_NE_Z   |_Z_NE_C   |   |Set flag if C!=Z       |
|%0111|_NC_OR_NZ |_NZ_OR_NC |   |Set flag if C=0 OR Z=0 |
|%1000|_C_AND_Z  |_Z_AND_C  |   |Set flag if C=1 AND Z=1|
|%1001|_C_EQ_Z   |_Z_EQ_C   |   |Set flag if C=Z        |
|%1010|_Z        |          |_E |Set flag if Z=1        |
|%1011|_NC_OR_Z  |_Z_OR_NC  |   |Set flag if C=0 OR Z=1 |
|%1100|_C        |          |_LT|Set flag if C=1        |
|%1101|_C_OR_NZ  |_NZ_OR_C  |   |Set flag if C=1 OR Z=0 |
|%1110|_C_OR_Z   |_Z_OR_C   |   |Set flag if C=1 OR Z=1 |
|%1111|_SET      |          |   |Always set flag        |

Note the logical nature of the encoding: Each bit in the modifier corrosponds to one possible state of \[C,Z\].

Thus, every modifier with one bit set is an "x AND y" type (only one of four possible states sets the flag), every modifier with 3 bits set is an "x OR y" type (all _but_ one state sets the flag).

<%=p2instrinfo('modc')%>
MODC is an alias for [MODCZ](#modcz) without the Z parameter.

<%=p2instrinfo('modz')%>
MODZ is an alias for [MODCZ](#modcz) without the C parameter.

<%=p2instrinfo('wrc')%>
WRC writes the state of C (0 or 1) to **D**estination. The entire register is overwritten.

<%=p2instrinfo('wrnc')%>
WRNC writes the inverse state of C (0 or 1) to **D**estination. The entire register is overwritten.

<%=p2instrinfo('wrz')%>
WRZ writes the state of Z (0 or 1) to **D**estination. The entire register is overwritten.

<%=p2instrinfo('wrnz')%>
WRNZ writes the inverse state of Z (0 or 1) to **D**estination. The entire register is overwritten.


## Other

<%=p2instrinfo('crcbit')%>
CRCBIT feeds one bit, taken from the C flag, into the CRC checksum in **D**estination, using the polynomial given in **S**ource.

`CRCBIT D,S` is equivalent to the following sequence (except that CRCBIT does not change the C flag):

~~~
        TESTB  D,#0 xorc
        SHR    D,#1
   if_c XOR    D,S
~~~

<%=p2instrinfo('crcnib')%>
CRCNIB feeds one nibble, taken from the top 4 bits of the [Q Register](cog.html#q-register), into the CRC checksum in **D**estination, using the polynomial given in **S**ource. The top bit of Q is processed first. Afterwards, Q is shifted left by 4 bits.

To process an entire long, the following sequence can be used:

~~~
        SETQ  value
        REP   #1,#8
        CRCNIB checksum,polynomial
~~~

<%=p2instrinfo('xoro32')%>
XORO32 generates a pseudo-random number based on the seed value in **D**estination. The next seed value is written back into **D**estination and the generated pseudo-random number is substituted as the next instruction's **S**ource value (and as a side effect, also written to the [Q Register](cog.html#q-register)).

**D**estination's value should never be zero, since that causes the seed to stay zero.

The algorithm used is xoroshiro32++, stepped twice to generate 2x16 bits of data. Due to this, some 32-bit numbers are never generated. Ideal properties are only guaranteed if only the top or bottom 16 bits of the generated number are used. Any subset of bits from either the upper or lower half are also equidistributed.

A software implementation of the algorithm in Spin2:

~~~
CON
    A = 13, B = 5, C = 10, D = 9
PUB xoro32_soft(seed) : state,val
  state, val.word[0] := xoro32_half(seed)
  state, val.word[1] := xoro32_half(state)

PRI xoro32_half(seed) : state,val
  val.word[0] := rol16(seed.word[0]+seed.word[1],D)+seed.word[0]
  state := seed
  state.word[1] ^= state.word[0]
  state.word[0] := rol16(state.word[0],A) ^ (state.word[1]<<B) ^ state.word[1]
  state.word[1] := rol16(state.word[1],C)

PRI rol16(val,amount) :r
  val.word[1] := val.word[0]
  return (val rol amount) zerox 15
~~~

<%p2instr_checkall :alu%>