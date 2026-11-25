extension W3C.WebAssembly {
    /// The least size a memory or a table has, and the most it may have when that is limited.
    public struct Limits: Sendable, Hashable {
        public var minimum: UInt32
        public var maximum: UInt32?

        public init(minimum: UInt32, maximum: UInt32? = nil) {
            self.minimum = minimum
            self.maximum = maximum
        }
    }
}
