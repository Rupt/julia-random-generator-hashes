module BitSift

# Generator interface
export AbstractHash
export query
export encode
# Generators
export Linear
export MultiplyWithCarry
export SplitMix
export XorShift

abstract type AbstractHash end

function query end
function encode end

include("hashes.jl")
include("tools.jl")

end  # module BitSift
