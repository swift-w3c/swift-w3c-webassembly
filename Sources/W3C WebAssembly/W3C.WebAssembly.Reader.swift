internal import Binary
internal import Byte

extension W3C.WebAssembly {
    /// A position in a module's bytes.
    struct Reader {
        var rest: ArraySlice<Byte>

        var offset: Int { rest.startIndex }
    }
}

extension W3C.WebAssembly.Reader {
    typealias Error = W3C.WebAssembly.Error
    typealias Instruction = W3C.WebAssembly.Instruction

    mutating func byte() throws(Error) -> UInt8 {
        guard let byte = rest.popFirst() else { throw .end(offset: offset) }
        return byte.bitPattern
    }

    mutating func bytes(_ count: Int) throws(Error) -> ArraySlice<Byte> {
        guard rest.count >= count else { throw .end(offset: offset) }
        defer { rest = rest.dropFirst(count) }
        return rest.prefix(count)
    }

    mutating func unsigned() throws(Error) -> UInt32 {
        let start = offset
        do throws(Binary.LEB128.Error) {
            return try Binary.LEB128.Unsigned<UInt32>().parse(&rest)
        } catch {
            throw error == .unterminated ? .end(offset: offset) : .number(offset: start)
        }
    }

    mutating func index() throws(Error) -> Int { Int(try unsigned()) }

    mutating func signed<Number: SignedInteger & FixedWidthInteger>(_: Number.Type) throws(Error) -> Number {
        let start = offset
        do throws(Binary.LEB128.Error) {
            return try Binary.LEB128.Signed<Number>().parse(&rest)
        } catch {
            throw error == .unterminated ? .end(offset: offset) : .number(offset: start)
        }
    }

    /// An unsigned number of fixed width, its lowest byte first.
    mutating func fixed<Number: UnsignedInteger & FixedWidthInteger>(_: Number.Type) throws(Error) -> Number {
        var number: Number = 0
        var shift = 0
        for byte in try bytes(Number.bitWidth / 8) {
            number |= Number(byte.bitPattern) << shift
            shift += 8
        }
        return number
    }

    mutating func name() throws(Error) -> String {
        let start = offset
        let length = try index()
        guard let name = String(validating: try bytes(length).map(\.bitPattern), as: UTF8.self) else { throw .name(offset: start) }
        return name
    }

    mutating func vector<Element>(_ element: (inout Self) throws(Error) -> Element) throws(Error) -> [Element] {
        let count = try index()
        var elements: [Element] = []
        for _ in 0..<count { elements.append(try element(&self)) }
        return elements
    }

    mutating func value() throws(Error) -> W3C.WebAssembly.Value {
        let start = offset
        let byte = try byte()
        guard let value = W3C.WebAssembly.Value(rawValue: byte) else { throw .byte(byte, offset: start) }
        return value
    }

    mutating func flag() throws(Error) -> Bool {
        let start = offset
        let byte = try byte()
        guard byte < 2 else { throw .byte(byte, offset: start) }
        return byte == 1
    }

    mutating func limits() throws(Error) -> W3C.WebAssembly.Limits {
        let limited = try flag()
        return .init(minimum: try unsigned(), maximum: limited ? try unsigned() : nil)
    }

    mutating func table() throws(Error) -> W3C.WebAssembly.Table {
        .init(element: try value(), limits: try limits())
    }

    mutating func global() throws(Error) -> W3C.WebAssembly.Global.Kind {
        .init(value: try value(), mutable: try flag())
    }
}
