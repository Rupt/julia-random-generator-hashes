using BenchmarkTools
using BitSift

multiplier::UInt64 = 0x5851f42d4c957f2d
increment::UInt64 = 0x14057b7ef767814f
seed::UInt64 = 0x2b992ddfa23249d6
rng = Linear(multiplier, increment, seed)

key = 0x8ee32211fc720d27
for _ in 1:100  # warmup
    query(rng, key)
end
@btime query(rng, key)
