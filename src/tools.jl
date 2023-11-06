function encode(key::T)::BitVector where {T<:Integer}
    length = sizeof(typemax(T) | typemin(T)) * 8  # Valid types must have bounds.
    # FIXME: this should be a trivial copy for primitive types, but it compiles
    # to lengthy code involving `j_fill_bitarray_from_itr`.
    # https://godbolt.org/z/n5Tx3W4Pf
    return BitVector((key >> i) & 1 for i in (length - 1):-1:0)
end

function encode(item::T)::BitVector where {T<:AbstractHash}
    return cat((encode(getfield(item, field)) for field in fieldnames(T))...; dims=1)
end
