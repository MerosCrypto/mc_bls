#FP bindings.

import Big384

type
    FP1* {.importc: "FP_BLS381", header: "fp_BLS381.h".} = object
        g*: Big384
        XES*: int32

    FP2* {.importc: "FP2_BLS381", header: "fp2_BLS381.h".} = object
        a*: FP1
        b*: FP1

#Negate a FP1.
proc neg*(
    res: ptr FP1,
    src: ptr FP1
) {.importc: "FP_BLS381_neg", header: "fp_BLS381.h".}

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

#Load a FP2 from two Big384s.
proc fromBigs*(
    res: ptr FP2,
    a: Big384,
    b: Big384
) {.importc: "FP2_BLS381_from_BIGs".}

{.pop.}
