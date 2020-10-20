import BLST
import common

type AggregationInfo* = FP12

proc newAggregationInfo*(
  key: G2,
  msg: string,
  dst: string
): AggregationInfo {.raises: [
  BLSError
].} =
  if (unsafeAddr key).isInf():
    raise newException(BLSError, "Infinite Public Key passed to newAggregationInfo.")

  var
    msgPoint: G1
    affineKey: G2Affine
    affineMsg: G1Affine
  hashToCurve(
    unsafeAddr msgPoint,
    nilIfEmpty(msg),
    csize_t(msg.len),
    nilIfEmpty(dst),
    csize_t(dst.len),
    nil,
    0
  )
  toAffine(addr affineKey, unsafeAddr key)
  toAffine(addr affineMsg, addr msgPoint)

  pair(addr result, unsafeAddr affineKey, addr affineMsg)

proc aggregate*(
  agInfos: seq[AggregationInfo]
): AggregationInfo {.raises: [
  BLSError
].} =
  if agInfos.len == 0:
    raise newException(BLSError, "No Aggregation Infos passed to aggregate.")

  result = agInfos[0]
  for i in 1 ..< agInfos.len:
    mul(addr result, addr result, unsafeAddr agInfos[i])
