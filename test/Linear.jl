function _ref_query(rng::Linear, key::UInt64)::UInt64
    x = rng.seed
    for _ in 1:key
        x = rng.multiplier * x + rng.increment
    end
    return x
end

@testset "BitSift.Linear" begin
    multiplier = 0x5851f42d4c957f2d
    increment = 0x14057b7ef767814f
    seed = 0x2b992ddfa23249d6
    rng = Linear(multiplier, increment, seed)
    # query
    @test typeof(query(rng, UInt64(0))) === UInt64
    @test query(rng, UInt64(0)) === _ref_query(rng, UInt64(0))
    for i in UInt64.(0:4)
        @test query(rng, i) === _ref_query(rng, UInt64(i))
    end
    # Reference: https://godbolt.org/z/hqTGP91d3 (Marsaglia KISS64)
    kiss_cng = Linear(6906969069, 1234567, 1066149217761810)
    @test query(kiss_cng, UInt64(0)) === 0x0003c9a83566fa12
    @test query(kiss_cng, UInt64(1)) === 0xa1f271f53fe5ff31
    @test query(kiss_cng, UInt64(2)) === 0x476be49fc6b421e4
    @test query(kiss_cng, UInt64(3)) === 0xb5475749c8ecc29b
    # encode
    code = encode(rng)
    @test length(code) === 192
    @test code[1:64] == encode(multiplier)
    @test code[65:128] == encode(increment)
    @test code[129:192] == encode(seed)
end
