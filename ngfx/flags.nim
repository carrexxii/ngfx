import common

type
    DepthTestFlag* {.size: sizeof(uint64).} = enum
        Shift    = 0x0000_0000_0000_0004
        Less     = 0x0000_0000_0000_0010
        LEqual   = 0x0000_0000_0000_0020
        Equal    = 0x0000_0000_0000_0030
        GEqual   = 0x0000_0000_0000_0040
        Greater  = 0x0000_0000_0000_0050
        NotEqual = 0x0000_0000_0000_0060
        Never    = 0x0000_0000_0000_0070
        Always   = 0x0000_0000_0000_0080
        Mask     = 0x0000_0000_0000_00F0

    WriteFlag* {.size: sizeof(uint64).} = enum
        R    = 0x0000_0000_0000_0001
        G    = 0x0000_0000_0000_0002
        B    = 0x0000_0000_0000_0004
        RGB  = 0x01 or 0x02 or 0x04
        A    = 0x0000_0000_0000_0008
        Z    = 0x0000_0040_0000_0000
        Mask = 0x7 or 0x1 or 0x0000_0040_0000_0000

    BlendFlag* {.size: sizeof(uint64).} = enum
        Shift        = 0x0000_0000_0000_000C
        Zero         = 0x0000_0000_0000_1000
        One          = 0x0000_0000_0000_2000
        SrcColour    = 0x0000_0000_0000_3000
        InvSrcColour = 0x0000_0000_0000_4000
        SrcAlpha     = 0x0000_0000_0000_5000
        InvSrcAlpha  = 0x0000_0000_0000_6000
        DstAlpha     = 0x0000_0000_0000_7000
        InvDstAlpha  = 0x0000_0000_0000_8000
        DstColour    = 0x0000_0000_0000_9000
        InvDstColour = 0x0000_0000_0000_A000
        SrcAlphaSat  = 0x0000_0000_0000_B000
        Factor       = 0x0000_0000_0000_C000
        InvFactor    = 0x0000_0000_0000_D000
        Mask         = 0x0000_0000_0FFF_F000

    BlendEquationFlag* {.size: sizeof(uint64).} = enum
        Add    = 0x0000_0000_0000_0000
        Shift  = 0x0000_0000_0000_001C
        Sub    = 0x0000_0000_1000_0000
        RevSub = 0x0000_0000_2000_0000
        Min    = 0x0000_0000_3000_0000
        Max    = 0x0000_0000_4000_0000
        Mask   = 0x0000_0003_F000_0000

    CullFlag* {.size: sizeof(uint64).} = enum
        Shift = 0x0000_0000_0000_0024
        CW    = 0x0000_0010_0000_0000
        CCW   = 0x0000_0020_0000_0000
        Mask  = 0x0000_0030_0000_0000

    PTFlag* {.size: sizeof(uint64).} = enum
        Shift     = 0x0000_0000_0000_0030
        TriStrip  = 0x0001_0000_0000_0000
        Lines     = 0x0002_0000_0000_0000
        LineStrip = 0x0003_0000_0000_0000
        Points    = 0x0004_0000_0000_0000
        Mask      = 0x0007_0000_0000_0000

    StateOptionFlag* {.size: sizeof(uint64).} = enum
        None                 = 0x0000_0000_0000_0000
        AlphaRefShift        = 0x0000_0000_0000_0028
        PointSizeShift       = 0x0000_0000_0000_0034
        BlendIndependent     = 0x0000_0004_0000_0000
        BlendAlphaToCoverage = 0x0000_0008_0000_0000
        FrontCCW             = 0x0000_0080_0000_0000
        AlphaRefMask         = 0x0000_FF00_0000_0000
        PointSizeMask        = 0x00F0_0000_0000_0000
        MSAA                 = 0x0100_0000_0000_0000
        LineAA               = 0x0200_0000_0000_0000
        ConservativeRaster   = 0x0400_0000_0000_0000
    StateFlag* {.size: sizeof(uint64).} =
        DepthTestFlag | WriteFlag | BlendFlag | BlendEquationFlag | CullFlag | PTFlag | StateOptionFlag | uint64

func `or`*[T, U: StateFlag | DepthTestFlag | WriteFlag | BlendFlag | BlendEquationFlag | CullFlag | PTFlag | StateOptionFlag] (a: T; b: U): StateFlag =
    StateFlag ((uint64 a) or (uint64 b))

template StateAlphaRef*(x: typed): StateFlag =
    (StateFlag x shl StateAlphaRefShift) and StateAlphaRefMask
template StatePointSize*(x: typed): StateFlag =
    (StateFlag x shl StatePointSizeShift) and StatePointSizeMask

const DefaultState* = RGB or A or Z or Less or CW or MSAA

#[ -------------------------------------------------------------------- ]#

type
    ResetFlag* {.size: sizeof(uint32).} = enum
        None                  = 0x0000_0000
        Fullscreen            = 0x0000_0001
        MSAAShift             = 0x0000_0004
        MSAAX2                = 0x0000_0010
        MSAAX4                = 0x0000_0020
        MSAAX8                = 0x0000_0030
        MSAAX16               = 0x0000_0040
        MSAAMask              = 0x0000_0070
        VSync                 = 0x0000_0080
        MaxAnisotropy         = 0x0000_0100
        Capture               = 0x0000_0200
        FlushAfterRender      = 0x0000_2000
        FlipAfterRender       = 0x0000_4000
        SRGBBackbuffer        = 0x0000_8000
        HDR10                 = 0x0001_0000
        HiDPI                 = 0x0002_0000
        DepthClamp            = 0x0004_0000
        Suspend               = 0x0008_0000
        TransparentBackbuffer = 0x0010_0000

    DiscardFlag* {.size: sizeof(uint8).} = enum
        None          = 0x00
        Bindings      = 0x01
        IndexBuffer   = 0x02
        InstanceData  = 0x04
        State         = 0x08
        Transform     = 0x10
        VertexStreams = 0x20
        All           = 0xFF

    ClearFlag* {.size: sizeof(uint16).} = enum
        None           = 0x0000
        Colour         = 0x0001
        Depth          = 0x0002
        Stencil        = 0x0004
        DiscardColour0 = 0x0008
        DiscardColour1 = 0x0010
        DiscardColour2 = 0x0020
        DiscardColour3 = 0x0040
        DiscardColour4 = 0x0080
        DiscardColour5 = 0x0100
        DiscardColour6 = 0x0200
        DiscardColour7 = 0x0400
        DiscardDepth   = 0x0800
        DiscardStencil = 0x1000

    ComputeFormat* {.size: sizeof(uint16).} = enum
        Shift = 0x0000
        N8x1  = 0x0001
        N8x2  = 0x0002
        N8x4  = 0x0003
        N16x1 = 0x0004
        N16x2 = 0x0005
        N16x4 = 0x0006
        N32x1 = 0x0007
        N32x2 = 0x0008
        N32x4 = 0x0009
        Mask  = 0x000F

    ComputeKind* {.size: sizeof(uint16).} = enum
        Shift = 0x0004
        Int   = 0x0010
        UInt  = 0x0020
        Float = 0x0030

    BufferFlag* {.size: sizeof(uint16).} = enum
        None               = 0x0000
        ComputeRead        = 0x0100
        ComputeWrite       = 0x0200
        DrawIndirect       = 0x0400
        AllowResize        = 0x0800
        Index32            = 0x1000

flag_bitop(`or`, ResetFlag, uint32)
flag_bitop(`or`, ClearFlag, uint16)

type
    SamplerFlag* {.size: sizeof(uint32).} = enum
        None              = 0x0000_0000
        UMirror           = 0x0000_0001
        UClamp            = 0x0000_0002
        UBorder           = 0x0000_0003
        VMirror           = 0x0000_0004
        VClamp            = 0x0000_0008
        VBorder           = 0x0000_000C
        WMirror           = 0x0000_0010
        WClamp            = 0x0000_0020
        WBorder           = 0x0000_0030
        MinPoint          = 0x0000_0040
        MinAnisotropic    = 0x0000_0080
        MagPoint          = 0x0000_0100
        MagAnisotropic    = 0x0000_0200
        MIPPoint          = 0x0000_0400
        CompareLess       = 0x0001_0000
        CompareLEqual     = 0x0002_0000
        CompareEqual      = 0x0003_0000
        CompareGEqual     = 0x0004_0000
        CompareGreater    = 0x0005_0000
        CompareNotEqual   = 0x0006_0000
        CompareNever      = 0x0007_0000
        CompareAlways     = 0x0008_0000
        SampleStencil     = 0x0010_0000

flag_bitop(`or`, SamplerFlag, uint32)

const
    SamplerUShift*            = 0x0000_0000
    SamplerUMask*             = 0x0000_0003
    SamplerVShift*            = 0x0000_0002
    SamplerVMask*             = 0x0000_000C
    SamplerWShift*            = 0x0000_0004
    SamplerWMask*             = 0x0000_0030
    SamplerMinShift*          = 0x0000_0006
    SamplerMinMask*           = 0x0000_00C0
    SamplerMagShift*          = 0x0000_0008
    SamplerMagMask*           = 0x0000_0300
    SamplerMIPShift*          = 0x0000_000A
    SamplerMIPMask*           = 0x0000_0400
    SamplerCompareShift*      = 0x0000_0010
    SamplerCompareMask*       = 0x000F_0000
    SamplerBorderColourShift* = 0x0000_0018
    SamplerBorderColourMask*  = 0x0F00_0000
    SamplerReservedShift*     = 0x0000_001C
    SamplerPoint*             = MinPoint or MagPoint or MIPPoint
    SamplerUVWMirror*         = UMirror or VMirror or WMirror
    SamplerUVWClamp*          = UClamp or VClamp or WClamp
    SamplerUVWBorder*         = UBorder or VBorder or WBorder
    SamplerBitsMask*          = SamplerUMask or SamplerVMask or SamplerWMask or
                                SamplerMinMask or SamplerMagMask or SamplerMIPMask or
                                SamplerCompareMask

template sampler_border_colour*(v: typed): SamplerFlag =
    (v.SamplerFlag shl SamplerBorderColourShift) and SamplerBorderColourMask

type StencilFlag* = distinct uint32
func `or`*(a, b: StencilFlag): StencilFlag {.borrow.}
const
    StencilFuncRefShift*   = StencilFlag 0x0000_0000
    StencilFuncRefMask*    = StencilFlag 0x0000_00FF
    StencilFuncRMaskShift* = StencilFlag 0x0000_0008
    StencilFuncRMaskMask*  = StencilFlag 0x0000_FF00
    StencilNone*           = StencilFlag 0x0000_0000
    StencilMask*           = StencilFlag 0xFFFF_FFFF
    StencilDefault*        = StencilFlag 0x0000_0000
    StencilTestLess*       = StencilFlag 0x0001_0000
    StencilTestLEqual*     = StencilFlag 0x0002_0000
    StencilTestEqual*      = StencilFlag 0x0003_0000
    StencilTestGEqual*     = StencilFlag 0x0004_0000
    StencilTestGreater*    = StencilFlag 0x0005_0000
    StencilTestNotEqual*   = StencilFlag 0x0006_0000
    StencilTestNever*      = StencilFlag 0x0007_0000
    StencilTestAlways*     = StencilFlag 0x0008_0000
    StencilTestShift*      = StencilFlag 0x0000_0010
    StencilTestMask*       = StencilFlag 0x000F_0000
    StencilOpFailSZero*    = StencilFlag 0x0000_0000
    StencilOpFailSKeep*    = StencilFlag 0x0010_0000
    StencilOpFailSReplace* = StencilFlag 0x0020_0000
    StencilOpFailSIncr*    = StencilFlag 0x0030_0000
    StencilOpFailSIncrSAT* = StencilFlag 0x0040_0000
    StencilOpFailSDecr*    = StencilFlag 0x0050_0000
    StencilOpFailSDecrSAT* = StencilFlag 0x0060_0000
    StencilOpFailSInvert*  = StencilFlag 0x0070_0000
    StencilOpFailSShift*   = StencilFlag 0x0000_0014
    StencilOpFailSMask*    = StencilFlag 0x00F0_0000
    StencilOpFailZZero*    = StencilFlag 0x0000_0000
    StencilOpFailZKeep*    = StencilFlag 0x0100_0000
    StencilOpFailZReplace* = StencilFlag 0x0200_0000
    StencilOpFailZIncr*    = StencilFlag 0x0300_0000
    StencilOpFailZIncrSAT* = StencilFlag 0x0400_0000
    StencilOpFailZDecr*    = StencilFlag 0x0500_0000
    StencilOpFailZDecrSAT* = StencilFlag 0x0600_0000
    StencilOpFailZInvert*  = StencilFlag 0x0700_0000
    StencilOpFailZShift*   = StencilFlag 0x0000_0018
    StencilOpFailZMask*    = StencilFlag 0x0f00_0000
    StencilOpPassZZero*    = StencilFlag 0x0000_0000
    StencilOpPassZKeep*    = StencilFlag 0x1000_0000
    StencilOpPassZReplace* = StencilFlag 0x2000_0000
    StencilOpPassZIncr*    = StencilFlag 0x3000_0000
    StencilOpPassZIncrSAT* = StencilFlag 0x4000_0000
    StencilOpPassZDecr*    = StencilFlag 0x5000_0000
    StencilOpPassZDecrSAT* = StencilFlag 0x6000_0000
    StencilOpPassZInvert*  = StencilFlag 0x7000_0000
    StencilOpPassZShift*   = StencilFlag 0x0000_001C
    StencilOpPassZMask*    = StencilFlag 0xF000_0000

template stencil_func_ref*(x: typed) =
    (x.uint32 shl StencilFuncRefShift) and StencilFuncRefMask
template stencil_func_rmask*(x: typed) =
    (x.uint32 shl StencilFuncRMaskShift) and StencilFuncRMaskMask

type ResolveFlag* {.size: sizeof(uint8).} = enum
    None
    AutoGenMips
