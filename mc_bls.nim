const currentFolder = currentSourcePath().substr(0, currentSourcePath().len - 11)

{.passC: "-I" & currentFolder & "blst/bindings".}
{.passL: "-L" & currentFolder & "blst/build/".}
{.passL: "-lblst".}

import mc_bls/[BLST, common, PrivateKey, PublicKey, AggregationInfo, Signature]
export SCALAR_LEN, G1_LEN, G2_LEN, BLSError
export PrivateKey, PublicKey, AggregationInfo, Signature
