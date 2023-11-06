function _ref_query(rng::XorShift, key::UInt64)::UInt64
    x = rng.seed
    for _ in 1:key
        x = xor(x, x << 13)
        x = xor(x, x >> 17)
        x = xor(x, x << 43)
    end
    return x
end

@testset "BitSift.XorShift" begin
    # query
    # Reference https://godbolt.org/z/bPr3vab1s
    rng = XorShift(362436362436362436)
    @test _ref_query(rng, UInt64(1)) === 0x032d38f9ec9e4292
    @test _ref_query(rng, UInt64(2)) === 0x6cb5f773267910f4
    @test _ref_query(rng, UInt64(3)) === 0x1ecdc291cdb992c7
    @test _ref_query(rng, UInt64(4)) === 0x36f6106902720d37
    # encode
    @test length(encode(rng)) === 64
    @test encode(rng) == encode(rng.seed)
end
