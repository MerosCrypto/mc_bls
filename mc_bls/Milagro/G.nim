#G bindings.

import Big384
import FP

type
    G1* {.importc: "ECP_BLS381", header: "ecp_BLS381.h".} = object
        x*: FP1
        y*: FP1
        z*: FP1

    G2* {.importc: "ECP2_BLS381", header: "ecp2_BLS381.h".} = object
        x*: FP2
        y*: FP2
        z*: FP2

var
    #Byte length of an element. This is not a cimport as gcc kept throwing errors.
    G1_LEN*: int = 48
    G2_LEN*: int = G1_LEN * 2

{.push header: "ecp_BLS381.h".}

#Set a G1 to infinity.
proc inf*(
    point: ptr G1
) {.importc: "ECP_BLS381_inf".}

#Check if a G1 is infinite.
proc isInf*(
    point: ptr G1
): cint {.importc: "ECP_BLS381_isinf".}

#Set a G1's X.
proc setx*(
    point: ptr G1,
    x: Big384,
    parity: cint
): cint {.importc: "ECP_BLS381_setx".}

#Add a G1 to a G1.
proc add*(
    res: ptr G1,
    x: ptr G1
) {.importc: "ECP_BLS381_add".}

#Multiply a G1 by a Big384.
proc mul*(
    res: ptr G1,
    x: Big384
) {.importc: "ECP_BLS381_mul".}

#Negate a G1.
proc neg*(
    point: ptr G1
) {.importc: "ECP_BLS381_neg".}

#Extract the X/Y values from a G1.
proc extract*(
    x: Big384,
    y: Big384,
    point: ptr G1
): cint {.importc: "ECP_BLS381_get".}

{.pop.}

{.push header: "ecp2_BLS381.h".}

#Set a G2 to infinity.
proc inf*(
    point: ptr G2
) {.importc: "ECP2_BLS381_inf".}

#Check if a G2 is infinite.
proc isInf*(
    point: ptr G2
): cint {.importc: "ECP2_BLS381_isinf".}

#Set a to the G2 generator.
proc newGenerator*(
    res: ptr G2
) {.importc: "ECP2_BLS381_generator".}

#Set a G2's X.
proc setx*(
    point: ptr G2,
    x: ptr FP2
): cint {.importc: "ECP2_BLS381_setx".}

#Add a G2 to a G2.
proc add*(
    res: ptr G2,
    x: ptr G2
): cint {.importc: "ECP2_BLS381_add".}

#Multiply a G2 by a Big384.
proc mul*(
    res: ptr G2,
    x: Big384
) {.importc: "ECP2_BLS381_mul".}

#Extract the X/Y values from a G2.
proc extract*(
    x: ptr FP2,
    y: ptr FP2,
    point: ptr G2
): cint {.importc: "ECP2_BLS381_get".}

{.pop.}
