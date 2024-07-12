type ClearFlag* = distinct uint16
func `and`*(a, b: ClearFlag): ClearFlag {.borrow.}
func `or`* (a, b: ClearFlag): ClearFlag {.borrow.}
const
    none*           = ClearFlag 0x0000
    colour*         = ClearFlag 0x0001
    depth*          = ClearFlag 0x0002
    stencil*        = ClearFlag 0x0004
    discardColour0* = ClearFlag 0x0008
    discardColour1* = ClearFlag 0x0010
    discardColour2* = ClearFlag 0x0020
    discardColour3* = ClearFlag 0x0040
    discardColour4* = ClearFlag 0x0080
    discardColour5* = ClearFlag 0x0100
    discardColour6* = ClearFlag 0x0200
    discardColour7* = ClearFlag 0x0400
    discardDepth*   = ClearFlag 0x0800
    discardStencil* = ClearFlag 0x1000
    discardColourMask* = discardColour0 or discardColour1 or
                         discardColour2 or discardColour3 or
                         discardColour4 or discardColour5 or
                         discardColour6 or discardColour7
    discardMask* = discardColourMask or discardDepth or discardStencil

