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

@testset "BitSift.xor_mul" begin
    identity = XorMatrix(Tuple(UInt64(1) << i for i in 0:63))
    matrix = XorMatrix(Tuple(query(SplitMix(), i) for i in UInt64.(1:64)))
    matrix_alt = XorMatrix(Tuple(query(SplitMix(), i) for i in UInt64.(1001:1064)))
    zero_matrix = XorMatrix(Tuple(zeros(UInt64, 64)))
    zero_vector = UInt64(0)
    vector = query(SplitMix(), UInt64(1789))
    vector_alt = query(SplitMix(), UInt64(2023))

    # Matrix Vector Product
    # 1 @ v = v
    for i in UInt64.(1:10)
        vector_i = query(SplitMix(), i)
        @test xor_mul(identity, vector) === vector
    end
    # M @ (1 << n) = M[n]
    for i in 0:63
        @test xor_mul(matrix, UInt64(1) << i) === matrix.column[i + 1]
    end
    # M @ 0 = 0
    @test xor_mul(matrix, zero_vector) === UInt64(0)
    # 0 @ v = 0
    @test xor_mul(zero_matrix, vector) === UInt64(0)

    # Matrix Matrix Product
    # 1 @ R = v
    @test xor_mul(identity, matrix).column == matrix.column
    # L @ 1 = L
    @test xor_mul(matrix, identity).column == matrix.column
    # L @ 0 = 0
    @test xor_mul(matrix, zero_matrix).column == zero_matrix.column
    # 0 @ R = 0
    @test xor_mul(zero_matrix, matrix).column == zero_matrix.column

    # Associativity
    @test xor_mul(xor_mul(matrix, matrix_alt), vector) ==
        xor_mul(matrix, xor_mul(matrix_alt, vector))

    # Distributivity
    @test xor_mul(matrix, xor(vector, vector_alt)) ==
        xor(xor_mul(matrix, vector), xor_mul(matrix, vector_alt))
end

function _add_mod_ref(a::UInt128, b::UInt128, m::UInt128)::UInt128
    return (BigInt(a) + BigInt(b)) % BigInt(m)
end

function _mul_mod_ref(a::UInt128, b::UInt128, m::UInt128)::UInt128
    return (BigInt(a) * BigInt(b)) % BigInt(m)
end

@testset "Modular arithmetic" begin
    m::UInt128 = 0xff992ddfa23249d62b992ddfa23249d5
    a::UInt128 = 0x5851f42d4c957f2d5851f42d4c957f2d % m
    b::UInt128 = 0xff057b7ef767814f14057b7ef767814f % m
    @test add_mod(a, b, m) == _add_mod_ref(a, b, m)
    @test mul_mod(a, b, m) == _mul_mod_ref(a, b, m)
    @test mul_mod2(a, b, m) == _mul_mod_ref(a, b, m)

    rng = SplitMix()
    for k in 1:100
        i = k * 6
        m = UInt128(query(rng, UInt64(i))) << 64 | query(rng, UInt64(i + 1))
        a = (UInt128(query(rng, UInt64(i + 2))) << 64 | query(rng, UInt64(i + 3))) % m
        b = (UInt128(query(rng, UInt64(i + 4))) << 64 | query(rng, UInt64(i + 5))) % m
        @test add_mod(a, b, m) == _add_mod_ref(a, b, m)
        @test mul_mod(a, b, m) == _mul_mod_ref(a, b, m)
        @test mul_mod2(a, b, m) == _mul_mod_ref(a, b, m)
    end
end
