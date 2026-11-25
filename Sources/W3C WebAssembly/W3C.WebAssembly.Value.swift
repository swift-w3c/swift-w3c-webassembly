extension W3C.WebAssembly {
    /// The type of a value, by its byte in the binary format.
    public enum Value: UInt8, Sendable, Hashable, CaseIterable {
        case i32 = 0x7F
        case i64 = 0x7E
        case f32 = 0x7D
        case f64 = 0x7C
        case v128 = 0x7B
        case funcref = 0x70
        case externref = 0x6F
    }
}
