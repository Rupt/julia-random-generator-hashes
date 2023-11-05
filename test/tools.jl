
@testset "BitSift.encode(::UInt64)" begin
    @test typeof(encode(UInt64(0))) === BitVector
    @test length(encode(UInt64(0))) === 64
    @test encode(UInt64(0b10101))[60:end] == [true, false, true, false, true]
    for example in [0, 0xe220a8397b1dcdaf, 0xbf58476d1ce4e5b9, 0x06c45d188009454f]
        @test join(UInt8.(encode(example))) == bitstring(example)
    end
end

@testset "BitSift.encode(::T)" begin
    for T in [UInt8, UInt16, UInt32, UInt64, UInt128, Int8, Int16, Int32, Int64, Int128]
        @test typeof(encode(T(0))) === BitVector
        @test length(encode(T(0))) === sizeof(T) * 8
        for example in [T(0), typemin(T), typemax(T), T(3), T(57)]
            @test join(UInt8.(encode(T(example)))) == bitstring(example)
        end
    end
end
