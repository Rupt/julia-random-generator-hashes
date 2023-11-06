@testset "BitSift.SplitMix64" begin
    # query
    @test typeof(query(SplitMix64(), UInt64(0))) === UInt64
    # Reference: https://godbolt.org/z/jGavMbPTn
    @test query(SplitMix64(), UInt64(1)) === 0xe220a8397b1dcdaf
    @test query(SplitMix64(), UInt64(2)) === 0x6e789e6aa1b965f4
    @test query(SplitMix64(), UInt64(3)) === 0x06c45d188009454f
    @test query(SplitMix64(), UInt64(4)) === 0xf88bb8a8724c81ec
    # encode
    @test encode(SplitMix64()) == Bool[]
end
