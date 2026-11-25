extension W3C.WebAssembly.Instruction {
    /// A load, by its byte in the binary format.
    public enum Load: UInt8, Sendable, Hashable, CaseIterable {
        /// `i32.load`
        case i32Load = 0x28
        /// `i64.load`
        case i64Load = 0x29
        /// `f32.load`
        case f32Load = 0x2A
        /// `f64.load`
        case f64Load = 0x2B
        /// `i32.load8_s`
        case i32Load8S = 0x2C
        /// `i32.load8_u`
        case i32Load8U = 0x2D
        /// `i32.load16_s`
        case i32Load16S = 0x2E
        /// `i32.load16_u`
        case i32Load16U = 0x2F
        /// `i64.load8_s`
        case i64Load8S = 0x30
        /// `i64.load8_u`
        case i64Load8U = 0x31
        /// `i64.load16_s`
        case i64Load16S = 0x32
        /// `i64.load16_u`
        case i64Load16U = 0x33
        /// `i64.load32_s`
        case i64Load32S = 0x34
        /// `i64.load32_u`
        case i64Load32U = 0x35
    }
}
