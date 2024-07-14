# This file is a part of NGfx. Copyright (C) 2024 carrexxii.
# It is distributed under the terms of the Apache License, Version 2.0.
# For a copy, see the LICENSE file or <https://apache.org/licenses/>.

type CapsFlag* = distinct uint64
func `and`*(a, b: CapsFlag): CapsFlag {.borrow.}
func `or`* (a, b: CapsFlag): CapsFlag {.borrow.}
const
    alphaToCoverage*        = CapsFlag 0x0000_0000_0000_0001
    blendIndependent*       = CapsFlag 0x0000_0000_0000_0002
    compute*                = CapsFlag 0x0000_0000_0000_0004
    conservativeRaster*     = CapsFlag 0x0000_0000_0000_0008
    drawIndirect*           = CapsFlag 0x0000_0000_0000_0010
    drawIndirectCount*      = CapsFlag 0x0000_0000_0000_0020
    fragmentDepth*          = CapsFlag 0x0000_0000_0000_0040
    fragmentOrdering*       = CapsFlag 0x0000_0000_0000_0080
    graphicsDebugger*       = CapsFlag 0x0000_0000_0000_0100
    hdr10*                  = CapsFlag 0x0000_0000_0000_0200
    hiDPI*                  = CapsFlag 0x0000_0000_0000_0400
    imageRW*                = CapsFlag 0x0000_0000_0000_0800
    index32*                = CapsFlag 0x0000_0000_0000_1000
    instancing*             = CapsFlag 0x0000_0000_0000_2000
    occlusionQuery*         = CapsFlag 0x0000_0000_0000_4000
    primitiveID*            = CapsFlag 0x0000_0000_0000_8000
    rendererMultithreaded*  = CapsFlag 0x0000_0000_0001_0000
    swapchain*              = CapsFlag 0x0000_0000_0002_0000
    textureBlit*            = CapsFlag 0x0000_0000_0004_0000
    textureCompareLEqual*   = CapsFlag 0x0000_0000_0008_0000
    textureCompareReserved* = CapsFlag 0x0000_0000_0010_0000
    textureCubeArray*       = CapsFlag 0x0000_0000_0020_0000
    textureDirectAccess*    = CapsFlag 0x0000_0000_0040_0000
    textureReadBack*        = CapsFlag 0x0000_0000_0080_0000
    texture2DArray*         = CapsFlag 0x0000_0000_0100_0000
    texture3D*              = CapsFlag 0x0000_0000_0200_0000
    transparentBackbuffer*  = CapsFlag 0x0000_0000_0400_0000
    vertexAttribHalf*       = CapsFlag 0x0000_0000_0800_0000
    vertexAttribUInt10*     = CapsFlag 0x0000_0000_1000_0000
    vertexID*               = CapsFlag 0x0000_0000_2000_0000
    viewportLayerArray*     = CapsFlag 0x0000_0000_4000_0000

