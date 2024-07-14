# This file is a part of NGfx. Copyright (C) 2024 carrexxii.
# It is distributed under the terms of the Apache License, Version 2.0.
# For a copy, see the LICENSE file or <https://apache.org/licenses/>.

type CubeMapFlag* = distinct uint8
const
    positiveX* = CubeMapFlag 0x00
    negativeX* = CubeMapFlag 0x01
    positiveY* = CubeMapFlag 0x02
    negativeY* = CubeMapFlag 0x03
    positiveZ* = CubeMapFlag 0x04
    negativeZ* = CubeMapFlag 0x05

