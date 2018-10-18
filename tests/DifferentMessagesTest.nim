#BLS lib.
import ../BLS

var
    #Define the Keys.
    privs: seq[PrivateKey] = @[
        newPrivateKeyFromSeed("0"),
        newPrivateKeyFromSeed("1"),
        newPrivateKeyFromSeed("2"),
        newPrivateKeyFromSeed("3"),
        newPrivateKeyFromSeed("4")
    ]
    pubs: seq[PublicKey] = @[
        privs[0].getPublicKey(),
        privs[1].getPublicKey(),
        privs[2].getPublicKey(),
        privs[3].getPublicKey(),
        privs[4].getPublicKey()
    ]
    #Message.
    msgs: seq[string] = @[
        "0",
        "1",
        "2",
        "3",
        "4"
    ]
    #Sign the message with each Private Key.
    sigs: seq[Signature] = @[
        privs[0].sign(msgs[0]),
        privs[1].sign(msgs[1]),
        privs[2].sign(msgs[2]),
        privs[3].sign(msgs[3]),
        privs[4].sign(msgs[4])
    ]
    #Aggregate the Signatures.
    sig1: Signature = sigs.aggregate()
    #Stringify the sig and read it back.
    sig2: Signature = newSignatureFromBytes(sig1.toString())
    #Create the Aggregation Infos.
    agInfos: seq[AggregationInfo] = @[
        newAggregationInfoFromMsg(pubs[0], msgs[0]),
        newAggregationInfoFromMsg(pubs[1], msgs[1]),
        newAggregationInfoFromMsg(pubs[2], msgs[2]),
        newAggregationInfoFromMsg(pubs[3], msgs[3]),
        newAggregationInfoFromMsg(pubs[4], msgs[4]),
    ]
    #Aggregate the Aggregation Infos.
    agInfo: AggregationInfo = agInfos.aggregate()

#Add the Aggregation Info to the signature.
sig2.setAggregationInfo(agInfo)

#Test the signature.
assert(sig1.toString() == sig2.toString())
assert(sig2.verify())
