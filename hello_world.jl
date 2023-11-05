using Printf
using BitSift

function main()
    for i in 0:10
        @printf "%#018x: %#018x\n" i query(SplitMix64(), UInt64(i))
    end
    query_split_mix64(k) = query(SplitMix64(), UInt64(k))
    println(query_split_mix64.(0:3))
    println((k -> query(SplitMix64(), UInt64(k))).(0:3))
    println(encode(SplitMix64()))
    println(encode(0xff00818283848586))
    return nothing
end

@time main()
