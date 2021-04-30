const
  SCALAR_LEN*: int = 32
  G1_LEN*: int = 48
  G2_LEN*: int = 96

{.push header: "blst.h".}

type
  ByteLike* = byte or char

  Scalar* {.importc: "blst_scalar", bycopy.} = object

  FP12* {.importc: "blst_fp12", bycopy.} = object

  G1* {.importc: "blst_p1", bycopy.} = object
  G1Affine* {.importc: "blst_p1_affine", bycopy.} = object

  G2* {.importc: "blst_p2", bycopy.} = object
  G2Affine* {.importc: "blst_p2_affine", bycopy.} = object

#Scalar functions.
proc serialize*(
  res: ptr ByteLike,
  x: ptr Scalar
) {.importc: "blst_bendian_from_scalar".}

proc parse*(
  res: ptr Scalar,
  x: ptr ByteLike
) {.importc: "blst_scalar_from_bendian".}

#FP12 functions.
proc pair*(
  pairing: ptr FP12,
  g2: ptr G2Affine,
  g1: ptr G1Affine
) {.importc: "blst_miller_loop".}

proc conjugate*(
  x: ptr FP12,
) {.importc: "blst_fp12_conjugate".}

proc mul*(
  res: ptr FP12,
  x: ptr FP12,
  y: ptr FP12
) {.importc: "blst_fp12_mul".}

proc finalize*(
  res: ptr FP12,
  pairing: ptr FP12
) {.importc: "blst_final_exp".}

proc isOne*(
  x: ptr FP12
): bool {.importc: "blst_fp12_is_one".}

#G1 functions.
proc isInf*(
  point: ptr G1
): bool {.importc: "blst_p1_is_inf".}

proc add*(
  res: ptr G1,
  x: ptr G1,
  y: ptr G1
) {.importc: "blst_p1_add".}

proc mul*(
  res: ptr G1,
  x: ptr G1,
  y: ptr Scalar,
  bits: csize_t
) {.importc: "blst_p1_mult".}

proc toAffine*(
  res: ptr G1Affine,
  x: ptr G1
) {.importc: "blst_p1_to_affine".}

proc fromAffine*(
  res: ptr G1,
  x: ptr G1Affine
) {.importc: "blst_p1_from_affine".}

proc hashToCurve*(
  res: ptr G1,
  msg: ptr ByteLike,
  msgLen: csize_t,
  dst: ptr ByteLike,
  dstLen: csize_t,
  aug: ptr ByteLike,
  augLen: csize_t
) {.importc: "blst_hash_to_g1".}

proc sign*(
  sig: ptr G1,
  msg: ptr G1,
  key: ptr Scalar
) {.importc: "blst_sign_pk_in_g2".}

proc serialize*(
  res: ptr ByteLike,
  x: ptr G1
) {.importc: "blst_p1_compress".}

proc parse*(
  res: ptr G1Affine,
  x: ptr ByteLike
): cint {.importc: "blst_p1_uncompress".}

#G2 Functions.
proc g2AffineGenerator*(): ptr G2Affine {.importc: "blst_p2_affine_generator".}

proc isInf*(
  point: ptr G2
): bool {.importc: "blst_p2_is_inf".}

proc toPublicKey*(
  res: ptr G2,
  x: ptr Scalar
) {.importc: "blst_sk_to_pk_in_g2".}

proc add*(
  res: ptr G2,
  x: ptr G2,
  y: ptr G2
) {.importc: "blst_p2_add".}

proc mul*(
  res: ptr G2,
  x: ptr G2,
  y: ptr Scalar,
  bits: csize_t
) {.importc: "blst_p2_mult".}

proc toAffine*(
  res: ptr G2Affine,
  x: ptr G2
) {.importc: "blst_p2_to_affine".}

proc fromAffine*(
  res: ptr G2,
  x: ptr G2Affine
) {.importc: "blst_p2_from_affine".}

proc serialize*(
  res: ptr ByteLike,
  x: ptr G2
) {.importc: "blst_p2_compress".}

proc parse*(
  res: ptr G2Affine,
  x: ptr ByteLike
): cint {.importc: "blst_p2_uncompress".}

proc inGroup*(
  p: ptr G2Affine
): bool {.importc: "blst_p2_affine_in_g2".}

{.pop.}

proc inf*(
  res: ptr G1
) {.raises: [].} =
  res[] = G1()

proc inf*(
  res: ptr G2
) {.raises: [].} =
  res[] = G2()
