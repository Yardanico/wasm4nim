## A simple example of how to use wasm-4 with Nim

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
