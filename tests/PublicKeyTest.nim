#BLS lib.
import ../ec_bls

var
    #Private Keys.
    privKey1: PrivateKey = newPrivateKeyFromSeed("1")
    privKey2: PrivateKey = newPrivateKeyFromSeed("2")

    #Public Keys.
    #From Private Key.
    pubKey1: PublicKey = privKey1.getPublicKey()
    #From bytes.
    pubKey2: PublicKey = newPublicKeyFromBytes(pubKey1.toString())
    #From hex.
    pubKey3: PublicKey = newPublicKeyFromBytes($pubKey1)
    #From a different Private Key.
    pubKey4: PublicKey = privKey2.getPublicKey()

#Make sure the first 3 keys are the same.
assert(pubKey1 == pubKey2)
assert(pubKey2 == pubKey3)

#Make sure the one from the different private key is different.
assert(pubKey3 != pubKey4)

#Assign #4 to #3.
pubKey4 = pubKey3
#Check their values.
assert(pubKey3 == pubKey4)
