# This file is a part of NGfx. Copyright (C) 2024 carrexxii.
# It is distributed under the terms of the Apache License, Version 2.0.
# For a copy, see the LICENSE file or <https://apache.org/licenses/>.

import std/[sugar, with, enumerate]
from std/os        import `/`, parent_dir
from std/strformat import `&`
export sugar, with, enumerate, `&`, `/`

const CWD = current_source_path.parent_dir()
const BGFXPath* = CWD / "../lib/libbgfx.so"

proc red*    (s: string): string = &"\e[31m{s}\e[0m"
proc green*  (s: string): string = &"\e[32m{s}\e[0m"
proc yellow* (s: string): string = &"\e[33m{s}\e[0m"
proc blue*   (s: string): string = &"\e[34m{s}\e[0m"
proc magenta*(s: string): string = &"\e[35m{s}\e[0m"
proc cyan*   (s: string): string = &"\e[36m{s}\e[0m"

template flag_bitop*(op, type_for, base_type) =
    proc `op`*(a, b: type_for): type_for {.warning[HoleEnumConv]: off.} =
        type_for ((base_type a) or (base_type b))

import flags
export flags

