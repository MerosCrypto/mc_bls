# BLS

A Nim Wrapper for [blst](https://github.com/supranational/blst).

It should be noted this library exposes a simplified API which is tailored for [Meros](https://github.com/MerosCrypto/Meros). This means it assumes Proof of Possessions are being used. Without any, Rogue-Key Attacks are possible. Beyond that, this uses G2 for Public Keys, whereas most libraries/projects assume/use G1 for Public Keys.

### Installation

```
nimble install https://github.com/MerosCrypto/mc_bls/
```
