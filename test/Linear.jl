function _ref_query(rng::Linear, key::UInt64)::UInt64
    x = UInt64(0)
    for _ in 0:key
        x = rng.multiplier * x + rng.increment
    end
    return x
end

@testset "BitSift.Linear" begin
    rng = Linear(0x5851f42d4c957f2d, 0x14057b7ef767814f)
    # query
    @test typeof(query(rng, UInt64(0))) === UInt64
    for i in UInt64.(0:4)
        @test query(rng, i) === _ref_query(rng, UInt64(i))
    end
    # encode
    code = encode(rng)
    @test length(code) === 128
    @test code[1:64] == encode(rng.multiplier)
    @test code[65:128] == encode(rng.increment)
end

# TODO check against Marsaglia's KISS CNG
# https://godbolt.org/z/q8djGdx4x
