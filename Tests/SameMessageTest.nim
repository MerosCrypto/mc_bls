#Tests an aggregated Signature of the same message signed by multiple people.
{.used.}

import random
import times
randomize(getTime().toUnix())

import ../mc_bls
import common

for i in 0 ..< 1000:
  #Create a random message.
  var msg: string = newString(rand(500) + 1)
  for c in 0 ..< msg.len:
    msg[c] = char(rand(255))

  var
    seed: string = newString(SCALAR_LEN * 2)
    privKeys: seq[PrivateKey] = newSeq[PrivateKey](rand(100) + 2)
    pubKeys: seq[PublicKey] = newSeq[PublicKey](privKeys.len)
    sigs: seq[Signature] = newSeq[Signature](privKeys.len)
    agInfos: seq[AggregationInfo] = newSeq[AggregationInfo](privKeys.len)

  for k in 0 ..< privKeys.len:
    #Randomize the seed.
    for c in 0 ..< seed.len:
      seed[c] = char(rand(255))

    #Create the Keys.
    privKeys[k] = newPrivateKey(seed)
    pubKeys[k] = privKeys[k].toPublicKey()

    #Create the Signature.
    sigs[k] = privKeys[k].sign(msg)

    #Create the Aggregation Info.
    agInfos[k] = newAggregationInfo(pubKeys[k], msg)

  #Create the Signature.
  var sig: Signature = sigs.aggregate()

  #Make sure aggregation and serialization is consistent.
  assert(sig.serialize() == sigs.aggregate().serialize())

  #Make sure the Signature is verifiable.
  assert(sig.verify(newAggregationInfo(pubKeys.aggregate(), msg)))

  #Make sure the Signature is verifiable with the slower Aggregation Info format.
  assert(sig.verify(agInfos.aggregate()))

  #Make sure the Signature doesn't verify against just one key.
  assert(not sig.verify(newAggregationInfo(pubKeys[rand(high(pubKeys))], msg)))

  #Make sure the Signature doesn't verify against a different message.
  if uint8(msg[0]) == 255:
    msg[0] = char(0)
  msg[0] = char(uint8(msg[0]) + 1)
  assert(not sig.verify(newAggregationInfo(pubKeys.aggregate(), msg)))

  #Make sure parsing the Signature works.
  assert(sig.serialize() == newSignature(sig.serialize()).serialize())

  #Make sure the first bit is always set and the second bit isn't.
  assert((uint8(sig.serialize()[0]) and 0b10000000) != 0)
  assert((uint8(sig.serialize()[0]) and 0b01000000) == 0)

  #Make sure the Signature isn't recognized as infinite.
  assert(not sig.isInf())

echo "Finished the Same Message Test."
