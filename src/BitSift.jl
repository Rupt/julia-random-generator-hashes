module BitSift

# Generator interface
export AbstractBitMix
export query
# Generators
export KISS
export Linear
export MultiplyWithCarry
export SplitMix
export XorShift
# Algebra
export XorMatrix
export xor_mul

abstract type AbstractBitMix end

function query end

include("tools.jl")
include("mixes.jl")

function query(rng::AbstractBitMix, keys::Array{UInt64})::Array{UInt64}
    return (key -> query(rng, key)).(keys)
end

end  # module BitSift
