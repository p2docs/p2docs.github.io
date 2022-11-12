---
title: Pixel Mixer
hyperjump:
    -   type: Topic
---

# Pixel Mixer


All pixel mixer operations perform the following math:

$$
\newcommand{\DMIX}{\mathit{DMIX}}
\newcommand{\SMIX}{\mathit{SMIX}}
D'[31:24] \approx \min\left({{D[31:24] *\DMIX+S[31:24] *\SMIX+255}\over 256},255\right) \\
D'[23:16] \approx \min\left({{D[23:16] *\DMIX+S[23:16] *\SMIX+255}\over 256},255\right) \\
D'[15:~~8] \approx \min\left({{D[15:08] *\DMIX+S[15:~~8] *\SMIX+255}\over 256},255\right) \\
D'[~~7:~~0] \approx \min\left({{D[~~7:~~0] *\DMIX+S[~~7:~~0] *\SMIX+255}\over 256},255\right)
$$

wherein DMIX and SMIX depend on the instruction:

|Instr.|DMIX|SMIX|
|-|-|-|
|ADDPIX|255|255|
|MULPIX|S[byte]|0|
|BLNPIX|255 - PIV|PIV|
|MIXPIX|PIX[5:3] = %000 -> 0<br>PIX[5:3] = %001 -> 255<br>PIX[5:3] = %010 -> PIV<br>PIX[5:3] = %011 -> 255 - PIV<br>PIX[5:3] = %100 -> S[byte]<br>PIX[5:3] = %101 -> 255 - S[byte]<br>PIX[5:3] = %110 -> D[byte]<br>PIX[5:3] = %111 -> 255 - D[byte]|PIX[2:0] = %000 -> 0<br>PIX[2:0] = %001 -> 255<br>PIX[2:0] = %010 -> PIV<br>PIX[2:0] = %011 -> 255 - PIV<br>PIX[2:0] = %100 -> S[byte]<br>PIX[2:0] = %101 -> 255 - S[byte]<br>PIX[2:0] = %110 -> D[byte]<br>PIX[2:0] = %111 -> 255 - D[byte]|

The equivalent SETPIX value for ADDPIX is `%001_001`.

The equivalent SETPIX value for MULPIX is `%100_000`.

The equivalent SETPIX value for BLNPIX is `%011_010`.

## Instructions

<%=p2instrinfo('addpix')%>
ADDPIX performs a per-byte saturated addition of **S**ource into **D**estination. I.e. if the addition of a byte overflows, the result is capped to 255.

$$
D'[31:24] = \min\left({D[31:24]+S[31:24]},255\right) \\
D'[23:16] = \min\left({D[23:16]+S[23:16]},255\right) \\
D'[15:~~8] = \min\left({D[15:08]+S[15:~~8]},255\right) \\
D'[~~7:~~0] = \min\left({D[~~7:~~0]+S[~~7:~~0]},255\right)
$$

<%=p2instrinfo('mulpix')%>
<%=p2instrinfo('blnpix')%>

<%=p2instrinfo('mixpix')%>
MIXPIX performs an arbitrary pixel mix operation between **S**ource and **D**estination, as configured by [SETPIX](#setpix). Also [see above]().

**TODO more**

<%=p2instrinfo('setpiv')%>
<%=p2instrinfo('setpix')%>

<%p2instr_checkall :mixpix%>