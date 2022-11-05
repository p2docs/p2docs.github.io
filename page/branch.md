---
title: Branching Instructions
hyperjump:
    -   type: Topic
---
# Branching Instructions

## Basic Branches

<%=p2instrinfo('jmp-a')%>
<%=p2instrinfo('jmp-d',joininstr:true)%>

<%=p2instrinfo('jmprel')%>

## Skip

<%=p2instrinfo('skip')%>
<%=p2instrinfo('skipf')%>
<%=p2instrinfo('execf')%>

## Repeat

<%=p2instrinfo('rep')%>

## Internal Stack Calls

<%=p2instrinfo('call-a')%>
<%=p2instrinfo('call-d',joininstr:true)%>
<%=p2instrinfo('calld-a')%>
<%=p2instrinfo('calld-s',joininstr:true)%>
<%=p2instrinfo('callpa')%>
<%=p2instrinfo('callpb')%>

<%=p2instrinfo('ret')%>
RET pops an address off the internal stack (**TODO Link**) and jumps to that address.

If the **WC** or **WCZ** effect is specified, the C flag is restored from bit 31 of the return address.

If the **WZ** or **WCZ** effect is specified, the Z flag is restored from bit 30 of the return address.

**TODO more detail**

## External Stack Calls

<%=p2instrinfo('calla-a')%>
<%=p2instrinfo('calla-d',joininstr:true)%>
<%=p2instrinfo('callb-a')%>
<%=p2instrinfo('callb-d',joininstr:true)%>

<%=p2instrinfo('reta')%>
RETA decrements **PTRA** by 4, reads an address from the new **PTRA** and jumps to that address.

If the **WC** or **WCZ** effect is specified, the C flag is restored from bit 31 of the return address.

If the **WZ** or **WCZ** effect is specified, the Z flag is restored from bit 30 of the return address.

**TODO more detail**

<%=p2instrinfo('retb')%>
See [RETA](#reta), but substitute **PTRA** with **PTRB**.

## Conditional branch addressing

For conditional branches (TJ\*/DJ\*/IJ\*) the address (**S**ource) can be absolute or relative.
To specify an absolute address, **S**ource must be a register containing a 20-bit address value.
To specify a relative address, use #Label for a 9-bit signed offset (a range of -256 to +255 instructions) or use ##Label (or insert a prior AUGS instruction) for a 20-bit signed offset (a range of -524288 to +524287).
Offsets are relative to the instruction following the conditional branch instruction.
The signed offset value is in units of whole instructions - it is added to PC as-is when in Cog/LUT execution mode and is multiplied by 4 then added to PC when in Hub execution mode.

And yes, it _is_ mildly confusing that the branch _destination_ is encoded by the **S**ource value.

## Test and Branch

<%=p2instrinfo('tjz')%>
TJZ jumps to the address described by **S**ource if the value in **D**estination is zero.

See [Conditional branch addressing](#conditional-branch-addressing) for details on how **S**ource encodes the branch target. 

<%=p2instrinfo('tjnz')%>
TJNZ jumps to the address described by **S**ource if the value in **D**estination is _not_ zero.

See [Conditional branch addressing](#conditional-branch-addressing) for details on how **S**ource encodes the branch target. 

<%=p2instrinfo('tjf')%>
TJF jumps to the address described by **S**ource if the value in **D**estination is full of ones (i.e. equals -1 / `$FFFFFFFF`).

See [Conditional branch addressing](#conditional-branch-addressing) for details on how **S**ource encodes the branch target. 

<%=p2instrinfo('tjnf')%>
TJNF jumps to the address described by **S**ource if the value in **D**estination is _not_ full of ones (i.e. does _not_ equal -1 / `$FFFFFFFF`).

See [Conditional branch addressing](#conditional-branch-addressing) for details on how **S**ource encodes the branch target. 

<%=p2instrinfo('tjs')%>
TJS jumps to the address described by **S**ource if the value in **D**estination is negative (i.e. bit 31 is 1).

See [Conditional branch addressing](#conditional-branch-addressing) for details on how **S**ource encodes the branch target. 

<%=p2instrinfo('tjns')%>
TJNS jumps to the address described by **S**ource if the value in **D**estination is positive (i.e. bit 31 is 0).

See [Conditional branch addressing](#conditional-branch-addressing) for details on how **S**ource encodes the branch target. 

<%=p2instrinfo('tjv')%>
TJV tests the value in **D**estination against the C flag and jumps to the address described by **S**ource if **D**estination has overflowed (**D**estination[31] != C). This instruction requires that C has been set to the "correct sign" by the ADDS / ADDSX / SUBS / SUBSX / CMPS / CMPSX / SUMx instruction that is to be checked for overflow.

See [Conditional branch addressing](#conditional-branch-addressing) for details on how **S**ource encodes the branch target. 

## Modify and Branch

<%=p2instrinfo('djz')%>
DJZ decrements the value in **D**estination, writes the result, and jumps to the address described by **S**ource if the
result is zero.

See [Conditional branch addressing](#conditional-branch-addressing) for details on how **S**ource encodes the branch target.

<%=p2instrinfo('djnz')%>
DJNZ decrements the value in **D**estination, writes the result, and jumps to the address described by **S**ource if the
result is _not_ zero.

This instruction is very commonly used for counted loops. In certain cases, it can be substituted with [REP](#rep).

See [Conditional branch addressing](#conditional-branch-addressing) for details on how **S**ource encodes the branch target.

<%=p2instrinfo('djf')%>
DJF decrements the value in **D**estination, writes the result, and jumps to the address described by **S**ource if the
result is -1 / `$FFFFFFFF` (i.e underflow/borrow occurred).

See [Conditional branch addressing](#conditional-branch-addressing) for details on how **S**ource encodes the branch target.

<%=p2instrinfo('djnf')%>
DJNF decrements the value in **D**estination, writes the result, and jumps to the address described by **S**ource if the
result is _not_ -1 / `$FFFFFFFF` (i.e no underflow/borrow occurred).

See [Conditional branch addressing](#conditional-branch-addressing) for details on how **S**ource encodes the branch target.

<%=p2instrinfo('ijz')%>
DJZ increments the value in **D**estination, writes the result, and jumps to the address described by **S**ource if the
result is zero.

See [Conditional branch addressing](#conditional-branch-addressing) for details on how **S**ource encodes the branch target.


<%=p2instrinfo('ijnz')%>
IJNZ increments the value in **D**estination, writes the result, and jumps to the address described by **S**ource if the
result is _not_ zero.

See [Conditional branch addressing](#conditional-branch-addressing) for details on how **S**ource encodes the branch target.

## Branch on Event

<% P2Opdata::EVENTS.each_with_index do |ev,i| %>
<%=p2instrinfo("j#{ev}",joininstr:i!=0)%>
<%=p2instrinfo("jn#{ev}",joininstr:true)%>
<%end%>

See [Events](event.html) for more info.


<%p2instr_checkall :branch%>