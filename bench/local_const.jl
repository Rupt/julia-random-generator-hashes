# Does the compiler really infer local constants?
using BenchmarkTools

function f()::UInt64
    x::UInt64 = 1
    for i in 1:100_000_000
        x = x * i
    end
    return x
end

function f_local()
    x_local = f()
    return x_local
end

const X_CONST = f()

function f_global()
    return X_CONST
end

@btime f()  # 18.557 ms (0 allocations: 0 bytes)
@btime f_local()  # 18.638 ms (0 allocations: 0 bytes)
@btime f_global()  # 1.154 ns (0 allocations: 0 bytes)
