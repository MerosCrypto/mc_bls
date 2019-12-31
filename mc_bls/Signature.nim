#Signature library.

import Milagro/Big384
import Milagro/FP
import Milagro/G
import Milagro/HashToG
import Milagro/Pairing

import Common
import PrivateKey
import AggregationInfo

type Signature* = object
    value*: G1

#Signature constructor.
proc newSignature*(
    sigArg: string
): Signature {.raises: [
    BLSError
].} =
    #Check the Signature is the right length and compressed.
    if sigArg.len != G1_LEN:
        raise newException(BLSError, "Invalid Signature length.")
    if (uint8(sigArg[0]) and C_FLAG) == 0:
        raise newException(BLSError, "Uncompressed Signature.")

    #Extract and clear the flags.
    var
        sig: string = sigArg
        inf: bool = (uint8(sig[0]) and B_FLAG) != 0
        greaterY: bool = (uint8(sig[0]) and A_FLAG) != 0
    sig[0] = char(uint8(sig[0]) and CLEAR_FLAGS)

    #Verify the Signature's infinite property.
    var c: int = 0
    while c < G1_LEN:
        if sig[c] != char(0):
            break
        inc(c)
    if inf and (c != G1_LEN):
        raise newException(BLSError, "Infinite G1 has a non-zeroed 381-bit number.")
    if (not inf) and (c == G1_LEN):
        raise newException(BLSError, "Non-infinite G1 has a zeroed 381-bit number.")

    #Set infinite and return if infinite.
    if inf:
        inf(addr result.value)
        return

    #Extract x.
    var x: Big384
    x.loadBytes(sig, cint(G1_LEN))

    #Calculate both Ys.
    var
        y1: Big384
        y2: Big384
    if (addr result.value).setx(x, cint(0)) != 1:
        raise newException(BLSError, "Invalid BLS signature.")
    doAssert(extract(x, y1, addr result.value) != -1)
    doAssert((addr result.value).setx(x, cint(1)) == 1)
    doAssert(extract(x, y2, addr result.value) != -1)

    #Use the correct Y.
    if (cmp(y2, y1) == 1) != greaterY:
        doAssert(setx(addr result.value, x, cint(0)) == 1)

#Check if a Signature is infinite.
proc isInf*(
    sigArg: Signature
): bool {.raises: [].} =
    var sig: G1 = sigArg.value
    return (addr sig).isInf == 1

#Aggregate Signatures.
proc aggregate*(
    sigsArg: seq[Signature]
): Signature {.raises: [].} =
    if sigsArg.len == 0:
        inf(addr result.value)
        return

    result.value = sigsArg[0].value
    var sigs: seq[Signature] = sigsArg
    for s in 1 ..< sigs.len:
        if sigs[s].isInf:
            inf(addr result.value)
            return

        add(addr result.value, addr sigs[s].value)

#Sign a message.
proc sign*(
    key: PrivateKey,
    msg: string
): Signature {.raises: [].} =
    result.value = msgToG(msg)
    (addr result.value).mul(key.value)

#Verify a Signature with the passed in AggregationInfo.
proc verify*(
    sigArg: Signature,
    agInfoArg: AggregationInfo
): bool {.raises: [].} =
    if sigArg.isInf:
        return false

    var
        sig: G1 = sigArg.value
        agInfo: FP12 = agInfoArg.value
        generator: G2
        sigPairing: FP12
    newGenerator(addr generator)

    neg(addr sig)
    pair(addr sigPairing, addr generator, addr sig)
    merge(addr sigPairing, addr agInfo)
    finalize(addr sigPairing)

    return unity(addr sigPairing) == 1

#Serialize a Signature as defined by the ZCash/Ethereum standards.
proc serialize*(
    sigArg: Signature
): string {.raises: [].} =
    var
        sig: Signature = sigArg
        x: Big384
        y: Big384
        yNeg: Big384
    result = newString(G1_LEN)

    #If the point is infinite, set the compressed/infinite flags and return.
    if extract(x, y, addr sig.value) == -1:
        result[0] = char(uint8(result[0]) or C_FLAG)
        result[0] = char(uint8(result[0]) or B_FLAG)
        return

    #Serialize the X value and set the compressed flag.
    result.saveBytes(x)
    result[0] = char(uint8(result[0]) or C_FLAG)

    #Negate the Y to find out if this is the larger or smaller Y.
    (addr sig.value.y).neg(addr sig.value.y)
    doAssert(extract(x, yNeg, addr sig.value) != -1)

    #If this is the larger Y, set the flag.
    if cmp(y, yNeg) == 1:
        result[0] = char(uint8(result[0]) or A_FLAG)
