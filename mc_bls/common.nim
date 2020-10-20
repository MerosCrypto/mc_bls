template nilIfEmpty*[T](
  data: openArray[T]
): ptr byte =
  if data.len == 0:
    cast[ptr byte](nil)
  else:
    cast[ptr byte](unsafeAddr data[0])

type BLSError* = object of CatchableError
