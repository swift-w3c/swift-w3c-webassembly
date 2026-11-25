extension W3C.WebAssembly {
    /// A module: everything its binary format holds.
    public struct Module: Sendable, Hashable {
        public var types: [Signature] = []
        public var imports: [Import] = []
        public var functions: [Function] = []
        public var tables: [Table] = []
        public var memories: [Limits] = []
        public var globals: [Global] = []
        public var exports: [Export] = []
        /// The index of the function that runs when the module starts.
        public var start: Int?
        public var elements: [Element] = []
        public var data: [Data] = []
        public var custom: [Section] = []

        public init() {}
    }
}

extension W3C.WebAssembly.Module {
    /// The imported functions, in the order of their indices.
    public var imported: [(module: String, name: String, type: Int)] {
        imports.compactMap {
            guard case .function(let type) = $0.kind else { return nil }
            return ($0.module, $0.name, type)
        }
    }

    /// The type of the function at an index, imported functions first, or nil where there is none.
    public func signature(of index: Int) -> W3C.WebAssembly.Signature? {
        let imported = imported
        let type: Int
        if imported.indices.contains(index) {
            type = imported[index].type
        } else if functions.indices.contains(index - imported.count) {
            type = functions[index - imported.count].type
        } else {
            return nil
        }
        return types.indices.contains(type) ? types[type] : nil
    }
}
