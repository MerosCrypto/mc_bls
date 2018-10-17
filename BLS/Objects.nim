#Objects.
{.push, header: "bls.hpp".}
type
    PrivateKeyObject* {.importcpp: "bls::PrivateKey".} = object
    PublicKeyObject* {.importcpp: "bls::PublicKey".} = object
    SignatureObject* {.importcpp: "bls::Signature".} = object
{.pop.}

#Refs.
type
    PrivateKeyRef* = ref PrivateKeyObject
    PublicKeyRef* = ref PublicKeyObject
    SignatureRef* = ref SignatureObject

#Wrappers.
type
    PrivateKey* = object
        data*: PrivateKeyRef
    PublicKey* = object
        data*: PublicKeyRef
    Signature* = object
        data*: SignatureRef
