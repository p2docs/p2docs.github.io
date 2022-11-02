---
title: Propeller 2 instruction table
---

# P2 Assembly elements

## Instructions

### Math and Logic

<%=column_list(P2Opdata::P2Instructions.select{|i|i.category==:alu&&!i.alias}.sort_by(&:name).map{|i| [i.name,"/#{i.category}.html##{i.name.downcase}"] })%>

### Branching

<%=column_list(P2Opdata::P2Instructions.select{|i|i.category==:branch&&!i.alias}.sort_by(&:name).map{|i| [i.name,"/#{i.category}.html##{i.name.downcase}"] })%>