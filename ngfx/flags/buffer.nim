type BufferFlag* = distinct uint16
func `and`*(a, b: BufferFlag): BufferFlag {.borrow.}
func `or`* (a, b: BufferFlag): BufferFlag {.borrow.}
const
    computeFormat8x1*   = BufferFlag 0x0001
    computeFormat8x2*   = BufferFlag 0x0002
    computeFormat8x4*   = BufferFlag 0x0003
    computeFormat16x1*  = BufferFlag 0x0004
    computeFormat16x2*  = BufferFlag 0x0005
    computeFormat16x4*  = BufferFlag 0x0006
    computeFormat32x1*  = BufferFlag 0x0007
    computeFormat32x2*  = BufferFlag 0x0008
    computeFormat32x4*  = BufferFlag 0x0009
    computeFormatShift* = BufferFlag 0
    computeFormatMask*  = BufferFlag 0x000F

    computeTypeInt*   = BufferFlag 0x0010
    computeTypeUInt*  = BufferFlag 0x0020
    computeTypeFloat* = BufferFlag 0x0030
    computeTypeShift* = BufferFlag 4
    computeTypeMask*  = BufferFlag 0x0030

    none*             = BufferFlag 0x0000
    computeRead*      = BufferFlag 0x0100
    computeWrite*     = BufferFlag 0x0200
    drawIndirect*     = BufferFlag 0x0400
    allowResize*      = BufferFlag 0x0800
    index32*          = BufferFlag 0x1000
    computeReadWrite* = computeRead or computeWrite

