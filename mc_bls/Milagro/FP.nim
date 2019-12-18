#FP bindings.

import Big384

type
    FP1* {.importc: "FP_BLS381", header: "fp_BLS381.h", bycopy.} = object
        g*: Big384
        XES*: int32

    FP2* {.importc: "FP2_BLS381", header: "fp2_BLS381.h", bycopy.} = object
        a*: FP1
        b*: FP1

#Negate a FP1.
proc neg*(
    res: ptr FP1,
    src: ptr FP1
) {.importc: "FP_BLS381_neg", header: "fp_BLS381.h".}

#Reduce and store a FP.
proc redc*(
    big: Big384,
    fp: ptr FP1
) {.importc: "FP_BLS381_redc".}

{.push header: "fp2_BLS381.h".}

#Negate a FP2.
proc neg*(
    res: ptr FP2,
    src: ptr FP2
) {.importc: "FP2_BLS381_neg".}

#Reduce a FP2.
proc reduce*(
    fp: ptr FP2
) {.importc: "FP2_BLS381_reduce".}

#Load a FP2 from Big384s.
proc fromBigs*(
    fp: ptr FP2,
    x1: Big384,
    x2: Big384
) {.importc: "FP2_BLS381_from_BIGs".}

{.pop.}
