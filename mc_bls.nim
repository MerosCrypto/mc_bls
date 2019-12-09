#Get the current folder.
const currentFolder = currentSourcePath().substr(0, currentSourcePath().len - 11)

#Include the Milagro headers.
{.passC: "-I" & currentFolder & "incubator-milagro-crypto-c/include".}
{.passC: "-I" & currentFolder & "incubator-milagro-crypto-c/build/include".}

#Link against Milagro.
{.passL: "-L" & currentFolder & "incubator-milagro-crypto-c/build/lib/".}
{.passL: "-lamcl_pairing_BLS381".}
{.passL: "-lamcl_curve_BLS381".}
{.passL: "-lamcl_bls_BLS381".}
{.passL: "-lamcl_core".}

#Export the sub-libraries.
import mc_bls/Milagro/G
export G1_LEN, G2_LEN

import mc_bls/Common
export BLSError

import mc_bls/PrivateKey
export PrivateKey

import mc_bls/PublicKey
export PublicKey

import mc_bls/AggregationInfo
export AggregationInfo

import mc_bls/Signature
export Signature
