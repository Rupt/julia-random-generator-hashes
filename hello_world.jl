module BitSift

import Printf

function main()
    for i in 0:10
        Printf.@printf "%#018x: %#018x\n" i query(SplitMix64(), UInt64(i))
    end
    querty_splitmix64(k) = query(SplitMix64(), UInt64(k))
    println(querty_splitmix64.(0:3))
    println((k -> query(SplitMix64(), UInt64(k))).(0:3))
    println(bits(SplitMix64()))
    println(big_endian_bits(0xff00818283848586))
end

function big_endian_bits(x::UInt64)::BitVector
    return BitVector((x >> i) & 1 for i = 63:-1:0)
end

# Abstract interface
abstract type AbstractRNG end

function query end
function bits end


# An example implementation
struct SplitMix64 <: AbstractRNG end

function query(::SplitMix64, key::UInt64)::UInt64
    x = key * 0x9e3779b97f4a7c15
    x = xor(x, x >> 30) * 0xbf58476d1ce4e5b9
    x = xor(x, x >> 27) * 0x94d049bb133111eb
    return xor(x, x >> 31)
end

function bits(::SplitMix64)::BitVector
    return BitVector()
end

@time main()

end  # module BitSift
