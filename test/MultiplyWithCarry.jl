using Printf
function _ref_kiss_mwc(key::UInt64)::UInt64
    # // https://web.archive.org/web/20221206094913/https://www.thecodingforums.com/threads/64-bit-kiss-rngs.673657/
    x::UInt64 = 1234567890987654321
    c::UInt64 = 123456123456123456
    for _ in 1:key
        t::UInt64 = (x << 58) + c
        c = x >> 6
        x += t
        c += x < t
    end
    return x
end

function _ref_kiss_mwc_dumb(key::UInt64)::UInt64
    x::UInt64 = 1234567890987654321
    c::UInt64 = 123456123456123456
    a::UInt128 = UInt128(1) << 58 + 1
    b::UInt128 = UInt128(1) << 64
    p::UInt128 = a * b - 1
    b_inverse::UInt128 = invmod(b, p)
    s::BigInt = x + c * b
    for _ in 1:key
        s = (b_inverse * s) % p
    end
    return s & typemax(UInt64)
end

function _ref_kiss_mwc_rng(key::UInt64)::UInt64
    x::UInt64 = 1234567890987654321
    c::UInt64 = 123456123456123456
    a::UInt64 = UInt64(1) << 58 + 1
    modulus::UInt128 = (UInt128(a) << 64) - 1  # prime
    rng = MultiplyWithCarry64(modulus, (UInt128(c) << 64) | x)
    return query(rng, key)
end

function _mwc_demo()
    c = UInt64(1)
    x = UInt64(0)
    a = 7
    b = 10
    for i in 0:5
        tmp = a * x + c
        x = tmp % b
        c = div(tmp, b)
    end
end

function _mwc_redo()
    c = UInt64(1)
    x = UInt64(0)
    a = 7
    b = 10
    p = a * b - 1
    multiplier = invmod(b, p)
    s = x + c * b
    for i in 0:5
        tmp = (multiplier * s) % p
        x = tmp % b
        c = div(tmp, b)
        s = tmp
    end
end

@testset "MultiplyWithCarry._ref_kiss_mwc" begin
    # Reference: https://godbolt.org/z/fezcd1rqM
    @test _ref_kiss_mwc(UInt64(0)) === 0x112210f4b16c1cb1
    @test _ref_kiss_mwc(UInt64(1)) === 0xd6d8aba5615f0ef1
    @test _ref_kiss_mwc(UInt64(2)) === 0x9b1d33e93424bf63
    @test _ref_kiss_mwc(UInt64(3)) === 0x2a789697c9aa3b9f

    for i in UInt64.(0:8)
        @test _ref_kiss_mwc(i) === _ref_kiss_mwc_dumb(i)
    end

    # println(_ref_kiss_mwc(UInt64(0)))
    # println(_ref_kiss_mwc_dumb(UInt64(0)))
    # println(_ref_kiss_mwc_rng(UInt64(0)))
    # println(_ref_kiss_mwc(UInt64(1)))
    # println(_ref_kiss_mwc_dumb(UInt64(1)))
    # println(_ref_kiss_mwc_rng(UInt64(1)))
end

# @testset "BitSift.MultiplyWithCarry" begin
#     rng = MultiplyWithCarry((UInt128(1) << 58) + 1)
#     # query
#     @test typeof(query(rng, UInt64(0))) === UInt64
#     for i in UInt64.(0:8)
#         @test query(rng, i) === _ref_kiss_mwc(UInt64(i))
#     end
#     # encode
#     @test encode(SplitMix64()) == Bool[]
# end
