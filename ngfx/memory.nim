import common

type
    Memory* = object
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
proc alloc*(size): ptr Memory                                                            {.importc: "bgfx_alloc"           .}
proc copy*(data; size): ptr Memory                                                       {.importc: "bgfx_copy"            .}
proc make_ref*(data; size): ptr Memory                                                   {.importc: "bgfx_make_ref"        .}
proc make_ref_release*(data; size; release_fn: ReleaseFn; userdata: pointer): ptr Memory {.importc: "bgfx_make_ref_release".}
{.pop.}

{.push inline.}

proc copy*(data; size: int): ptr Memory =
    copy data, uint32 size

proc make_ref*[T](data: openArray[T]; release_fn: ReleaseFn = nil): ptr Memory =
    let size = data.len*(sizeof T)
    if release_fn == nil:
        make_ref data[0].addr, size
    else:
        make_ref_release data[0].addr, size, release_fn, nil

{.pop.}

