## A simple example of how to use wasm-4 with Nim

Compile the `hello.nim` with:
```
nim c -d:danger -o:build/cart.wasm examples/hello.nim
```

If you have `wasm-opt` installed (comes with `binaryen`) you can reduce the binary size even further:
```
wasm-opt -Oz --zero-filled-memory --strip-producers build/cart.wasm -o build/cart.wasm
```

Run the cartridge:
```
w4 run build/cart.wasm
```

Check the `examples` folder for more examples!

Some limitations or caveats (might be eventually fixed):
- You can only compile with `-d:danger`. This is needed because without `-d:danger`, different checks are enabled, and, in turn, stack traces, which makes the WASI compiler import a lot of `wasi_snapshot_preview1` functions which are not available for WASM-4.
- If you use anything that allocates memory (e.g. Nim strings, sequences, etc), WASI SDK will automatically add `dlmalloc` to your WASM module.
It takes around 9KB total (while WASM-4 binary size limit is 64KB), so keep that in mind.

TODO:
- Make it so wasm-opt is called automatically (create a Nimble package?)
- Decide if we want to convert constants into Nim enums
- Write more examples (or maybe actual games :P)
