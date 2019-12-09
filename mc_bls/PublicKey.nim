#Public Key library.

import Milagro/Big384 as Big384File
import Milagro/FP
import Milagro/G

import Common
import PrivateKey

type PublicKey* = object
    value*: G2

#PublicKey constructors.
proc newPublicKey*(
    keyArg: string
): PublicKey {.raises: [
    BLSError
].} =
    #Check the Public Key is the right length and compressed.
    if keyArg.len != G2_LEN:
        raise newException(BLSError, "Invalid Public Key length.")
    if (uint8(keyArg[0]) and C_FLAG) == 0:
        raise newException(BLSError, "Uncompressed Public Key.")
    if (uint8(keyArg[G1_LEN]) and CLEAR_FLAGS) != uint8(keyArg[G1_LEN]):
        raise newException(BLSError, "G2's second G has flags set.")

    #Extract and clear the flags.
    var
        key: string = keyArg
        inf: bool = (uint8(key[0]) and B_FLAG) != 0
        greaterY: bool = (uint8(key[0]) and A_FLAG) != 0
    key[0] = char(uint8(key[0]) and CLEAR_FLAGS)

    #Verify the Public Key's infinite property.
    var c: int = 0
    while c < G2_LEN:
        if key[c] != char(0):
            break
        inc(c)
    if inf and (c != G2_LEN):
        echo c
        raise newException(BLSError, "Infinite G2 has a non-zeroed pair of 381-bit numbers.")
    if (not inf) and (c == G2_LEN):
        raise newException(BLSError, "Non-infinite G2 has a zeroed pair of 381-bit number.")

    #Set infinite and return if infinite.
    if inf:
        inf(addr result.value)
        return

    #Extract x.
    var
        a: Big384
        b: Big384
        x: FP2
    a.loadBytes(addr key[0], cint(G1_LEN))
    b.loadBytes(addr key[G1_LEN], cint(G1_LEN))

    copyMem(addr x.a.g, addr a, sizeof(Big384))
    x.a.XES = 1
    copyMem(addr x.b.g, addr b, sizeof(Big384))
    x.b.XES = 1

    #Set x.
    if (addr result.value).setx(addr x) == 0:
        raise newException(BLSError, "Infinite G2 didn't have the infinite flag set.")

    #Calculate both Ys.
    var
        yNeg: FP2
        cmpRes: int
    (addr yNeg).neg(addr result.value.y)

    #Compare the Ys.
    copy(a, result.value.y.b.g)
    copy(b, yNeg.b.g)
    cmpRes = cmp(a, b)
    if cmpRes == 0:
        a.copy(result.value.y.a.g)
        b.copy(yNeg.a.g)
        cmpRes = cmp(a, b)

    #Use the correct Y.
    if (cmpRes == 1) != greaterY:
        result.value.y = yNeg

proc toPublicKey*(
    key: PrivateKey
): PublicKey {.raises: [].} =
    newGenerator(addr result.value)
    mul(addr result.value, key.value)

#Check if a Public Key is infinite.
proc isInf*(
    keyArg: PublicKey
): bool {.raises: [].} =
    var key: G2 = keyArg.value
    return (addr key).isInf == 1

#Aggregate Public Keys.
proc aggregate*(
    keysArg: seq[PublicKey]
): PublicKey {.raises: [].} =
    if keysArg.len == 0:
        inf(addr result.value)
        return

    result.value = keysArg[0].value
    var keys: seq[PublicKey] = keysArg[1 ..< keysArg.len]
    for k in 0 ..< keys.len:
        if keys[k].isInf:
            inf(addr result.value)
            return

        doAssert(add(addr result.value, addr keys[k].value) == 0)

#Serialize a Public Key.
proc serialize*(
    keyArg: PublicKey
): string {.raises: [].} =
    var
        key: PublicKey = keyArg
        x: FP2
        y: FP2
    result = newString(G2_LEN)

    #If the point is infinite, set the compressed/infinite flags and return.
    if extract(addr x, addr y, addr key.value) == -1:
        result[0] = char(uint8(result[0]) or C_FLAG)
        result[0] = char(uint8(result[0]) or B_FLAG)
        return

    #Reduce X and Y.
    reduce(addr x)
    reduce(addr y)

    var
        a: Big384
        b: Big384
    a.copy(x.a.g)
    b.copy(x.b.g)

    #Serialize the X values and set the compressed flag.
    result.saveBytes(a)
    (addr result[G1_LEN]).saveBytes(b)
    result[0] = char(uint8(result[0]) or C_FLAG)

    #Negate the Y to find out if this is the larger or smaller Y.
    var
        yNeg: FP2
        cmpRes: int
    (addr yNeg).neg(addr y)

    #Compare the Ys.
    copy(a, y.b.g)
    copy(b, yNeg.b.g)
    cmpRes = cmp(a, b)
    if cmpRes == 0:
        a.copy(y.a.g)
        b.copy(yNeg.a.g)
        cmpRes = cmp(a, b)

    #If this is the larger Y, set the flag.
    if cmpRes == 1:
        result[0] = char(uint8(result[0]) or A_FLAG)
