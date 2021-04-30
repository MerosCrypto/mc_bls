#Tests the Public Key functions.
{.used.}

import random
import times
randomize(getTime().toUnix())

import ../mc_bls

#Create a buffer for the seed.
var seed: string = newString(SCALAR_LEN)
for i in 0 ..< 1000:
  #Randomize the seed.
  for c in 0 ..< seed.len:
    seed[c] = char(rand(255))

  var
    #Create the Keys.
    privKey: PrivateKey = newPrivateKey(seed)
    pubKey: PublicKey
    #We only use this variable to ensure an empty Signature is considered infinite.
    #It needed to be in some test and the Public Key's infinite property check was here.
    sig: Signature
  assert(pubKey.isInf())
  assert(sig.isInf())
  pubKey = privKey.toPublicKey()

  #Serialize the Public Key.
  var serialized: string = pubKey.serialize()

  #Make sure conersion and serialization is consistent.
  assert(serialized == privKey.toPublicKey().serialize())

  #Make sure parsing the Public Key works.
  assert(serialized == newPublicKey(serialized).serialize())

  #Make sure the first bit is always set and the second bit isn't.
  assert((uint8(serialized[0]) and 0b10000000) != 0)
  assert((uint8(serialized[0]) and 0b01000000) == 0)

  #Make sure the Key isn't recognized as infinite.
  assert(not pubKey.isInf())

  #Test that an infinite Public Key is recognized as infinite.
  var infKey: string = newString(G2_LEN)
  infKey[0] = char(0b11000000)
  assert(newPublicKey(infKey).isInf())

  #Make sure infinite Public Keys serialize properly.
  assert(infKey == newPublicKey(infKey).serialize())

echo "Finished the Public Key Test."
