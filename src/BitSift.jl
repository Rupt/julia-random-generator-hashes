module BitSift

# Generator interface
export AbstractBitHash
export query
export encode
# Generators
export KISS
export Linear
export MultiplyWithCarry
export SplitMix
export XorShift
# Algebra
export XorMatrix
export xor_mul

abstract type AbstractBitHash end

function query end
function encode end

include("tools.jl")
include("hashes.jl")

end  # module BitSift
