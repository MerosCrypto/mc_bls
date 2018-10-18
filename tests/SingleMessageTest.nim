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
    #Aggregate the Public Keys.
    pub: PublicKey = pubs.aggregate()
    #Message.
    msg: string = "message"
    #Sign the message with each Private Key.
    sigs: seq[Signature] = @[
        privs[0].sign(msg),
        privs[1].sign(msg),
        privs[2].sign(msg),
        privs[3].sign(msg),
        privs[4].sign(msg)
    ]
    #Aggregate the Signatures.
    sig1: Signature = sigs.aggregate()
    #Stringify the sig and read it back.
    sig2: Signature = newSignatureFromBytes(sig1.toString())
    #Create the Aggregation Info.
    agInfo: AggregationInfo = newAggregationInfoFromMsg(pub, msg)

#Add the Aggregation Info to the signature.
sig2.setAggregationInfo(agInfo)

#Test the signature.
assert(sig1.toString() == sig2.toString())
assert(sig2.verify())
