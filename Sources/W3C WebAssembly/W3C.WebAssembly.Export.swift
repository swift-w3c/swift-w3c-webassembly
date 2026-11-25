extension W3C.WebAssembly {
    /// Something the module gives to outside, by name.
    public struct Export: Sendable, Hashable {
        public var name: String
        public var kind: Kind
        public var index: Int

        public init(name: String, kind: Kind, index: Int) {
            self.name = name
            self.kind = kind
            self.index = index
        }
    }
}

extension W3C.WebAssembly.Export {
    /// What is exported, by its byte in the binary format.
    public enum Kind: UInt8, Sendable, Hashable, CaseIterable {
        case function = 0
        case table = 1
        case memory = 2
        case global = 3
    }
}
