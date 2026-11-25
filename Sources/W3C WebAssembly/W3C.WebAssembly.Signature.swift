extension W3C.WebAssembly {
    /// A function type: what a function takes and what it gives.
    public struct Signature: Sendable, Hashable {
        public var parameters: [Value]
        public var results: [Value]

        public init(parameters: [Value], results: [Value]) {
            self.parameters = parameters
            self.results = results
        }
    }
}
