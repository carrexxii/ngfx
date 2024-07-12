import common, memory, renderer

type
    AttribKind* {.size: sizeof(cint).} = enum
        UInt8
        UInt10
        Int16
        Half
        Float

    Attrib* {.size: sizeof(cint).} = enum
        Position
        Normal
        Tangent, BiTangent
        Colour0, Colour1, Colour2, Colour3
        Indices, Weight
        TexCoord0, TexCoord1, TexCoord2, TexCoord3, TexCoord4, TexCoord5, TexCoord6, TexCoord7

type
    Shader*       = distinct uint16
    Program*      = distinct uint16
    ShaderStage*  = distinct uint8
    MIPLevel*     = distinct uint8
    VertexStream* = distinct uint8

    VertexLayoutHandle* = distinct uint16
    VertexLayout* = object
        hash*   : uint32
        stride* : uint16
        offsets*: array[(int high Attrib) + 1, uint16]
        attribs*: array[(int high Attrib) + 1, uint16]

    VBO*  = distinct uint16
    DVBO* = distinct uint16
    TVBO* = object
        data*        : ptr UncheckedArray[uint8]
        size*        : uint32
        start_vertex*: uint32
        stride*      : uint16
        vbo*         : VBO
        layout*      : VertexLayoutHandle

    IBO*  = distinct uint16
    DIBO* = distinct uint16
    TIBO* = object
        data*     : ptr UncheckedArray[uint8]
        size*     : uint32
        start_idx*: uint32
        ibo*      : IBO
        is_16bit* : bool

    FBO*            = distinct uint16
    IndirectBuffer* = distinct uint16
    OcclusionQuery* = distinct uint16
    Uniform*        = distinct uint16
    Texture*        = distinct uint16
    ScissorCache*   = distinct uint16
    MatrixCache*    = distinct uint32

    Instance* = object
        data*  : ptr UncheckedArray[uint8]
        size*  : uint32
        offset*: uint32
        count* : uint32
        stride*: uint16
        vbo*   : VBO

    Transform* = object
        data* : ptr UncheckedArray[array[16, float32]]
        count*: uint16

    TextureInfo* = object
        format*      : TextureFormat
        storage_size*: uint32
        w*, h*       : uint16
        depth*       : uint16
        layer_count* : uint16
        mip_count*   : uint8
        bpp*         : uint8
        is_cube_map* : bool

    UniformKind* = enum
        Sampler
        _
        Vec4
        Mat3
        Mat4

    UniformInfo* = object
        name* : array[256, char]
        kind* : UniformKind
        count*: uint16

    Access* = enum
        Read
        Write
        ReadWrite

    Attachment* = object
        access*     : Access
        texture*    : Texture
        mip*        : uint16
        layer*      : uint16
        layer_count*: uint16
        resolve*    : ResolveFlag

#[ -------------------------------------------------------------------- ]#

from renderer import ViewID

using
    mem        : Memory
    vlay_handle: VertexLayoutHandle
    vlayptr    : ptr VertexLayout
    vert_stream: VertexStream
    vbo        : VBO
    ibo        : IBO
    texture    : Texture
    attr       : Attrib
    view       : ViewID

    uniform    : Uniform
    uniform_arr: ptr Uniform

    attr_kind    : AttribKind
    attr_kind_arr: ptr AttribKind

    u8_count    : uint8
    u8_count_arr: ptr uint8

    as_int    : bool
    as_int_arr: ptr bool

    normalized    : bool
    normalized_arr: ptr bool

{.push dynlib: BGFXPath.}
proc create_shader*(memory: Memory): Shader                                 {.importc: "bgfx_create_shader"      .}
proc destroy_shader*(shader: Shader)                                        {.importc: "bgfx_destroy_shader"     .}
proc get_shader_uniforms*(shader: Shader; uniform_arr; max: uint16): uint16 {.importc: "bgfx_get_shader_uniforms".}
proc set_shader_name*(shader: Shader; name: cstring; len: int32)            {.importc: "bgfx_get_shader_name"    .}

proc create_program*(vs, fs: Shader; destroy_shaders = true): Program     {.importc: "bgfx_create_program"        .}
proc create_compute_program*(cs: Shader; destroy_shaders = true): Program {.importc: "bgfx_create_compute_program".}
proc destroy_program*(program: Program)                                   {.importc: "bgfx_destroy_program"       .}

proc create_vertex_layout*(vlayptr): VertexLayoutHandle                                            {.importc: "bgfx_create_vertex_layout"            .}
proc destroy_vertex_layout*(handle: VertexLayoutHandle)                                            {.importc: "bgfx_destroy_vertex_layout"           .}
proc vertex_layout_begin*(vlayptr; renderer: RendererKind): ptr VertexLayout                       {.importc: "bgfx_vertex_layout_begin", discardable.}
proc vertex_layout_add*(vlayptr; attr; u8_count; attr_kind; normalized; as_int): ptr VertexLayout  {.importc: "bgfx_vertex_layout_add"  , discardable.}
proc vertex_layout_end*(vlayptr)                                                                   {.importc: "bgfx_vertex_layout_end"  , discardable.}
proc vertex_layout_decode*(vlayptr; attr; u8_count_arr; attr_kind_arr; normalized_arr; as_int_arr) {.importc: "bgfx_vertex_layout_decode"            .}
proc vertex_layout_has*(vlayptr; attr): bool                                                       {.importc: "bgfx_vertex_layout_has"               .}
proc vertex_layout_skip*(vlayptr; u8_count): ptr VertexLayout                                      {.importc: "bgfx_vertex_layout_skip"              .}

proc create_vertex_buffer*(mem; vlayptr; flags: BufferFlag): VBO                                {.importc: "bgfx_create_vertex_buffer"  .}
proc destroy_vertex_buffer*(vbo)                                                                {.importc: "bgfx_destroy_vertex_buffer" .}
proc set_vertex_buffer*(vert_stream; vbo; start_vertex, num_vertices: uint32)                   {.importc: "bgfx_set_vertex_buffer"     .}
proc set_vertex_with_layout*(vert_stream; vbo; start_vertex, num_vertices: uint32; vlay_handle) {.importc: "bgfx_set_vertex_with_layout".}
proc set_vertex_count*(num_vertices: uint32)                                                    {.importc: "bgfx_set_vertex_count"      .}

proc create_index_buffer*(mem; flags: BufferFlag): IBO      {.importc: "bgfx_create_index_buffer" .}
proc destroy_index_buffer*(ibo)                             {.importc: "bgfx_destroy_index_buffer".}
proc set_index_buffer*(ibo; first_idx, num_indices: uint32) {.importc: "bgfx_set_index_buffer"    .}

proc create_uniform*(name: cstring; kind: UniformKind; count: uint16 = 1): Uniform {.importc: "bgfx_create_uniform"  .}
proc destroy_uniform*(uniform)                                                     {.importc: "bgfx_destroy_uniform" .}
proc get_uniform_info*(uniform; info: ptr UniformInfo)                             {.importc: "bgfx_get_uniform_info".}
proc set_uniform*(uniform; val: pointer; num: uint16)                              {.importc: "bgfx_set_uniform"     .}

proc set_texture*(stage: ShaderStage; sampler: Uniform; handle: Texture; flags: SamplerFlag) {.importc: "bgfx_set_texture".}

proc set_transform*(mat: pointer; count: uint16 = 1): uint32 {.importc: "bgfx_set_transform".}

proc attachment_init*(attach: ptr Attachment; texture; access: Access; layer, layer_count, mip, resolve: uint16) {.importc: "bgfx_attachment_init".}
{.pop.}

{.push inline.}

proc create_program*(vs_path, fs_path: string): Program =
    try:
        let
            vs_data = read_file vs_path
            fs_data = read_file fs_path
            vs_mem  = copy(cast[pointer](vs_data[0].addr), uint32 vs_data.len)
            fs_mem  = copy(cast[pointer](fs_data[0].addr), uint32 fs_data.len)
            vs      = create_shader vs_mem
            fs      = create_shader fs_mem
        result = create_program(vs, fs, true)
    except IOError:
        echo red &"Failed to open files for shader program '{vs_path} / {fs_path}'"
        return

    echo green &"Created shader program for '{vs_path} / {fs_path}'"

#~~~ Buffers ~~~#

# VBO Layouts
proc create_vertex_layout*(attrs: varargs[tuple[attr: Attrib; count: int; kind: AttribKind]]): VertexLayout =
    vertex_layout_begin result.addr, get_renderer_kind()
    for (attr, count, kind) in attrs:
        vertex_layout_add result.addr, attr, uint8 count, kind, true, false
    vertex_layout_end result.addr

# VBOs
proc create_vbo*(mem; layout: VertexLayout; flags: BufferFlag = none): VBO =
    create_vertex_buffer mem, layout.addr, flags

proc set_vbo*(vert_stream; vbo; start_vertex, num_vertices: Natural) =
    set_vertex_buffer vert_stream, vbo, uint32 start_vertex, uint32 num_vertices

# IBOs
proc create_ibo*(mem; flags: BufferFlag = index32): IBO =
    create_index_buffer mem, flags

proc set_ibo*(ibo; first_idx, idx_count: Natural) =
    set_index_buffer ibo, uint32 first_idx, uint32 idx_count

# Uniforms
proc create_uniform*(name: string; kind: UniformKind; count = 1): Uniform =
    create_uniform cstring name, kind, uint16 count

proc set_uniform*(uniform; val: pointer) =
    set_uniform uniform, val, high uint16

# Textures

# Transforms

{.pop.}

# TODO
    # bgfx_index_buffer_handle_t bgfx_create_index_buffer(const bgfx_memory_t* _mem, uint16_t _flags);
    # void bgfx_set_index_buffer_name(bgfx_index_buffer_handle_t _handle, const char* _name, int32_t _len);
    # void bgfx_destroy_index_buffer(bgfx_index_buffer_handle_t _handle);
    # bgfx_vertex_layout_handle_t bgfx_create_vertex_layout(const bgfx_vertex_layout_t * _layout);
    # void bgfx_destroy_vertex_layout(bgfx_vertex_layout_handle_t _layoutHandle);
    # bgfx_vertex_buffer_handle_t bgfx_create_vertex_buffer(const bgfx_memory_t* _mem, const bgfx_vertex_layout_t * _layout, uint16_t _flags);
    # void bgfx_set_vertex_buffer_name(bgfx_vertex_buffer_handle_t _handle, const char* _name, int32_t _len);
    # void bgfx_destroy_vertex_buffer(bgfx_vertex_buffer_handle_t _handle);
    # bgfx_dynamic_index_buffer_handle_t bgfx_create_dynamic_index_buffer(uint32_t _num, uint16_t _flags);
    # bgfx_dynamic_index_buffer_handle_t bgfx_create_dynamic_index_buffer_mem(const bgfx_memory_t* _mem, uint16_t _flags);
    # void bgfx_update_dynamic_index_buffer(bgfx_dynamic_index_buffer_handle_t _handle, uint32_t _startIndex, const bgfx_memory_t* _mem);
    # void bgfx_destroy_dynamic_index_buffer(bgfx_dynamic_index_buffer_handle_t _handle);
    # bgfx_dynamic_vertex_buffer_handle_t bgfx_create_dynamic_vertex_buffer(uint32_t _num, const bgfx_vertex_layout_t* _layout, uint16_t _flags);
    # bgfx_dynamic_vertex_buffer_handle_t bgfx_create_dynamic_vertex_buffer_mem(const bgfx_memory_t* _mem, const bgfx_vertex_layout_t* _layout, uint16_t _flags);
    # void bgfx_update_dynamic_vertex_buffer(bgfx_dynamic_vertex_buffer_handle_t _handle, uint32_t _startVertex, const bgfx_memory_t* _mem);
    # void bgfx_destroy_dynamic_vertex_buffer(bgfx_dynamic_vertex_buffer_handle_t _handle);
    # uint32_t bgfx_get_avail_transient_index_buffer(uint32_t _num, bool _index32);
    # uint32_t bgfx_get_avail_transient_vertex_buffer(uint32_t _num, const bgfx_vertex_layout_t * _layout);
    # uint32_t bgfx_get_avail_instance_data_buffer(uint32_t _num, uint16_t _stride);
    # void bgfx_alloc_transient_index_buffer(bgfx_transient_index_buffer_t* _tib, uint32_t _num, bool _index32);
    # void bgfx_alloc_transient_vertex_buffer(bgfx_transient_vertex_buffer_t* _tvb, uint32_t _num, const bgfx_vertex_layout_t * _layout);
    # bool bgfx_alloc_transient_buffers(bgfx_transient_vertex_buffer_t* _tvb, const bgfx_vertex_layout_t * _layout, uint32_t _numVertices, bgfx_transient_index_buffer_t* _tib, uint32_t _numIndices, bool _index32);
    # void bgfx_alloc_instance_data_buffer(bgfx_instance_data_buffer_t* _idb, uint32_t _num, uint16_t _stride);
    # bgfx_indirect_buffer_handle_t bgfx_create_indirect_buffer(uint32_t _num);
    # void bgfx_destroy_indirect_buffer(bgfx_indirect_buffer_handle_t _handle);

    # bool bgfx_is_texture_valid(uint16_t _depth, bool _cubeMap, uint16_t _numLayers, bgfx_texture_format_t _format, uint64_t _flags);
    # bool bgfx_is_frame_buffer_valid(uint8_t _num, const bgfx_attachment_t* _attachment);
    # void bgfx_calc_texture_size(bgfx_texture_info_t * _info, uint16_t _width, uint16_t _height, uint16_t _depth, bool _cubeMap, bool _hasMips, uint16_t _numLayers, bgfx_texture_format_t _format);
    # bgfx_texture_handle_t bgfx_create_texture(const bgfx_memory_t* _mem, uint64_t _flags, uint8_t _skip, bgfx_texture_info_t* _info);
    # bgfx_texture_handle_t bgfx_create_texture_2d(uint16_t _width, uint16_t _height, bool _hasMips, uint16_t _numLayers, bgfx_texture_format_t _format, uint64_t _flags, const bgfx_memory_t* _mem);
    # bgfx_texture_handle_t bgfx_create_texture_2d_scaled(bgfx_backbuffer_ratio_t _ratio, bool _hasMips, uint16_t _numLayers, bgfx_texture_format_t _format, uint64_t _flags);
    # bgfx_texture_handle_t bgfx_create_texture_3d(uint16_t _width, uint16_t _height, uint16_t _depth, bool _hasMips, bgfx_texture_format_t _format, uint64_t _flags, const bgfx_memory_t* _mem);
    # bgfx_texture_handle_t bgfx_create_texture_cube(uint16_t _size, bool _hasMips, uint16_t _numLayers, bgfx_texture_format_t _format, uint64_t _flags, const bgfx_memory_t* _mem);
    # void bgfx_update_texture_2d(bgfx_texture_handle_t _handle, uint16_t _layer, uint8_t _mip, uint16_t _x, uint16_t _y, uint16_t _width, uint16_t _height, const bgfx_memory_t* _mem, uint16_t _pitch);
    # void bgfx_update_texture_3d(bgfx_texture_handle_t _handle, uint8_t _mip, uint16_t _x, uint16_t _y, uint16_t _z, uint16_t _width, uint16_t _height, uint16_t _depth, const bgfx_memory_t* _mem);
    # void bgfx_update_texture_cube(bgfx_texture_handle_t _handle, uint16_t _layer, uint8_t _side, uint8_t _mip, uint16_t _x, uint16_t _y, uint16_t _width, uint16_t _height, const bgfx_memory_t* _mem, uint16_t _pitch);
    # uint32_t bgfx_read_texture(bgfx_texture_handle_t _handle, void* _data, uint8_t _mip);
    # void bgfx_set_texture_name(bgfx_texture_handle_t _handle, const char* _name, int32_t _len);
    # void* bgfx_get_direct_access_ptr(bgfx_texture_handle_t _handle);
    # void bgfx_destroy_texture(bgfx_texture_handle_t _handle);

    # bgfx_frame_buffer_handle_t bgfx_create_frame_buffer(uint16_t _width, uint16_t _height, bgfx_texture_format_t _format, uint64_t _textureFlags);
    # bgfx_frame_buffer_handle_t bgfx_create_frame_buffer_scaled(bgfx_backbuffer_ratio_t _ratio, bgfx_texture_format_t _format, uint64_t _textureFlags);
    # bgfx_frame_buffer_handle_t bgfx_create_frame_buffer_from_handles(uint8_t _num, const bgfx_texture_handle_t* _handles, bool _destroyTexture);
    # bgfx_frame_buffer_handle_t bgfx_create_frame_buffer_from_attachment(uint8_t _num, const bgfx_attachment_t* _attachment, bool _destroyTexture);
    # bgfx_frame_buffer_handle_t bgfx_create_frame_buffer_from_nwh(void* _nwh, uint16_t _width, uint16_t _height, bgfx_texture_format_t _format, bgfx_texture_format_t _depthFormat);
    # void bgfx_set_frame_buffer_name(bgfx_frame_buffer_handle_t _handle, const char* _name, int32_t _len);
    # bgfx_texture_handle_t bgfx_get_texture(bgfx_frame_buffer_handle_t _handle, uint8_t _attachment);
    # void bgfx_destroy_frame_buffer(bgfx_frame_buffer_handle_t _handle);

    # bgfx_occlusion_query_handle_t bgfx_create_occlusion_query(void);
    # bgfx_occlusion_query_result_t bgfx_get_result(bgfx_occlusion_query_handle_t _handle, int32_t* _result);
    # void bgfx_destroy_occlusion_query(bgfx_occlusion_query_handle_t _handle);

    # void bgfx_set_palette_color(uint8_t _index, const float _rgba[4]);
    # void bgfx_set_palette_color_rgba8(uint8_t _index, uint32_t _rgba);

    # void bgfx_set_marker(const char* _name, int32_t _len);
    # void bgfx_set_state(uint64_t _state, uint32_t _rgba);
    # void bgfx_set_condition(bgfx_occlusion_query_handle_t _handle, bool _visible);
    # void bgfx_set_stencil(uint32_t _fstencil, uint32_t _bstencil);
    # uint16_t bgfx_set_scissor(uint16_t _x, uint16_t _y, uint16_t _width, uint16_t _height);
    # void bgfx_set_scissor_cached(uint16_t _cache);
    # void bgfx_set_transform_cached(uint32_t _cache, uint16_t _num);
    # uint32_t bgfx_alloc_transform(bgfx_transform_t* _transform, uint16_t _num);
    # void bgfx_set_uniform(bgfx_uniform_handle_t _handle, const void* _value, uint16_t _num);
    # void bgfx_set_index_buffer(bgfx_index_buffer_handle_t _handle, uint32_t _firstIndex, uint32_t _numIndices);
    # void bgfx_set_dynamic_index_buffer(bgfx_dynamic_index_buffer_handle_t _handle, uint32_t _firstIndex, uint32_t _numIndices);
    # void bgfx_set_transient_index_buffer(const bgfx_transient_index_buffer_t* _tib, uint32_t _firstIndex, uint32_t _numIndices);
    # void bgfx_set_vertex_buffer(uint8_t _stream, bgfx_vertex_buffer_handle_t _handle, uint32_t _startVertex, uint32_t _numVertices);
    # void bgfx_set_vertex_buffer_with_layout(uint8_t _stream, bgfx_vertex_buffer_handle_t _handle, uint32_t _startVertex, uint32_t _numVertices, bgfx_vertex_layout_handle_t _layoutHandle);
    # void bgfx_set_dynamic_vertex_buffer(uint8_t _stream, bgfx_dynamic_vertex_buffer_handle_t _handle, uint32_t _startVertex, uint32_t _numVertices);
    # void bgfx_set_dynamic_vertex_buffer_with_layout(uint8_t _stream, bgfx_dynamic_vertex_buffer_handle_t _handle, uint32_t _startVertex, uint32_t _numVertices, bgfx_vertex_layout_handle_t _layoutHandle);
    # void bgfx_set_transient_vertex_buffer(uint8_t _stream, const bgfx_transient_vertex_buffer_t* _tvb, uint32_t _startVertex, uint32_t _numVertices);
    # void bgfx_set_transient_vertex_buffer_with_layout(uint8_t _stream, const bgfx_transient_vertex_buffer_t* _tvb, uint32_t _startVertex, uint32_t _numVertices, bgfx_vertex_layout_handle_t _layoutHandle);
    # void bgfx_set_vertex_count(uint32_t _numVertices);
    # void bgfx_set_instance_data_buffer(const bgfx_instance_data_buffer_t* _idb, uint32_t _start, uint32_t _num);
    # void bgfx_set_instance_data_from_vertex_buffer(bgfx_vertex_buffer_handle_t _handle, uint32_t _startVertex, uint32_t _num);
    # void bgfx_set_instance_data_from_dynamic_vertex_buffer(bgfx_dynamic_vertex_buffer_handle_t _handle, uint32_t _startVertex, uint32_t _num);
    # void bgfx_set_instance_count(uint32_t _numInstances);
    # void bgfx_set_texture(uint8_t _stage, bgfx_uniform_handle_t _sampler, bgfx_texture_handle_t _handle, uint32_t _flags);

    # void bgfx_set_compute_index_buffer(uint8_t _stage, bgfx_index_buffer_handle_t _handle, bgfx_access_t _access);
    # void bgfx_set_compute_vertex_buffer(uint8_t _stage, bgfx_vertex_buffer_handle_t _handle, bgfx_access_t _access);
    # void bgfx_set_compute_dynamic_index_buffer(uint8_t _stage, bgfx_dynamic_index_buffer_handle_t _handle, bgfx_access_t _access);
    # void bgfx_set_compute_dynamic_vertex_buffer(uint8_t _stage, bgfx_dynamic_vertex_buffer_handle_t _handle, bgfx_access_t _access);
    # void bgfx_set_compute_indirect_buffer(uint8_t _stage, bgfx_indirect_buffer_handle_t _handle, bgfx_access_t _access);

    # void bgfx_set_image(uint8_t _stage, bgfx_texture_handle_t _handle, uint8_t _mip, bgfx_access_t _access, bgfx_texture_format_t _format);
    # uintptr_t bgfx_override_internal_texture_ptr(bgfx_texture_handle_t _handle, uintptr_t _ptr);
    # uintptr_t bgfx_override_internal_texture(bgfx_texture_handle_t _handle, uint16_t _width, uint16_t _height, uint8_t _numMips, bgfx_texture_format_t _format, uint64_t _flags);
