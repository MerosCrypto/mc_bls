import os

version     = "2.0.5"
author      = "Luke Parker"
description = "A Nim Wrapper for Milagro."
license     = "MIT"

installDirs = @[
    "mc_bls"
]

installFiles = @[
    "LICENSE",
    "mc_bls.nim",
    "README.md"
]

requires "nim > 1.0.0"

after install:
    let gitExe = system.findExe("git")
    if gitExe == "":
        echo "failed to find git!"
        quit(1)

    let cmakeExe = system.findExe("cmake")
    if cmakeExe == "":
        echo "failed to find cmake!"
        quit(1)

    let makeExe = system.findExe("make")
    if makeExe == "":
        echo "failed to find make!"
        quit(1)

    let milagroDir = projectDir() / "incubator-milagro-crypto-c"
    rmDir milagroDir
    exec gitExe & " clone " & " https://github.com/apache/incubator-milagro-crypto-c " & milagroDir

    withDir milagroDir:
        mkDir "build"

    withDir milagroDir / "build":
        exec cmakeExe & " -DBUILD_SHARED_LIBS=OFF -DAMCL_CURVE=BLS381 .."
        exec makeExe