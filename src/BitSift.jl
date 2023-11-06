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

include("tools.jl")
include("Linear.jl")
include("MultiplyWithCarry.jl")
include("SplitMix.jl")
include("XorShift.jl")

end  # module BitSift
