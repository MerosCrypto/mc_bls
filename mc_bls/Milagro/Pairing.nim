#'Pairing' bindings.
#The type is FP12, which requires G1/G2, which requires FP1/FP2.
#That's why this is not the the FP file.

import G

type FP12* {.importc: "FP12_BLS381", header: "fp12_BLS381.h".} = object

{.push header: "pair_BLS381.h".}

#Calculate a pairing.
proc pair*(
    pairing: ptr FP12,
    g2: ptr G2,
    g1: ptr G1
) {.importc: "PAIR_BLS381_ate".}

#Finalize a pairing.
proc finalize*(
    pairing: ptr FP12
) {.importc: "PAIR_BLS381_fexp".}

{.pop.}

{.push header: "fp12_BLS381.h".}

#Multiply two pairings.
proc mul*(
    pairing: ptr FP12,
    x: ptr FP12
) {.importc: "FP12_BLS381_mul".}

#Merge two pairings.
proc merge*(
    pairing: ptr FP12,
    x: ptr FP12
) {.importc: "FP12_BLS381_ssmul".}

#Get a pairing's unity.
proc unity*(
    pairing: ptr FP12
): cint {.importc: "FP12_BLS381_isunity".}

{.pop.}
