.PHONY: hello
hello:
	julia -- hello_world.jl

.PHONY: test
test:
	julia -- test/runtests.jl
