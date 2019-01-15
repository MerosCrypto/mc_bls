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
): AggregationInfo {.importcpp: "bls::AggregationInfo::FromMsg(@)".}

func aggregationInfoFromSig(
    sig: SignatureObject
): ptr AggregationInfo {.importcpp: "#.GetAggregationInfo()".}

func aggregateAggregationInfos(
    vec: AggregationInfoVector
): AggregationInfo {.importcpp: "bls::AggregationInfo::MergeInfos(@)".}

func `==`*(
    lhs: AggregationInfo,
    rhs: AggregationInfo
): bool {.importcpp: "# == #".}

{.pop.}

#Constructor.
func newAggregationInfoFromMsg*(
    key: PublicKey,
    msgArg: string
): AggregationInfo =
    #Extract the message.
    var msg: string = msgArg

    #Create the AggregationInfo.
    result = aggregationInfoFromMsg(
        key[],
        cast[ptr uint8](addr msg[0]),
        uint(msg.len)
    )

#Aggregate.
func aggregate*(agInfos: seq[AggregationInfo]): AggregationInfo =
    if agInfos.len == 1:
        return agInfos[0]

    aggregateAggregationInfos(agInfos)

func getAggregationInfo*(
    sig: Signature
): AggregationInfo =
    aggregationInfoFromSig(sig[])[]
