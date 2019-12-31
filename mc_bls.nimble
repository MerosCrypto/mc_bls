import os

version     = "2.0.8"
author      = "Luke Parker"
description = "A Nim Wrapper for Milagro."
license     = "MIT"

installDirs = @[
    "mc_bls",
    "incubator-milagro-crypto-c"
]

installFiles = @[
    "mc_bls.nim"
]

requires "nim > 1.0.0"

before install:
    let gitExe: string = system.findExe("git")
    if gitExe == "":
        echo "Failed to find executable `git`."
        quit(1)

    let cmakeExe: string = system.findExe("cmake")
    if cmakeExe == "":
        echo "Failed to find executable `cmake`."
        quit(1)

    let makeExe: string = system.findExe("make")
    if makeExe == "":
        echo "Failed to find executable `make`."
        quit(1)

    let milagroDir: string = projectDir() / "incubator-milagro-crypto-c"
    rmDir milagroDir
    exec gitExe & " clone " & " https://github.com/apache/incubator-milagro-crypto-c " & milagroDir

    withDir milagroDir:
        mkDir "build"

    withDir milagroDir / "build":
        exec cmakeExe & " -DBUILD_SHARED_LIBS=OFF -DAMCL_CURVE=BLS381 .."
        exec makeExe
