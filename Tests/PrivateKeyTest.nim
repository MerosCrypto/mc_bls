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
  assert privKey.serialize() == privKey.serialize()

  if i == 500:
    seed.setLen(SCALAR_LEN * 2)

#Validate reduction.
var
  one_32: string
  one_64: string
one_32.setLen(32)
one_64.setLen(64)
one_32[31] = '\1'
one_64[63] = '\1'
assert newPrivateKey(one_32).serialize() == newPrivateKey(one_64).serialize()

echo "Finished the Private Key Test."
