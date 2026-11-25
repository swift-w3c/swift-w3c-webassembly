# swift-w3c-webassembly

Use this package when you have a WebAssembly binary and need its contents as values: types, imports, functions with their instructions, globals, exports and data. Start from `W3C.WebAssembly.Module.parse(_:)`. It does not validate a module's typing, run it, or write it back.

## Laws

- The model is the WebAssembly Core Specification's structure: function indices count imported functions first, and instructions nest as blocks do in the text format.
- The reader covers the numeric, reference, table, memory and control instructions. A vector (SIMD) or proposal instruction throws `.opcode`, with the byte offset it stands at.
- Floating-point constants are kept as bit patterns, so a NaN keeps its payload.
- Every section's contents must fill the section exactly; a custom section's bytes are kept as they are.
- Offsets in errors count from the first byte of the module.
