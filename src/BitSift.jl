module BitSift

# Generator interface
export AbstractBitMix
export query
export bytes
export bits
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
function bytes end
function bits end

include("tools.jl")
include("mixes.jl")

function query(rng::AbstractBitMix, keys::Array{UInt64})::Array{UInt64}
    return (key -> query(rng, key)).(keys)
end

# TODO: vectorize bits and bytes carefully to preserve dimensions, if feasible
function bytes(keys::Array{UInt64})  # TODO return type
    return bytes.(keys)
end

end  # module BitSift
