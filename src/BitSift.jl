module BitSift

# Generator interface
export AbstractRNG
export query
export encode
# Generators
export SplitMix64
export Linear

abstract type AbstractRNG end

function query end
function encode end

include("tools.jl")
include("SplitMix64.jl")
include("Linear.jl")

end  # module BitSift
