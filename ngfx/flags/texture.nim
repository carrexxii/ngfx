#define BGFX_TEXTURE_NONE                         UINT64_C(0x0000000000000000)
#define BGFX_TEXTURE_MSAA_SAMPLE                  UINT64_C(0x0000000800000000) //!< Texture will be used for MSAA sampling.
#define BGFX_TEXTURE_RT                           UINT64_C(0x0000001000000000) //!< Render target no MSAA.
#define BGFX_TEXTURE_COMPUTE_WRITE                UINT64_C(0x0000100000000000) //!< Texture will be used for compute write.
#define BGFX_TEXTURE_SRGB                         UINT64_C(0x0000200000000000) //!< Sample texture as sRGB.
#define BGFX_TEXTURE_BLIT_DST                     UINT64_C(0x0000400000000000) //!< Texture will be used as blit destination.
#define BGFX_TEXTURE_READ_BACK                    UINT64_C(0x0000800000000000) //!< Texture will be used for read back from GPU.

#define BGFX_TEXTURE_RT_MSAA_X2                   UINT64_C(0x0000002000000000) //!< Render target MSAAx2 mode.
#define BGFX_TEXTURE_RT_MSAA_X4                   UINT64_C(0x0000003000000000) //!< Render target MSAAx4 mode.
#define BGFX_TEXTURE_RT_MSAA_X8                   UINT64_C(0x0000004000000000) //!< Render target MSAAx8 mode.
#define BGFX_TEXTURE_RT_MSAA_X16                  UINT64_C(0x0000005000000000) //!< Render target MSAAx16 mode.
#define BGFX_TEXTURE_RT_MSAA_SHIFT                36

#define BGFX_TEXTURE_RT_MSAA_MASK                 UINT64_C(0x0000007000000000)

#define BGFX_TEXTURE_RT_WRITE_ONLY                UINT64_C(0x0000008000000000) //!< Render target will be used for writing
#define BGFX_TEXTURE_RT_SHIFT                     36

#define BGFX_TEXTURE_RT_MASK                      UINT64_C(0x000000f000000000)

