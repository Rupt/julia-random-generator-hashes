function encode(key::T)::BitVector where {T<:Integer}
    length = sizeof(typemax(T) & typemin(T)) * 8  # Valid types must have bounds.
    # FIXME: this should be a trivial copy for primitive types, but it compiles
    # to lengthy code involving `j_fill_bitarray_from_itr`.
    # https://godbolt.org/z/n5Tx3W4Pf
    return BitVector((key >> T(i)) & T(1) for i in (length - 1):-1:0)
end
