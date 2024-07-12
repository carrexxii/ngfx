from std/strformat import `&`
import sdl, ngfx, ngfx/debug

const
    WinW = 800
    WinH = 600

discard sdl.init()
let window = create_window("SDL + BGFX", WinW, WinH)

let (nwh, ndt) = get_x11_nwh_and_ndt window
init(nwh, ndt, WinW, WinH)

let view = ViewID 0
set_debug dfText
view.set_clear colour = 0x003535FF

var
    encoder  : Encoder
    frame_num: int
    running = true
while running:
    for event in get_events():
        case event.kind
        of Quit: running = false
        else: discard

    set_view_rect(ViewID 0, 0, 0, WinW, WinH)

    encoder.start
    encoder.touch ViewID 0
    encoder.stop

    debug.clear()
    debug.print(0, 1, "Hello, World!")
    debug.print(0, 2, &"Total memory usage: {get_total_mem()/1024:.2}kB")
    debug.print(0, 3, &"Frame: {frame_num}")

    frame_num = int frame false

# ngfx.shutdown()
destroy_window window
sdl.quit()

