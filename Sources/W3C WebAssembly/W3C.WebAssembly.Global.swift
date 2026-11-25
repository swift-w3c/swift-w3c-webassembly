extension W3C.WebAssembly {
    /// A global of the module and the constant expression it starts from.
    public struct Global: Sendable, Hashable {
        public var kind: Kind
        public var initial: [Instruction]

        public init(kind: Kind, initial: [Instruction]) {
            self.kind = kind
            self.initial = initial
        }
    }
}

extension W3C.WebAssembly.Global {
    /// A global's type.
    public struct Kind: Sendable, Hashable {
        public var value: W3C.WebAssembly.Value
        public var mutable: Bool

        public init(value: W3C.WebAssembly.Value, mutable: Bool) {
            self.value = value
            self.mutable = mutable
        }
    }
}
