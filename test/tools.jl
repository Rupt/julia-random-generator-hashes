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
