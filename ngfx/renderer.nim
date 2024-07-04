import common

type
    ## PCI Adapters
    VendorID* {.size: sizeof(uint16).} = enum
        None      = 0x0000_0000
        Software  = 0x0000_0001
        AMD       = 0x0000_1002
        Apple     = 0x0000_106b
        Nvidia    = 0x0000_10DE
        ARM       = 0x0000_13B5
        Microsoft = 0x0000_1414
        Intel     = 0x0000_8086

    RendererKind* {.size: sizeof(cint).} = enum
        NoOp
        AGC
        Direct3D11
        Direct3D12
        GNM
        Metal
        NVN
        OpenGLES
        OpenGL
        Vulkan
        Auto

    TextureFormat* {.size: sizeof(cint).} = enum
        BC1, BC2, BC3, BC4, BC5, BC6H, BC7,
        ETC1, ETC2, ETC2A, ETC2A1, PTC12,
        PTC14, PTC12A, PTC14A, PTC22, PTC24, ATC,
        ATCE, ATCI,
        ASTC4X4, ASTC5X4, ASTC5X5, ASTC6X5, ASTC6X6, ASTC8X5, ASTC8X6, ASTC8X8, ASTC10X5,
        ASTC10X6, ASTC10X8, ASTC10X10, ASTC12X10, ASTC12X12,
        Unknown,
        R1, A8, R8, R8I, R8U, R8S, R16, R16I, R16U, R16F, R16S, R32I, R32U, R32F, RG8,
        RG8I, RG8U, RG8S, RG16, RG16I, RG16U, RG16F, RG16S, RG32I, RG32U, RG32F, RGB8,
        RGB8I, RGB8U, RGB8S, RGB9E5F, BGRA8, RGBA8, RGBA8I, RGBA8U, RGBA8S, RGBA16, RGBA16I,
        RGBA16U, RGBA16F, RGBA16S, RGBA32I, RGBA32U, RGBA32F, B5G6R5, R5G6B5, BGRA4, RGBA4, BGR5A1, RGB5A1, RGB10A2, RG11B10F,
        UnknownDepth,
        D16, D24, D24S8, D32, D16F, D24F, D32F, D0S8,

    BackbufferRatio* {.size: sizeof(cint).} = enum
        Equal
        Half
        Quarter
        Eighth
        Sixteenth
        Double

    OcclusionQueryResult* {.size: sizeof(cint).} = enum
        Invisible
        Visible
        NoResult

    Topology* {.size: sizeof(cint).} = enum
        TriList
        TriStrip
        LineList
        LineStrip
        PointList

    TopologyConvert* {.size: sizeof(cint).} = enum
        TriListFlipWinding
        TriStripFlipWinding
        TriListToLineList
        TriStripToTriList
        LienStripToLineList

    TopologySort* {.size: sizeof(cint).} = enum
        DirFrontToBackMin
        DirFrontToBackAvg
        DirFrontToBackMax
        DirBackToFrontMin
        DirBackToFrontAvg
        DirBackToFrontMax
        DistFrontToBackMin
        DistFrontToBackAvg
        DistFrontToBackMax
        DistBackToFrontMin
        DistBackToFrontAvg
        DistBackToFrontMax

    ViewMode* {.size: sizeof(cint).} = enum
        Default
        Sequential
        DepthAscending
        DepthDescending

    RenderFrame* {.size: sizeof(cint).} = enum
        NoContext
        Render
        Timeout
        Exiting

type
    ViewID* = distinct uint16

    ViewStats* = object
        name*          : array[256, char]
        view*          : ViewID
        cpu_time_begin*: int64
        cpu_time_end*  : int64
        gpu_time_begin*: int64
        gpu_time_end*  : int64
        gpu_frame_num* : int64

    GPUInfo* = object
        vendor_id*: VendorID
        device_id*: uint16

    GPULimits* = object
        maxDrawCalls*           : uint32
        maxBlits*               : uint32
        maxTextureSize*         : uint32
        maxTextureLayers*       : uint32
        maxViews*               : uint32
        maxFrameBuffers*        : uint32
        maxFBAttachments*       : uint32
        maxPrograms*            : uint32
        maxShaders*             : uint32
        maxTextures*            : uint32
        maxTextureSamplers*     : uint32
        maxComputeBindings*     : uint32
        maxVertexLayouts*       : uint32
        maxVertexStreams*       : uint32
        maxIndexBuffers*        : uint32
        maxVertexBuffers*       : uint32
        maxDynamicIndexBuffers* : uint32
        maxDynamicVertexBuffers*: uint32
        maxUniforms*            : uint32
        maxOcclusionQueries*    : uint32
        maxEncoders*            : uint32
        minResourceCbSize*      : uint32
        transientVbSize*        : uint32
        transientIbSize*        : uint32

    RendererCapabilities* = object
        kind*              : RendererKind
        supported*         : uint64
        vendor_id*         : VendorID
        device_id*         : uint16
        homogeneous_depth* : bool
        origin_bottom_left*: bool
        gpuc*              : byte
        gpus*              : array[4, GPUInfo]
        limits*            : GPULimits
        formats*           : array[(int high TextureFormat) + 1, TextureFormat]

#[ -------------------------------------------------------------------- ]#

using
    view        : ViewID
    ren_kind_arr: ptr RendererKind

{.push dynlib: BGFXPath.}
proc get_supported_renderers*(count: uint8; ren_kind_arr): uint8 {.importc: "bgfx_get_supported_renderers".}
proc get_renderer_kind*(): RendererKind                          {.importc: "bgfx_get_renderer_type"      .}
proc get_renderer_name*(kind: RendererKind): cstring             {.importc: "bgfx_get_renderer_name"      .}

proc reset*(w, h: uint32; flags: ResetFlag; format: TextureFormat) {.importc: "bgfx_reset".}
proc frame*(capture: bool = false): uint32                         {.importc: "bgfx_frame".}

proc set_view_clear*(view; flags: ClearFlag; colour: uint32; depth: cfloat; stencil: uint8) {.importc: "bgfx_set_view_clear"    .}
proc set_view_rect*(view; x, y, w, h: uint16)                                               {.importc: "bgfx_set_view_rect"     .}
proc set_view_transform*(view; view_mat, proj_mat: pointer)                                 {.importc: "bgfx_set_view_transform".}
{.pop.}

{.push inline.}

proc get_supported_renderers*(): seq[RendererKind] =
    let ren_count = get_supported_renderers(0, nil)
    result = new_seq_of_cap[RendererKind] ren_count
    discard get_supported_renderers(ren_count, result[0].addr)

proc set_clear*(view; flags: ClearFlag = Colour or Depth; colour = 0'u32; depth = 1.0; stencil = 0'u8) =
    set_view_clear(view, flags, colour, cfloat depth, uint8 stencil)

{.pop.}

# TODO
    # void bgfx_set_view_name(bgfx_view_id_t _id, const char* _name, int32_t _len);
    # void bgfx_set_view_rect_ratio(bgfx_view_id_t _id, uint16_t _x, uint16_t _y, bgfx_backbuffer_ratio_t _ratio);
    # void bgfx_set_view_scissor(bgfx_view_id_t _id, uint16_t _x, uint16_t _y, uint16_t _width, uint16_t _height);
    # void bgfx_set_view_clear_mrt(bgfx_view_id_t _id, uint16_t _flags, float _depth, uint8_t _stencil, uint8_t _c0, uint8_t _c1, uint8_t _c2, uint8_t _c3, uint8_t _c4, uint8_t _c5, uint8_t _c6, uint8_t _c7);
    # void bgfx_set_view_mode(bgfx_view_id_t _id, bgfx_view_mode_t _mode);
    # void bgfx_set_view_frame_buffer(bgfx_view_id_t _id, bgfx_frame_buffer_handle_t _handle);
    # void bgfx_set_view_order(bgfx_view_id_t _id, uint16_t _num, const bgfx_view_id_t* _order);
    # void bgfx_reset_view(bgfx_view_id_t _id);

    # void bgfx_request_screen_shot(bgfx_frame_buffer_handle_t _handle, const char* _filePath);

    # bgfx_render_frame_t bgfx_render_frame(int32_t _msecs);

    # void bgfx_touch(bgfx_view_id_t _id);
    # void bgfx_submit(bgfx_view_id_t _id, bgfx_program_handle_t _program, uint32_t _depth, uint8_t _flags);
    # void bgfx_submit_occlusion_query(bgfx_view_id_t _id, bgfx_program_handle_t _program, bgfx_occlusion_query_handle_t _occlusionQuery, uint32_t _depth, uint8_t _flags);
    # void bgfx_submit_indirect(bgfx_view_id_t _id, bgfx_program_handle_t _program, bgfx_indirect_buffer_handle_t _indirectHandle, uint32_t _start, uint32_t _num, uint32_t _depth, uint8_t _flags);
    # void bgfx_submit_indirect_count(bgfx_view_id_t _id, bgfx_program_handle_t _program, bgfx_indirect_buffer_handle_t _indirectHandle, uint32_t _start, bgfx_index_buffer_handle_t _numHandle, uint32_t _numIndex, uint32_t _numMax, uint32_t _depth, uint8_t _flags);

    # void bgfx_dispatch(bgfx_view_id_t _id, bgfx_program_handle_t _program, uint32_t _numX, uint32_t _numY, uint32_t _numZ, uint8_t _flags);
    # void bgfx_dispatch_indirect(bgfx_view_id_t _id, bgfx_program_handle_t _program, bgfx_indirect_buffer_handle_t _indirectHandle, uint32_t _start, uint32_t _num, uint8_t _flags);
    # void bgfx_discard(uint8_t _flags);
    # void bgfx_blit(bgfx_view_id_t _id, bgfx_texture_handle_t _dst, uint8_t _dstMip, uint16_t _dstX, uint16_t _dstY, uint16_t _dstZ, bgfx_texture_handle_t _src, uint8_t _srcMip, uint16_t _srcX, uint16_t _srcY, uint16_t _srcZ, uint16_t _width, uint16_t _height, uint16_t _depth);
