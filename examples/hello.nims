import std/os


let wasi = getEnv("WASI_SDK_PATH")
if wasi == "":
  quit("Please set the WASI_SDK_PATH environment variable!")

switch("cpu", "wasm32")
switch("cc", "clang")

switch("gc", "arc") # arc is much more embedded-friendly
switch("panics", "on") # defects are errors, smaller binary size

switch("os", "any") # common ANSI C target
switch("define", "posix") # needed for Nim

switch("define", "noSignalHandler") # wasm has no signal handlers
switch("define", "useMalloc") # use malloc instead of nim's memory allocator

switch("clang.exe", wasi / "bin" / "clang")
switch("clang.linkerexe", wasi / "bin" / "clang")

switch("passC", "--sysroot=" & (wasi / "share" / "wasi-sysroot"))

switch("passC", "-W -Wall -Wextra -Werror -Wno-unused -MMD -MP -fno-exceptions")
switch("passL", "-Wl,-zstack-size=1024,--no-entry,--import-memory -mexec-model=reactor -Wl,--initial-memory=65536,--max-memory=65536,--global-base=6560")

when not defined(release):
  switch("passC", "-DDEBUG")
  switch("debugger", "native")
  switch("passL", "-Wl,--export-all,--no-gc-sections")
else:
  switch("opt", "size")
  switch("passC", "-DNDEBUG -flto")
  switch("passL", "-Wl,--strip-all,--gc-sections,--lto-O3")
