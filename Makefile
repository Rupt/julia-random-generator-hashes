.PHONY: hello
hello:
	julia -- hello_world.jl

.PHONY: test
test:
	julia -- test/runtests.jl

.PHONY: bench
bench:
	julia -- bench/kiss.jl
	julia -- bench/linear.jl
	julia -- bench/mwc.jl
	julia -- bench/splitmix.jl
	julia -- bench/xsh.jl
	julia -- bench/encode.jl
	julia -- bench/bitcode.jl
