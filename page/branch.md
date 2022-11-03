---
title: Branching Instructions
jump_toplevel: Topic
---
# Branching Instructions

## Basic Branches

<%=p2instrinfo('jmp')%>
**TODO: THERE ARE MULTIPLE DESTINCT JMP OPCODES**

<%=p2instrinfo('jmprel')%>

## Skip

<%=p2instrinfo('skip')%>
<%=p2instrinfo('skipf')%>
<%=p2instrinfo('execf')%>

## Repeat

<%=p2instrinfo('rep')%>

## Internal Stack Calls

<%=p2instrinfo('call')%>
**TODO: THERE ARE MULTIPLE DESTINCT CALL OPCODES**
<%=p2instrinfo('ret')%>
<%=p2instrinfo('callpa')%>
<%=p2instrinfo('callpb')%>
<%=p2instrinfo('calld')%>
**TODO: THERE ARE MULTIPLE DESTINCT CALLD OPCODES**

## External Stack Calls

<%=p2instrinfo('calla')%>
<%=p2instrinfo('callb')%>
<%=p2instrinfo('reta')%>
<%=p2instrinfo('retb')%>

## Test and Branch

<%=p2instrinfo('tjz')%>
<%=p2instrinfo('tjnz')%>
<%=p2instrinfo('tjf')%>
<%=p2instrinfo('tjnf')%>
<%=p2instrinfo('tjs')%>
<%=p2instrinfo('tjns')%>
<%=p2instrinfo('tjv')%>

## Modify and Branch

<%=p2instrinfo('djz')%>
<%=p2instrinfo('djnz')%>
<%=p2instrinfo('djf')%>
<%=p2instrinfo('djnf')%>
<%=p2instrinfo('ijz')%>
<%=p2instrinfo('ijnz')%>

## Branch on Event

See [Events](event.html) for more info.

<% P2Opdata::EVENTS.each do |ev| %>
<%=p2instrinfo("j#{ev}")%>
<%=p2instrinfo("jn#{ev}")%>
<%end%>


<%p2instr_checkall :branch%>