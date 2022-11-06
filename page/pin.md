---
title: I/O Pins
hyperjump:
    -   type: Topic
    -   id: smart-pin-modes
        name: Smart Pin Modes
        type: Topic

---

# I/O Pins

**TODO**


## Diagram
<img src="pin-diagram.png">

**TODO: Transparent version**

## I/O Instructions
<%=p2instrinfo('drvl')%>
<%=p2instrinfo('drvh')%>
<%=p2instrinfo('drvnot')%>
<%=p2instrinfo('drvrnd')%>
<%=p2instrinfo('drvc')%>
<%=p2instrinfo('drvnc')%>
<%=p2instrinfo('drvz')%>
<%=p2instrinfo('drvnz')%>

<%=p2instrinfo('fltl')%>
<%=p2instrinfo('flth')%>
<%=p2instrinfo('fltnot')%>
<%=p2instrinfo('fltrnd')%>
<%=p2instrinfo('fltc')%>
<%=p2instrinfo('fltnc')%>
<%=p2instrinfo('fltz')%>
<%=p2instrinfo('fltnz')%>

<%=p2instrinfo('outl')%>
<%=p2instrinfo('outh')%>
<%=p2instrinfo('outnot')%>
<%=p2instrinfo('outrnd')%>
<%=p2instrinfo('outc')%>
<%=p2instrinfo('outnc')%>
<%=p2instrinfo('outz')%>
<%=p2instrinfo('outnz')%>

<%=p2instrinfo('dirl')%>
<%=p2instrinfo('dirh')%>
<%=p2instrinfo('dirnot')%>
<%=p2instrinfo('dirrnd')%>
<%=p2instrinfo('dirc')%>
<%=p2instrinfo('dirnc')%>
<%=p2instrinfo('dirz')%>
<%=p2instrinfo('dirnz')%>


<%=p2instrinfo('testp')%>
<%=p2instrinfo('testpn',joinup:true)%>
<%=p2instrinfo('testp-and',joinup:true)%>
<%=p2instrinfo('testpn-and',joinup:true)%>
<%=p2instrinfo('testp-or',joinup:true)%>
<%=p2instrinfo('testpn-or',joinup:true)%>
<%=p2instrinfo('testp-xor',joinup:true)%>
<%=p2instrinfo('testpn-xor',joinup:true)%>



## Smart Pin Instructions

**TODO: AKPIN is an alias??????**

<%=p2instrinfo('wrpin')%>
<%=p2instrinfo('wxpin')%>
<%=p2instrinfo('wypin')%>
<%=p2instrinfo('rdpin')%>
<%=p2instrinfo('rqpin')%>

<%=p2instrinfo('akpin')%>
AKPIN is an alias for [WRPIN **#1**,{#}S](#wrpin) **TODO**


## Other Instructions

<%=p2instrinfo('setdacs')%>
<%=p2instrinfo('setscp')%>
<%=p2instrinfo('getscp')%>

<%p2instr_checkall :pin%>

## Smart Pin modes

<%=p2smartinfo('p-normal')%>
<%=p2smartinfo('p-repository')%>
<%=p2smartinfo('p-dac-noise')%>
<%=p2smartinfo('p-dac-dither-rnd')%>
<%=p2smartinfo('p-dac-dither-pwm')%>
<%=p2smartinfo('p-pulse')%>
<%=p2smartinfo('p-transition')%>
<%=p2smartinfo('p-nco-freq')%>
<%=p2smartinfo('p-nco-duty')%>
<%=p2smartinfo('p-pwm-triangle')%>
<%=p2smartinfo('p-pwm-sawtooth')%>
<%=p2smartinfo('p-pwm-smps')%>
<%=p2smartinfo('p-quadrature')%>
<%=p2smartinfo('p-reg-up')%>
<%=p2smartinfo('p-reg-up-down')%>
<%=p2smartinfo('p-count-rises')%>
<%=p2smartinfo('p-count-highs')%>
<%=p2smartinfo('p-state-ticks')%>
<%=p2smartinfo('p-high-ticks')%>
<%=p2smartinfo('p-events-ticks')%>
<%=p2smartinfo('p-periods-ticks')%>
<%=p2smartinfo('p-periods-highs')%>
<%=p2smartinfo('p-counter-ticks')%>
<%=p2smartinfo('p-counter-highs')%>
<%=p2smartinfo('p-counter-periods')%>
<%=p2smartinfo('p-adc')%>
<%=p2smartinfo('p-adc-ext')%>
<%=p2smartinfo('p-adc-scope')%>
<%=p2smartinfo('p-usb-pair')%>
<%=p2smartinfo('p-sync-tx')%>
<%=p2smartinfo('p-sync-rx')%>
<%=p2smartinfo('p-async-tx')%>
<%=p2smartinfo('p-async-rx')%>



