public import Byte

extension W3C.WebAssembly.Module {
    /// The module a binary holds.
    public static func parse(_ bytes: [Byte]) throws(W3C.WebAssembly.Error) -> Self {
        let header: [UInt8] = [0x00, 0x61, 0x73, 0x6D, 0x01, 0x00, 0x00, 0x00]
        guard bytes.prefix(8).map(\.bitPattern) == header else { throw .header }
        var module = Self()
        var types: [Int] = []
        var bodies = 0
        var reader = W3C.WebAssembly.Reader(rest: bytes.dropFirst(8))
        while !reader.rest.isEmpty {
            let start = reader.offset
            let id = try reader.byte()
            let length = try reader.index()
            var section = W3C.WebAssembly.Reader(rest: try reader.bytes(length))
            switch id {
            case 3: types = try section.vector { reader throws(W3C.WebAssembly.Error) in try reader.index() }
            case 10:
                let end = section.rest.endIndex
                let found = try section.vector { reader throws(W3C.WebAssembly.Error) in try reader.body() }
                guard end == section.rest.startIndex else { throw .length(offset: start) }
                bodies = found.count
                guard found.count == types.count else { throw .functions(declared: types.count, defined: found.count) }
                module.functions = zip(types, found).map { .init(type: $0, locals: $1.locals, body: $1.body) }
            default: try module.read(id, from: &section, at: start)
            }
            guard section.rest.isEmpty else { throw .length(offset: start) }
        }
        guard bodies == types.count else { throw .functions(declared: types.count, defined: bodies) }
        return module
    }

    private mutating func read(_ id: UInt8, from section: inout W3C.WebAssembly.Reader, at start: Int) throws(W3C.WebAssembly.Error) {
        switch id {
        case 0:
            let name = try section.name()
            custom.append(.init(name: name, bytes: Array(section.rest)))
            section.rest = section.rest.suffix(0)
        case 1: types = try section.vector { reader throws(W3C.WebAssembly.Error) in try reader.signature() }
        case 2: imports = try section.vector { reader throws(W3C.WebAssembly.Error) in try reader.imported() }
        case 4: tables = try section.vector { reader throws(W3C.WebAssembly.Error) in try reader.table() }
        case 5: memories = try section.vector { reader throws(W3C.WebAssembly.Error) in try reader.limits() }
        case 6:
            globals = try section.vector { reader throws(W3C.WebAssembly.Error) in
                .init(kind: try reader.global(), initial: try reader.expression())
            }
        case 7: exports = try section.vector { reader throws(W3C.WebAssembly.Error) in try reader.exported() }
        case 8: self.start = try section.index()
        case 9: elements = try section.vector { reader throws(W3C.WebAssembly.Error) in try reader.element() }
        case 11: data = try section.vector { reader throws(W3C.WebAssembly.Error) in try reader.data() }
        case 12: _ = try section.index()
        default: throw .byte(id, offset: start)
        }
    }
}

extension W3C.WebAssembly.Reader {
    fileprivate mutating func signature() throws(Error) -> W3C.WebAssembly.Signature {
        let start = offset
        let form = try byte()
        guard form == 0x60 else { throw .byte(form, offset: start) }
        let parameters = try vector { reader throws(Error) in try reader.value() }
        return .init(parameters: parameters, results: try vector { reader throws(Error) in try reader.value() })
    }

    fileprivate mutating func imported() throws(Error) -> W3C.WebAssembly.Import {
        let module = try name()
        let name = try name()
        let start = offset
        let byte = try byte()
        let kind: W3C.WebAssembly.Import.Kind
        switch byte {
        case 0: kind = .function(try index())
        case 1: kind = .table(try table())
        case 2: kind = .memory(try limits())
        case 3: kind = .global(try global())
        default: throw .byte(byte, offset: start)
        }
        return .init(module: module, name: name, kind: kind)
    }

    fileprivate mutating func exported() throws(Error) -> W3C.WebAssembly.Export {
        let name = try name()
        let start = offset
        let byte = try byte()
        guard let kind = W3C.WebAssembly.Export.Kind(rawValue: byte) else { throw .byte(byte, offset: start) }
        return .init(name: name, kind: kind, index: try index())
    }

    fileprivate mutating func body() throws(Error) -> (locals: [W3C.WebAssembly.Value], body: [Instruction]) {
        let start = offset
        let length = try index()
        var inner = W3C.WebAssembly.Reader(rest: try bytes(length))
        var locals: [W3C.WebAssembly.Value] = []
        let groups = try inner.index()
        for _ in 0..<groups {
            let count = try inner.index()
            locals += Array(repeating: try inner.value(), count: count)
        }
        let body = try inner.expression()
        guard inner.rest.isEmpty else { throw .length(offset: start) }
        return (locals, body)
    }

    fileprivate mutating func data() throws(Error) -> W3C.WebAssembly.Data {
        let start = offset
        let mode = try unsigned()
        guard mode < 3 else { throw .byte(UInt8(truncatingIfNeeded: mode), offset: start) }
        let memory = mode == 2 ? try index() : 0
        let offset = mode == 1 ? nil : try expression()
        let length = try index()
        return .init(memory: memory, offset: offset, bytes: Array(try bytes(length)))
    }

    fileprivate mutating func element() throws(Error) -> W3C.WebAssembly.Element {
        let start = offset
        let form = try unsigned()
        guard form < 8 else { throw .byte(UInt8(truncatingIfNeeded: form), offset: start) }
        let mode: W3C.WebAssembly.Element.Mode
        if form & 1 == 0 {
            let table = form & 2 == 0 ? 0 : try index()
            mode = .active(table: table, offset: try expression())
        } else {
            mode = form & 2 == 0 ? .passive : .declarative
        }
        let expressions = form & 4 != 0
        var kind = W3C.WebAssembly.Value.funcref
        if form & 3 != 0 {
            if expressions {
                kind = try value()
            } else {
                let start = self.offset
                let byte = try byte()
                guard byte == 0 else { throw .byte(byte, offset: start) }
            }
        }
        let initial = try vector { reader throws(Error) -> [Instruction] in
            expressions ? try reader.expression() : [.refFunc(try reader.index())]
        }
        return .init(mode: mode, kind: kind, initial: initial)
    }
}
