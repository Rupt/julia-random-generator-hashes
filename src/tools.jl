function encode(key::T)::BitVector where {T<:Integer}
    length = sizeof(typemax(T) | typemin(T)) * 8  # Valid types must have bounds.
    return BitVector((key >> i) & 1 for i in (length - 1):-1:0)
end

function encode(item::T)::BitVector where {T<:AbstractBitHash}
    return cat((encode(getfield(item, field)) for field in fieldnames(T))...; dims=1)
end

# Linear algebra modulo 2

struct BitMatrix64
    columns::Vector{UInt64}
end

function bit_product(left::BitMatrix64, vector::UInt64)::UInt64  # M @ v
    _assert_bit_matrix_64(left)
    result = UInt64(0)
    for i in 0:63
        bit = (vector >> i) & 1 == 1
        result = xor(result, left.columns[i + 1] & -UInt64(bit))
    end
    return result
end

function bit_product(left::BitMatrix64, right::BitMatrix64)::BitMatrix64  # L @ R
    _assert_bit_matrix_64(left)
    _assert_bit_matrix_64(right)
    return BitMatrix64([bit_product(left, column) for column in right.columns])
end

function _assert_bit_matrix_64(matrix::BitMatrix64)
    @assert length(matrix.columns) == 64
end
