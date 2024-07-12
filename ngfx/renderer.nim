import common, flags

type
    RendererKind* {.size: sizeof(cint).} = enum
        rkNoOp
        rkAGC
        rkDirect3D11
        rkDirect3D12
        rkGNM
        rkMetal
        rkNVN
        rkOpenGLES
        rkOpenGL
        rkVulkan
        rkAuto

    TextureFormat* {.size: sizeof(cint).} = enum
        tfBC1, tfBC2, tfBC3, tfBC4, tfBC5, tfBC6H, tfBC7,
        tfETC1, tfETC2, tfETC2A, tfETC2A1, tfPTC12,
        tfPTC14, tfPTC12A, tfPTC14A, tfPTC22, tfPTC24, tfATC,
        tfATCE, tfATCI,
        tfASTC4X4, tfASTC5X4, tfASTC5X5, tfASTC6X5, tfASTC6X6, tfASTC8X5, tfASTC8X6, tfASTC8X8, tfASTC10X5,
        tfASTC10X6, tfASTC10X8, tfASTC10X10, tfASTC12X10, tfASTC12X12,
        tfUnknown,
        tfR1, tfA8, tfR8, tfR8I, tfR8U, tfR8S, tfR16, tfR16I, tfR16U, tfR16F, tfR16S, tfR32I, tfR32U, tfR32F, tfRG8,
        tfRG8I, tfRG8U, tfRG8S, tfRG16, tfRG16I, tfRG16U, tfRG16F, tfRG16S, tfRG32I, tfRG32U, tfRG32F, tfRGB8,
        tfRGB8I, tfRGB8U, tfRGB8S, tfRGB9E5F, tfBGRA8, tfRGBA8, tfRGBA8I, tfRGBA8U, tfRGBA8S, tfRGBA16, tfRGBA16I,
        tfRGBA16U, tfRGBA16F, tfRGBA16S, tfRGBA32I, tfRGBA32U, tfRGBA32F, tfB5G6R5, tfR5G6B5, tfBGRA4, tfRGBA4, tfBGR5A1, tfRGB5A1, tfRGB10A2, tfRG11B10F,
        tfUnknownDepth,
        tfD16, tfD24, tfD24S8, tfD32, tfD16F, tfD24F, tfD32F, tfD0S8,

    BackbufferRatio* {.size: sizeof(cint).} = enum
        bbrEqual
        bbrHalf
        bbrQuarter
        bbrEighth
        bbrSixteenth
        bbrDouble

    OcclusionQueryResult* {.size: sizeof(cint).} = enum
        oqrInvisible
        oqrVisible
        oqrNoResult

    Topology* {.size: sizeof(cint).} = enum
        tTriList
        tTriStrip
        tLineList
        tLineStrip
        tPointList

    TopologyConvert* {.size: sizeof(cint).} = enum
        tcTriListFlipWinding
        tcTriStripFlipWinding
        tcTriListToLineList
        tcTriStripToTriList
        tcLienStripToLineList

    TopologySort* {.size: sizeof(cint).} = enum
        tsDirFrontToBackMin
        tsDirFrontToBackAvg
        tsDirFrontToBackMax
        tsDirBackToFrontMin
        tsDirBackToFrontAvg
        tsDirBackToFrontMax
        tsDistFrontToBackMin
        tsDistFrontToBackAvg
        tsDistFrontToBackMax
        tsDistBackToFrontMin
        tsDistBackToFrontAvg
        tsDistBackToFrontMax

    ViewMode* {.size: sizeof(cint).} = enum
        vmDefault
        vmSequential
        vmDepthAscending
        vmDepthDescending

    RenderFrame* {.size: sizeof(cint).} = enum
        rfNoContext
        rfRender
        rfTimeout
        rfExiting

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
        vendor_id*: PCIIDFlag
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
        vendor_id*         : PCIIDFlag
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

proc set_clear*(view; flags: ClearFlag = colour or depth; colour = 0'u32; depth = 1.0; stencil = 0'u8) =
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
