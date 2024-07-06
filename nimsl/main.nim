import std/[macros, tables, strutils, sequtils]

type
    ShaderKind* = enum
        Vertex
        Fragment

    ShaderBackend* = enum
        Nim
        GLSL

type
    Vec2 = array[2, float32]
    Vec3 = array[3, float32]

    Input[T]  = T
    Output[T] = T

    Shader = object
        kind   : ShaderKind
        inputs : Table[string, tuple[kind: string, loc: int]]
        outputs: Table[string, tuple[kind: string, loc: int]]
        body   : NimNode

proc write_node(backend: ShaderBackend; node: NimNode): string

proc convert_type(backend: ShaderBackend; t: string): string =
    case backend
    of Nim: t
    of GLSL:
        case t
        of $Vec2: "vec2"
        of $Vec3: "vec3"
        else:
            echo "Invalid type"
            quit 1

proc write_input(backend: ShaderBackend; name, kind: string; loc: int): string =
    let fmt = case backend
    of Nim : "var $1: $2"
    of GLSL: "layout(location = $3) in $2 $1;"
    fmt % [name, backend.convert_type kind, $loc] & "\n"

proc write_output(backend: ShaderBackend; name, kind: string; loc: int): string =
    let fmt = case backend
    of Nim : "var $1: $2"
    of GLSL: "layout(location = $3) out $2 $1;"
    fmt % [name, backend.convert_type kind, $loc] & "\n"

proc write_assign(backend: ShaderBackend; lhs, rhs: NimNode): string =
    case lhs.kind
    of nnkIdent:
        result = $lhs & " = " & (backend.write_node rhs)
    else:
        echo "Failed to write assign for " & (repr lhs) & (repr rhs)
        quit 1
    result &= "\n"

proc write_node(backend: ShaderBackend; node: NimNode): string =
    case node.kind
    of nnkIdent: $node
    of nnkAsgn : backend.write_assign node[0], node[1]
    else:
        echo "Failed to write node $1 ($2)" % [repr node, $node.kind]
        quit 1

proc parse_inner(kind: ShaderKind; backend: ShaderBackend; body: NimNode): string =
    result = new_string_of_cap 10*1024
    var shader = Shader(kind: kind, body: new_nim_node nnkStmtList)
    var in_loc  = 0
    var out_loc = 0
    for node in body:
        case node.kind
        of nnkLetSection:
            for assign in node:
                let name = $assign[0]
                let kind = $assign[1][1]
                if name in shader.inputs or name in shader.outputs:
                    assert false

                case $assign[1][0]
                of $Input:
                    shader.inputs[name] = (kind, in_loc)
                    inc in_loc
                of $Output:
                    shader.outputs[name] = (kind, out_loc)
                    inc out_loc
                else: discard
        of nnkAsgn:
            shader.body.add node
        else:
            echo "Failed on " & repr node
            quit 1

    var idents: Table[string, string]
    for k, v in shader.inputs:
        result &= backend.write_input(k, v.kind, v.loc)
        idents[k] = v.kind
    for k, v in shader.outputs:
        result &= backend.write_output(k, v.kind, v.loc)
        idents[k] = v.kind

    for node in shader.body:
        result &= backend.write_node node

macro parse(kind: static[ShaderKind]; backend: static[ShaderBackend]; body: untyped): string =
    new_lit kind.parse_inner(backend, body)

macro parse_all(kind: static[ShaderKind]; body: untyped) =
    for b in ShaderBackend:
        echo "======= " & $b & " ======="
        echo new_lit kind.parse_inner(b, body)

Vertex.parse_all:
    let
        Vpos   : Input[Vec3]
        Vnormal: Input[Vec3]
        Vuv    : Input[Vec2]
        Fnormal: Output[Vec3]
        Fuv    : Output[Vec3]

    Fnormal = Vnormal
    Fuv     = Vuv
    result  = Vpos

