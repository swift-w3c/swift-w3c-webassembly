extension W3C.WebAssembly {
    /// Something the module takes from outside, by module and name.
    public struct Import: Sendable, Hashable {
        public var module: String
        public var name: String
        public var kind: Kind

        public init(module: String, name: String, kind: Kind) {
            self.module = module
            self.name = name
            self.kind = kind
        }
    }
}

extension W3C.WebAssembly.Import {
    /// What is imported, with its type.
    public enum Kind: Sendable, Hashable {
        /// A function, by the index of its type.
        case function(Int)
        case table(W3C.WebAssembly.Table)
        case memory(W3C.WebAssembly.Limits)
        case global(W3C.WebAssembly.Global.Kind)
    }
}
