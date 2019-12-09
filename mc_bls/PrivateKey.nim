#Private Key library.

import Common

import Milagro/Big384
import Milagro/G

type PrivateKey* = object
    value*: Big384

#PrivateKey constructor.
proc newPrivateKey*(
    keyArg: string
): PrivateKey {.raises: [
    BLSError
].} =
    if keyArg.len != G1_LEN:
        raise newException(BLSError, "Invalid Private Key length.")

    var
        key: DBig384
        q: Big384
    key.loadBytes(keyArg, cint(G1_LEN))
    q.copy(Q)
    result.value.mod(key, q)

#Serialize a Private Key.
proc serialize*(
    key: PrivateKey
): string {.raises: [].} =
    result = newString(G1_LEN)
    result.saveBytes(key.value)
