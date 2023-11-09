module BitSift

# Generator interface
export AbstractBitHash
export query
export encode
# Generators
export Linear
export MultiplyWithCarry
export SplitMix
export XorShift
# Algebra
export BitMatrix64
export bit_product

abstract type AbstractBitHash end

function query end
function encode end

include("hashes.jl")
include("tools.jl")

end  # module BitSift
