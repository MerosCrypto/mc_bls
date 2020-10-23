import common
import BLST

type PrivateKey* = Scalar

proc newPrivateKey*(
  key: string
): PrivateKey {.raises: [
  BLSError
].} =
  if key.len != SCALAR_LEN:
    raise newException(BLSError, "Invalid Private Key length.")
  parse(addr result, unsafeAddr key[0])

proc serialize*(
  key: PrivateKey
): string {.raises: [].} =
  result = newString(SCALAR_LEN)
  serialize(addr result[0], unsafeAddr key)
