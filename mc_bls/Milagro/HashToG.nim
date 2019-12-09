#Reimplementation of BLS_HASHIT as it's private.
#Also enables changing the algorithm in the future without writing any C.

import G

#ID for the SHA3 SHAKE256 algorithm. This is not a cimport as gcc kept throwing errors.
const SHA3_SHAKE256: cint = 32

{.push header: "amcl.h".}

type
    #Milagro's custom string format.
    Octet {.importc: "octet".} = object
        len: cint
        max: cint
        val: cstring

    #Milagro's SHA3 object.
    #This is needed to hash a message so it can be mapped to a G1.
    #The plan was to call the existing BLS_HASHIT yet it's private.
    #We've had to rewrite it and call the functions it calls, which are still public.
    SHA3 {.importc: "sha3".} = object

#SHA3 functions.
proc init(
    sha3: ptr SHA3,
    algorithm: cint
) {.importc: "SHA3_init".}

proc process(
    sha3: ptr SHA3,
    b: cint
) {.importc: "SHA3_process".}

proc shake(
    sha3: ptr SHA3,
    res: cstring,
    len: cint
) {.importc: "SHA3_shake".}

#Map a hash stored in an octet to a G1.
proc hashToG(
    res: ptr G1,
    hash: ptr Octet
) {.importc: "ECP_BLS381_mapit".}

{.pop.}

#Hash a message and convert it to a G! element.
proc msgToG*(
    msg: string
): G1 {.raises: [].} =
    var
        context: SHA3
        hash: string = newString(G1_LEN)
        octet: Octet
    octet.len = 0
    octet.max = cint(G1_LEN)
    octet.val = addr hash[0]

    (addr context).init(SHA3_SHAKE256)
    for i in 0 ..< msg.len:
        (addr context).process(cint(msg[i]))
    (addr context).shake(octet.val, cint(G1_LEN))
    octet.len = cint(G1_LEN)

    (addr result).hashToG(addr octet)
