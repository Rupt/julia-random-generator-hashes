# https://web.archive.org/web/20221206094913/https://www.thecodingforums.com/threads/64-bit-kiss-rngs.673657/
struct KISS <: AbstractBitMix end

function query(::KISS, key::UInt64)::UInt64
    mwc = MultiplyWithCarry(UInt64(1) << 58 + 1, 123456123456123456, 1234567890987654321)
    xsh = XorShift(362436362436362436)
    cng = Linear(6906969069, 1234567, 1066149217761810)
    return query(mwc, key) + query(xsh, key) + query(cng, key)
end

# - Seminumerical Algorithms. The Art of Computer Programming. Vol. 2 (3rd ed.)
#     3.2.1 The Linear Congruential Method
struct Linear <: AbstractBitMix
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
struct MultiplyWithCarry <: AbstractBitMix
    reduced_multiplier::UInt64
    seed_c::UInt64
    seed_x::UInt64
end

function query(rng::MultiplyWithCarry, key::UInt64)::UInt64
    # Not that we have bounded length, so could reduce allocations by replacing
    # BigInt with some 128-to-256-bit multiply-modulo function.
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
struct SplitMix <: AbstractBitMix end

function query(::SplitMix, key::UInt64)::UInt64
    x::UInt64 = key * 0x9e3779b97f4a7c15
    x = xor(x, x >> 30) * 0xbf58476d1ce4e5b9
    x = xor(x, x >> 27) * 0x94d049bb133111eb
    return xor(x, x >> 31)
end

# https://doi.org/10.18637%2Fjss.v008.i14
struct XorShift <: AbstractBitMix
    seed::UInt64
end

function query(rng::XorShift, key::UInt64)::UInt64
    x::UInt64 = rng.seed
    for i in 0:63
        x = (key >> i) & 1 == 1 ? xor_mul(_XOR_SHIFT_LEFT[i + 1], x) : x
    end
    return x
end

function _xor_shift_kiss(x::UInt64)::UInt64
    x = xor(x, x << 13)
    x = xor(x, x >> 17)
    return xor(x, x << 43)
end

const _XOR_SHIFT_LEFT::NTuple{64,XorMatrix} = let
    operators = Vector{XorMatrix}(undef, 64)
    operators[1] = left = XorMatrix(Tuple(_xor_shift_kiss.(UInt64(1) .<< (0:63))))
    for i in 2:64
        operators[i] = left = xor_mul(left, left)  # Two steps
    end
    Tuple(operators)
end
