---
title: Common Idioms and Tricks
---

# Common Idioms and Tricks

Here are some common P2ASM code patterns for operations not obviously provided by the instruction set.

## 32x16 multiply

Chain two 16-bit [MUL](alu.html#mul) instructions together. Often a better idea than using QMUL.

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

## 64-bit absolute

~~~
              abs high wc
        if_c  neg low wz
  if_c_and_nz sub high,#1
~~~
