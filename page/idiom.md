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

## Nibble reverse
{:.anchor}

For reversing the order of nibbles in a long, i.e. `$12345678 <-> $87654321`. Useful for interacting with PSRAM and other QPI devices.

~~~

              splitb  x
              rev     x
              movbyts x, #%%0123
              mergeb  x
~~~

## Fast Cog/LUT RAM clearing
{:.anchor}

To clear (i.e. set to zero) a large area of cog RAM quickly, perform a [block read](hubmem.html#block-transfers) from the unused area at `$80000`

~~~
              setq #size-1
              rdlong buffer,##$80000
~~~

The same works using SETQ2 for LUT RAM.

## Encoding/Decoding Manchester Encoded Data
{:.anchor}

[Manchester code](https://en.wikipedia.org/wiki/Manchester_code) is a DC free encoding scheme that uses two bits to encode a single logical bit, so a `0` is encoded as `%01`, while a `1` is encoded as `%10`. This can easily be achieved with the [MERGEW](alu.html#mergew) and [SPLITW](alu.html#splitw) instructions.

Encoding is done like this:

~~~
              SETWORD data, data, #1        ' duplicate the data into the upper word
              BITNOT  data, #16 addbits 15  ' invert all bits of the upper word
              MERGEW  data                  ' now interleave the bits, which is the manchester encoding
~~~

Decoding is done by using [SPLITW](alu.html#splitw) to reverse the interleaving:

~~~
              SPLITW data          ' de-interleave the bits, which reverses the manchester encoding
              ZEROX  data, #(16-1) ' clear the upper 16 bits
~~~

If error handling is necessary, the check can be done with [XOR](alu.html#xor), as the upper word must contain the inverse of the lower word. This requires a temporary register:

~~~
              SPLITW  data
              GETWORD temp, data, #1      ' fetch the upper word to process it later
              ZEROX   data, #(16-1)
              BITNOT  temp, #0 addbits 15 ' invert the "upper" word (which is now stored in bits 0..15)
              CMP     temp, data WZ       ' and compare the input to the expected
~~~

Afterwards, if `Z` contains `1`, the data was uncorrupted and has a sequence of `%01` and `%10` patterns. Otherwise, `Z` is `0` and marks an error.

This works, because we fetch the upper data word before clearing, and then comparing if the upper word is the inverse of the lower word.

