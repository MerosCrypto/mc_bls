version     = "2.0.1"
author      = "Luke Parker"
description = "A Nim Wrapper for Milagro."
license     = "MIT"

installDirs = @[
    "mc_bls",
    "incubator-milagro-crypto-c"
]

installFiles = @[
    "LICENSE",
    "mc_bls.nim",
    "README.md"
]

requires "nim > 1.0.0"
