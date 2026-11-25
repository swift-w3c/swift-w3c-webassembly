extension W3C.WebAssembly {
    /// References for a table.
    public struct Element: Sendable, Hashable {
        public var mode: Mode
        public var kind: Value
        /// One constant expression for each reference.
        public var initial: [[Instruction]]

        public init(mode: Mode, kind: Value, initial: [[Instruction]]) {
            self.mode = mode
            self.kind = kind
            self.initial = initial
        }
    }
}

extension W3C.WebAssembly.Element {
    /// When the references go into a table.
    public enum Mode: Sendable, Hashable {
        case active(table: Int, offset: [W3C.WebAssembly.Instruction])
        case passive
        case declarative
    }
}
