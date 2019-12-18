#Tests a Signature of a message signed by a person.
{.used.}

#BLS lib.
import ../mc_bls

#Random standard lib.
import random

#Times random lib. Used to seed random.
import times
randomize(getTime().toUnix())

#Create a buffer for the seed.
var seed: string = newString(G1_LEN)
for i in 0 ..< 1000:
    #Randomize the seed.
    for c in 0 ..< seed.len:
        seed[c] = char(rand(255))

    #Create a random message.
    var msg: string = newString(rand(500) + 1)
    for c in 0 ..< msg.len:
        msg[c] = char(rand(255))

    var
        #Create the Keys.
        privKey: PrivateKey = newPrivateKey(seed)
        pubKey: PublicKey = privKey.toPublicKey()

        #Sign the message.
        sig: Signature = privKey.sign(msg)
        #Serialize the Signature.
        serialized: string = sig.serialize()

    #Make sure signing and serialization is consistent.
    assert(serialized == privKey.sign(msg).serialize())

    #Make sure the Signature is verifiable.
    assert(sig.verify(newAggregationInfo(pubKey, msg)))

    #Make sure the Signature doesn't verify against a different message.
    if uint8(msg[0]) == 255:
        msg[0] = char(0)
    msg[0] = char(uint8(msg[0]) + 1)
    assert(not sig.verify(newAggregationInfo(pubKey, msg)))

    #Make sure parsing the Signature works.
    assert(serialized == newSignature(serialized).serialize())

    #Make sure the first bit is always set and the second bit isn't.
    assert((uint8(serialized[0]) and 0b10000000) != 0)
    assert((uint8(serialized[0]) and 0b01000000) == 0)

    #Make sure the Signature isn't recognized as infinite.
    assert(not sig.isInf())

    #The following checks aren't really part of the Single Message Test.
    #They're very basic Signature checks and this is the most basic Signature Test.
    #Test that an infinite Signature is recognized as infinite.
    var infSig: string = newString(G1_LEN)
    infSig[0] = char(0b11000000)
    assert(newSignature(infSig).isInf())

    #Make sure infinite Signatures serialize properly.
    assert(infSig == newSignature(infSig).serialize())

echo "Finished the Single Message Test."
