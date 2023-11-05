module BitSift

# Generator interface
export AbstractRNG
export query
export encode
# Generators
export SplitMix64

abstract type AbstractRNG end

function query end
function encode end

include("SplitMix64.jl")
include("tools.jl")

end  # module BitSift
