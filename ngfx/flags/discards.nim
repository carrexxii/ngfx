type DiscardFlag* = distinct uint8
const
    none*          = DiscardFlag 0x00
    bindings*      = DiscardFlag 0x01
    indexBuffer*   = DiscardFlag 0x02
    instanceData*  = DiscardFlag 0x04
    state*         = DiscardFlag 0x08
    transform*     = DiscardFlag 0x10
    vertexStreams* = DiscardFlag 0x20
    all*           = DiscardFlag 0xFF

