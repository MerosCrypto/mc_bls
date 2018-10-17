#BLS lib.
import ../BLS

var
    #Create the key pair.
    priv: PrivateKey = newPrivateKeyFromSeed("seed")
    pub: PublicKey = priv.getPublicKey
    #Define the message.
    msg: string = "message"
    #Sign the message.
    sig1: Signature = priv.sign(msg)
    #Stringify it and parse it back.
    sig2: Signature = newSignatureFromBytes($sig1)
    #Create the Aggregation Info.
    agInfo: AggregationInfo = newAggregationInfoFromMsg(pub, msg)

#Add the Aggregation Info to the signature.
sig2.setAggregationInfo(agInfo)

#Test the signature.
assert(sig2.verify())
