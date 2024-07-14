# This file is a part of NGfx. Copyright (C) 2024 carrexxii.
# It is distributed under the terms of the Apache License, Version 2.0.
# For a copy, see the LICENSE file or <https://apache.org/licenses/>.

type CapsFormatFlag* = distinct uint32
func `and`*(a, b: CapsFormatFlag): CapsFormatFlag {.borrow.}
func `or`* (a, b: CapsFormatFlag): CapsFormatFlag {.borrow.}
const
    textureNone*            = CapsFormatFlag 0x0000_0000
    texture2D*              = CapsFormatFlag 0x0000_0001
    texture2DSRGB*          = CapsFormatFlag 0x0000_0002
    texture2DEmulated*      = CapsFormatFlag 0x0000_0004
    texture3D*              = CapsFormatFlag 0x0000_0008
    texture3DSRGB*          = CapsFormatFlag 0x0000_0010
    texture3DEmulated*      = CapsFormatFlag 0x0000_0020
    textureCube*            = CapsFormatFlag 0x0000_0040
    textureCubeSRGB*        = CapsFormatFlag 0x0000_0080
    textureCubeEmulated*    = CapsFormatFlag 0x0000_0100
    textureVertex*          = CapsFormatFlag 0x0000_0200
    textureImageRead*       = CapsFormatFlag 0x0000_0400
    textureImageWrite*      = CapsFormatFlag 0x0000_0800
    textureFramebuffer*     = CapsFormatFlag 0x0000_1000
    textureFramebufferMSAA* = CapsFormatFlag 0x0000_2000
    textureMSAA*            = CapsFormatFlag 0x0000_4000
    textureMipAutogen*      = CapsFormatFlag 0x0000_8000

