#Big384 bindings.

{.push header: "big_384_58.h".}

type
    Big384*      {.importc: "BIG_384_58".} = object
    ConstBig384* {.importc: "const BIG_384_58".} = object
    DBig384*     {.importc: "DBIG_384_58".} = object

{.pop.}

#Number to mod everything by.
var Q* {.importc: "Modulus_BLS381".}: ConstBig384

{.push header: "big_384_58.h".}

#Copy one Big384 to another.
proc copy*(
    res: Big384,
    value: Big384
) {.importc: "BIG_384_58_copy".}

proc copy*(
    res: Big384,
    value: ConstBig384
) {.importc: "BIG_384_58_rcopy".}

#Mod one Big384 by another.
proc `mod`*(
    res: Big384,
    value: DBig384,
    modulus: Big384
) {.importc: "BIG_384_58_dmod".}

#Compare two Big384s.
#Returns 1 for a > b, -1 for a < b, and 0 for a == b.
proc cmp*(
    a: Big384,
    b: Big384
): cint {.importc: "BIG_384_58_comp".}

#Save a Big384 to bytes/load a Big384 from bytes.
proc saveBytes*(
    res: cstring,
    value: Big384
) {.importc: "BIG_384_58_toBytes".}

proc loadBytes*(
    res: Big384,
    bytes: cstring,
    len: cint
) {.importc: "BIG_384_58_fromBytesLen".}

proc loadBytes*(
    res: DBig384,
    bytes: cstring,
    len: cint
) {.importc: "BIG_384_58_dfromBytesLen".}

{.pop.}
