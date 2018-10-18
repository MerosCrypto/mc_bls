#BLS Objects.
import Objects

#Vectors.
import Vectors

#String utils standard lib.
import strutils

{.push, header: "bls.hpp".}

#Constructor.
proc aggregationInfoFromMsg(
    key: PublicKeyObject,
    msg: ptr uint8,
    len: uint
): AggregationInfo {.importcpp: "bls::AggregationInfo::FromMsg(@)".}

proc aggregationInfoFromSig(
    sig: SignatureObject
): ptr AggregationInfo {.importcpp: "#.GetAggregationInfo()".}

proc aggregateAggregationInfos(
    vec: AggregationInfoVector
): AggregationInfo {.importcpp: "bls::AggregationInfo::MergeInfos(@)".}

proc `==`*(
    lhs: AggregationInfo,
    rhs: AggregationInfo
): bool {.importcpp: "# == #".}

{.pop.}

#Constructor.
proc newAggregationInfoFromMsg*(
    key: PublicKey,
    msgArg: string
): AggregationInfo =
    #Extract the message.
    var msg: string = msgArg

    #Create the AggregationInfo.
    result = aggregationInfoFromMsg(
        key.data[],
        cast[ptr uint8](addr msg[0]),
        uint(msg.len)
    )

#Aggregate.
proc aggregate*(agInfos: seq[AggregationInfo]): AggregationInfo =
    aggregateAggregationInfos(agInfos)

proc getAggregationInfo*(
    sig: Signature
): AggregationInfo =
    aggregationInfoFromSig(sig.data[])[]
