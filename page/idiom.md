---
title: Common Idioms and Tricks
hyperjump:
    -   type: Topic
---

# Common Idioms and Tricks

Here are some common P2ASM code patterns for operations not obviously provided by the instruction set.

## 32x16 multiply
{:.anchor}

Chain two 16-bit [MUL](alu.html#mul) instructions together to multiply a 32-bit number with a 16-bit number. Often a better idea than using QMUL.

~~~
            getword res,x,#0
            mul res,y
            getword tmp,x,#1
            mul tmp,y
            shl tmp,#16
            add res,tmp
~~~

If calculating in-place, a getword can be omitted.

~~~
            getword tmp,x,#1
            mul tmp,y
            shl tmp,#16
            mul x,y
            add x,tmp
~~~

TODO: Variant where Y is signed.


## Signed QMUL
{:.anchor}

For the common case of only needing the bottom half of the result, there is no difference between signed/unsigned multiplication.

In case the entire result is needed:

~~~
            qmul x,y
            mov temp,#0
            cmps x,#0 wc
      if_b  add temp,y
            cmps y,#0 wc
      if_b  add temp,x
            getqx lo
            getqy hi
            sub hi,temp
~~~

## Signed QDIV
{:.anchor}

If only the dividend is signed (as is commonly the case):

~~~
            abs x wc
            qdiv x,y
            getqx res
            negc res
~~~

If both operands are signed, a slightly ugly construction is needed to XOR the signs. A somewhat nice way:

~~~
            abs x wc
            modz _c wz
            abs y wc
            qdiv x,y
            getqx res
  if_c_ne_z neg res
~~~

... but you could also store the flags into a register.


## 64-bit absolute
{:.anchor}

~~~
              abs high wc
        if_c  neg low wz
  if_c_and_nz sub high,#1
~~~

## Fast Cog/LUT RAM clearing
{:.anchor}

To clear (i.e. set to zero) a large area of cog RAM quickly, perform a [block read](hubmem.html#block-transfers) from the unused area at `$80000`

~~~
              setq #size-1
              rdlong buffer,##$80000
~~~

The same works using SETQ2 for LUT RAM.
