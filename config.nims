from std/strformat import `&`

const
    BXTag   = "0481ee10634c6f30c87c5de7279a9d6634e70a72"
    BImgTag = ""
    BGFXTag = ""

const
    LibDir  = "./lib"
    TestDir = "./tests"

task test, "Run tests":
    exec &"nim c -r -p:. --passL:-lSDL2 -o:test {TestDir}/helloworld.nim"

task build_libs, "Build libraries":
    with_dir &"{LibDir}/bgfx":
        exec &"make -j linux"
        exec &"make -j tools"
    exec &"cp {LibDir}/bgfx/.build/linux64_gcc/bin/libbgfx-shared-libDebug.so ./libbgfx.so"
    exec &"cp {LibDir}/bgfx/src/bgfx_shader.sh ./"
    exec &"cp -r {LibDir}/bgfx/tools/bin/linux/* {LibDir}"

task restore, "Fetch and build dependencies":
    exec "git submodule update --init --remote --merge --recursive -j 8"
    with_dir &"{LibDir}/bx"  : exec &"git checkout {BXTag}"
    with_dir &"{LibDir}/bimg": exec &"git checkout {BImgTag}"
    with_dir &"{LibDir}/bgfx": exec &"git checkout {BGFXTag}"
    build_libs_task()
