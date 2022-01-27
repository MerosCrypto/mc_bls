import stint

import common
import BLST

type PrivateKey* = Scalar

const R: StUInt[512] = "0x000000000000000000000000000000000000000000000000000000000000000073EDA753299D7D483339D80809A1D80553BDA402FFFE5BFEFFFFFFFF00000001".parse(StUInt[512], 16)

proc newPrivateKey*(
  keyArg: string
): PrivateKey {.raises: [
  BLSError
].} =
  if (keyArg.len != SCALAR_LEN) and (keyArg.len != (SCALAR_LEN * 2)):
    raise newException(BLSError, "Invalid Private Key length.")
  #If it's not already 64 bytes, expand it to be.
  #Simplifies the below scalar reduction.
  var prefix: string = ""
  prefix.setLen((SCALAR_LEN * 2) - keyArg.len)
  let key = prefix & keyArg

  #[
  Mod by the curve order (r). Needed to create a valid scalar.
  blst doesn't provide a scalar modulus function, unfortunately, hence this.
  ]#
  var keyArr: array[SCALAR_LEN * 2, byte]
  try:
    #This line is a horrendous hack.
    keyArr = (StUInt[SCALAR_LEN * 8 * 2].fromBytesBE(cast[seq[byte]](key)) mod R).toByteArrayBE()
  except DivByZeroError as e:
    doAssert(false, "Divided by zero when applying the moduli of the curve order: " & e.msg)
  parse(addr result, addr keyArr[32])

proc serialize*(
  key: PrivateKey
): string {.raises: [].} =
  result = newString(SCALAR_LEN)
  serialize(addr result[0], unsafeAddr key)
