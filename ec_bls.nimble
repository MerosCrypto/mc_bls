version     = "1.0.0"
author      = "Luke Parker"
description = "A Nim Wrapper for Chia's BLS Library."
license     = "MIT"

installFiles = @[
    "ec_bls.nim"
]

installDirs = @[
    "ec_bls",
    "Chia"
]

requires "nim > 0.18.0"
