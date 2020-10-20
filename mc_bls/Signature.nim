import common
import BLST

type Signature* = G1

proc newSignature*(
  sig: string
): Signature {.raises: [
  BLSError
].} =
  if sig.len != G1_LEN:
    raise newException(BLSError, "Invalid Signature length.")

  var affine: G1Affine
  if parse(addr affine, unsafeAddr sig[0]) != 0:
    raise newException(BLSError, "Invalid Signature.")
  fromAffine(addr result, addr affine)

proc isInf*(
  sig: Signature
): bool {.inline, raises: [].} =
  isInf(unsafeAddr sig)

proc serialize*(
  sig: Signature
): string {.raises: [].} =
  result = newString(G1_LEN)
  (addr result[0]).serialize(unsafeAddr sig)

proc sign*(
  key: Scalar,
  msg: string,
  dst: string
): Signature {.raises: [].} =
  hashToCurve(
    addr result,
    nilIfEmpty(msg),
    csize_t(msg.len),
    nilIfEmpty(dst),
    csize_t(dst.len),
    nil,
    0
  )
  sign(addr result, addr result, unsafeAddr key)

proc aggregate*(
  sigs: seq[Signature]
): Signature {.raises: [].} =
  if sigs.len == 0:
    inf(addr result)
    return

  result = sigs[0]
  for k in 1 ..< sigs.len:
    if sigs[k].isInf():
      inf(addr result)
      return
    add(addr result, addr result, unsafeAddr sigs[k])

proc verify*(
  sig: Signature,
  agInfo: FP12
): bool {.raises: [].} =
  if sig.isInf():
    return false

  var
    expected: FP12 = FP12()
    affineSig: G1Affine
  toAffine(addr affineSig, unsafeAddr sig)
  pair(addr expected, g2AffineGenerator(), addr affineSig)
  conjugate(addr expected)

  #Don't mutate this either.
  var actual: FP12 = agInfo
  mul(addr actual, addr actual, addr expected)
  finalize(addr actual, addr actual)

  result = (addr actual).isOne()
