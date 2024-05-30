from std/strformat import `&`
from std/sugar     import `->`
export `&`, `->`

const BGFXPath* = "lib/libbgfx.so"

type BGFXError* = object of CatchableError

proc red*    (s: string): string = "\e[31m" & s & "\e[0m"
proc green*  (s: string): string = "\e[32m" & s & "\e[0m"
proc yellow* (s: string): string = "\e[33m" & s & "\e[0m"
proc blue*   (s: string): string = "\e[34m" & s & "\e[0m"
proc magenta*(s: string): string = "\e[35m" & s & "\e[0m"
proc cyan*   (s: string): string = "\e[36m" & s & "\e[0m"

# {.hint[XDeclaredButNotUsed]: off.}
template flag_bitop*(op, type_for, base_type) =
    proc `op`*(a, b: type_for): type_for {.warning[HoleEnumConv]: off.} =
        type_for ((base_type a) or (base_type b))

import flags
export flags
