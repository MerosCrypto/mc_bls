#BLS Objects.
import Objects

#Vectors.
import Vectors

#String utils standard lib.
import strutils

{.push, header: "bls.hpp".}

#Constructors.
func publicKeyFromPrivateKey(
    key: PrivateKeyObject
): PublicKeyObject {.importcpp: "#.GetPublicKey()".}

func publicKeyFromBytes(
    bytes: ptr uint8
): PublicKeyObject {.importcpp: "bls::PublicKey::FromBytes(@)".}

func aggregatePublicKeys(
    vec: PublicKeyVector
): PublicKeyObject {.importcpp: "bls::PublicKey::Aggregate(@)".}

#Equality operators
func `==`(
    lhs: PublicKeyObject,
    rhs: PublicKeyObject
): bool {.importcpp: "# == #"}

func `!=`(
    lhs: PublicKeyObject,
    rhs: PublicKeyObject
): bool {.importcpp: "# != #"}

#Serialize.
func serialize(
    key: PublicKeyObject,
    buffer: ptr uint8
) {.importcpp: "#.Serialize(@)".}

{.pop.}

#Constructors.
func getPublicKey*(key: PrivateKey): PublicKey =
    #Allocate the Public Key.
    result = (Objects.PublicKey)()
    #Create the Public Key.
    result[] = publicKeyFromPrivateKey(key[])

func newPublicKeyFromBytes*(keyArg: string): PublicKey =
    #Check this isn't a null key.
    var broke: bool = false
    if keyArg.len == 48:
        for b in keyArg:
            if ord(b) != 0:
                broke = true
                break
        if not broke:
            return nil
    elif keyArg.len == 96:
        for b in keyArg:
            if b != '0':
                broke = true
                break
        if not broke:
            return nil
    #Else, throw an error.
    else:
        raise newException(ValueError, "Invalid BLS Public Key length.")

    #Allocate the Public Key.
    result = (Objects.PublicKey)()

    #If a binary string was passed in...
    if keyArg.len == 48:
        #Extract the argument.
        var key: string = keyArg
        #Create the Public Key.
        result[] = publicKeyFromBytes(cast[ptr uint8](addr key[0]))

    #If a hex string was passed in...
    elif keyArg.len == 96:
        #Define a array for the key.
        var key: array[48, uint8]
        #Parse the hex string.
        for b in countup(0, 95, 2):
            key[b div 2] = uint8(parseHexInt(keyArg[b .. b + 1]))
        #Create the Public Key.
        result[] = publicKeyFromBytes(addr key[0])

#Aggregate.
func aggregate*(keys: seq[PublicKey]): PublicKey =
    if keys.len == 0:
        return nil
    if keys.len == 1:
        return keys[0]
    
    #Allocate the Public Key.
    result = (Objects.PublicKey)()
    #Aggregate the Public Keys.
    result[] = aggregatePublicKeys(keys)

#Equality operators.
func `==`*(lhs: PublicKey, rhs: PublicKey): bool =
    if lhs.isNil or rhs.isNil:
        return cast[int](lhs) == cast[int](rhs)

    result = lhs[] == rhs[]

func `!=`*(lhs: PublicKey, rhs: PublicKey): bool =
    if lhs.isNil or rhs.isNil:
        return cast[int](lhs) != cast[int](rhs)

    result = lhs[] != rhs[]

#Stringify a Public Key.
func toString*(key: PublicKey): string =
    #Create the result string.
    result = newString(48)

    #Check if the Key is null.
    if key.isNil:
        return

    #Serialize the key into the string.
    key[].serialize(cast[ptr uint8](addr result[0]))

#Stringify a Public Key for printing.
func `$`*(key: PublicKey): string =
    #Create the result string.
    result = ""

    #Get the binary version of the string.
    var serialized: string = key.toString()

    #Format the serialized string into a hex string.
    for i in serialized:
        result &= uint8(i).toHex()
