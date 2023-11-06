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
