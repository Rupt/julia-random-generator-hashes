function _ref_kiss_mwc(key::UInt64)::UInt64
    # https://web.archive.org/web/20221206094913/https://www.thecodingforums.com/threads/64-bit-kiss-rngs.673657/
    c::UInt64 = 123456123456123456
    x::UInt64 = 1234567890987654321
    for _ in 1:key
        t::UInt64 = (x << 58) + c
        c = x >> 6
        x += t
        c += x < t
    end
    return x
end

function _ref_kiss_mwc_rng(key::UInt64)::UInt64
    c::UInt64 = 123456123456123456
    x::UInt64 = 1234567890987654321
    rng = MultiplyWithCarry(UInt64(1) << 58 + 1, c, x)
    return query(rng, key)
end

@testset "BitSift.MultiplyWithCarry" begin
    c::UInt64 = 1
    x::UInt64 = 3141592653589793238
    mwc_a1::UInt64 = 0xffebb71d94fcdaf9
    rng = MultiplyWithCarry(mwc_a1, c, x)
    # query
    @test typeof(query(rng, UInt64(0))) === UInt64
    # Reference: https://godbolt.org/z/1G89dnvoT
    @test query(rng, UInt64(1)) === 0x8ee32211fc720d27
    @test query(rng, UInt64(2)) === 0x8d4afc4090e4aa85
    @test query(rng, UInt64(3)) === 0x5dcc5d9277c19e28
    @test query(rng, UInt64(4)) === 0x99d4dc2af9055010
    # Reference: https://godbolt.org/z/dE64vPMWb (KISS64)
    @test _ref_kiss_mwc_rng(UInt64(1)) === 0xd6d8aba5615f0ef1
    @test _ref_kiss_mwc_rng(UInt64(2)) === 0x9b1d33e93424bf63
    @test _ref_kiss_mwc_rng(UInt64(3)) === 0x2a789697c9aa3b9f
    @test _ref_kiss_mwc_rng(UInt64(4)) === 0xa8e50b676e7ace9d
    for i in UInt64.(0:8)
        @test _ref_kiss_mwc(i) === _ref_kiss_mwc_rng(i)
    end
    # encode
    code = encode(rng)
    @test length(code) === 192
    @test code[1:64] == encode(mwc_a1)
    @test code[65:128] == encode(c)
    @test code[129:192] == encode(x)
end
