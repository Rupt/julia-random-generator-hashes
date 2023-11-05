struct MultiplyWithCarry64 <: AbstractRNG
    modulus::UInt128
    seed::UInt128
end

function query(rng::MultiplyWithCarry64, key::UInt64)::UInt64
    p::UInt128 = rng.modulus
    a::BigInt = invmod(UInt128(1) << 64, p)
    x::BigInt = rng.seed
    for i in 0:63
        x = Bool((key >> i) & 1) ? (a * x) % p : x
        # Two steps: a * ((a * x) % p) % p = ((a * a) % p * x) % p
        a = (a * a) % p
    end
    return x & typemax(UInt64)
end

function encode(rng::MultiplyWithCarry64)::BitVector
    return cat(encode(rng.multiplier), encode(rng.seed); dims=1)
end
