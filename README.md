# BLS

A Nim Wrapper for [Chia's BLS Library](https://github.com/chia-network/bls-signatures).


# Installation

1) Run `nimble install`.
2) Apply the following diff to Chia's library:
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
3) Build the Chia library on your system. For instructions on how to, see their README.
4) Place only the generated `build/` folder inside this package's `Chia/` folder.
5) Move `libbls.a` out of your `build/` folder and install it on your system.
