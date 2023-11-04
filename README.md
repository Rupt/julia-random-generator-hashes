# BitSift.jl

Challenge random number generators with powerful, learned tests.

Things to write up fully:

- Simple random number generators pass all statistical tests.
- Randomness tests suck, because:
  - they are hand-crafted to target historical failures, and
  - their results are hard to interpret (because they use p-values).
- We can cast any random number generator to a function
  `(constant context, key::UInt64)::UInt64`.
  - Modern hash-based generators implement this explicitly.
  - Sequence-based generators implement this implicitly; the key is the index.
- etc TODO
