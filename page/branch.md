---
title: Branching Instructions
hyperjump:
    -   type: Topic
---
# Branching Instructions

## Basic Branches

<%=p2instrinfo('jmp-a')%>
<%=p2instrinfo('jmp-d')%>
**TODO: THERE ARE MULTIPLE DESTINCT JMP OPCODES**

<%=p2instrinfo('jmprel')%>

## Skip

<%=p2instrinfo('skip')%>
<%=p2instrinfo('skipf')%>
<%=p2instrinfo('execf')%>

## Repeat

<%=p2instrinfo('rep')%>

## Internal Stack Calls

<%=p2instrinfo('call-a')%>
<%=p2instrinfo('call-d')%>
<%=p2instrinfo('calld-a')%>
<%=p2instrinfo('calld-s')%>
<%=p2instrinfo('callpa')%>
<%=p2instrinfo('callpb')%>
<%=p2instrinfo('ret')%>

## External Stack Calls

<%=p2instrinfo('calla-a')%>
<%=p2instrinfo('calla-d')%>
<%=p2instrinfo('callb-a')%>
<%=p2instrinfo('callb-d')%>
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