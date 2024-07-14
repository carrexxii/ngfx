# This file is a part of NGfx. Copyright (C) 2024 carrexxii.
# It is distributed under the terms of the Apache License, Version 2.0.
# For a copy, see the LICENSE file or <https://apache.org/licenses/>.

type ResolveFlag* = distinct uint8
const
    none*        = ResolveFlag 0x00
    autoGenMips* = ResolveFlag 0x01

