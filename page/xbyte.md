---
title: Bytecode Engine (XBYTE)
hyperjump:
    -   type: Topic
---
# Bytecode Engine (XBYTE)

**TODO**

Bytecodes go brr.

|Cycle|Phase|XBYTE activity                              |Description                                |
|:---:|:---:|--------------------------------------------|-------------------------------------------|
|1    |go   |RFBYTE bytecode<br>SKIPF #0                 |_Last clock of the RET/_RET_ to $1FF_<br>**Fetch bytecode from FIFO (initialized via prior RDFAST).**<br>**Cancel any SKIPF pattern in progress (from prior bytecode).**|
|2    |get  |MOV PA,bytecode<br>RDLUT (computed address) |_1st clock of 1st canceled instruction_<br>**Write bytecode to PA ($1F6).**<br>**Read lookup-table RAM according to bytecode and mode.**|
|3    |go   |RDLUT (data -> D)                           |_2nd clock of 1st canceled instruction_<br>**Get lookup RAM long into D for EXECF.**|
|4    |get  |EXECF D (begin)                             |_1st clock of 2nd canceled instruction_<br>**Execute EXECF.**|
|5    |go   |GETPTR PB<br>(Set flags)<br>EXECF D (branch)|_2nd clock of 2nd canceled instruction_<br>**Write FIFO pointer to PB ($1F7).**<br>**Write C,Z with bit1,bit0 of RDLUT address, if enabled.**<br>**Do EXECF branch.**|
|6    |get  |(Flush pipeline)                            |_1st clock of 3rd canceled instruction_|
|7    |go   |(Reload pipeline)                           |_2nd clock of 3rd canceled instruction_|
|8    |get  |(done)                                      |_1st clock of 1st instruction of bytecode routine_<br>**Loop to clock 1 if _RET_ or RET.**|

|Bits|SETQ/SETQ2<br>D value|LUT base<br>address|LUT index<br>(b = bytecode)|LUT EXECF<br>address|
|:--:|:-------------------:|:-----------------:|:--------------------------|:------------------:|
|8   |%A000000xF           |%A00000000         |I = b[7:0]                 |%AIIIIIIII          |
|8   |%ABBBB00xF<br>(%BBBB > 0)|%A00000000     |if b[7:4] <&nbsp; %BBBB then I = b[7:0]<br>if b[7:4] >= %BBBB then I = b[7:4] - %BBBB|%AIIIIIIII<br>%ABBBBIIII|
|7   |%AAxx0010F           |%AA0000000         |I = b[6:0]                 |%AAIIIIIII          |
|7   |%AAxx0011F           |%AA0000000         |I = b[7:1]                 |%AAIIIIIII          |
|6   |%AAAx1010F           |%AAA000000         |I = b[5:0]                 |%AAAIIIIII          |
|6   |%AAAx1011F           |%AAA000000         |I = b[7:2]                 |%AAAIIIIII          |
|5   |%AAAAx100F           |%AAAA00000         |I = b[4:0]                 |%AAAAIIIII          |
|5   |%AAAAx100F           |%AAAA00000         |I = b[7:3]                 |%AAAAIIIII          |
|4   |%AAAAA110F           |%AAAAA0000         |I = b[3:0]                 |%AAAAAIIII          |
|4   |%AAAAA111F           |%AAAAA0000         |I = b[7:4]                 |%AAAAAIIII          |

|SETQ/SETQ2<br>D value|Flag Writing                            |
|:-------------------:|----------------------------------------|
|%xxxxxxxx0           |Do not affect flags on XBYTE            |
|%xxxxxxxx1           |Write the bytecode index LSBs to C and Z|
