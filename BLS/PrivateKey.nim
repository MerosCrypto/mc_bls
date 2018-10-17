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

#Serialize.
proc serialize(
    key: PrivateKeyObject,
    buffer: ptr uint8
) {.importcpp: "#.Serialize(@)".}

{.pop.}

#Constructors.
proc newPrivateKeyFromSeed*(seed: string): PrivateKey =
    #Allocate the Private Key.
    result = (Objects.PrivateKey)()
    #Create the Private Key.
    result[] = privateKeyFromSeed(cast[ptr uint8](seed[0]), uint(seed.len))

proc newPrivateKey*(keyArg: string): PrivateKey =
    #Allocate the Private Key.
    result = (Objects.PrivateKey)()

    #If a binary string was passed in...
    if keyArg.len == 32:
        #Extract the argument.
        var key: string = keyArg
        #Create the Private Key.
        result[] = privateKeyFromBytes(cast[ptr uint8](key[0]))

    #If a hex string was passed in...
    elif keyArg.len == 64:
        #Define a array for the key.
        var key: array[32, uint8]
        #Parse the hex string.
        for b in countup(0, 63, 2):
            key[b div 2] = uint8(parseHexInt(keyArg[b .. b + 1]))
        #Create the Private Key.
        result[] = privateKeyFromBytes(addr key[0])

    #Else, throw an error.
    else:
        raise newException(ValueError, "Invalid BLS Private Key length.")

#Stringify a Private Key.
proc `toString`*(key: PrivateKey): string =
    #Create the result string.
    result = newString(32)
    #Serialize the key into the string.
    key[].serialize(cast[ptr uint8](addr result[0]))

#Stringify a Private Key for printing.
proc `$`*(key: PrivateKey): string =
    #Create the result string.
    result = ""

    #Get the binary version of the string.
    var serialized: string = key.toString()

    #Format the serialized string into a hex string.
    for i in serialized:
        result &= uint8(i).toHex()
