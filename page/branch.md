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

## Instruction Skipping

<%=p2instrinfo('skip')%>
SKIP causes the following 32 instructions to be conditionally skipped, based on the bit pattern loaded from **D**estination (bit 0 corresponds to the instruction immediately following SKIP and bit 31 corresponds to the 32nd instruction following SKIP).

The skipped instructions are treated similarly to ones whose `if_*` condition check isn't met, i.e. they take 2 cycles to execute and _do_ consume any [ALTx-type instruction](indir.html) preceding them.

Skipping continues after jump instructions and the same skip pattern applies whether or not a conditional jump is made. A call instruction (or [interrupt](irq.html)) suspends skipping until after the corresponding return instruction. Nested calls are allowed up to a level of eight, matching the size of the internal stack. A routine called from a skip sequence and any subroutines it calls consume only one skip bit. A SKIP/SKIPF/EXECF within the routine replaces the suspended skip sequence and starts a new one, which provides a way of ending skipping earlier than normal but otherwise should be avoided.

Note that [AUGS](misc.html#augs) and [AUGD](misc.html#augd) count as instructions! So `WRLONG ##1234, ##4568` **counts as 3 instructions!**

For example:

~~~
        skip #%1_001101

        add x,y  ' Skipped !
        add x,y  ' Not skipped !
        add x,y  ' Skipped !
        add x,y  ' Skipped !
        call #subroutine
        jmp #somewhere ' Not skipped !
        ...
somewhere
        add x,y  ' Skipped !
        add x,y  ' Not skipped !
        ...
subroutine
        ' Anything here is not skipped!
        ret
~~~

**TODO: Research what happens if skip is executed when another SKIP is still active (or suspended)**

<%=p2instrinfo('skipf')%>
SKIPF causes the following 32 instructions to be conditionally skipped, based on the bit pattern loaded from **D**estination (bit 0 corresponds to the instruction immediately following SKIPF and bit 31 corresponds to the 32nd instruction following SKIPF).

Skipping continues after jump instructions and the same skip pattern applies whether or not a conditional jump is made. A call instruction (or [interrupt](irq.html)) suspends skipping until after the corresponding return instruction. Nested calls are allowed up to a level of eight, matching the size of the internal stack. A routine called from a skip sequence and any subroutines it calls consume only one skip bit. A SKIP/SKIPF/EXECF within the routine replaces the suspended skip sequence and starts a new one, which provides a way of ending skipping earlier than normal but otherwise should be avoided.

Note that [AUGS](misc.html#augs) and [AUGD](misc.html#augd) count as instructions! So `WRLONG ##1234, ##4568` **counts as 3 instructions!**

SKIPF is different to [SKIP](#skip) in that it can completely eliminate instructions from the pipeline. The skipped instructions take zero cycles to execute and _don't_ consume any [ALTx-type instruction](indir.html) preceding them. This works by incrementing PC by more than one instruction at a time.

However, this instruction has some **severe limitations/oddities**:

 - It can only be used when executing from Cog or LUT memory. If it is used when executing from Hub memory, it acts as a normal [SKIP](#skip).
 - Only 7 instructions can be fast-skipped at once. The 8th instruction will be skipped normally (i.e. takes 2 cycles and consumes ALTx).
 - The first instruction after SKIPF can not be fast-skipped. If its bit is set, it is skipped normally (see above)
 - Relative addressing should not be used for subroutine calls if the instruction after the call should be skipped (explicitly specify absolute addressing by writing `#\label` instead of `#label`). (**TODO: What happens if this is violated?**)
 - Absolute addressing (both direct immediates and indirect jumps through a register) should not be used for (non-call) branches where the first instruction after the branch should be skipped. (**TODO: What happens if this is violated?**)

Example:

~~~
        skipf ##%0111111110_011111110_101

        add x,y  ' Slow-Skipped (first after skipf) !
        add x,y  ' Not skipped !
        add x,y  ' Fast-Skipped !

        altr z   ' This ALT...
        nop ' 1
        nop ' 2
        nop ' 3
        nop ' 4
        nop ' 5
        nop ' 6
        nop ' 7
        add x,y  ' ... applies to this instruction

        altr z   ' BUT this ALT...
        nop ' 1
        nop ' 2
        nop ' 3
        nop ' 4
        nop ' 5
        nop ' 6
        nop ' 7
        nop ' 8 (8th instruction is SLOW SKIPPED, CONSUMES ALT)
        add x,y  ' ... does NOT apply to this instruction
~~~

<%=p2instrinfo('execf')%>
EXECF loads an instruction skip pattern from **D**estination[31:10] and jumps to the absolute address in **D**estination[9:0] (this limits it to Cog/LUT memory!).

Please see [SKIPF](#skipf) for details on the fast skipping function and its limitations, but note that EXECF can only skip the following 22 instructions, where **D**estination[10] corresponds to the first instruction at the jump target.

**TODO: more**

## Block Repeat

<%=p2instrinfo('rep')%>
REP causes the following block of instructions (whose length is provided in **D**estination) to be repeated the number of times given in **S**ource (if **S**ource is zero, the block is repeated indefinitely). (**TODO: Less janky wording?**) The values of **D**estination and **S**ource are copied to internal registers - changing them during the loop has no effect.

Looping with REP is faster than using a normal branch instruction (such as [DJNZ](#djnz)): If executing from Cog or LUT memory, the jump back to the top of the REP block is fully pipelined and thus instant. **0 cycles**! **TODO hubexec timing**

REP loops **can not be nested!** Also, any jump or call instruction will cancel the REP effect (this can be used to exit the loop early!).

The last instruction in the REP loop should not be a relative-addressed jump or call, since the PC will already have looped back to the top by the time the target address is computed.

While REP is active, **[Interrupts](#irq) are stalled**. REP can thus also be used to protect a sequence of instructions from interrupts (set **S**ource to 1 so it doesn't actually repeat).

The assembler supports a special syntax `@end_label` to automatically calculate the length of the REP block.

~~~
        rep @.loop,#5 ' repeat block enclosed by REP/.loop 5 times
        add x,##1234
        wrlong x,ptra++
.loop
        ' equivalent without special syntax:
        rep #3,#5
        add x,##1234 ' AUGS/AUDG count as extra instructions!
        wrlong x,ptra++
~~~

Note: if **D**estination is zero, REP does nothing.

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