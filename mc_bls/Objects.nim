#C++ imports. The ones suffixed with "Object" have private constructors.
{.push, header: "bls.hpp".}

type
    PrivateKeyObject* {.importcpp: "bls::PrivateKey".} = object
    PublicKeyObject* {.importcpp: "bls::PublicKey".} = object
    SignatureObject* {.importcpp: "bls::Signature".} = object
    AggregationInfoObject* {.importcpp: "bls::AggregationInfo".} = object

{.pop.}

#Wrappers.
type
    PrivateKey* = ptr PrivateKeyObject
    PublicKey* = ptr PublicKeyObject
    Signature* = ptr SignatureObject
    AggregationInfo* = ptr AggregationInfoObject
