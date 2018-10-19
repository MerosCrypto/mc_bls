#BLS Objects.
import Objects

#Vectors.
import Vectors

#String utils standard lib.
import strutils

{.push, header: "bls.hpp".}

#Constructor.
proc signatureFromBytes(
    bytes: ptr uint8
): SignatureObject {.importcpp: "bls::Signature::FromBytes(@)".}

proc aggregateSignatures(
    vec: SignatureVector
): SignatureObject {.importcpp: "bls::Signature::AggregateSigs(@)".}

#Equality operators
proc `==`*(
    lhs: SignatureObject,
    rhs: SignatureObject
): bool {.importcpp: "# == #"}

proc `!=`*(
    lhs: SignatureObject,
    rhs: SignatureObject
): bool {.importcpp: "# != #"}

#Set Aggregation Info.
proc cSetAggregationInfo(
    sig: SignatureObject,
    agInfo: AggregationInfo
) {.importcpp: "#.SetAggregationInfo(@)".}

#Verify.
proc cVerify(
    sig: SignatureObject
): bool {.importcpp: "#.Verify()".}

#Serialize.
proc serialize(
    key: SignatureObject,
    buffer: ptr uint8
) {.importcpp: "#.Serialize(@)".}

{.pop.}

#Constructor.
proc newSignatureFromBytes*(keyArg: string): Signature =
    #Allocate the Signature.
    result = (Objects.Signature)()

    #If a binary string was passed in...
    if keyArg.len == 96:
        #Extract the argument.
        var key: string = keyArg
        #Create the Public Key.
        result[] = signatureFromBytes(cast[ptr uint8](addr key[0]))

    #If a hex string was passed in...
    elif keyArg.len == 192:
        #Define a array for the key.
        var key: array[96, uint8]
        #Parse the hex string.
        for b in countup(0, 191, 2):
            key[b div 2] = uint8(parseHexInt(keyArg[b .. b + 1]))
        #Create the Public Key.
        result[] = signatureFromBytes(addr key[0])

    #Else, throw an error.
    else:
        raise newException(ValueError, "Invalid BLS Public Key length.")

#Aggregate.
proc aggregate*(sigs: seq[Signature]): Signature =
    #Allocate the Signature.
    result = (Objects.Signature)()
    #Aggregate the Signatures.
    result[] = aggregateSignatures(sigs)

#Set Aggregation Info.
proc setAggregationInfo*(sig: Signature, agInfo: AggregationInfo) =
    sig[].cSetAggregationInfo(agInfo)

proc `==`*(lhs: Signature, rhs: Signature): bool =
    lhs[] == rhs[]

proc `!=`*(lhs: Signature, rhs: Signature): bool =
    lhs[] != rhs[]

#Verify.
proc verify*(sig: Signature): bool =
    sig[].cVerify()

#Stringify a Public Key.
proc toString*(key: Signature): string =
    #Create the result string.
    result = newString(96)
    #Serialize the key into the string.
    key[].serialize(cast[ptr uint8](addr result[0]))

#Stringify a Public Key for printing.
proc `$`*(key: Signature): string =
    #Create the result string.
    result = ""

    #Get the binary version of the string.
    var serialized: string = key.toString()

    #Format the serialized string into a hex string.
    for i in serialized:
        result &= uint8(i).toHex()
