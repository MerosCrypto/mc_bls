#BLS lib.
import ../ec_bls

var
    #Create the key pair.
    priv: PrivateKey = newPrivateKeyFromSeed("seed")
    pub: PublicKey = priv.getPublicKey()
    #Define the message.
    msg: string = "message"
    #Sign the message.
    sig1: Signature = priv.sign(msg)
    #Stringify it and parse it back.
    sig2: Signature = newSignatureFromBytes($sig1)
    #Create the Aggregation Info.
    agInfo: AggregationInfo = newAggregationInfoFromMsg(pub, msg)
    #Null Signature.
    sigNil: Signature = nil

#Add the Aggregation Info to the signature.
sig2.setAggregationInfo(agInfo)

#Test the signature.
assert(sig1.getAggregationInfo() == sig2.getAggregationInfo())
assert(sig1.toString() == sig2.toString())
assert(sig2.verify())

#Test null signatures.
assert(sigNil == sigNil)
assert(sigNil != sig1)

assert(sigNil.toString() == newString(96))
assert(newSignatureFromBytes(sigNil.toString()) == nil)
assert(newSignatureFromBytes($sigNil) == nil)
