import std/os

let wasi = getEnv("WASI_SDK_PATH")
if wasi == "":
  quit("Please set the WASI_SDK_PATH environment variable!")

switch("cpu", "wasm32")
switch("cc", "clang")

# ARC is much more embedded-friendly
switch("gc", "arc")
# Treats defects as errors, results in smaller binary size 
switch("panics", "on")

# Use the common ANSI C target
switch("os", "any")
# Needed for os:any
switch("define", "posix")

# WASM has no signal handlers
switch("define", "noSignalHandler")
# The only entrypoints are start and update
switch("noMain")
# Use malloc instead of Nim's memory allocator, makes binary size much smaller
switch("define", "useMalloc")

switch("clang.exe", wasi / "bin" / "clang")
switch("clang.linkerexe", wasi / "bin" / "clang")

switch("passC", "--sysroot=" & (wasi / "share" / "wasi-sysroot"))

switch("passC", "-MMD -MP")
switch("passL", "-Wl,-zstack-size=1024,--no-entry,--import-memory -mexec-model=reactor -Wl,--initial-memory=65536,--max-memory=65536,--global-base=6560")

when not defined(release):
  switch("debugger", "native")
  switch("passL", "-Wl,--export-all,--no-gc-sections")
else:
  switch("opt", "size")
  switch("passC", "-flto")
  switch("passL", "-Wl,--strip-all,--gc-sections,--lto-O3")
