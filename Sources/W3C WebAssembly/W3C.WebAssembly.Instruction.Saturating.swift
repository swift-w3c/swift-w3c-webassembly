extension W3C.WebAssembly.Instruction {
    /// A saturating truncation, by its number after the prefix byte `0xFC`.
    public enum Saturating: UInt8, Sendable, Hashable, CaseIterable {
        /// `i32.trunc_sat_f32_s`
        case i32TruncSatF32S = 0x00
        /// `i32.trunc_sat_f32_u`
        case i32TruncSatF32U = 0x01
        /// `i32.trunc_sat_f64_s`
        case i32TruncSatF64S = 0x02
        /// `i32.trunc_sat_f64_u`
        case i32TruncSatF64U = 0x03
        /// `i64.trunc_sat_f32_s`
        case i64TruncSatF32S = 0x04
        /// `i64.trunc_sat_f32_u`
        case i64TruncSatF32U = 0x05
        /// `i64.trunc_sat_f64_s`
        case i64TruncSatF64S = 0x06
        /// `i64.trunc_sat_f64_u`
        case i64TruncSatF64U = 0x07
    }
}
