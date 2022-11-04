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

If the **WZ** or **WCZ** effect is specified, the Z flag is set (1) if the **D**estination result equals zero, or is cleared (0) if it is
non-zero.



<%=p2instrinfo('movbyts')%>
<%=p2instrinfo('loc')%>

---

<%=p2instrinfo('getnib')%>
<%=p2instrinfo('getbyte')%>
<%=p2instrinfo('getword')%>

---

<%=p2instrinfo('setnib')%>
<%=p2instrinfo('setbyte')%>
<%=p2instrinfo('setword')%>

---

<%=p2instrinfo('rolnib')%>
<%=p2instrinfo('rolbyte')%>
<%=p2instrinfo('rolword')%>

---

<%=p2instrinfo('sets')%>
<%=p2instrinfo('setd')%>
<%=p2instrinfo('setr')%>

## Arithmetic

<%=p2instrinfo('add')%>
Number go brr.
<%=p2instrinfo('adds')%>
<%=p2instrinfo('addx')%>
<%=p2instrinfo('addsx')%>

---

<%=p2instrinfo('sub')%>
<%=p2instrinfo('subs')%>
<%=p2instrinfo('subr')%>
<%=p2instrinfo('subx')%>
<%=p2instrinfo('subsx')%>

---

<%=p2instrinfo('cmp')%>
<%=p2instrinfo('cmps')%>
<%=p2instrinfo('cmpr')%>
<%=p2instrinfo('cmpm')%>
<%=p2instrinfo('cmpsub')%>
<%=p2instrinfo('cmpx')%>
<%=p2instrinfo('cmpsx')%>

---

<%=p2instrinfo('abs')%>
ABS determines the absolute value of **S**ource and writes the result into **D**estination.

If the **WC** or **WCZ** effect is specified, the C flag is set (1) if the original **S**ource value was negative, or is cleared
(0) if it was positive.

If the **WZ** or **WCZ** effect is specified, the Z flag is set (1) if the result is zero, or is cleared (0) if it is non-zero.

Literal **S**ource values are zero-extended, so ABS is really best used with register **S**ource (or augmented **S**ource) values.

<%=p2instrinfo('neg')%>
NEG negates **S**ource and stores the result in the **D**estination register. The negation flips the
value's sign; ex: 78 becomes -78, or -306 becomes 306.

If the **WC** or **WCZ** effect is specified, the C flag is set (1) if the result is negative, or is cleared (0) if positive.

If the **WZ** or **WCZ** effect is specified, the Z flag is set (1) if the result is zero, or is cleared (0) if it is non-zero.


<%=p2instrinfo('negc')%>
<%=p2instrinfo('negnc')%>
<%=p2instrinfo('negz')%>
<%=p2instrinfo('negnz')%>

---

<%=p2instrinfo('sumc')%>
<%=p2instrinfo('sumnc')%>
<%=p2instrinfo('sumz')%>
<%=p2instrinfo('sumnz')%>

---

<%=p2instrinfo('mul')%>
MUL multiplies the lower 16-bits of each of **D**estination and **S**ource together and stores the 32-bit product result into the **D**estination
register. This is a fast (2-clock) 16 x 16 bit multiplication operation - to multiply larger factors, use [the CORDIC Solver QMUL instruction](cordic.html#qmul).

If the **WZ** effect is specified, the Z flag is set (1) if either the **D**estination or **S**ource values are zero, or is cleared (0) if both are
non-zero. **TODO: is the entire register checked or just the bottom 16 bits?**

<%=p2instrinfo('muls')%>

MULS multiplies the signed lower 16-bits of each of **D**estination and **S**ource together and stores the 32-bit signed product
result into the **D**estination register. This is a fast (2-clock) signed 16 x 16 bit multiplication operation - to multiply larger factors, use [the CORDIC Solver QMUL instruction](cordic.html#qmul).

If the **WZ** effect is specified, the Z flag is set (1) if either the **D**estination or **S**ource values are zero, or is cleared (0) if both are
non-zero. **TODO: same question as MUL**

<%=p2instrinfo('sca')%>
SCA multiplies the lower 16-bits of each of **D**estination and **S**ource together, shifts the 32-bit product right by 16 (to scale
down the result), and substitutes this value as the next instruction's **S**ource value.

If the **WZ** effect is specified, the Z flag is set (1) if the product (before scaling down) is zero, or is cleared (0) if
non-zero.

<%=p2instrinfo('scas')%>
SCAS multiplies the lower, signed 16-bits of each of **D**estination and **S**ource together, right shifts the 32-bit product by 14 (to
scale down the result), and substitutes this value as the next instruction's **S**ource value.

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
<%=p2instrinfo('ror')%>
<%=p2instrinfo('rcl')%>
<%=p2instrinfo('rcr')%>
<%=p2instrinfo('rczl')%>
<%=p2instrinfo('rczr')%>
<%=p2instrinfo('signx')%>
<%=p2instrinfo('zerox')%>

---

<%=p2instrinfo('not')%>
<%=p2instrinfo('ones')%>
<%=p2instrinfo('encod')%>
<%=p2instrinfo('decod')%>
<%=p2instrinfo('bmask')%>

---

<%=p2instrinfo('rev')%>
<%=p2instrinfo('splitb')%>
<img src="P2_instruction_SPLITB_MERGEB.png">
<%=p2instrinfo('mergeb')%>
<%=p2instrinfo('splitw')%>
<img src="P2_instruction_SPLITW_MERGEW.png">
<%=p2instrinfo('mergew')%>
<%=p2instrinfo('rgbsqz')%>
<%=p2instrinfo('rgbexp')%>
<%=p2instrinfo('seussf')%>
<img src="P2_instruction_SEUSSF_SEUSSR.png">
<%=p2instrinfo('seussr')%>

---

<%=p2instrinfo('test')%>
<%=p2instrinfo('testn')%>
<%=p2instrinfo('and')%>
<%=p2instrinfo('andn')%>
<%=p2instrinfo('or')%>
<%=p2instrinfo('xor')%>

---

<%=p2instrinfo('testb')%>
<%=p2instrinfo('testbn')%>
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
<%=p2instrinfo('muxnits')%>
<%=p2instrinfo('muxnibs')%>

## Flag manipulation

<%=p2instrinfo('modcz')%>
<%=p2instrinfo('wrc')%>
<%=p2instrinfo('wrnc')%>
<%=p2instrinfo('wrz')%>
<%=p2instrinfo('wrnz')%>


## Other

<%=p2instrinfo('crcbit')%>
<%=p2instrinfo('crcnib')%>
<%=p2instrinfo('xoro32')%>

<%p2instr_checkall :alu%>