extension W3C.WebAssembly {
    /// Why bytes are not a module, with the offset of where that shows.
    public enum Error: Swift.Error, Sendable, Hashable {
        /// The bytes do not begin as a module of version 1.
        case header
        /// The bytes end too soon.
        case end(offset: Int)
        /// A number is not a LEB128 of its width.
        case number(offset: Int)
        /// A name is not UTF-8.
        case name(offset: Int)
        /// A byte has no meaning where it stands.
        case byte(UInt8, offset: Int)
        /// An instruction the reader does not know.
        case opcode(UInt32, offset: Int)
        /// A section or a body holds more or less than its length.
        case length(offset: Int)
        /// There are not as many bodies as functions.
        case functions(declared: Int, defined: Int)
    }
}
