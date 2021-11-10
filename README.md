## A simple example of how to use wasm-4 with Nim

Since Nim compiles to C we can simple reuse the existing `wasm4.h` header and all the C compiler settings. 
This is especially useful for `WASM_IMPORT` and `WASM_EXPORT` as it's not easy to emit those with Nim itself.

Compile the example with:
```
nim c -d:danger -o:build/hello.wasm examples/hello.nim
```

If you have `wasm-opt` installed (comes with `binaryen`) you can reduce the binary size even further:
```
wasm-opt -Oz --zero-filled-memory --strip-producers build/hello.wasm -o build/hello.wasm
```

Run the cartridge:
```
w4 run build/hello.wasm
```

TODO:
- Make it so wasm-opt is called automatically
- Decide if we want to convert constants into Nim enums
