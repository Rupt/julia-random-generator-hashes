function _ref_query(rng::Linear, key::UInt64)::UInt64
    x = rng.seed
    for _ in 1:key
        x = rng.multiplier * x + rng.increment
    end
    return x
end

@testset "BitSift.XorShift" begin
    # query
    @test typeof(query(XorShift(), UInt64(0))) === UInt64
    # TODO Reference https://godbolt.org/z/qaqe4e84x
    # y = 362436362436362436ULL  # seed
    # 0 => 0x0507a1f38cb440c4
    # 1 => 0x032d38f9ec9e4292
    # 2 => 0x6cb5f773267910f4
    # 3 => 0x1ecdc291cdb992c7
    # encode
    @test encode(XorShift()) == Bool[]
end
