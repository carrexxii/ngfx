import ngfx/[common, debug]

func is_valid*(handle: uint16): bool =
    handle != high uint16

import ngfx/[flags, memory, shaders, encoder, renderer]
export flags, memory, shaders, encoder, renderer

#[ -------------------------------------------------------------------- ]#

type NativeWindowHandleKind* {.size: sizeof(cint).} = enum
    Default
    Wayland

type
    Resolution* = object
        format*           : TextureFormat
        width*            : uint32
        height*           : uint32
        reset*            : ResetFlag
        num_back_buffers* : uint8
        max_frame_latency*: uint8
        debug_text_scale* : uint8

    PlatformData* = object
        ndt*           : pointer
        nwh*           : pointer
        context*       : pointer
        back_buffer*   : pointer
        back_buffer_ds*: pointer
        kind*          : NativeWindowHandleKind

    InternalData* = object
        capabilities*: ptr RendererCapabilities
        context*     : pointer

    InitLimits* = object
        max_encoders*        : uint16
        min_resource_cb_size*: uint32
        transient_vb_size*   : uint32
        transient_ib_size*   : uint32

    Init* = object
        kind*         : RendererKind
        vendor_id*    : PCIIDFlag
        device_id*    : uint16
        capabilities* : uint64
        debug*        : bool
        profile*      : bool
        platform_data*: PlatformData
        resolution*   : Resolution
        limits*       : InitLimits
        callback*     : ptr CallbackInterface
        allocator*    : ptr AllocatorInterface

#[ -------------------------------------------------------------------- ]#

{.push dynlib: BGFXPath.}
proc get_internal_data*(): ptr InternalData     {.importc: "bgfx_get_internal_data".}
proc set_platform_data*(data: ptr PlatformData) {.importc: "bgfx_set_platform_data".}

proc init_ctor*(ci: ptr Init)  {.importc: "bgfx_init_ctor".}
proc init*(ci: ptr Init): bool {.importc: "bgfx_init"     .}
proc shutdown*()               {.importc: "bgfx_shutdown" .} # This causes a crash. It seems to be related to a debugging refcount problem,
                                                             # but the solution is in a cpp function...
{.pop.}

{.push inline.}

proc create_init*(): Init =
    init_ctor result.addr

proc init*(ci: Init): bool =
    init ci.addr

proc reset*(w, h: int; flags: ResetFlag = vSync; fmt: TextureFormat = tfRGBA8) =
    reset uint32 w, uint32 h, flags, fmt

{.pop.}

proc init*(nwh, ndt: pointer; w, h: int;
           renderer   : RendererKind = rkAuto;
           vendor_id  : PCIIDFlag    = none;
           reset_flags: ResetFlag    = vSync) =
    var ci: Init
    init_ctor ci.addr
    ci.platform_data.nwh  = nwh
    ci.platform_data.ndt  = ndt
    ci.platform_data.kind = Default
    if not init(addr ci):
        echo red "Error: failed to initialize BGFX"

    reset(w, h, reset_flags)

    echo &"Initialized BGFX ({ci.resolution.width}x{ci.resolution.height}):"
    echo &"\tRenderer  -> {get_renderer_kind()}"
    echo &"\tVendor ID -> {ci.vendor_id}"
    echo &"\tDevice ID -> {ci.device_id}"

