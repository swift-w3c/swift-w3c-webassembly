extension W3C.WebAssembly.Instruction {
    /// A numeric instruction without immediates, by its byte in the binary format.
    public enum Numeric: UInt8, Sendable, Hashable, CaseIterable {
        /// `i32.eqz`
        case i32Eqz = 0x45
        /// `i32.eq`
        case i32Eq = 0x46
        /// `i32.ne`
        case i32Ne = 0x47
        /// `i32.lt_s`
        case i32LtS = 0x48
        /// `i32.lt_u`
        case i32LtU = 0x49
        /// `i32.gt_s`
        case i32GtS = 0x4A
        /// `i32.gt_u`
        case i32GtU = 0x4B
        /// `i32.le_s`
        case i32LeS = 0x4C
        /// `i32.le_u`
        case i32LeU = 0x4D
        /// `i32.ge_s`
        case i32GeS = 0x4E
        /// `i32.ge_u`
        case i32GeU = 0x4F
        /// `i64.eqz`
        case i64Eqz = 0x50
        /// `i64.eq`
        case i64Eq = 0x51
        /// `i64.ne`
        case i64Ne = 0x52
        /// `i64.lt_s`
        case i64LtS = 0x53
        /// `i64.lt_u`
        case i64LtU = 0x54
        /// `i64.gt_s`
        case i64GtS = 0x55
        /// `i64.gt_u`
        case i64GtU = 0x56
        /// `i64.le_s`
        case i64LeS = 0x57
        /// `i64.le_u`
        case i64LeU = 0x58
        /// `i64.ge_s`
        case i64GeS = 0x59
        /// `i64.ge_u`
        case i64GeU = 0x5A
        /// `f32.eq`
        case f32Eq = 0x5B
        /// `f32.ne`
        case f32Ne = 0x5C
        /// `f32.lt`
        case f32Lt = 0x5D
        /// `f32.gt`
        case f32Gt = 0x5E
        /// `f32.le`
        case f32Le = 0x5F
        /// `f32.ge`
        case f32Ge = 0x60
        /// `f64.eq`
        case f64Eq = 0x61
        /// `f64.ne`
        case f64Ne = 0x62
        /// `f64.lt`
        case f64Lt = 0x63
        /// `f64.gt`
        case f64Gt = 0x64
        /// `f64.le`
        case f64Le = 0x65
        /// `f64.ge`
        case f64Ge = 0x66
        /// `i32.clz`
        case i32Clz = 0x67
        /// `i32.ctz`
        case i32Ctz = 0x68
        /// `i32.popcnt`
        case i32Popcnt = 0x69
        /// `i32.add`
        case i32Add = 0x6A
        /// `i32.sub`
        case i32Sub = 0x6B
        /// `i32.mul`
        case i32Mul = 0x6C
        /// `i32.div_s`
        case i32DivS = 0x6D
        /// `i32.div_u`
        case i32DivU = 0x6E
        /// `i32.rem_s`
        case i32RemS = 0x6F
        /// `i32.rem_u`
        case i32RemU = 0x70
        /// `i32.and`
        case i32And = 0x71
        /// `i32.or`
        case i32Or = 0x72
        /// `i32.xor`
        case i32Xor = 0x73
        /// `i32.shl`
        case i32Shl = 0x74
        /// `i32.shr_s`
        case i32ShrS = 0x75
        /// `i32.shr_u`
        case i32ShrU = 0x76
        /// `i32.rotl`
        case i32Rotl = 0x77
        /// `i32.rotr`
        case i32Rotr = 0x78
        /// `i64.clz`
        case i64Clz = 0x79
        /// `i64.ctz`
        case i64Ctz = 0x7A
        /// `i64.popcnt`
        case i64Popcnt = 0x7B
        /// `i64.add`
        case i64Add = 0x7C
        /// `i64.sub`
        case i64Sub = 0x7D
        /// `i64.mul`
        case i64Mul = 0x7E
        /// `i64.div_s`
        case i64DivS = 0x7F
        /// `i64.div_u`
        case i64DivU = 0x80
        /// `i64.rem_s`
        case i64RemS = 0x81
        /// `i64.rem_u`
        case i64RemU = 0x82
        /// `i64.and`
        case i64And = 0x83
        /// `i64.or`
        case i64Or = 0x84
        /// `i64.xor`
        case i64Xor = 0x85
        /// `i64.shl`
        case i64Shl = 0x86
        /// `i64.shr_s`
        case i64ShrS = 0x87
        /// `i64.shr_u`
        case i64ShrU = 0x88
        /// `i64.rotl`
        case i64Rotl = 0x89
        /// `i64.rotr`
        case i64Rotr = 0x8A
        /// `f32.abs`
        case f32Abs = 0x8B
        /// `f32.neg`
        case f32Neg = 0x8C
        /// `f32.ceil`
        case f32Ceil = 0x8D
        /// `f32.floor`
        case f32Floor = 0x8E
        /// `f32.trunc`
        case f32Trunc = 0x8F
        /// `f32.nearest`
        case f32Nearest = 0x90
        /// `f32.sqrt`
        case f32Sqrt = 0x91
        /// `f32.add`
        case f32Add = 0x92
        /// `f32.sub`
        case f32Sub = 0x93
        /// `f32.mul`
        case f32Mul = 0x94
        /// `f32.div`
        case f32Div = 0x95
        /// `f32.min`
        case f32Min = 0x96
        /// `f32.max`
        case f32Max = 0x97
        /// `f32.copysign`
        case f32Copysign = 0x98
        /// `f64.abs`
        case f64Abs = 0x99
        /// `f64.neg`
        case f64Neg = 0x9A
        /// `f64.ceil`
        case f64Ceil = 0x9B
        /// `f64.floor`
        case f64Floor = 0x9C
        /// `f64.trunc`
        case f64Trunc = 0x9D
        /// `f64.nearest`
        case f64Nearest = 0x9E
        /// `f64.sqrt`
        case f64Sqrt = 0x9F
        /// `f64.add`
        case f64Add = 0xA0
        /// `f64.sub`
        case f64Sub = 0xA1
        /// `f64.mul`
        case f64Mul = 0xA2
        /// `f64.div`
        case f64Div = 0xA3
        /// `f64.min`
        case f64Min = 0xA4
        /// `f64.max`
        case f64Max = 0xA5
        /// `f64.copysign`
        case f64Copysign = 0xA6
        /// `i32.wrap_i64`
        case i32WrapI64 = 0xA7
        /// `i32.trunc_f32_s`
        case i32TruncF32S = 0xA8
        /// `i32.trunc_f32_u`
        case i32TruncF32U = 0xA9
        /// `i32.trunc_f64_s`
        case i32TruncF64S = 0xAA
        /// `i32.trunc_f64_u`
        case i32TruncF64U = 0xAB
        /// `i64.extend_i32_s`
        case i64ExtendI32S = 0xAC
        /// `i64.extend_i32_u`
        case i64ExtendI32U = 0xAD
        /// `i64.trunc_f32_s`
        case i64TruncF32S = 0xAE
        /// `i64.trunc_f32_u`
        case i64TruncF32U = 0xAF
        /// `i64.trunc_f64_s`
        case i64TruncF64S = 0xB0
        /// `i64.trunc_f64_u`
        case i64TruncF64U = 0xB1
        /// `f32.convert_i32_s`
        case f32ConvertI32S = 0xB2
        /// `f32.convert_i32_u`
        case f32ConvertI32U = 0xB3
        /// `f32.convert_i64_s`
        case f32ConvertI64S = 0xB4
        /// `f32.convert_i64_u`
        case f32ConvertI64U = 0xB5
        /// `f32.demote_f64`
        case f32DemoteF64 = 0xB6
        /// `f64.convert_i32_s`
        case f64ConvertI32S = 0xB7
        /// `f64.convert_i32_u`
        case f64ConvertI32U = 0xB8
        /// `f64.convert_i64_s`
        case f64ConvertI64S = 0xB9
        /// `f64.convert_i64_u`
        case f64ConvertI64U = 0xBA
        /// `f64.promote_f32`
        case f64PromoteF32 = 0xBB
        /// `i32.reinterpret_f32`
        case i32ReinterpretF32 = 0xBC
        /// `i64.reinterpret_f64`
        case i64ReinterpretF64 = 0xBD
        /// `f32.reinterpret_i32`
        case f32ReinterpretI32 = 0xBE
        /// `f64.reinterpret_i64`
        case f64ReinterpretI64 = 0xBF
        /// `i32.extend8_s`
        case i32Extend8S = 0xC0
        /// `i32.extend16_s`
        case i32Extend16S = 0xC1
        /// `i64.extend8_s`
        case i64Extend8S = 0xC2
        /// `i64.extend16_s`
        case i64Extend16S = 0xC3
        /// `i64.extend32_s`
        case i64Extend32S = 0xC4
    }
}
