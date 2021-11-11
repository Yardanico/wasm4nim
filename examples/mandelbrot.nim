import ../src/wasm4

# https://wasm4.org/docs/guides/basic-drawing#direct-framebuffer-access
proc pixel(x, y: int32, color: uint8 = 0) =
  ## Draws a pixel at the given coordinates. `color` represents
  ## one of the colors in the palette.
  # The byte index into the framebuffer that contains (x, y)
  let idx = (y * SCREEN_SIZE + x) shr 2

  # Calculate the bits within the byte that corresponds to our position
  let shift = (x and 0b11) shl 1
  let mask = uint8(0b11 shl shift)

  # Write to the framebuffer
  FRAMEBUFFER[idx] = uint8((color shl shift) or (FRAMEBUFFER[idx] and not mask))

import std/complex

# https://rosettacode.org/wiki/Mandelbrot_set#Nim
const
  W = 160
  H = 160
  MaxIter = 32

var
  zoom = 0.5
  moveX = -0.5
  moveY = 0.0

proc drawMandelbrot = 
  for x in 0..<W:
    for y in 0..<H:
      var i = MaxIter - 1
      let c = complex(float(2 * x - W) / (W * zoom) + moveX, float(2 * y - H) / (H * zoom) + moveY)
      var z = c
      while abs(z) < 2 and i > 0:
        z = z * z + c
        dec i
      
      # I don't know ho to do mandelbrot coloring properly with 4 colours
      let color = case i
      of 0..8: 0'u8
      of 9..16: 1
      of 17..24: 2
      of 25..32: 3
      else: 0
      pixel(int32(x), int32(y), color)

proc start {.exportWasm.} = 
  PALETTE[0] = 0x000000
  PALETTE[1] = 0xFFFF00
  PALETTE[2] = 0xFFFF66
  PALETTE[3] = 0x0000FF

const
  MoveSpeed = 0.02
  ZoomSpeed = 0.1

proc update {.exportWasm.} = 
  let gamepad = GAMEPAD1[]
  
  # Scale moving speed to the zoom
  if bool(gamepad and BUTTON_UP):
    moveY -= MoveSpeed / zoom
  if bool(gamepad and BUTTON_DOWN):
    moveY += MoveSpeed / zoom
  if bool(gamepad and BUTTON_LEFT):
    moveX -= MoveSpeed / zoom
  if bool(gamepad and BUTTON_RIGHT):
    moveX += MoveSpeed / zoom
  if bool(gamepad and BUTTON_1):
    zoom += ZoomSpeed
  if bool(gamepad and BUTTON_2):
    zoom -= ZoomSpeed

  drawMandelbrot()
