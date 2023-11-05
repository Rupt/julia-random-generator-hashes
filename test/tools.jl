@testset "BitSift tools" begin
    @test typeof(encode(UInt64(0))) === BitVector
    @test length(encode(UInt64(0))) === 64
    @test encode(UInt64(0b10101))[60:64] == [true, false, true, false, true]
    examples = [0xe220a8397b1dcdaf, 0xbf58476d1ce4e5b9, 0x06c45d188009454f]
    for example in examples
        @test join(UInt8.(encode(example))) == bitstring(example)
    end
end
