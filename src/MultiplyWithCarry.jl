struct MultiplyWithCarry <: AbstractHash
    reduced_multiplier::UInt64
    seed_c::UInt64
    seed_x::UInt64
end

function query(rng::MultiplyWithCarry, key::UInt64)::UInt64
    m::BigInt = (BigInt(rng.reduced_multiplier) << 64) - 1
    a::BigInt = invmod(BigInt(1) << 64, m)
    x::BigInt = (BigInt(rng.seed_c) << 64) | rng.seed_x
    for i in 0:63
        x = (key >> i) & 1 == 1 ? (a * x) % m : x
        # Two steps: a * ((a * x) % m) = ((a * a) % m) * x
        a = (a * a) % m
    end
    return x & typemax(UInt64)
end

function encode(rng::MultiplyWithCarry)::BitVector
    return cat(
        encode(rng.reduced_multiplier), encode(rng.seed_c), encode(rng.seed_x); dims=1
    )
end
