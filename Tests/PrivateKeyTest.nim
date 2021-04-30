#Tests the Private Key functions.
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

  #Create the Private Key.
  var privKey: PrivateKey = newPrivateKey(seed)

  #Make sure serialization is consistent.
  assert(privKey.serialize() == privKey.serialize())

echo "Finished the Private Key Test."
