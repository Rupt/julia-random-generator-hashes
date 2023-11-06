using Printf
using BitSift

function main()
    for i in 0:10
        @printf "%#018x: %#018x\n" i query(SplitMix(), UInt64(i))
    end
    query_split_mix64(k) = query(SplitMix(), UInt64(k))
    println(query_split_mix64.(0:3))
    println((k -> query(SplitMix(), UInt64(k))).(0:3))
    println(encode(SplitMix()))
    println(encode(0xff00818283848586))
    return nothing
end

@time main()
