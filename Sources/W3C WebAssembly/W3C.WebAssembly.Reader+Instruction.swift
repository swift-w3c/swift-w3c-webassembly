internal import Byte

extension W3C.WebAssembly.Reader {
    /// What ends a run of instructions.
    enum End {
        case end
        case otherwise
    }

    /// An expression: instructions up to their end.
    mutating func expression() throws(Error) -> [Instruction] {
        let start = offset
        let (instructions, end) = try run()
        guard end == .end else { throw .byte(0x05, offset: start) }
        return instructions
    }

    mutating func run() throws(Error) -> ([Instruction], End) {
        var instructions: [Instruction] = []
        while true {
            let start = offset
            let opcode = try byte()
            switch opcode {
            case 0x0B: return (instructions, .end)
            case 0x05: return (instructions, .otherwise)
            default: instructions.append(try instruction(opcode, at: start))
            }
        }
    }

    private mutating func block() throws(Error) -> Instruction.Block {
        let start = offset
        if let first = rest.first?.bitPattern {
            if first == 0x40 {
                _ = try byte()
                return .empty
            }
            if let value = W3C.WebAssembly.Value(rawValue: first) {
                _ = try byte()
                return .result(value)
            }
        }
        let number = try signed(Int64.self)
        guard number >= 0, number <= Int64(UInt32.max) else { throw .number(offset: start) }
        return .type(Int(number))
    }

    private mutating func address() throws(Error) -> Instruction.Address {
        let alignment = try unsigned()
        return .init(offset: try unsigned(), alignment: alignment)
    }

    private mutating func zero() throws(Error) {
        let start = offset
        let byte = try byte()
        guard byte == 0 else { throw .byte(byte, offset: start) }
    }

    private mutating func instruction(_ opcode: UInt8, at start: Int) throws(Error) -> Instruction {
        if let load = Instruction.Load(rawValue: opcode) { return .load(load, try address()) }
        if let store = Instruction.Store(rawValue: opcode) { return .store(store, try address()) }
        if let numeric = Instruction.Numeric(rawValue: opcode) { return .numeric(numeric) }
        switch opcode {
        case 0x00...0x11: return try control(opcode, at: start)
        case 0x1A: return .drop
        case 0x1B: return .select
        case 0x1C: return .selectOf(try vector { reader throws(Error) in try reader.value() })
        case 0x20: return .localGet(try index())
        case 0x21: return .localSet(try index())
        case 0x22: return .localTee(try index())
        case 0x23: return .globalGet(try index())
        case 0x24: return .globalSet(try index())
        case 0x25: return .tableGet(try index())
        case 0x26: return .tableSet(try index())
        case 0x3F:
            try zero()
            return .memorySize
        case 0x40:
            try zero()
            return .memoryGrow
        case 0x41: return .i32(try signed(Int32.self))
        case 0x42: return .i64(try signed(Int64.self))
        case 0x43: return .f32(try fixed(UInt32.self))
        case 0x44: return .f64(try fixed(UInt64.self))
        case 0xD0: return .refNull(try value())
        case 0xD1: return .refIsNull
        case 0xD2: return .refFunc(try index())
        case 0xFC: return try prefixed(at: start)
        default: throw .opcode(UInt32(opcode), offset: start)
        }
    }

    private mutating func control(_ opcode: UInt8, at start: Int) throws(Error) -> Instruction {
        switch opcode {
        case 0x00: return .unreachable
        case 0x01: return .nop
        case 0x02: return .block(try block(), try expression())
        case 0x03: return .loop(try block(), try expression())
        case 0x04:
            let block = try block()
            let (then, end) = try run()
            return .if(block, then: then, else: end == .otherwise ? try expression() : [])
        case 0x0C: return .br(try index())
        case 0x0D: return .brIf(try index())
        case 0x0E:
            let labels = try vector { reader throws(Error) in try reader.index() }
            return .brTable(labels, otherwise: try index())
        case 0x0F: return .return
        case 0x10: return .call(try index())
        case 0x11:
            let type = try index()
            return .callIndirect(type: type, table: try index())
        default: throw .opcode(UInt32(opcode), offset: start)
        }
    }

    private mutating func prefixed(at start: Int) throws(Error) -> Instruction {
        let number = try unsigned()
        if let byte = UInt8(exactly: number), let saturating = Instruction.Saturating(rawValue: byte) { return .saturating(saturating) }
        switch number {
        case 8:
            let data = try index()
            try zero()
            return .memoryInit(data: data)
        case 9: return .dataDrop(try index())
        case 10:
            try zero()
            try zero()
            return .memoryCopy
        case 11:
            try zero()
            return .memoryFill
        case 12:
            let element = try index()
            return .tableInit(table: try index(), element: element)
        case 13: return .elemDrop(try index())
        case 14:
            let to = try index()
            return .tableCopy(to: to, from: try index())
        case 15: return .tableGrow(try index())
        case 16: return .tableSize(try index())
        case 17: return .tableFill(try index())
        default: throw .opcode(0xFC00 | number, offset: start)
        }
    }
}
