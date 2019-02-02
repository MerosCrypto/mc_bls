# BLS

A Nim Wrapper for [Chia's BLS Library](https://github.com/chia-network/bls-signatures).

# Installation

1) Download all the needed files.
```
nimble install https://github.com/MerosCrypto/mc_bls/

git clone https://github.com/chia-network/bls-signatures
cd bls-signatures
git checkout 5401869ae1a6f0235094fdfc93c51208c80d3000
git submodule update --init --recursive
```

2) Add `tree = AggregationInfo::AggregationTree();` after line 247, but before line 248, to `src/aggregationinfo.cpp`. To be more exact, here is a diff file.
```
diff --git a/src/aggregationinfo.cpp b/src/aggregationinfo.cpp
index 0cefddd..690ceed 100644
--- a/src/aggregationinfo.cpp
+++ b/src/aggregationinfo.cpp
@@ -245,6 +245,7 @@ std::ostream &operator<<(std::ostream &os, AggregationInfo const &a) {

 AggregationInfo& AggregationInfo::operator=(const AggregationInfo &rhs) {
     Clear();
+    tree = AggregationInfo::AggregationTree();
     InsertIntoTree(tree, rhs);
     SortIntoVectors(sortedMessageHashes, sortedPubKeys, tree);
     return *this;
 ```

3) Build Chia's BLS library.
```
mkdir build
cd build
cmake ../
cmake --build . -- -j 6
```
If there's a complaint about `Python.h`, you can install it on Debian based systems via the `python-dev` package.

4) Place the generated `build/` folder (which you are in) inside the Nimble package's `Chia/` folder. The Nimble package can be found in `~/.nimble/pkgs` (on Linux and Mac OS) or in `C:\Users\USERNAME\.nimble\pkgs` (on Windows).

5) Either add `build/` to your linker's search paths or install `build/libbls.a` on your system. On Linux (and maybe Mac OS), you can install it on your system via `/lib`, `/lib64`, `/usr/lib`, and/or `/usr/local/lib`. On Windows, your compiler may have a special folder.
