extension W3C.WebAssembly {
    /// A function of the module: the index of its type, its locals after its parameters, and its body.
    public struct Function: Sendable, Hashable {
        public var type: Int
        public var locals: [Value]
        public var body: [Instruction]

        public init(type: Int, locals: [Value], body: [Instruction]) {
            self.type = type
            self.locals = locals
            self.body = body
        }
    }
}
