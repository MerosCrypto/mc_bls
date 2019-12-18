#Tests the Private Key functions.
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

    #Create the Private Key.
    var privKey: PrivateKey = newPrivateKey(seed)

    #Make sure serialization is consistent.
    assert(privKey.serialize() == privKey.serialize())

echo "Finished the Private Key Test."
