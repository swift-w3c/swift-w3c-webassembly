extension W3C.WebAssembly.Instruction {
    /// A store, by its byte in the binary format.
    public enum Store: UInt8, Sendable, Hashable, CaseIterable {
        /// `i32.store`
        case i32Store = 0x36
        /// `i64.store`
        case i64Store = 0x37
        /// `f32.store`
        case f32Store = 0x38
        /// `f64.store`
        case f64Store = 0x39
        /// `i32.store8`
        case i32Store8 = 0x3A
        /// `i32.store16`
        case i32Store16 = 0x3B
        /// `i64.store8`
        case i64Store8 = 0x3C
        /// `i64.store16`
        case i64Store16 = 0x3D
        /// `i64.store32`
        case i64Store32 = 0x3E
    }
}
