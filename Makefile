.PHONY: hello
hello:
	julia -O0 -- hello_world.jl

.PHONY: test
test:
	julia -O0 -- test/runtests.jl
