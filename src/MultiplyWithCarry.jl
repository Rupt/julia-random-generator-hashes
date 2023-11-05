struct MultiplyWithCarry <: AbstractRNG
    multiplier::UInt128
end

function query(rng::MultiplyWithCarry, key::UInt64)::UInt64
    x = rng.multiplier
    a = rng.multiplier
    for i in 0:63
        x = Bool((key >> i) & 1) ? a * x : x
        a *= a
    end
    return x >> 64
end

function encode(rng::MultiplyWithCarry)::BitVector
    return encode(rng.multiplier)
end
