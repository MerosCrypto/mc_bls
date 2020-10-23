import ../mc_bls

proc sign*(
  key: PrivateKey,
  msg: string
): Signature =
  key.sign(msg, "DST")

proc newAggregationInfo*(
  key: PublicKey,
  msg: string
): AggregationInfo =
  newAggregationInfo(key, msg, "DST")
