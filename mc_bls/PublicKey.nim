import common
import BLST

type PublicKey* = G2

proc newPublicKey*(
  key: string
): PublicKey {.raises: [
  BLSError
].} =
  if key.len != G2_LEN:
    raise newException(BLSError, "Invalid Public Key length.")

  var affine: G2Affine
  if parse(addr affine, unsafeAddr key[0]) != 0:
    raise newException(BLSError, "Invalid Public Key.")
  fromAffine(addr result, addr affine)

proc toPublicKey*(
  key: Scalar
): PublicKey {.inline, raises: [].} =
  toPublicKey(addr result, unsafeAddr key)

proc isInf*(
  key: PublicKey
): bool {.inline, raises: [].} =
  isInf(unsafeAddr key)

proc aggregate*(
  keys: seq[PublicKey]
): PublicKey {.raises: [].} =
  if keys.len == 0:
    inf(addr result)
    return

  result = keys[0]
  for k in 1 ..< keys.len:
    if keys[k].isInf():
      inf(addr result)
      return
    add(addr result, addr result, unsafeAddr keys[k])

proc serialize*(
  key: PublicKey
): string {.raises: [].} =
  result = newString(G2_LEN)
  (addr result[0]).serialize(unsafeAddr key)
