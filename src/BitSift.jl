module BitSift

# Generator interface
export AbstractRNG
export query
export bits
# Generators
export SplitMix64
# Tools
export unpack_big_endian

# Generator interface
abstract type AbstractRNG end

function query end
function encode end

# Generators
# SplitMix64
# https://web.archive.org/web/20220617005635/https://prng.di.unimi.it/splitmix64.c
struct SplitMix64 <: AbstractRNG end

function query(::SplitMix64, key::UInt64)::UInt64
    x = key * 0x9e3779b97f4a7c15
    x = xor(x, x >> 30) * 0xbf58476d1ce4e5b9
    x = xor(x, x >> 27) * 0x94d049bb133111eb
    return xor(x, x >> 31)
end

function encode(::SplitMix64)::BitVector
    return BitVector()
end

# Tools
function encode(key::UInt64)::BitVector
    return BitVector((key >> i) & 1 for i in 63:-1:0)
end

end  # module BitSift
