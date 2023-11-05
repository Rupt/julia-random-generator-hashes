# BitSift.jl

🚧 Very unfinished 🚧

## TODO(Rupt): write a clear README

Challenge random number generators with powerful, learned tests.

Things to write up fully:

- Simple random number generators pass all statistical tests.
- Randomness tests suck because:
  - they are hand-crafted to target historical failures, and
  - their results have no clear interpretation.
- We can cast any random number generator to a function
  `(constant context, key::UInt64)::UInt64`.
  - Modern hash-based generators implement this explicitly.
  - Sequence-based generators implement this implicitly; the key is a counter.
- etc TODO(Rupt)
