extension W3C.WebAssembly {
    /// A table's type: the references it holds and how many.
    public struct Table: Sendable, Hashable {
        public var element: Value
        public var limits: Limits

        public init(element: Value, limits: Limits) {
            self.element = element
            self.limits = limits
        }
    }
}
