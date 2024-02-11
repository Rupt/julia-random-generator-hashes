using BenchmarkTools
using BitSift

const rng = KISS()

key = 0x8ee32211fc720d27
for _ in 1:100  # warmup
    query(rng, key)
end
@btime query(rng, key)
