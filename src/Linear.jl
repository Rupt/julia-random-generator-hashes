# - Seminumerical Algorithms. The Art of Computer Programming. Vol. 2 (3rd ed.)
#     3.2.1 The Linear Congruential Method
struct Linear <: AbstractRNG
    multiplier::UInt64
    increment::UInt64
end

function query(rng::Linear, key::UInt64)::UInt64
    c = x = rng.increment
    a = rng.multiplier
    for i in 0:63
        x = Bool((key >> i) & 1) ? a * x + c : x
        # Two steps: a * (a * x + c) + c = a * a * x + a * c + c
        c += a * c
        a *= a
    end
    return x
end

function encode(rng::Linear)::BitVector
    return cat(encode(rng.multiplier), encode(rng.increment); dims=1)
end
