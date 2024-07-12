
# #define BGFX_CAPS_ALPHA_TO_COVERAGE               UINT64_C(0x0000000000000001) //!< Alpha to coverage is supported.
# #define BGFX_CAPS_BLEND_INDEPENDENT               UINT64_C(0x0000000000000002) //!< Blend independent is supported.
# #define BGFX_CAPS_COMPUTE                         UINT64_C(0x0000000000000004) //!< Compute shaders are supported.
# #define BGFX_CAPS_CONSERVATIVE_RASTER             UINT64_C(0x0000000000000008) //!< Conservative rasterization is supported.
# #define BGFX_CAPS_DRAW_INDIRECT                   UINT64_C(0x0000000000000010) //!< Draw indirect is supported.
# #define BGFX_CAPS_DRAW_INDIRECT_COUNT             UINT64_C(0x0000000000000020) //!< Draw indirect with indirect count is supported.
# #define BGFX_CAPS_FRAGMENT_DEPTH                  UINT64_C(0x0000000000000040) //!< Fragment depth is available in fragment shader.
# #define BGFX_CAPS_FRAGMENT_ORDERING               UINT64_C(0x0000000000000080) //!< Fragment ordering is available in fragment shader.
# #define BGFX_CAPS_GRAPHICS_DEBUGGER               UINT64_C(0x0000000000000100) //!< Graphics debugger is present.
# #define BGFX_CAPS_HDR10                           UINT64_C(0x0000000000000200) //!< HDR10 rendering is supported.
# #define BGFX_CAPS_HIDPI                           UINT64_C(0x0000000000000400) //!< HiDPI rendering is supported.
# #define BGFX_CAPS_IMAGE_RW                        UINT64_C(0x0000000000000800) //!< Image Read/Write is supported.
# #define BGFX_CAPS_INDEX32                         UINT64_C(0x0000000000001000) //!< 32-bit indices are supported.
# #define BGFX_CAPS_INSTANCING                      UINT64_C(0x0000000000002000) //!< Instancing is supported.
# #define BGFX_CAPS_OCCLUSION_QUERY                 UINT64_C(0x0000000000004000) //!< Occlusion query is supported.
# #define BGFX_CAPS_PRIMITIVE_ID                    UINT64_C(0x0000000000008000) //!< PrimitiveID is available in fragment shader.
# #define BGFX_CAPS_RENDERER_MULTITHREADED          UINT64_C(0x0000000000010000) //!< Renderer is on separate thread.
# #define BGFX_CAPS_SWAP_CHAIN                      UINT64_C(0x0000000000020000) //!< Multiple windows are supported.
# #define BGFX_CAPS_TEXTURE_BLIT                    UINT64_C(0x0000000000040000) //!< Texture blit is supported.
# #define BGFX_CAPS_TEXTURE_COMPARE_LEQUAL          UINT64_C(0x0000000000080000) //!< Texture compare less equal mode is supported.
# #define BGFX_CAPS_TEXTURE_COMPARE_RESERVED        UINT64_C(0x0000000000100000)
# #define BGFX_CAPS_TEXTURE_CUBE_ARRAY              UINT64_C(0x0000000000200000) //!< Cubemap texture array is supported.
# #define BGFX_CAPS_TEXTURE_DIRECT_ACCESS           UINT64_C(0x0000000000400000) //!< CPU direct access to GPU texture memory.
# #define BGFX_CAPS_TEXTURE_READ_BACK               UINT64_C(0x0000000000800000) //!< Read-back texture is supported.
# #define BGFX_CAPS_TEXTURE_2D_ARRAY                UINT64_C(0x0000000001000000) //!< 2D texture array is supported.
# #define BGFX_CAPS_TEXTURE_3D                      UINT64_C(0x0000000002000000) //!< 3D textures are supported.
# #define BGFX_CAPS_TRANSPARENT_BACKBUFFER          UINT64_C(0x0000000004000000) //!< Transparent back buffer supported.
# #define BGFX_CAPS_VERTEX_ATTRIB_HALF              UINT64_C(0x0000000008000000) //!< Vertex attribute half-float is supported.
# #define BGFX_CAPS_VERTEX_ATTRIB_UINT10            UINT64_C(0x0000000010000000) //!< Vertex attribute 10_10_10_2 is supported.
# #define BGFX_CAPS_VERTEX_ID                       UINT64_C(0x0000000020000000) //!< Rendering with VertexID only is supported.
# #define BGFX_CAPS_VIEWPORT_LAYER_ARRAY            UINT64_C(0x0000000040000000) //!< Viewport layer is available in vertex shader.
# /// All texture compare modes are supported.
# #define BGFX_CAPS_TEXTURE_COMPARE_ALL (0 \
# 	| BGFX_CAPS_TEXTURE_COMPARE_RESERVED \
# 	| BGFX_CAPS_TEXTURE_COMPARE_LEQUAL \
# 	)


# #define BGFX_CAPS_FORMAT_TEXTURE_NONE             UINT32_C(0x00000000) //!< Texture format is not supported.
# #define BGFX_CAPS_FORMAT_TEXTURE_2D               UINT32_C(0x00000001) //!< Texture format is supported.
# #define BGFX_CAPS_FORMAT_TEXTURE_2D_SRGB          UINT32_C(0x00000002) //!< Texture as sRGB format is supported.
# #define BGFX_CAPS_FORMAT_TEXTURE_2D_EMULATED      UINT32_C(0x00000004) //!< Texture format is emulated.
# #define BGFX_CAPS_FORMAT_TEXTURE_3D               UINT32_C(0x00000008) //!< Texture format is supported.
# #define BGFX_CAPS_FORMAT_TEXTURE_3D_SRGB          UINT32_C(0x00000010) //!< Texture as sRGB format is supported.
# #define BGFX_CAPS_FORMAT_TEXTURE_3D_EMULATED      UINT32_C(0x00000020) //!< Texture format is emulated.
# #define BGFX_CAPS_FORMAT_TEXTURE_CUBE             UINT32_C(0x00000040) //!< Texture format is supported.
# #define BGFX_CAPS_FORMAT_TEXTURE_CUBE_SRGB        UINT32_C(0x00000080) //!< Texture as sRGB format is supported.
# #define BGFX_CAPS_FORMAT_TEXTURE_CUBE_EMULATED    UINT32_C(0x00000100) //!< Texture format is emulated.
# #define BGFX_CAPS_FORMAT_TEXTURE_VERTEX           UINT32_C(0x00000200) //!< Texture format can be used from vertex shader.
# #define BGFX_CAPS_FORMAT_TEXTURE_IMAGE_READ       UINT32_C(0x00000400) //!< Texture format can be used as image and read from.
# #define BGFX_CAPS_FORMAT_TEXTURE_IMAGE_WRITE      UINT32_C(0x00000800) //!< Texture format can be used as image and written to.
# #define BGFX_CAPS_FORMAT_TEXTURE_FRAMEBUFFER      UINT32_C(0x00001000) //!< Texture format can be used as frame buffer.
# #define BGFX_CAPS_FORMAT_TEXTURE_FRAMEBUFFER_MSAA UINT32_C(0x00002000) //!< Texture format can be used as MSAA frame buffer.
# #define BGFX_CAPS_FORMAT_TEXTURE_MSAA             UINT32_C(0x00004000) //!< Texture can be sampled as MSAA.
# #define BGFX_CAPS_FORMAT_TEXTURE_MIP_AUTOGEN      UINT32_C(0x00008000) //!< Texture format supports auto-generated mips.

