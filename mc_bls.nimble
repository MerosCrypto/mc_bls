import os

version   = "3.0.1"
author    = "Luke Parker"
description = "A Nim Wrapper for blst."
license   = "MIT"

installDirs = @[
  "mc_bls",
  "blst"
]

installFiles = @[
  "mc_bls.nim"
]

requires "nim > 1.0.0"
requires "stint"

before install:
  let gitExe: string = system.findExe("git")
  if gitExe == "":
    echo "Failed to find executable `git`."
    quit(1)

  let makeExe: string = system.findExe("make")
  if makeExe == "":
    echo "Failed to find executable `make`."
    quit(1)

  withDir thisDir() / "blst" / "build":
    exec $(thisDir() / "blst" / "build.sh")
