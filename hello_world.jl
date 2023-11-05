using Printf
include("src/BitSift.jl")

function main()
    for i in 0:10
        @printf "%#018x: %#018x\n" i BitSift.query(BitSift.SplitMix64(), UInt64(i))
    end
    query_split_mix64(k) = BitSift.query(BitSift.SplitMix64(), UInt64(k))
    println(query_split_mix64.(0:3))
    println((k -> BitSift.query(BitSift.SplitMix64(), UInt64(k))).(0:3))
    println(BitSift.encode(BitSift.SplitMix64()))
    return println(BitSift.encode(0xff00818283848586))
end

@time main()
