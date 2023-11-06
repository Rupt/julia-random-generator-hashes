# https://doi.org/10.18637%2Fjss.v008.i14

# TODO(Rupt): parameterize on the permissible shift values / eight permutations
struct XorShift <: AbstractHash end

function query(::XorShift, key::UInt64)::UInt64
    # TODO(Rupt): build transition matrix
    # TODO(Rupt): matrix power operation
    return 0
end

function encode(::XorShift)::BitVector
    return BitVector()
end
