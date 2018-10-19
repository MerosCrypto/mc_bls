#BLS Objects.
import Objects

#Vectors.
import Vectors

#String utils standard lib.
import strutils

{.push, header: "bls.hpp".}

#Constructor.
func signatureFromBytes(
    bytes: ptr uint8
): SignatureObject {.importcpp: "bls::Signature::FromBytes(@)".}

func aggregateSignatures(
    vec: SignatureVector
): SignatureObject {.importcpp: "bls::Signature::AggregateSigs(@)".}

#Equality operators
func `==`(
    lhs: SignatureObject,
    rhs: SignatureObject
): bool {.importcpp: "# == #"}

func `!=`(
    lhs: SignatureObject,
    rhs: SignatureObject
): bool {.importcpp: "# != #"}

#Set Aggregation Info.
func cSetAggregationInfo(
    sig: SignatureObject,
    agInfo: AggregationInfo
) {.importcpp: "#.SetAggregationInfo(@)".}

#Verify.
func cVerify(
    sig: SignatureObject
): bool {.importcpp: "#.Verify()".}

#Serialize.
func serialize(
    sig: SignatureObject,
    buffer: ptr uint8
) {.importcpp: "#.Serialize(@)".}

{.pop.}

#Constructor.
func newSignatureFromBytes*(sigArg: string): Signature =
    #Allocate the Signature.
    result = (Objects.Signature)()

    #If a binary string was passed in...
    if sigArg.len == 96:
        #Extract the argument.
        var sig: string = sigArg
        #Create the Signature.
        result[] = signatureFromBytes(cast[ptr uint8](addr sig[0]))

    #If a hex string was passed in...
    elif sigArg.len == 192:
        #Define a array for the sig.
        var sig: array[96, uint8]
        #Parse the hex string.
        for b in countup(0, 191, 2):
            sig[b div 2] = uint8(parseHexInt(sigArg[b .. b + 1]))
        #Create the Signature.
        result[] = signatureFromBytes(addr sig[0])

    #Else, throw an error.
    else:
        raise newException(ValueError, "Invalid BLS Public sig length.")

#Aggregate.
func aggregate*(sigs: seq[Signature]): Signature =
    #Allocate the Signature.
    result = (Objects.Signature)()
    #Aggregate the Signatures.
    result[] = aggregateSignatures(sigs)

#Set Aggregation Info.
func setAggregationInfo*(sig: Signature, agInfo: AggregationInfo) =
    sig[].cSetAggregationInfo(agInfo)

func `==`*(lhs: Signature, rhs: Signature): bool =
    lhs[] == rhs[]

func `!=`*(lhs: Signature, rhs: Signature): bool =
    lhs[] != rhs[]

#Verify.
func verify*(sig: Signature): bool =
    sig[].cVerify()

#Stringify a Signature.
func toString*(sig: Signature): string =
    #Create the result string.
    result = newString(96)
    #Serialize the sig into the string.
    sig[].serialize(cast[ptr uint8](addr result[0]))

#Stringify a Signature for printing.
func `$`*(sig: Signature): string =
    #Create the result string.
    result = ""

    #Get the binary version of the string.
    var serialized: string = sig.toString()

    #Format the serialized string into a hex string.
    for i in serialized:
        result &= uint8(i).toHex()
