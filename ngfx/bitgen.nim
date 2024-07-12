# zlib License
#
# (C) 2024 carrexxii
#
# This software is provided 'as-is', without any express or implied
# warranty. In no event will the authors be held liable for any damages
# arising from the use of this software.
#
# Permission is granted to anyone to use this software for any purpose,
# including commercial applications, and to alter it and redistribute it
# freely, subject to the following restrictions:
#
# 1. The origin of this software must not be misrepresented; you must not
#    claim that you wrote the original software. If you use this software
#    in a product, an acknowledgment in the product documentation would be
#    appreciated but is not required.
# 2. Altered source versions must be plainly marked as such, and must not be
#    misrepresented as being the original software.
# 3. This notice may not be removed or altered from any source distribution.

import std/[macros, enumerate]
from std/strutils import join
from std/sequtils import map_it, filter_it

macro gen_bit_ops_inner(T: typedesc; flags: varargs[untyped]): untyped =
    result = new_nim_node nnkStmtList

    var defs = new_nim_node nnkConstSection
    for (i, flag) in enumerate flags:
        if $flag == "_":
            continue
        let lhs = flag.postfix "*"
        let rhs = nnkCommand.new_tree(T, infix(new_lit 1, "shl", new_lit i))
        defs.add nnkConstDef.new_tree(lhs, new_empty_node(), rhs)
    result.add defs

    let flag_count = flags.len
    let flag_list  = flags.filter_it($it != "_")
    let flag_strs  = flag_list.map_it $it
    result.add quote("@@") do:
        func `or`*(a, b: `@@T`) : `@@T` {.borrow, inline.}
        func `and`*(a, b: `@@T`): `@@T` {.borrow, inline.}
        func `==`*(a, b: `@@T`) : bool  {.borrow, inline.}
        func contains*(a, b: `@@T`): bool {.inline.} =
            (a and b) != `@@T` 0

        func `$`*(mask: `@@T`): string =
            var flags = new_seq_of_cap[string] `@@flag_count`
            for (i, flag) in enumerate `@@flag_strs`:
                if `@@flag_list`[i] in mask:
                    flags.add flag
            result = "{" & (flags.join ", ") & "}"

template gen_bit_ops*(T: typedesc; flags: varargs[untyped]): untyped =
    static: assert T is distinct
    T.gen_bit_ops_inner flags

