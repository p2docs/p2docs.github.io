---
title: CORDIC Coprocessor
hyperjump:
    -   type: Topic
---
# CORDIC Coprocessor

The Propeller 2 contains a 54-stage pipelined CORDIC solver that can compute various math functions.

When a cog issues a CORDIC instruction, it must wait for its hub slot, which is 0..7 clocks away, in order to hand off the command to the CORDIC coprocessor. 55 clocks later, results will be available via the GETQX and GETQY instructions, which will wait for the results, in case they haven't arrived yet.

Because each cog's hub slot comes around every 8 clocks and the pipeline is 54 clocks long, it is possible to overlap CORDIC commands, where several commands are initially given to the coprocessor, and then results are read and another command is given, indefinitely, until, at the end, the trailing results are read. One must not have interrupts enabled during such a juggle, or enough clocks could be stolen by the interrupt service routine that one or more of the results could be overwritten before you can read them.

**TODO: Reword above**

If results are attempted to be read when none are available and no commands are in progress, GETQX/GETQY will only take 2 cycles and the QMT (CORDIC empty) event flag will be set.

## Binary Angles

**TODO explain binrads**


## Result retrieval

<%=p2instrinfo('getqx')%>
Retrieves the X result from the CORDIC coprocessor into **D**estination. **TODO: What gets written if QMT flag gets set?**

If the **WC** or **WCZ** effect is specified, the C flag is set to the MSB of the X result.

If the **WZ** or **WCZ** effect is specified, the Z flag is set (1) if the X result equals zero, or is cleared (0) if it is
non-zero.

<%=p2instrinfo('getqy')%>
Retrieves the Y result from the CORDIC coprocessor into **D**estination. **TODO: What gets written if QMT flag gets set?**

If the **WC** or **WCZ** effect is specified, the C flag is set to the MSB of the Y result.

If the **WZ** or **WCZ** effect is specified, the Z flag is set (1) if the Y result equals zero, or is cleared (0) if it is
non-zero.


## Commands

<%=p2instrinfo('qrotate')%>
QROTATE instructs the CORDIC coprocessor to rotate a signed 2D vector by the [binary angle](#binary-angles) in **S**ource. The X component of the vector is given in **D**estination and if QROTATE is immediately preceded by SETQ, the **Q** value provides the Y component (otherwise, Y=0).

When it is done, GETQX/GETQY will return the X'/Y' of the rotated vector, respectively.

Mathematically, it performs this operation:

$$
\begin{align*}
QX \approx D cos(S) - Q sin(S)\\\
QY \approx D sin(S) + Q cos(S)
\end{align*}
$$

Thus, if Q=0 (as happens when SETQ is not used), QROTATE can be used to compute sine/cosine pairs at a scale given by D. i.e.

~~~
    '' Compute sine/cosine for theta, 32 bit precision.
    QROTATE ##$7FFF_FFFF, theta
    ' Can do other stuff while waiting
    GETQX   cosine ' cosine with 32 bit precision
    GETQY   sine ' cosine with 32 bit precision
~~~

This is also the same operation as converting a polar vector (length/angle) into a carthesian(X/Y) one:

~~~
    '' Convert polar to carthesian
    QROTATE length,angle
    ' Can do other stuff while waiting
    GETQX x
    GETQY y
~~~

<%=p2instrinfo('qvector')%>
QROTATE instructs the CORDIC coprocessor to convert a carthesian vector (X/Y) in **D**estination (**X**) and **S**ource (**Y**) into a polar vector (length/angle). When it is done, **GETQX** will return the angle (as a [binary angle](#binary-angles)) and **GETQY** will return the length of the vector.

Mathematically:

$$
QX \approx atan2(S,D)\\\
QY \approx \sqrt{D^2+S^2}
$$

<%=p2instrinfo('qmul')%>
QMUL instructs the CORDIC coprocessor to perform unsigned multiplication of **D**estination and **S**ource. When it is done, **GETQX** will return the lower 32 bits of the result and **GETQY** will return the upper 32 bits.

Note that the lower half of a multiply result is the same regardless of wether the operation is signed or unsigned. Thus QMUL can be used for signed multiplication as-is, as long as the upper half of the result from GETQY isn't needed.

<%=p2instrinfo('qdiv')%>
QDIV instructs the CORDIC coprocessor to perform unsigned division of **D**estination by **S**ource. If QDIV is immediately preceded by SETQ, the **Q** value provides the upper 32 bits of a 64-bit dividend.

When it is done, **GETQX** will return the quotient and **GETQY** will return the remainder.

<%=p2instrinfo('qfrac')%>
QFRAC instructs the CORDIC coprocessor to perform fractional division of **D**estination by **S**ource. It works identically to [QDIV](#qdiv), except that **D**estination is the upper 32 bits of the dividend and the optional SETQ value is the bottom 32 bits (zero if no SETQ).

**TODO maybe write more here**

<%=p2instrinfo('qsqrt')%>
QSQRT instructs the CORDIC coprocessor to compute the square root of the unsigned 64-bit number formed by **D**estination (lower half) and **S**ource (upper half).

When it is done, **GETQX** will return the result, rounded down. **? TODO verify rounding. Also what happens to Y???**

<%=p2instrinfo('qlog')%>
QLOG instructs the CORDIC coprocessor to compute the base-2 logarithm of the unsigned 32-bit number in **D**estination. When it is done, **GETQX** returns the logarithm, in 5.27 fixed-point format (i.e. the top five bits containing the whole part).

$$
QX \approx 2^{27}log2(D)
$$


<%=p2instrinfo('qexp')%>
QLOG instructs the CORDIC coprocessor to compute two to the power of the 5.27 fixed-point exponent in **D**estination. When it is done, **GETQX** returns the result (**TODO rounded down?**).

$$
QX \approx 2^{D/2^{27}}
$$

<%p2instr_checkall :cordic%>