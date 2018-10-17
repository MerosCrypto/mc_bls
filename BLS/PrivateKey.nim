#BLS Objects.
import Objects

#String utils standard lib.
import strutils

{.push, header: "bls.hpp".}

#Constructors.
proc privateKeyFromSeed(
    bytes: ptr uint8,
    size: uint
): PrivateKeyObject {.importcpp: "bls::PrivateKey::FromSeed(@)".}

proc privateKeyFromBytes(
    bytes: ptr uint8
): PrivateKeyObject {.importcpp: "bls::PrivateKey::FromBytes(@)".}

#Equality operators
proc `==`(
    lhs: PrivateKeyObject,
    rhs: PrivateKeyObject
): bool {.importcpp: "# == #"}

proc `!=`(
    lhs: PrivateKeyObject,
    rhs: PrivateKeyObject
): bool {.importcpp: "# != #"}

#Sign a message.
proc sign(
    key: PrivateKeyObject,
    msg: ptr uint8,
    len: uint
): SignatureObject {.importcpp: "#.Sign(@)".}

#Serialize.
proc serialize(
    key: PrivateKeyObject,
    buffer: ptr uint8
) {.importcpp: "#.Serialize(@)".}

{.pop.}

#Constructors.
proc newPrivateKeyFromSeed*(seedArg: string): PrivateKey =
    #Allocate the Private Key.
    result.data = PrivateKeyRef()
    #Extract the seed arg.
    var seed: string = seedArg
    #Create the Private Key.
    result.data[] = privateKeyFromSeed(
        cast[ptr uint8](addr seed[0]),
        uint(seed.len)
    )

proc newPrivateKeyFromBytes*(keyArg: string): PrivateKey =
    #Allocate the Private Key.
    result.data = PrivateKeyRef()

    #If a binary string was passed in...
    if keyArg.len == 32:
        #Extract the argument.
        var key: string = keyArg
        #Create the Private Key.
        result.data[] = privateKeyFromBytes(cast[ptr uint8](addr key[0]))

    #If a hex string was passed in...
    elif keyArg.len == 64:
        #Define a array for the key.
        var key: array[32, uint8]
        #Parse the hex string.
        for b in countup(0, 63, 2):
            key[b div 2] = uint8(parseHexInt(keyArg[b .. b + 1]))
        #Create the Private Key.
        result.data[] = privateKeyFromBytes(addr key[0])

    #Else, throw an error.
    else:
        raise newException(ValueError, "Invalid BLS Private Key length.")

#Equality operators.
proc `==`*(lhs: PrivateKey, rhs: PrivateKey): bool =
    lhs.data[] == rhs.data[]

proc `!=`*(lhs: PrivateKey, rhs: PrivateKey): bool =
    lhs.data[] != rhs.data[]

#Assignment operator.
proc `=`*(lhs: var PrivateKey, rhs: PrivateKey) =
    lhs.data[] = rhs.data[]

#Sign a message.
proc sign*(key: PrivateKey, msgArg: string): Signature =
    #Allocate the Signature.
    result.data = SignatureRef()
    #Extract the msg argument.
    var msg: string = msgArg

    #Create the Signature.
    result.data[] = key.data[].sign(
        cast[ptr uint8](addr msg[0]),
        uint(msg.len)
    )

#Stringify a Private Key.
proc toString*(key: PrivateKey): string =
    #Create the result string.
    result = newString(32)
    #Serialize the key into the string.
    key.data[].serialize(cast[ptr uint8](addr result[0]))

#Stringify a Private Key for printing.
proc `$`*(key: PrivateKey): string =
    #Create the result string.
    result = ""

    #Get the binary version of the string.
    var serialized: string = key.toString()

    #Format the serialized string into a hex string.
    for i in serialized:
        result &= uint8(i).toHex()
