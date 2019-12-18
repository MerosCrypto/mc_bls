# BLS

A Nim Wrapper for [Milagro](https://github.com/apache/incubator-milagro), specifically the C version.

It should be noted this library exposes a simplified API meant specifically for use in systems which implement Proof of Possessions. Systems without PoPs which use this library are vulnerable to Rogue-Key Attacks.

# Installation

```
nimble install https://github.com/MerosCrypto/mc_bls/
```

Then, from inside the mc_bls package directory:

```
git clone https://github.com/apache/incubator-milagro-crypto-c
cd incubator-milagro-crypto-c
mkdir build
cd build
cmake -DBUILD_SHARED_LIBS=OFF -DAMCL_CURVE=BLS381 ..
make
```
