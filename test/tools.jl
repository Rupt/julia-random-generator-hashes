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

@testset "BitSift.bit_product" begin
    identity = BitMatrix64([UInt64(1) << i for i in 0:63])
    matrix = BitMatrix64([query(SplitMix(), i) for i in UInt64.(1:64)])
    matrix_alt = BitMatrix64([query(SplitMix(), i) for i in UInt64.(1001:1064)])
    zero_matrix = BitMatrix64(zeros(UInt64, 64))
    zero_vector = UInt64(0)
    vector = query(SplitMix(), UInt64(1789))
    vector_alt = query(SplitMix(), UInt64(2023))

    # Matrix Vector Product
    # 1 @ v = v
    for i in UInt64.(1:10)
        vector_i = query(SplitMix(), i)
        @test bit_product(identity, vector) === vector
    end
    # M @ (1 << n) = M[n]
    for i in 0:63
        @test bit_product(matrix, UInt64(1) << i) === matrix.columns[i + 1]
    end
    # M @ 0 = 0
    @test bit_product(matrix, zero_vector) === UInt64(0)
    # 0 @ v = 0
    @test bit_product(zero_matrix, vector) == UInt64(0)

    # Matrix Matrix Product
    # 1 @ R = v
    @test bit_product(identity, matrix).columns == matrix.columns
    # L @ 1 = L
    @test bit_product(matrix, identity).columns == matrix.columns
    # L @ 0 = 0
    @test bit_product(matrix, zero_matrix).columns == zero_matrix.columns
    # 0 @ R = 0
    @test bit_product(zero_matrix, matrix).columns == zero_matrix.columns

    # Associativity
    @test bit_product(bit_product(matrix, matrix_alt), vector) ==
        bit_product(matrix, bit_product(matrix_alt, vector))

    # Distributivity
    @test bit_product(matrix, xor(vector, vector_alt)) ==
        xor(bit_product(matrix, vector), bit_product(matrix, vector_alt))
end
