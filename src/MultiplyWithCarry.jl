struct MultiplyWithCarry64 <: AbstractRNG
    modulus::UInt128
    seed_c::UInt64
    seed_x::UInt64
end

function query(rng::MultiplyWithCarry64, key::UInt64)::UInt64
    m::UInt128 = rng.modulus
    a::BigInt = invmod(UInt128(1) << 64, m)
    x::BigInt = (UInt128(rng.seed_c) << 64) | rng.seed_x
    for i in 0:63
        x = Bool((key >> i) & 1) ? (a * x) % m : x
        # Two steps: a * ((a * x) % m) = ((a * a) % m) * x
        a = (a * a) % m
    end
    return x & typemax(UInt64)
end

function encode(rng::MultiplyWithCarry64)::BitVector
    return cat(encode(rng.modulus), encode(rng.seed_c), encode(rng.seed_x); dims=1)
end
