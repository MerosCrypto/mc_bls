#C++ imports. The ones suffixed with "Object" have private constructors.
{.push, header: "bls.hpp".}
type
    PrivateKeyObject* {.importcpp: "bls::PrivateKey".} = object
    PublicKeyObject* {.importcpp: "bls::PublicKey".} = object
    SignatureObject* {.importcpp: "bls::Signature".} = object
    AggregationInfo* {.importcpp: "bls::AggregationInfo".} = object
{.pop.}

#Wrappers.
type
    PrivateKey* = ref PrivateKeyObject
    PublicKey* = ref PublicKeyObject
    Signature* = ref SignatureObject
