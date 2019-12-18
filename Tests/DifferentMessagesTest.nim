#Tests an aggregated Signature of different messages signed by multiple people.
{.used.}

#BLS lib.
import ../mc_bls

#Random standard lib.
import random

#Times random lib. Used to seed random.
import times
randomize(getTime().toUnix())

for i in 0 ..< 1000:
    var
        #Messages.
        msgs: seq[string] = newSeq[string](rand(100) + 2)
        #Buffer for the seed.
        seed: string = newString(G1_LEN)
        #Keys.
        privKeys: seq[PrivateKey] = newSeq[PrivateKey](msgs.len)
        pubKeys: seq[PublicKey] = newSeq[PublicKey](msgs.len)
        #Signatures.
        sigs: seq[Signature] = newSeq[Signature](msgs.len)
        #Aggregation Infos.
        agInfos: seq[AggregationInfo] = newSeq[AggregationInfo](msgs.len)

    for k in 0 ..< msgs.len:
        #Randomize the message.
        msgs[k] = newString(rand(500) + 1)
        for c in 0 ..< msgs[k].len:
            msgs[k][c] = char(rand(255))

        #Randomize the seed.
        for c in 0 ..< seed.len:
            seed[c] = char(rand(255))

        #Create the Keys.
        privKeys[k] = newPrivateKey(seed)
        pubKeys[k] = privKeys[k].toPublicKey()

        #Create the Signature.
        sigs[k] = privKeys[k].sign(msgs[k])

        #Create the Aggregation Info.
        agInfos[k] = newAggregationInfo(pubKeys[k], msgs[k])

    #Create the Signature.
    var sig: Signature = sigs.aggregate()

    #Make sure aggregation and serialization is consistent.
    assert(sig.serialize() == sigs.aggregate().serialize())

    #Make sure the Signature is verifiable.
    assert(sig.verify(agInfos.aggregate()))

    #Make sure the Signature doesn't verify against just one Aggregation Info.
    assert(not sig.verify(agInfos[0]))

    #Make sure the Signature is verifiable when the Aggregation Infos are swapped.
    agInfos.add(agInfos[^2])
    agInfos.del(agInfos.len - 3)
    assert(sig.verify(agInfos.aggregate()))

    #Make sure the Signature doesn't verify when different Public Keys are assigned to different messages.
    agInfos[^2] = newAggregationInfo(pubKeys[^1], msgs[^2])
    agInfos[^1] = newAggregationInfo(pubKeys[^2], msgs[^1])
    assert(not sig.verify(agInfos.aggregate()))

    #Make sure parsing the Signature works.
    assert(sig.serialize() == newSignature(sig.serialize()).serialize())

    #Make sure the first bit is always set and the second bit isn't.
    assert((uint8(sig.serialize()[0]) and 0b10000000) != 0)
    assert((uint8(sig.serialize()[0]) and 0b01000000) == 0)

    #Make sure the Signature isn't recognized as infinite.
    assert(not sig.isInf())

echo "Finished the Different Messages Test."
