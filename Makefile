.PHONY: hello
hello:
	julia -- hello_world.jl

.PHONY: test
test:
	julia -- test/runtests.jl

.PHONY: bench
bench:
	julia -- bench/bytes.jl
	julia -- bench/bits.jl
	julia -- bench/kiss.jl
	julia -- bench/linear.jl
	julia -- bench/multiply_with_carry.jl
	julia -- bench/split_mix.jl
	julia -- bench/xor_shift.jl
