module BitSift

# Tools
export multiplicative_inverse
# Generator interface
export AbstractRNG
export query
export encode
# Generators
export Linear
export MultiplyWithCarry64
export SplitMix64

abstract type AbstractRNG end

function query end
function encode end

include("tools.jl")
include("SplitMix64.jl")
include("Linear.jl")
include("MultiplyWithCarry.jl")

end  # module BitSift
