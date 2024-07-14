# This file is a part of NGfx. Copyright (C) 2024 carrexxii.
# It is distributed under the terms of the Apache License, Version 2.0.
# For a copy, see the LICENSE file or <https://apache.org/licenses/>.

type SamplerFlag* = distinct uint32
func `and`*(a, b: SamplerFlag): SamplerFlag {.borrow.}
func `or`* (a, b: SamplerFlag): SamplerFlag {.borrow.}
func `shl`*(a, b: SamplerFlag): SamplerFlag {.borrow.}
const
    uMirror* = SamplerFlag 0x0000_0001
    uClamp*  = SamplerFlag 0x0000_0002
    uBorder* = SamplerFlag 0x0000_0003
    uShift*  = SamplerFlag 0
    uMask*   = SamplerFlag 0x0000_0003

    vMirror* = SamplerFlag 0x0000_0004
    vClamp*  = SamplerFlag 0x0000_0008
    vBorder* = SamplerFlag 0x0000_000C
    vShift*  = SamplerFlag 2
    vMask*   = SamplerFlag 0x0000_000C

    wMirror* = SamplerFlag 0x0000_0010
    wClamp*  = SamplerFlag 0x0000_0020
    wBorder* = SamplerFlag 0x0000_0030
    wShift*  = SamplerFlag 4
    wMask*   = SamplerFlag 0x0000_0030

    minPoint*       = SamplerFlag 0x0000_0040
    minAnisotropic* = SamplerFlag 0x0000_0080
    minShift*       = SamplerFlag 6
    minMask*        = SamplerFlag 0x0000_00C0

    magPoint*       = SamplerFlag 0x0000_0100
    magAnisotropic* = SamplerFlag 0x0000_0200
    magShift*       = SamplerFlag 8
    magMask*        = SamplerFlag 0x0000_0300

    mipPoint* = SamplerFlag 0x0000_0400
    mipShift* = SamplerFlag 10
    mipMask*  = SamplerFlag 0x0000_0400

    compareLess*    = SamplerFlag 0x0001_0000
    compareLEqual*  = SamplerFlag 0x0002_0000
    compareEqual*   = SamplerFlag 0x0003_0000
    compareGEqual*  = SamplerFlag 0x0004_0000
    compareGreater* = SamplerFlag 0x0005_0000
    compareNEqual*  = SamplerFlag 0x0006_0000
    compareNever*   = SamplerFlag 0x0007_0000
    compareAlways*  = SamplerFlag 0x0008_0000
    compareShift*   = SamplerFlag 16
    compareMask*    = SamplerFlag 0x000F_0000

    borderColourShift* = SamplerFlag 24
    borderColourMask*  = SamplerFlag 0x0F00_0000

    none*           = SamplerFlag 0x0000_0000
    samplerStencil* = SamplerFlag 0x0010_0000

    point*     = minPoint or magPoint or mipPoint
    uvwMirror* = uMirror  or vMirror  or wMirror
    uvwClamp*  = uClamp   or vClamp   or wClamp
    uvwBorder* = uBorder  or vBorder  or wBorder
    bitsMask*  = uMask   or vMask   or wMask   or
                 minMask or magMask or mipMask or
                 compareMask

func border_colour*(x: SamplerFlag): SamplerFlag = (x shl borderColourShift) and borderColourMask

