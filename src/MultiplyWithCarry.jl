struct MultiplyWithCarry <: AbstractRNG
    modulus::UInt128
    seed::UInt128
end

function query(rng::MultiplyWithCarry, key::UInt64)::UInt64
    m::UInt128 = rng.modulus
    a::BigInt = invmod(UInt128(1) << 64, m)
    x::BigInt = rng.seed
    for i in 0:63
        x = Bool((key >> i) & 1) ? (a * x) % m : x
        # Two steps: a * ((a * x) % m) = ((a * a) % m) * x
        a = (a * a) % m
    end
    return x & typemax(UInt64)
end

function encode(rng::MultiplyWithCarry)::BitVector
    return cat(encode(rng.modulus), encode(rng.seed); dims=1)
end
