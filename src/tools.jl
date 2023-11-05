function encode(key::UInt64)::BitVector
    return BitVector((key >> i) & 1 for i in 63:-1:0)
end
