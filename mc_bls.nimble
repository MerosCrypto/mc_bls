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
    let milagroDir = projectDir() & os.DirSep & "incubator-milagro-crypto-c"

    rmDir milagroDir

    exec "git clone https://github.com/apache/incubator-milagro-crypto-c " & milagroDir

    withDir milagroDir:
        mkDir "build"

    withDir milagroDir & os.DirSep & "build":
        exec "cmake -DBUILD_SHARED_LIBS=OFF -DAMCL_CURVE=BLS381 .."
        exec "make"