---
title: Math and Logic Instructions
hyperjump:
    -   type: Topic
---
# Math and Logic Instructions

## Data movement
<%=p2instrinfo('mov')%>
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
<%=p2instrinfo('neg')%>
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
<%=p2instrinfo('muls')%>
<%=p2instrinfo('sca')%>
<%=p2instrinfo('scas')%>

---

<%=p2instrinfo('incmod')%>
<%=p2instrinfo('decmod')%>

---

<%=p2instrinfo('fge')%>
<%=p2instrinfo('fges')%>
<%=p2instrinfo('fle')%>
<%=p2instrinfo('fles')%>

## Bit operations

<%=p2instrinfo('shl')%>
<%=p2instrinfo('shr')%>
<%=p2instrinfo('sal')%>
Not very helpful...
<%=p2instrinfo('sar')%>
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
<%=p2instrinfo('decod')%>
<%=p2instrinfo('encod')%>
<%=p2instrinfo('bmask')%>
<%=p2instrinfo('ones')%>

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