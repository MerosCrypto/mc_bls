import Objects

{.push, header: "vector".}

type
    PublicKeyVector* {.importcpp: "std::vector<bls::PublicKey>"} = object
    AggregationInfoVector* {.importcpp: "std::vector<bls::AggregationInfo>".} = object
    SignatureVector* {.importcpp: "std::vector<bls::Signature>"} = object

proc newPublicKeyVector(): PublicKeyVector {.
    importcpp: "std::vector<bls::PublicKey>",
    constructor
.}

proc newAggregationInfoVector(): AggregationInfoVector {.
    importcpp: "std::vector<bls::AggregationInfo>",
    constructor
.}

proc newSignatureVector(): SignatureVector {.
    importcpp: "std::vector<bls::Signature>",
    constructor
.}

proc add(
    vector: PublicKeyVector,
    key: PublicKeyObject
) {.importcpp: "#.push_back(@)"}

proc add(
    vector: AggregationInfoVector,
    agInfo: AggregationInfo
) {.importcpp: "#.push_back(@)"}

proc add(
    vector: SignatureVector,
    key: SignatureObject
) {.importcpp: "#.push_back(@)"}

{.pop.}

converter toVector*(keys: seq[PublicKey]): PublicKeyVector =
    result = newPublicKeyVector()
    for i in 0 ..< keys.len:
        result.add(keys[i].data[])

converter toVector*(agInfos: seq[AggregationInfo]): AggregationInfoVector =
    result = newAggregationInfoVector()
    for i in 0 ..< agInfos.len:
        result.add(agInfos[i])

converter toVector*(sigs: seq[Signature]): SignatureVector =
    result = newSignatureVector()
    for i in 0 ..< sigs.len:
        result.add(sigs[i].data[])
