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
