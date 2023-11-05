# // https://web.archive.org/web/20221206094913/https://www.thecodingforums.com/threads/64-bit-kiss-rngs.673657/
# #include <stdint.h>

# static uint64_t x = 1234567890987654321ULL, c = 123456123456123456ULL,
#                 y = 362436362436362436ULL, z = 1066149217761810ULL, t;

# #define MWC (t = (x << 58) + c, c = (x >> 6), x += t, c += (x < t), x)
# #define XSH (y ^= (y << 13), y ^= (y >> 17), y ^= (y << 43))
# #define CNG (z = 6906969069LL * z + 1234567)
# #define KISS (MWC + XSH + CNG)

# int main(void) {
#     for (int i = 0; i < 4; ++i) __builtin_printf("%d => %#018llx\n", i, CNG);
# }

function _ref_kiss_mwc(key::UInt64)::UInt64
    x = UInt64(1234567890987654321)
    c = UInt64(123456123456123456)
    for _ in 0:key
        t = (x << 58) + c
        c = (x >> 6)
        x += t
        c += (x < t)
    end
    return x
end

@testset "_ref_kiss_mwc" begin
    # Reference: https://godbolt.org/z/x9685zodY
    @test _ref_kiss_mwc(UInt64(0)) === 0xd6d8aba5615f0ef1
    @test _ref_kiss_mwc(UInt64(1)) === 0x9b1d33e93424bf63
    @test _ref_kiss_mwc(UInt64(2)) === 0x2a789697c9aa3b9f
    @test _ref_kiss_mwc(UInt64(3)) === 0xa8e50b676e7ace9d
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
