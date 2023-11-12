_PrimitiveSigned = Union{Int8,Int16,Int32,Int64,Int128}
_PrimitiveUnsigned = Union{UInt8,UInt16,UInt32,UInt64,UInt128}
_PrimitiveInteger = Union{_PrimitiveSigned,_PrimitiveUnsigned}

function bytes(item::_PrimitiveInteger)::Vector{UInt8}
    return [UInt8((item >> i) & 0xff) for i in (sizeof(item) * 8 - 8):-8:0]
end

function bytes(item::AbstractBitMix)::Vector{UInt8}
    names = fieldnames(typeof(item))
    return cat((bytes(getfield(item, name)) for name in names)...; dims=1)
end

function bits(bytes::Vector{UInt8})::BitVector
    mask::Vector{UInt8} = 1 .<< (7:-1:0)
    product::Array{UInt8,2} = mask .& reshape(bytes, 1, :)  # (8, length)
    return reshape(product, :) .!= 0
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
