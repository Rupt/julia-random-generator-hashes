using BenchmarkTools
using BitSift

const rng = XorShift(362436362436362436)

key = 0x8ee32211fc720d27
for _ in 1:100  # warmup
    query(rng, key)
end
@btime query(rng, key)

# WIP: Is auto vectorization efficient?
keys = [query(SplitMix(), i) for i in UInt64.(1:1000)]

function bench(keys)
    return [query(rng, key) for key in keys]
end
for _ in 1:100  # warmup
    bench(keys)
end
@btime bench(keys)

for _ in 1:100  # warmup
    query(rng, keys)
end
@btime query(rng, keys)
