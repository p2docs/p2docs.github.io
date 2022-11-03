---
title: Events
jump-toplevel: Topic
---
# Events

Brain hurt.

## Setup Instructions

<%=p2instrinfo('setse1')%>
<%=p2instrinfo('setse2')%>
<%=p2instrinfo('setse3')%>
<%=p2instrinfo('setse4')%>
<%=p2instrinfo('addct1')%>
<%=p2instrinfo('addct2')%>
<%=p2instrinfo('addct3')%>
<%=p2instrinfo('setpat')%>

## Attention

<%=p2instrinfo('cogatn')%>

## Poll Instructions

<% P2Opdata::EVENTS.each do |ev| %>
<%=p2instrinfo("poll#{ev}")%>
<%end%>

## Wait Instructions

<% P2Opdata::EVENTS.each do |ev| %>
<%next if ev=="qmt"%>
<%=p2instrinfo("wait#{ev}")%>
<%end%>

<%p2instr_checkall :event%>
