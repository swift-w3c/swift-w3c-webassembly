extension W3C.WebAssembly {
    /// An instruction. Blocks hold their own instructions, and a label is counted outward from the innermost block.
    public indirect enum Instruction: Sendable, Hashable {
        case unreachable
        case nop
        case block(Block, [Instruction])
        case loop(Block, [Instruction])
        case `if`(Block, then: [Instruction], else: [Instruction])
        case br(Int)
        case brIf(Int)
        case brTable([Int], otherwise: Int)
        case `return`
        case call(Int)
        case callIndirect(type: Int, table: Int)
        case drop
        case select
        case selectOf([Value])
        case localGet(Int)
        case localSet(Int)
        case localTee(Int)
        case globalGet(Int)
        case globalSet(Int)
        case tableGet(Int)
        case tableSet(Int)
        case load(Load, Address)
        case store(Store, Address)
        case memorySize
        case memoryGrow
        case memoryInit(data: Int)
        case dataDrop(Int)
        case memoryCopy
        case memoryFill
        case tableInit(table: Int, element: Int)
        case elemDrop(Int)
        case tableCopy(to: Int, from: Int)
        case tableGrow(Int)
        case tableSize(Int)
        case tableFill(Int)
        case i32(Int32)
        case i64(Int64)
        /// A constant by its bit pattern.
        case f32(UInt32)
        /// A constant by its bit pattern.
        case f64(UInt64)
        case numeric(Numeric)
        case saturating(Saturating)
        case refNull(Value)
        case refIsNull
        case refFunc(Int)
    }
}

extension W3C.WebAssembly.Instruction {
    /// What a block takes and gives: nothing, one result, or a function type by its index.
    public enum Block: Sendable, Hashable {
        case empty
        case result(W3C.WebAssembly.Value)
        case type(Int)
    }

    /// Where a load or a store reaches: an offset added to its operand, and the alignment promised, as a power of two.
    public struct Address: Sendable, Hashable {
        public var offset: UInt32
        public var alignment: UInt32

        public init(offset: UInt32, alignment: UInt32) {
            self.offset = offset
            self.alignment = alignment
        }
    }
}
