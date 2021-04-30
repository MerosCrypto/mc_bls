import stint

import common
import BLST

type PrivateKey* = Scalar

const R: StUInt[256] = "0x73EDA753299D7D483339D80809A1D80553BDA402FFFE5BFEFFFFFFFF00000001".parse(StUInt[256], 16)

proc newPrivateKey*(
  key: string
): PrivateKey {.raises: [
  BLSError
].} =
  if key.len != SCALAR_LEN:
    raise newException(BLSError, "Invalid Private Key length.")

  #[
  Mod by the curve order (r). Needed to create a valid scalar.
  blst doesn't provide a scalar modulus function, unfortunately; hence this.
  ]#
  var keyArr: array[SCALAR_LEN, byte]
  try:
    keyArr = (StUInt[SCALAR_LEN * 8].fromBytesBE(cast[seq[byte]](key)) mod R).toBytesBE()
  except DivByZeroError as e:
    doAssert(false, "Divided by zero when applying the moduli of the curve order: " & e.msg)
  parse(addr result, unsafeAddr keyArr[0])

proc serialize*(
  key: PrivateKey
): string {.raises: [].} =
  result = newString(SCALAR_LEN)
  serialize(addr result[0], unsafeAddr key)
