#Tests aggregated Signatures where:
#- Some Signatures are of the same message signed by multiple people.
#- Some are of different messages.
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
        privKeys: seq[seq[PrivateKey]] = newSeq[seq[PrivateKey]](msgs.len)
        pubKeys: seq[seq[PublicKey]] = newSeq[seq[PublicKey]](msgs.len)
        #Signatures.
        sigs: seq[Signature] = newSeq[Signature](msgs.len)
        #Aggregation Infos.
        agInfos: seq[AggregationInfo] = newSeq[AggregationInfo](msgs.len)

    for k in 0 ..< msgs.len:
        #Randomize the message.
        msgs[k] = newString(rand(500) + 1)
        for c in 0 ..< msgs[k].len:
            msgs[k][c] = char(rand(255))

        #Same Message.
        if rand(1) == 0:
            privKeys[k] = newSeq[PrivateKey](rand(100) + 2)
            pubKeys[k] = newSeq[PublicKey](privKeys[k].len)
            var subSigs: seq[Signature] = newSeq[Signature](privKeys[k].len)

            for s in 0 ..< privKeys[k].len:
                #Randomize the seed.
                for c in 0 ..< seed.len:
                    seed[c] = char(rand(255))

                #Create the Keys.
                privKeys[k][s] = newPrivateKey(seed)
                pubKeys[k][s] = privKeys[k][s].toPublicKey()

                #Create the Signature.
                subSigs[s] = privKeys[k][s].sign(msgs[k])

            sigs[k] = subSigs.aggregate()
            agInfos[k] = newAggregationInfo(pubKeys[k], msgs[k])

        #Different Message.
        else:
            #Randomize the seed.
            for c in 0 ..< seed.len:
                seed[c] = char(rand(255))

            #Create the Keys.
            privKeys[k] = @[newPrivateKey(seed)]
            pubKeys[k] = @[privKeys[k][0].toPublicKey()]

            #Create the Signature.
            sigs[k] = privKeys[k][0].sign(msgs[k])

            #Create the Aggregation Info.
            agInfos[k] = newAggregationInfo(pubKeys[k][0], msgs[k])

    #Create the Signature.
    var sig: Signature = sigs.aggregate()

    #Make sure aggregation and serialization is consistent.
    assert(sig.serialize() == sigs.aggregate().serialize())

    #Make sure the Signature is verifiable.
    assert(sig.verify(agInfos.aggregate()))

    #Make sure parsing the Signature works.
    assert(sig.serialize() == newSignature(sig.serialize()).serialize())

    #Make sure the first bit is always set and the second bit isn't.
    assert((uint8(sig.serialize()[0]) and 0b10000000) != 0)
    assert((uint8(sig.serialize()[0]) and 0b01000000) == 0)

    #Make sure the Signature isn't recognized as infinite.
    assert(not sig.isInf())

echo "Finished the Same and Different Messages Test."
