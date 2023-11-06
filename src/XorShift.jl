# https://doi.org/10.18637%2Fjss.v008.i14

struct XorShift <: AbstractHash
    seed::UInt64
end

function query(::XorShift, key::UInt64)::UInt64
    # TODO(Rupt): build transition matrix
    # TODO(Rupt): matrix power operation
    return 0
end
