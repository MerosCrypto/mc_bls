# BLS

A Nim Wrapper for [Chia's BLS Library](https://github.com/chia-network/bls-signatures).

# Installation

1) Download all the needed files.
```
nimble install https://github.com/MerosCrypto/ec_bls/

git clone https://github.com/chia-network/bls-signatures
cd bls-signatures
git checkout 5401869ae1a6f0235094fdfc93c51208c80d3000
git submodule update --init --recursive
```

2) Apply the following diff file.
```
diff --git a/src/aggregationinfo.cpp b/src/aggregationinfo.cpp
index 0cefddd..d29da52 100644
--- a/src/aggregationinfo.cpp
+++ b/src/aggregationinfo.cpp
@@ -245,6 +245,7 @@ std::ostream &operator<<(std::ostream &os, AggregationInfo const &a) {

 AggregationInfo& AggregationInfo::operator=(const AggregationInfo &rhs) {
     Clear();
+    tree = AggregationInfo::AggregationTree();
     InsertIntoTree(tree, rhs);
     SortIntoVectors(sortedMessageHashes, sortedPubKeys, tree);
     return *this;
@@ -253,8 +254,8 @@ AggregationInfo& AggregationInfo::operator=(const AggregationInfo &rhs) {
 void AggregationInfo::InsertIntoTree(AggregationInfo::AggregationTree &tree,
                                      const AggregationInfo& info) {
     for (auto &mapEntry : info.tree) {
-        uint8_t* messageCopy = new uint8_t[BLS::MESSAGE_HASH_LEN
-                + PublicKey::PUBLIC_KEY_SIZE];
+        uint8_t* messageCopy = (uint8_t*) malloc(BLS::MESSAGE_HASH_LEN
+                + PublicKey::PUBLIC_KEY_SIZE);
         std::memcpy(messageCopy, mapEntry.first, BLS::MESSAGE_HASH_LEN
                 + PublicKey::PUBLIC_KEY_SIZE);
         bn_t * exponent = new bn_t[1]
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
