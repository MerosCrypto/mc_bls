# BLS

A Nim Wrapper for [Milagro](https://github.com/apache/incubator-milagro), specifically the C version.

It should be noted this library exposes a simplified API meant specifically for use in systems which implement Proof of
Possessions. Systems without PoPs which use this library are vulnerable to Rogue-Key Attacks.

### Installation

```
nimble install https://github.com/MerosCrypto/mc_bls/
```