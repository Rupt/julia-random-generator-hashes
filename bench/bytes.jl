using BenchmarkTools
using BitSift

key = 0x8ee32211fc720d27

@btime bytes(key)

# WIP: Is auto vectorization efficient?
keys = [query(SplitMix(), i) for i in UInt64.(1:1000)]

function bench(keys)
    return [bytes(key) for key in keys]
end
for _ in 1:100  # warmup
    bench(keys)
end
@btime bench(keys)

for _ in 1:100  # warmup
    bytes(keys)
end
@btime bytes(keys)
