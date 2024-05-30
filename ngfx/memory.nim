import common

type
    Memory* = ptr MemoryObj
    MemoryObj* = object
        data*: ptr uint8
        size*: uint32

    ReleaseFn* = (mem: pointer, userdata: pointer) -> void

    AllocatorInterface* = object
        vtable*: ptr AllocatorVTable
    AllocatorVTable* = object
        realloc*: (this: ptr AllocatorInterface, p: pointer, size: csize_t, align: csize_t, file: cstring, line: uint32) -> pointer

#[ -------------------------------------------------------------------- ]#

using
    data: pointer
    size: uint32

{.push dynlib: BGFXPath.}
proc alloc*(size): Memory                                                            {.importc: "bgfx_alloc"           .}
proc copy*(data; size): Memory                                                       {.importc: "bgfx_copy"            .}
proc make_ref*(data; size): Memory                                                   {.importc: "bgfx_make_ref"        .}
proc make_ref_release*(data; size; release_fn: ReleaseFn; userdata: pointer): Memory {.importc: "bgfx_make_ref_release".}
{.pop.}

{.push inline, raises: [].}

proc copy*(data; size: int): Memory =
    copy(data, uint32 size)

proc make_ref*[T](data: openArray[T]; release_fn: ReleaseFn = nil): Memory =
    let size = data.len*(sizeof T)
    if release_fn == nil:
        make_ref(data[0].addr, size)
    else:
        make_ref_release(data[0].addr, size, release_fn, nil)

{.pop.}
