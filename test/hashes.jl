@testset "BitSift.KISS" begin
    rng = KISS()

    # https://godbolt.org/z/dWYe3Yeb7 (KISS)
    @test query(rng, UInt64(1)) === 0x7bf856948de350b4
    @test query(rng, UInt64(2)) === 0x4f3f0ffc2151f23b
    @test query(rng, UInt64(3)) === 0xfe8db07360509101
    @test query(rng, UInt64(4)) === 0xc680b96777f2d4da

    @test encode(rng) == Bool[]
end

function _query_ref(rng::Linear, key::UInt64)::UInt64
    x::UInt64 = rng.seed
    for _ in 1:key
        x = rng.multiplier * x + rng.increment
    end
    return x
end

@testset "BitSift.Linear" begin
    multiplier::UInt64 = 0x5851f42d4c957f2d
    increment::UInt64 = 0x14057b7ef767814f
    seed::UInt64 = 0x2b992ddfa23249d6
    rng = Linear(multiplier, increment, seed)

    @test typeof(query(rng, UInt64(0))) === UInt64
    @test query(rng, UInt64(0)) === _query_ref(rng, UInt64(0))
    for i in UInt64.(0:4)
        @test query(rng, i) === _query_ref(rng, UInt64(i))
    end
    # https://godbolt.org/z/avYrzxocq (KISS CNG)
    kiss_cng = Linear(6906969069, 1234567, 1066149217761810)
    @test query(kiss_cng, UInt64(1)) === 0xa1f271f53fe5ff31
    @test query(kiss_cng, UInt64(2)) === 0x476be49fc6b421e4
    @test query(kiss_cng, UInt64(3)) === 0xb5475749c8ecc29b
    @test query(kiss_cng, UInt64(4)) === 0xe6a59d970705f906

    code = encode(rng)
    @test length(code) === 192
    @test code[1:64] == encode(multiplier)
    @test code[65:128] == encode(increment)
    @test code[129:192] == encode(seed)
end

function _kiss_mwc_ref(key::UInt64)::UInt64
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

@testset "BitSift.MultiplyWithCarry" begin
    mwc_a1::UInt64 = 0xffebb71d94fcdaf9
    seed_c::UInt64 = 1
    seed_x::UInt64 = 3141592653589793238
    rng = MultiplyWithCarry(mwc_a1, seed_c, seed_x)

    # https://godbolt.org/z/1G89dnvoT
    @test query(rng, UInt64(1)) === 0x8ee32211fc720d27
    @test query(rng, UInt64(2)) === 0x8d4afc4090e4aa85
    @test query(rng, UInt64(3)) === 0x5dcc5d9277c19e28
    @test query(rng, UInt64(4)) === 0x99d4dc2af9055010
    # https://godbolt.org/z/dE64vPMWb (KISS MWC)
    kiss_a1 = UInt64(1) << 58 + 1
    kiss_c::UInt64 = 123456123456123456
    kiss_x::UInt64 = 1234567890987654321
    kiss_mwc = MultiplyWithCarry(kiss_a1, kiss_c, kiss_x)
    @test query(kiss_mwc, UInt64(1)) === 0xd6d8aba5615f0ef1
    @test query(kiss_mwc, UInt64(2)) === 0x9b1d33e93424bf63
    @test query(kiss_mwc, UInt64(3)) === 0x2a789697c9aa3b9f
    @test query(kiss_mwc, UInt64(4)) === 0xa8e50b676e7ace9d
    for i in UInt64.(0:8)
        @test query(kiss_mwc, i) === _kiss_mwc_ref(i)
    end

    code = encode(rng)
    @test length(code) === 192
    @test code[1:64] == encode(mwc_a1)
    @test code[65:128] == encode(seed_c)
    @test code[129:192] == encode(seed_x)
end

@testset "BitSift.SplitMix" begin
    rng = SplitMix()

    # https://godbolt.org/z/jGavMbPTn
    @test query(rng, UInt64(1)) === 0xe220a8397b1dcdaf
    @test query(rng, UInt64(2)) === 0x6e789e6aa1b965f4
    @test query(rng, UInt64(3)) === 0x06c45d188009454f
    @test query(rng, UInt64(4)) === 0xf88bb8a8724c81ec

    @test encode(rng) == Bool[]
end

function _query_ref(rng::XorShift, key::UInt64)::UInt64
    x = rng.seed
    for _ in 1:key
        x = xor(x, x << 13)
        x = xor(x, x >> 17)
        x = xor(x, x << 43)
    end
    return x
end

@testset "BitSift.XorShift" begin
    rng = XorShift(362436362436362436)

    # https://godbolt.org/z/bPr3vab1s (KISS XSH)
    @test _query_ref(rng, UInt64(1)) === 0x032d38f9ec9e4292
    @test _query_ref(rng, UInt64(2)) === 0x6cb5f773267910f4
    @test _query_ref(rng, UInt64(3)) === 0x1ecdc291cdb992c7
    @test _query_ref(rng, UInt64(4)) === 0x36f6106902720d37
    for i in UInt64.(0:8)
        @test query(rng, i) === _query_ref(rng, i)
    end

    @test length(encode(rng)) === 64
    @test encode(rng) == encode(rng.seed)
end
