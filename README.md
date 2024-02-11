# Random sequences? Nah, just hash functions

Random number generators produce deterministic sequences. That's useful.
It can also be useful to jump straight to the N-th item in the sequence.
Such N-th item functions exist for many existing generators.

This repository implements N-th item functions for a few 64-bit generators:

- [Multiply With Carry (MWC)](https://en.wikipedia.org/wiki/Multiply-with-carry)
- [XorShift](https://en.wikipedia.org/wiki/Xorshift)
- [Linear "Congruential Generator" (LCG)](https://en.wikipedia.org/wiki/Linear_congruential_generator)
- [KISS64](https://www.thecodingforums.com/threads/64-bit-kiss-rngs.673657/)  (sum of the above)
- [SplitMix64](https://prng.di.unimi.it/SplitMix.c)

## Usage

- Add this local package through the Julia CLI with `julia > ] > add .`.
- Run the automated checks with `make test`.
- Run some basic timing measurements with `make bench`.
  This needs `BenchmarkTools`, installed for example with `julia > ] > add BenchmarkTools`.

## Historical note

I originally planned this project to:

1. Challenge random number generators with powerful, learned tests, and
2. experience Julia.

The following claims motivate Item 1:

- Surprisingly simple random number generators claim to pass all existing statistical tests.
- I distrust all existing statistical tests. Test batteries were hand-crafted to target weak
  historical generators, and they uniformly [misuse p-values](https://en.wikipedia.org/wiki/Misuse_of_p-values).

In performing Item 2, I learned that there are better tools for achieving point 1,
so I conclude this project with just the N-th item functions.
Of course this "better" word is meaningless.
Concretely, I mean that there are language ecosystems that offer
non-global namespaces without textual include directives,
faster compilation,
faster execution (with or without compilation),
stronger semantic guarantees (with regards to typing and immutability),
fewer syntactic gimmicks,
and more mature libraries.
Julia is a great demonstration of LLVM's capabilities, but it is not alone.
