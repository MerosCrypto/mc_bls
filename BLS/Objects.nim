#C++ imports. The ones suffixed with "Object" have private constructors.
{.push, header: "bls.hpp".}
type
    PrivateKeyObject* {.importcpp: "bls::PrivateKey".} = object
    PublicKeyObject* {.importcpp: "bls::PublicKey".} = object
    SignatureObject* {.importcpp: "bls::Signature".} = object
    AggregationInfo* {.importcpp: "bls::AggregationInfo".} = object
{.pop.}

#Refs.
type
    PrivateKeyRef* = ref PrivateKeyObject
    PublicKeyRef* = ref PublicKeyObject
    SignatureRef* = ref SignatureObject

#Wrappers. These are objects so we can overload `=`.
type
    PrivateKey* = object
        data*: PrivateKeyRef
    PublicKey* = object
        data*: PublicKeyRef
    Signature* = object
        data*: SignatureRef
