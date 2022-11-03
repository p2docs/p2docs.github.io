---
title: Miscellaneous Instructions
jump-toplevel: Topic
---

# Miscellaneous Instructions

## Internal Stack

<%=p2instrinfo('push')%>
<%=p2instrinfo('pop')%>

## Q Register

<%=p2instrinfo('setq')%>
<%=p2instrinfo('setq2')%>

## Augment Prefixes

<%=p2instrinfo('augd')%>
<%=p2instrinfo('augs')%>

## Other

<%=p2instrinfo('nop')%>
Special case: Encoded the same as `_RET_ ROR 0,0` would be.
<%=p2instrinfo('getct')%>
<%=p2instrinfo('waitx')%>
<%=p2instrinfo('getrnd')%>


<%p2instr_checkall :misc%>