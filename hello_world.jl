module BitSift

using Printf

struct SplitMix64 end

function hash(::SplitMix64, key::UInt64)::UInt64
    x = key * 0x9e3779b97f4a7c15
    x = xor(x, x >> 30) * 0xbf58476d1ce4e5b9
    x = xor(x, x >> 27) * 0x94d049bb133111eb
    return xor(x, x >> 31)
end


for i in 0:10
    Printf.@printf "%#018x: %#018x\n" i hash(SplitMix64(), UInt64(i))
end


Printf.@printf "%#018x: %#018x\n" 3 hash(AbstractRNG(), UInt64(3))

end  # module BitSift
