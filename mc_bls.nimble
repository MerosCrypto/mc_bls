import os

version   = "3.0.0"
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

before install:
  let gitExe: string = system.findExe("git")
  if gitExe == "":
    echo "Failed to find executable `git`."
    quit(1)

  let makeExe: string = system.findExe("make")
  if makeExe == "":
    echo "Failed to find executable `make`."
    quit(1)

  let blstDir: string = projectDir() / "blst"
  rmDir blstDir
  exec gitExe & " clone " & " https://github.com/supranational/blst " & blstDir

  withDir blstDir / "build":
    exec $(projectDir() / "blst" / "build.sh")
