using BenchmarkTools
using BitSift

key = 0x8ee32211fc720d27
encoding = encode(key)

@btime bitcode(encoding)
