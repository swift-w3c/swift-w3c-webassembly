public import Byte

extension W3C.WebAssembly {
    /// A custom section: a name, and bytes whose meaning the name gives.
    public struct Section: Sendable, Hashable {
        public var name: String
        public var bytes: [Byte]

        public init(name: String, bytes: [Byte]) {
            self.name = name
            self.bytes = bytes
        }
    }
}
