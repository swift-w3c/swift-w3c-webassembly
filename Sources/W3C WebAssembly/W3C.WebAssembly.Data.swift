public import Byte

extension W3C.WebAssembly {
    /// Bytes for a memory: placed when the module starts, at an offset, or kept until an instruction copies them.
    public struct Data: Sendable, Hashable {
        public var memory: Int
        /// The constant expression of where the bytes go, or nil for passive data.
        public var offset: [Instruction]?
        public var bytes: [Byte]

        public init(memory: Int, offset: [Instruction]?, bytes: [Byte]) {
            self.memory = memory
            self.offset = offset
            self.bytes = bytes
        }
    }
}
