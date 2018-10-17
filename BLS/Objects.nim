#Import the objects.
{.push, header: "bls.hpp".}
type
    PrivateKeyObject* {.importcpp: "bls::PrivateKey".} = object
    PublicKeyObject* {.importcpp: "bls::PublicKey".} = object
    SignatureObject* {.importcpp: "bls::Signature".} = object
{.pop.}

#Define ref wrappers.
type
    PrivateKey* = ref PrivateKeyObject
    PublicKey* = ref PublicKeyObject
    Signature* = ref SignatureObject
