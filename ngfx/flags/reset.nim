type ResetFlag* = distinct uint32
func `and`*(a, b: ResetFlag): ResetFlag {.borrow.}
func `or`* (a, b: ResetFlag): ResetFlag {.borrow.}
const
    msaaX2*    = ResetFlag 0x0000_0010
    msaaX4*    = ResetFlag 0x0000_0020
    msaaX8*    = ResetFlag 0x0000_0030
    msaaX16*   = ResetFlag 0x0000_0040
    msaaShift* = ResetFlag 4
    msaaMask*  = ResetFlag 0x00000070

    none*             = ResetFlag 0x0000_0000
    fullscreen*       = ResetFlag 0x0000_0001
    vSync*            = ResetFlag 0x0000_0080
    maxAnisotropy*    = ResetFlag 0x0000_0100
    capture*          = ResetFlag 0x0000_0200
    flushAfterRender* = ResetFlag 0x0000_2000

    flipAfterRender*       = ResetFlag 0x0000_4000
    srgbBackbuffer*        = ResetFlag 0x0000_8000
    hdr10*                 = ResetFlag 0x0001_0000
    hiDPI*                 = ResetFlag 0x0002_0000
    depthClamp*            = ResetFlag 0x0004_0000
    suspend*               = ResetFlag 0x0008_0000
    transparentBackbuffer* = ResetFlag 0x0010_0000

    fullscreenShift* = ResetFlag 0
    fullscreenMask*  = ResetFlag 0x0000_0001

