import Testing
import W3C_WebAssembly

enum `W3C.WebAssembly Tests` {}

extension `W3C.WebAssembly Tests` {
    @Suite
    struct Module {
        static func module(_ sections: [UInt8]...) -> [Byte] {
            ([0x00, 0x61, 0x73, 0x6D, 0x01, 0x00, 0x00, 0x00] + sections.flatMap { $0 }).map(Byte.init(bitPattern:))
        }

        static let types: [UInt8] = [1, 7, 1, 0x60, 2, 0x7F, 0x7F, 1, 0x7F]
        static let function: [UInt8] = [3, 2, 1, 0]

        @Test
        func `A function that adds its parameters is read with its type, export and body`() throws {
            let export: [UInt8] = [7, 7, 1, 3, 0x61, 0x64, 0x64, 0, 0]
            let code: [UInt8] = [10, 9, 1, 7, 0, 0x20, 0, 0x20, 1, 0x6A, 0x0B]
            let module = try W3C.WebAssembly.Module.parse(Self.module(Self.types, Self.function, export, code))
            #expect(module.signature(of: 0) == .init(parameters: [.i32, .i32], results: [.i32]))
            #expect(module.exports == [.init(name: "add", kind: .function, index: 0)])
            #expect(module.functions[0].body == [.localGet(0), .localGet(1), .numeric(.i32Add)])
        }

        @Test
        func `Blocks nest, and an else is its own run`() throws {
            let code: [UInt8] = [10, 15, 1, 13, 0, 0x20, 0, 0x04, 0x7F, 0x41, 0x7F, 0x05, 0x20, 1, 0x0B, 0x0B]
            var bytes = code
            bytes[1] = UInt8(code.count - 2)
            bytes[3] = UInt8(code.count - 4)
            let module = try W3C.WebAssembly.Module.parse(Self.module(Self.types, Self.function, bytes))
            #expect(module.functions[0].body == [.localGet(0), .if(.result(.i32), then: [.i32(-1)], else: [.localGet(1)])])
        }

        @Test
        func `What is not a module says why and where`() {
            #expect(throws: W3C.WebAssembly.Error.header) { try W3C.WebAssembly.Module.parse([]) }
            #expect(throws: W3C.WebAssembly.Error.byte(13, offset: 8)) { try W3C.WebAssembly.Module.parse(Self.module([13, 0])) }
            #expect(throws: W3C.WebAssembly.Error.functions(declared: 1, defined: 0)) {
                try W3C.WebAssembly.Module.parse(Self.module(Self.types, Self.function))
            }
            #expect(throws: W3C.WebAssembly.Error.opcode(0xFD, offset: 26)) {
                try W3C.WebAssembly.Module.parse(Self.module(Self.types, Self.function, [10, 5, 1, 3, 0, 0xFD, 0x0B]))
            }
        }
    }
}
