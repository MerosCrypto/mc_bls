#BLS Objects.
import Objects

#Vectors.
import Vectors

#String utils standard lib.
import strutils

{.push, header: "bls.hpp".}

#Constructor.
func aggregationInfoFromMsg(
    key: PublicKeyObject,
    msg: ptr uint8,
    len: uint
): AggregationInfoObject {.importcpp: "bls::AggregationInfo::FromMsg(@)".}

func aggregationInfoFromSig(
    sig: SignatureObject
): AggregationInfo {.importcpp: "#.GetAggregationInfo()".}

func aggregateAggregationInfos(
    vec: AggregationInfoVector
): AggregationInfoObject {.importcpp: "bls::AggregationInfo::MergeInfos(@)".}

func `==`*(
    lhs: AggregationInfoObject,
    rhs: AggregationInfoObject
): bool {.importcpp: "# == #".}

func `!=`*(
    lhs: AggregationInfoObject,
    rhs: AggregationInfoObject
): bool {.importcpp: "# != #".}

{.pop.}

#Constructor.
proc newAggregationInfoFromMsg*(
    key: PublicKey,
    msgArg: string
): AggregationInfo =
    #Extract the message.
    var msg: string = msgArg

    #Allocate the AggregationInfo.
    result = cast[AggregationInfo](alloc0(sizeof(AggregationInfoObject)))

    #Create the AggregationInfo.
    result[] = aggregationInfoFromMsg(
        key[],
        cast[ptr uint8](addr msg[0]),
        uint(msg.len)
    )

#Aggregate.
proc aggregate*(agInfos: seq[AggregationInfo]): AggregationInfo =
    if agInfos.len == 0:
        return nil
    elif agInfos.len == 1:
        return agInfos[0]

    #Allocate the AggregationInfo.
    result = cast[AggregationInfo](alloc0(sizeof(AggregationInfoObject)))

    result[] = aggregateAggregationInfos(agInfos.toVector())

func `==`*(
    lhs: AggregationInfo,
    rhs: AggregationInfo
): bool =
    lhs[] == rhs[]

func `!=`*(
    lhs: AggregationInfo,
    rhs: AggregationInfo
): bool =
    lhs[] != rhs[]

proc getAggregationInfo*(
    sig: Signature
): AggregationInfo =
    #Allocate the AggregationInfo.
    result = cast[AggregationInfo](alloc0(sizeof(AggregationInfoObject)))

    result[] = aggregationInfoFromSig(sig[])[]
