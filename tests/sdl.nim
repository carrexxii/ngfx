type
    EventKind* {.size: sizeof(cint).} = enum
        Quit = 0x100
        KeyDown = 0x300
        KeyUp

    KeyboardEvent* = object
    QuitEvent*     = object
    Event* {.union.} = object
        kind*: EventKind
        key* : KeyboardEvent
        quit*: QuitEvent
        padding: array[128, byte]

    X11Info* = object
        display*: pointer
        window* : pointer
    WM* {.union.} = object
        x11*: X11Info
        _: array[64, byte]
    WMInfo* = object
        version*  : uint32
        subsystem*: cint
        info*     : WM

# Init video and events
proc init*(flags = 0x0000_4020): cint                                 {.importc: "SDL_Init"           .}
proc quit*()                                                          {.importc: "SDL_Quit"           .}
proc get_version*(version: ptr uint32)                                {.importc: "SDL_GetVersion"     .}
proc create_window*(title: cstring; x, y, w, h, flags: cint): pointer {.importc: "SDL_CreateWindow"   .}
proc destroy_window*(window: pointer)                                 {.importc: "SDL_DestroyWindow"  .}
proc poll_event*(event: ptr Event): bool                              {.importc: "SDL_PollEvent"      .}
proc get_wm_info*(window, wm_info: pointer): bool                     {.importc: "SDL_GetWindowWMInfo".}

iterator get_events*(): Event =
    var event: Event
    while poll_event(addr event):
        yield event

proc create_window*(title: string; w, h: int; flags = 0): pointer =
    create_window(cstring title, 0, 0, cint w, cint h, cint flags)

func get_x11_nwh_and_ndt*(window: pointer): tuple[nwh, ndt: pointer] =
    var wm_info: WMInfo
    get_version wm_info.version.addr
    assert window.get_wm_info wm_info.addr
    result.nwh = wm_info.info.x11.window
    result.ndt = wm_info.info.x11.display
