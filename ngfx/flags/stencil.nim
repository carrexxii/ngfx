type StencilFlag* = distinct uint32
func `and`*(a, b: StencilFlag): StencilFlag {.borrow.}
func `or`* (a, b: StencilFlag): StencilFlag {.borrow.}
func `shl`*(a, b: StencilFlag): StencilFlag {.borrow.}
const
    none*    = StencilFlag 0x0000_0000
    mask*    = StencilFlag 0xFFFF_FFFF
    default* = StencilFlag 0x0000_0000

    funcRefShift* = StencilFlag 0
    funcRefMask*  = StencilFlag 0x0000_00FF

    funcRMaskShift* = StencilFlag 8
    funcRMaskMask*  = StencilFlag 0x0000_FF00

    testLess*    = StencilFlag 0x0001_0000
    testLEqual*  = StencilFlag 0x0002_0000
    testEqual*   = StencilFlag 0x0003_0000
    testGEqual*  = StencilFlag 0x0004_0000
    testGreater* = StencilFlag 0x0005_0000
    testNEqual*  = StencilFlag 0x0006_0000
    testNever*   = StencilFlag 0x0007_0000
    testAlways*  = StencilFlag 0x0008_0000
    testShift*   = StencilFlag 16
    testMask*    = StencilFlag 0x000F_0000

    opFailSZero*    = StencilFlag 0x0000_0000
    opFailSKeep*    = StencilFlag 0x0010_0000
    opFailSReplace* = StencilFlag 0x0020_0000
    opFailSIncr*    = StencilFlag 0x0030_0000
    opFailSIncrSAT* = StencilFlag 0x0040_0000
    opFailSDecr*    = StencilFlag 0x0050_0000
    opFailSDecrSAT* = StencilFlag 0x0060_0000
    opFailSInvert*  = StencilFlag 0x0070_0000
    opFailSShift*   = StencilFlag 20
    opFailSMask*    = StencilFlag 0x00F0_0000

    opFailZZero*    = StencilFlag 0x0000_0000
    opFailZKeep*    = StencilFlag 0x0100_0000
    opFailZReplace* = StencilFlag 0x0200_0000
    opFailZIncr*    = StencilFlag 0x0300_0000
    opFailZIncrSAT* = StencilFlag 0x0400_0000
    opFailZDecr*    = StencilFlag 0x0500_0000
    opFailZDecrSAT* = StencilFlag 0x0600_0000
    opFailZInvert*  = StencilFlag 0x0700_0000
    opFailZShift*   = StencilFlag 24
    opFailZMask*    = StencilFlag 0x0F00_0000

    opPassZZero*    = StencilFlag 0x0000_0000
    opPassZKeep*    = StencilFlag 0x1000_0000
    opPassZReplace* = StencilFlag 0x2000_0000
    opPassZIncr*    = StencilFlag 0x3000_0000
    opPassZIncrSAT* = StencilFlag 0x4000_0000
    opPassZDecr*    = StencilFlag 0x5000_0000
    opPassZDecrSAT* = StencilFlag 0x6000_0000
    opPassZInvert*  = StencilFlag 0x7000_0000
    opPassZShift*   = StencilFlag 28
    opPassZMask*    = StencilFlag 0xF000_0000

func stencil_func_ref*  (stencil: StencilFlag): StencilFlag {.inline.} = (stencil shl funcRefShift)   and funcRefMask
func stencil_func_rmask*(stencil: StencilFlag): StencilFlag {.inline.} = (stencil shl funcRMaskShift) and funcRMaskMask

