using BenchmarkTools
using BitSift

mwc_a1::UInt64 = 0xffebb71d94fcdaf9
seed_c::UInt64 = 1
seed_x::UInt64 = 3141592653589793238
rng = MultiplyWithCarry(mwc_a1, seed_c, seed_x)
key = 0x8ee32211fc720d27

for _ in 1:100  # warmup
    query(rng, key)
end

@btime query(rng, key)
