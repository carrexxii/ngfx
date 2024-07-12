type StateFlag* = distinct uint64
func `and`*(a, b: StateFlag): StateFlag {.borrow.}
func `or`* (a, b: StateFlag): StateFlag {.borrow.}
func `shl`*(a, b: StateFlag): StateFlag {.borrow.}
const
    writeR*    = StateFlag 0x0000_0000_0000_0001
    writeG*    = StateFlag 0x0000_0000_0000_0002
    writeB*    = StateFlag 0x0000_0000_0000_0004
    writeA*    = StateFlag 0x0000_0000_0000_0008
    writeZ*    = StateFlag 0x0000_0040_0000_0000
    writeRGB*  = writeR or writeG or writeB
    writeMask* = writeRGB or writeA or writeZ

    depthTestLess*    = StateFlag 0x0000_0000_0000_0010
    depthTestLEqual*  = StateFlag 0x0000_0000_0000_0020
    depthTestEqual*   = StateFlag 0x0000_0000_0000_0030
    depthTestGEqual*  = StateFlag 0x0000_0000_0000_0040
    depthTestGreater* = StateFlag 0x0000_0000_0000_0050
    depthTestNEqual*  = StateFlag 0x0000_0000_0000_0060
    depthTestNever*   = StateFlag 0x0000_0000_0000_0070
    depthTestAlways*  = StateFlag 0x0000_0000_0000_0080
    depthTestShift*   = StateFlag 4
    depthTestMask*    = StateFlag 0x0000_0000_0000_00F0

    blendZero*         = StateFlag 0x0000_0000_0000_1000
    blendOne*          = StateFlag 0x0000_0000_0000_2000
    blendSrcColour*    = StateFlag 0x0000_0000_0000_3000
    blendInvSrcColour* = StateFlag 0x0000_0000_0000_4000
    blendAlpha*        = StateFlag 0x0000_0000_0000_5000
    blendSrcAlpha*     = StateFlag 0x0000_0000_0000_6000
    blendDstAlpha*     = StateFlag 0x0000_0000_0000_7000
    blendInvDstAlpha*  = StateFlag 0x0000_0000_0000_8000
    blendDstColour*    = StateFlag 0x0000_0000_0000_9000
    blendInvDstColour* = StateFlag 0x0000_0000_0000_A000
    blendSrcAlphaSAT*  = StateFlag 0x0000_0000_0000_B000
    blendFactor*       = StateFlag 0x0000_0000_0000_C000
    blendInvFactor*    = StateFlag 0x0000_0000_0000_D000
    blendShift*        = StateFlag 12
    blendMask*         = StateFlag 0x0000_0000_0FFF_F000

    blendEqAdd*    = StateFlag 0x0000_0000_0000_0000
    blendEqSub*    = StateFlag 0x0000_0000_1000_0000
    blendEqRevSub* = StateFlag 0x0000_0000_2000_0000
    blendEqMin*    = StateFlag 0x0000_0000_3000_0000
    blendEqMax*    = StateFlag 0x0000_0000_4000_0000
    blendEqShift*  = StateFlag 28
    blendEqMask*   = StateFlag 0x0000_0003_F000_0000

    cullCW*    = StateFlag 0x0000_0010_0000_0000
    cullCCW*   = StateFlag 0x0000_0020_0000_0000
    cullShift* = StateFlag 36
    cullMask*  = StateFlag 0x0000_0030_0000_0000

    alphaRefShift* = StateFlag 40
    alphaRefMask*  = StateFlag 0x0000_FF00_0000_0000

    ptTriStrip*  = StateFlag 0x0001_0000_0000_0000
    ptLines*     = StateFlag 0x0002_0000_0000_0000
    ptLineStrip* = StateFlag 0x0003_0000_0000_0000
    ptPoints*    = StateFlag 0x0004_0000_0000_0000
    ptShift*     = StateFlag 48
    ptMask*      = StateFlag 0x0007_0000_0000_0000

    pointSizeShift* = StateFlag 52
    pointSizeMask*  = StateFlag 0x00F0_0000_0000_0000

    none*                 = StateFlag 0x0000_0000_0000_0000
    msaa*                 = StateFlag 0x0100_0000_0000_0000
    lineAA*               = StateFlag 0x0200_0000_0000_0000
    conservativeRaster*   = StateFlag 0x0400_0000_0000_0000
    frontCCW*             = StateFlag 0x0000_0080_0000_0000
    blendIndependent*     = StateFlag 0x0000_0004_0000_0000
    blendAlphaToCoverage* = StateFlag 0x0000_0008_0000_0000

func default*(_: typedesc[StateFlag]): StateFlag {.inline.} =
    writeRGB or writeA or writeZ or
    depthTestLess or cullCW or msaa

func alpha_ref* (state: StateFlag): StateFlag {.inline.} = (state shl alphaRefShift)  and alphaRefMask
func point_size*(state: StateFlag): StateFlag {.inline.} = (state shl pointSizeShift) and pointSizeMask

# func blend_func_separate*(src, dst: ; srca, dsta: )

# #define BGFX_STATE_BLEND_FUNC_SEPARATE(_srcRGB, _dstRGB, _srcA, _dstA) (UINT64_C(0) \
# 	| ( ( (uint64_t)(_srcRGB)|( (uint64_t)(_dstRGB)<<4) )   )                       \
# 	| ( ( (uint64_t)(_srcA  )|( (uint64_t)(_dstA  )<<4) )<<8)                       \
# 	)

# #define BGFX_STATE_BLEND_EQUATION_SEPARATE(_equationRGB, _equationA) ( (uint64_t)(_equationRGB)|( (uint64_t)(_equationA)<<3) )
# #define BGFX_STATE_BLEND_FUNC(_src, _dst)    BGFX_STATE_BLEND_FUNC_SEPARATE(_src, _dst, _src, _dst)
# #define BGFX_STATE_BLEND_EQUATION(_equation) BGFX_STATE_BLEND_EQUATION_SEPARATE(_equation, _equation)

# #define BGFX_STATE_BLEND_ADD (0                                         \
# 	| BGFX_STATE_BLEND_FUNC(BGFX_STATE_BLEND_ONE, BGFX_STATE_BLEND_ONE) \
# 	)

# #define BGFX_STATE_BLEND_ALPHA (0                                                       \
# 	| BGFX_STATE_BLEND_FUNC(BGFX_STATE_BLEND_SRC_ALPHA, BGFX_STATE_BLEND_INV_SRC_ALPHA) \
# 	)

# #define BGFX_STATE_BLEND_DARKEN (0                                      \
# 	| BGFX_STATE_BLEND_FUNC(BGFX_STATE_BLEND_ONE, BGFX_STATE_BLEND_ONE) \
# 	| BGFX_STATE_BLEND_EQUATION(BGFX_STATE_BLEND_EQUATION_MIN)          \
# 	)

# #define BGFX_STATE_BLEND_LIGHTEN (0                                     \
# 	| BGFX_STATE_BLEND_FUNC(BGFX_STATE_BLEND_ONE, BGFX_STATE_BLEND_ONE) \
# 	| BGFX_STATE_BLEND_EQUATION(BGFX_STATE_BLEND_EQUATION_MAX)          \
# 	)

# #define BGFX_STATE_BLEND_MULTIPLY (0                                           \
# 	| BGFX_STATE_BLEND_FUNC(BGFX_STATE_BLEND_DST_COLOR, BGFX_STATE_BLEND_ZERO) \
# 	)

# #define BGFX_STATE_BLEND_NORMAL (0                                                \
# 	| BGFX_STATE_BLEND_FUNC(BGFX_STATE_BLEND_ONE, BGFX_STATE_BLEND_INV_SRC_ALPHA) \
# 	)

# #define BGFX_STATE_BLEND_SCREEN (0                                                \
# 	| BGFX_STATE_BLEND_FUNC(BGFX_STATE_BLEND_ONE, BGFX_STATE_BLEND_INV_SRC_COLOR) \
# 	)

# #define BGFX_STATE_BLEND_LINEAR_BURN (0                                                 \
# 	| BGFX_STATE_BLEND_FUNC(BGFX_STATE_BLEND_DST_COLOR, BGFX_STATE_BLEND_INV_DST_COLOR) \
# 	| BGFX_STATE_BLEND_EQUATION(BGFX_STATE_BLEND_EQUATION_SUB)                          \
# 	)

# #define BGFX_STATE_BLEND_FUNC_RT_x(_src, _dst) (0         \
# 	| ( (uint32_t)( (_src)>>BGFX_STATE_BLEND_SHIFT)       \
# 	| ( (uint32_t)( (_dst)>>BGFX_STATE_BLEND_SHIFT)<<4) ) \
# 	)

# #define BGFX_STATE_BLEND_FUNC_RT_xE(_src, _dst, _equation) (0         \
# 	| BGFX_STATE_BLEND_FUNC_RT_x(_src, _dst)                          \
# 	| ( (uint32_t)( (_equation)>>BGFX_STATE_BLEND_EQUATION_SHIFT)<<8) \
# 	)

# #define BGFX_STATE_BLEND_FUNC_RT_1(_src, _dst)  (BGFX_STATE_BLEND_FUNC_RT_x(_src, _dst)<< 0)
# #define BGFX_STATE_BLEND_FUNC_RT_2(_src, _dst)  (BGFX_STATE_BLEND_FUNC_RT_x(_src, _dst)<<11)
# #define BGFX_STATE_BLEND_FUNC_RT_3(_src, _dst)  (BGFX_STATE_BLEND_FUNC_RT_x(_src, _dst)<<22)

# #define BGFX_STATE_BLEND_FUNC_RT_1E(_src, _dst, _equation) (BGFX_STATE_BLEND_FUNC_RT_xE(_src, _dst, _equation)<< 0)
# #define BGFX_STATE_BLEND_FUNC_RT_2E(_src, _dst, _equation) (BGFX_STATE_BLEND_FUNC_RT_xE(_src, _dst, _equation)<<11)
# #define BGFX_STATE_BLEND_FUNC_RT_3E(_src, _dst, _equation) (BGFX_STATE_BLEND_FUNC_RT_xE(_src, _dst, _equation)<<22)

