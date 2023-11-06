# - Seminumerical Algorithms. The Art of Computer Programming. Vol. 2 (3rd ed.)
#     3.2.1 The Linear Congruential Method
struct Linear <: AbstractHash
    multiplier::UInt64
    increment::UInt64
    seed::UInt64
end

function query(rng::Linear, key::UInt64)::UInt64
    a::UInt64 = rng.multiplier
    c::UInt64 = rng.increment
    x::UInt64 = rng.seed
    for i in 0:63
        x = (key >> i) & 1 == 1 ? a * x + c : x
        # Two steps: a * (a * x + c) + c = a * a * x + a * c + c
        c += a * c
        a *= a
    end
    return x
end

# https://en.wikipedia.org/wiki/Multiply-with-carry_pseudorandom_number_generator
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

# https://web.archive.org/web/20220617005635/https://prng.di.unimi.it/SplitMix.c
struct SplitMix <: AbstractHash end

function query(::SplitMix, key::UInt64)::UInt64
    x = key * 0x9e3779b97f4a7c15
    x = xor(x, x >> 30) * 0xbf58476d1ce4e5b9
    x = xor(x, x >> 27) * 0x94d049bb133111eb
    return xor(x, x >> 31)
end

# https://doi.org/10.18637%2Fjss.v008.i14
struct XorShift <: AbstractHash
    seed::UInt64
end

function query(::XorShift, key::UInt64)::UInt64
    # TODO(Rupt): build transition matrix
    # TODO(Rupt): matrix power operation
    return 0
end
