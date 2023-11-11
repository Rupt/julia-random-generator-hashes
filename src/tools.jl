_PrimitiveSigned = Union{Int8,Int16,Int32,Int64,Int128}
_PrimitiveUnsigned = Union{UInt8,UInt16,UInt32,UInt64,UInt128}
_PrimitiveInteger = Union{_PrimitiveSigned,_PrimitiveUnsigned}

function encode(key::T)::BitVector where {T<:_PrimitiveInteger}
    length = sizeof(T) * 8
    return BitVector((key >> i) & 1 for i in (length - 1):-1:0)
end

function encode(item::T)::BitVector where {T<:AbstractBitHash}
    return cat((encode(getfield(item, field)) for field in fieldnames(T))...; dims=1)
end

# Linear algebra modulo 2

struct XorMatrix
    column::NTuple{64,UInt64}
end

function xor_mul(left::XorMatrix, vector::UInt64)::UInt64  # L @ v
    x::UInt64 = 0
    for i in 0:63
        x = (vector >> i) & 1 == 1 ? xor(x, left.column[i + 1]) : x
    end
    return x
end

function xor_mul(left::XorMatrix, right::XorMatrix)::XorMatrix  # L @ R
    return XorMatrix(Tuple(xor_mul(left, col) for col in right.column))
end

# Algebra modulo m

@inline function add_mod(a::UInt128, b::UInt128, m::UInt128)::UInt128 # a < m, b < m
    sum = a + b
    return (sum >= m) | (sum < a) ? sum - m : sum
end

function mul_mod(a::UInt128, b::UInt128, m::UInt128)::UInt128  # a < m, b < m
    x::UInt128 = 0
    scale::UInt128 = b
    for i in 0:127
        x = (a >> i) & 1 == 1 ? add_mod(x, scale, m) : x
        scale = add_mod(scale, scale, m)
    end
    return x
end

function mul_mod2(a::UInt128, b::UInt128, m::UInt128)::UInt128  # a < m, b < m
    # a = (c * 2^64) + d
    # b = (e * 2^64) + f
    # =>
    # (a * b) % m
    # = (c * e * 2^128 + (c * f + d * e) * 2^64 + d * f) % m
    c = a >> 64
    d = a & 0xffffffffffffffff
    e = b >> 64
    f = b & 0xffffffffffffffff

    m0 = (UInt128(1) << 127) % m
    m1 = add_mod(m0, m0, m)
    m2 = (UInt128(1) << 64) % m

    p1 = mul_mod(c, e, m)
    p2 = mul_mod(c, f, m)
    p3 = mul_mod(d, e, m)
    p4 = mul_mod(d, f, m)
    p5 = add_mod(p2, p3, m)
    p6 = mul_mod(p1, m1, m)
    p7 = mul_mod(p5, m2, m)
    p8 = add_mod(p6, p7, m)
    return add_mod(p4, p8, m)
end
