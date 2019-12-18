#Aggregation Info library.

import Milagro/G
import Milagro/HashToG
import Milagro/Pairing

import Common
import PublicKey

type AggregationInfo* = object
    value*: FP12

#AggregationInfo constructors.
proc newAggregationInfo*(
    keyArg: PublicKey,
    msgArg: string
): AggregationInfo {.raises: [
    BLSError
].} =
    if keyArg.isInf:
        raise newException(BLSError, "Infinite Public Key passed to newAggregationInfo.")

    var
        key: PublicKey = keyArg
        msg: G1 = msgToG(msgArg)
    pair(addr result.value, addr key.value, addr msg)

proc newAggregationInfo*(
    keys: seq[PublicKey],
    msg: string
): AggregationInfo {.inline, raises: [
    BLSError
].} =
    newAggregationInfo(keys.aggregate(), msg)

#Aggregate Aggregation Infos.
proc aggregate*(
    agInfosArg: seq[AggregationInfo]
): AggregationInfo {.raises: [
    BLSError
].} =
    if agInfosArg.len == 0:
        raise newException(BLSError, "No Aggregation Infos passed to aggregate.")

    var agInfos: seq[AggregationInfo] = agInfosArg
    for i in 1 ..< agInfos.len:
        (addr agInfos[0].value).mul(addr agInfos[i].value)
    return agInfos[0]
