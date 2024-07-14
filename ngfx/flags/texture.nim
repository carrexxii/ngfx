# This file is a part of NGfx. Copyright (C) 2024 carrexxii.
# It is distributed under the terms of the Apache License, Version 2.0.
# For a copy, see the LICENSE file or <https://apache.org/licenses/>.

type TextureFlag* = distinct uint64
func `and`*(a, b: TextureFlag): TextureFlag {.borrow.}
func `or`* (a, b: TextureFlag): TextureFlag {.borrow.}
const
    none*         = TextureFlag 0x0000_0000_0000_0000
    msaaSample*   = TextureFlag 0x0000_0008_0000_0000
    rt*           = TextureFlag 0x0000_0010_0000_0000
    computeWrite* = TextureFlag 0x0000_1000_0000_0000
    srgb*         = TextureFlag 0x0000_2000_0000_0000
    blitDst*      = TextureFlag 0x0000_4000_0000_0000
    readBack*     = TextureFlag 0x0000_8000_0000_0000

    rtMSAAX2*    = TextureFlag 0x0000_0020_0000_0000
    rtMSAAX4*    = TextureFlag 0x0000_0030_0000_0000
    rtMSAAX8*    = TextureFlag 0x0000_0040_0000_0000
    rtMSAAX16*   = TextureFlag 0x0000_0050_0000_0000
    rtMSAAShift* = TextureFlag 36
    rtMSAAMask*  = TextureFlag 0x0000_0070_0000_0000

    rtWriteOnly* = TextureFlag 0x0000_0080_0000_0000
    rtShift*     = TextureFlag 36
    rtMask*      = TextureFlag 0x0000_00F0_0000_0000

