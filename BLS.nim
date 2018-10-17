#Make sure C++ is the backend.
when not defined(cpp):
    {.fatal: "The BLS lib requires C++.".}

#String utils standard lib.
import strutils

#Include the BLS headers.
{.passC: "-Ichia/src/".}
{.passC: "-Ichia/contrib/relic/include".}
{.passC: "-Ichia/build/contrib/relic/include".}

#Link against BLS.
{.passL: "-lbls".}

#All of the following are in bls.hpp.
{.push, header: "bls.hpp".}

#Init BLS.
proc init(): bool {.importcpp: "bls::BLS::Init".}
if not init():
    raise newException(Exception, "Couldn't init the BLS lib.")

#Define objects and refs.
type
    BLSPrivateKeyObject {.importcpp: "bls::PrivateKey".} = object
    BLSPublicKeyObject {.importcpp: "bls::PublicKey".} = object
    BLSSignatureObject {.importcpp: "bls::Signature".} = object
    BLSPrivateKey* = ref BLSPrivateKeyObject
    BLSPublicKey* = ref BLSPublicKeyObject
    BLSSignature* = ref BLSSignatureObject

#Constructors.
proc cNewBLSPrivateKey(
    bytes: ptr uint8
): BLSPrivateKeyObject {.importcpp: "bls::PrivateKey::FromBytes(@)".}
proc cNewBLSPublicKey(
    key: BLSPrivateKeyObject
): BLSPublicKeyObject {.importcpp: "#.GetPublicKey()".}

#Serialize.
proc cSerialize(
    key: BLSPrivateKeyObject,
    buffer: ptr uint8
) {.importcpp: "#.Serialize(@)".}

#Move out of bls.hpp.
{.pop.}

#Constructor.
proc newBLSPrivateKey*(keyArg: string): BLSPrivateKey =
    #Create the Private Key.
    result = BLSPrivateKey()

    #If a binary string was passed in...
    if keyArg.len == 32:
        #Extract the argument.
        var key: string = keyArg
        #Create the Private Key.
        result[] = cNewBLSPrivateKey(cast[ptr uint8](key[0]))

    #If a hex string was passed in...
    elif keyArg.len == 64:
        #Define a array for the key.
        var key: array[32, uint8]
        #Parse the hex string.
        for b in countup(0, 63, 2):
            key[b div 2] = uint8(parseHexInt(keyArg[b .. b + 1]))
        #Create the Private Key.
        result[] = cNewBLSPrivateKey(addr key[0])

    #Else, throw an error.
    else:
        raise newException(ValueError, "Invalid BLS Private Key length.")

#Stringify a Private Key.
proc `$`*(key: BLSPrivateKey): string =
    #Create the empty result.
    result = ""
    #Create a buffer.
    var buffer: array[32, uint8]

    #Serialize into the buffer.
    key[].cSerialize(addr buffer[0])
    #Format the buffer into a hex string.
    for i in buffer:
        result &= i.toHex()
