# This file is a part of NGfx. Copyright (C) 2024 carrexxii.
# It is distributed under the terms of the Apache License, Version 2.0.
# For a copy, see the LICENSE file or <https://apache.org/licenses/>.

import common, bitgen, renderer

type BGFXFatal* {.size: sizeof(cint).} = enum
    bfDebugCheck
    bfInvalidShader
    bfUnableToInitialize
    bfUnableToCreateTexture
    bfDeviceLost

type DebugFlag* = distinct uint32
DebugFlag.gen_bit_ops(
    dfWireFrame, dfIFH, dfStats, dfText,
    dfProfiler
)
const dfNone* = DebugFlag 0

type
    CallbackInterface* = object
        vtable*: ptr CallbackVTable

    CallbackVTable = object
        fatal*                 :  (ptr CallbackInterface, file_path: cstring, line: uint16, code: BGFXFatal, str: cstring) -> void
        trace_vargs*           : ((ptr CallbackInterface, file_path: cstring, line: uint16, fmt: cstring) {.varargs.} -> void)
        profiler_begin*        :  (ptr CallbackInterface, name: cstring, abgr: uint32, file_path: cstring, line: uint16) -> void
        profiler_begin_literal*:  (ptr CallbackInterface, name: cstring, abgr: uint32, file_paht: cstring, line: uint16) -> void
        profiler_end*          :   ptr CallbackInterface -> void
        cache_read_size*       :  (ptr CallbackInterface, id: uint64) -> uint32
        cache_read*            :  (ptr CallbackInterface, id: uint64, data: pointer, size: uint32) -> bool
        cache_write*           :  (ptr CallbackInterface, id: uint64, data: pointer, size: uint32) -> void
        screen_shot*           :  (ptr CallbackInterface, file_path: cstring, width: uint32, height: uint32, pitch: uint32, tex_fmt: pointer, size: uint32, flipy: bool) -> void
        capture_begin*         :  (ptr CallbackInterface, width: uint32, height: uint32, pitch: uint32, tex_fmt: cint, flipy: bool) -> void
        capture_end*           :   ptr CallbackInterface -> void
        capture_frame*         :  (ptr CallbackInterface, data: pointer, size: uint32) -> void

    EncoderStats* = object
        cpu_time_begin*: int64
        cpu_time_end*  : int64

    RendererStats* = object
        cpu_time_frame*             : int64
        cpu_time_begin*             : int64
        cpu_time_end*               : int64
        cpu_timer_freq*             : int64
        gpu_time_begin*             : int64
        gpu_time_end*               : int64
        gpu_timer_freq*             : int64
        wait_render*                : int64
        wait_submit*                : int64
        draw_count*                 : uint32
        compute_count*              : uint32
        blit_count*                 : uint32
        max_gpu_latency*            : uint32
        gpu_frame_num*              : uint32
        dynamic_index_buffer_count* : uint16
        dynamic_vertex_buffer_count*: uint16
        frame_buffer_count*         : uint16
        index_buffer_count*         : uint16
        occlusion_query_count*      : uint16
        program_count*              : uint16
        shader_count*               : uint16
        texture_count*              : uint16
        uniform_count*              : uint16
        vertex_buffer_count*        : uint16
        vertex_layout_count*        : uint16
        texture_memory_used*        : int64
        rt_memory_used*             : int64
        transient_vb_count_used*    : int32
        transient_ib_count_used*    : int32
        prim_counts*                : array[(int high Topology) + 1, uint32]
        gpu_memory_max*             : int64
        gpu_memory_used*            : int64
        width*                      : uint16
        height*                     : uint16
        text_width*                 : uint16
        text_height*                : uint16
        num_views*                  : uint16
        view_stats*                 : ptr ViewStats
        encoder_count*              : uint8
        encoder_stats*              : ptr EncoderStats

#[ -------------------------------------------------------------------- ]#

{.push dynlib: BGFXPath.}
proc set_debug*(debug: DebugFlag)                                      {.importc: "bgfx_set_debug"               .}
proc dbg_text_clear*(attr: uint8; small: bool)                         {.importc: "bgfx_dbg_text_clear"          .} # TODO: Colour attr = palette
proc dbg_text_printf*(x, y: uint16; attr: uint8; fmt: cstring)         {.importc: "bgfx_dbg_text_printf", varargs.}
proc dbg_text_image*(x, y, w, h: uint16; data: pointer; pitch: uint16) {.importc: "bgfx_dbg_text_image"          .}

proc get_caps*(): ptr RendererCapabilities {.importc: "bgfx_get_caps" .}
proc get_stats*(): ptr RendererStats       {.importc: "bgfx_get_stats".}
{.pop.}

{.push inline.}

proc clear*(attr = 0'u8; small = false) =
    dbg_text_clear attr, small

proc print*(x, y: int; msg: string; attr = 0x0F'u8) =
    dbg_text_printf uint16 x, uint16 y, attr, cstring msg

proc image*(x, y, w, h: int; data: pointer; pitch = 0) =
    dbg_text_image uint16 x, uint16 y, uint16 w, uint16 h, data, uint16 pitch

{.pop.}

