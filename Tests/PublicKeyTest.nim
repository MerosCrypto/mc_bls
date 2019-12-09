#Tests the Public Key functions.
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

    var
        #Create the Keys.
        privKey: PrivateKey = newPrivateKey(seed)
        pubKey: PublicKey = privKey.toPublicKey()

        #Serialize the Public Key.
        serialized: string = pubKey.serialize()

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
