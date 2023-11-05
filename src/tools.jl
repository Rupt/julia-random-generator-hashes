function encode(key::T)::BitVector where {T<:Integer}
    length = sizeof(typemax(T) & typemin(T)) * 8  # Valid types must have bounds.
    # FIXME: this should be a trivial copy for primitive types, but it compiles
    # to lengthy code involving `j_fill_bitarray_from_itr`.
    # https://godbolt.org/z/n5Tx3W4Pf
    return BitVector((key >> i) & 1 for i in (length - 1):-1:0)
end

function multiplicative_inverse(x::T)::T where {T<:Integer}
    if x & 1 == 0
        return 0  # Even numbers have no inverse
    end
    # https://lemire.me/blog/2017/09/18/computing-the-inverse-of-odd-integers/
    y = xor(T(3) * x, T(2))
    n_bits = Int64(5)
    while n_bits < sizeof(T) * 8
        y *= T(2) - y * x
        n_bits *= 2
    end
    return y
end
