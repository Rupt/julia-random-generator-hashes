function encode(key::T)::BitVector where {T<:Integer}
    length = sizeof(typemax(T) | typemin(T)) * 8  # Valid types must have bounds.
    return BitVector((key >> i) & 1 for i in (length - 1):-1:0)
end

function encode(item::T)::BitVector where {T<:AbstractBitHash}
    return cat((encode(getfield(item, field)) for field in fieldnames(T))...; dims=1)
end

# Linear algebra modulo 2

struct XorMatrix64
    columns::Vector{UInt64}
end

function xor_product(left::XorMatrix64, vector::UInt64)::UInt64  # M @ v
    @assert length(left.columns) == 64
    result = UInt64(0)
    for i in 0:63
        bit = (vector >> i) & 1 == 1
        # We want C `result ^= bit ? col : 0;`, and branchless.
        result = xor(result, left.columns[i + 1] & -UInt64(bit))
    end
    return result
end

function xor_product(left::XorMatrix64, right::XorMatrix64)::XorMatrix64  # L @ R
    @assert length(left.columns) == length(right.columns) == 64
    return XorMatrix64([xor_product(left, column) for column in right.columns])
end
