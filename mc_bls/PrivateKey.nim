#Private Key library.

import Common

import Milagro/Big384
import Milagro/G

type PrivateKey* = object
    value*: Big384

#PrivateKey constructor.
proc newPrivateKey*(
    key: string
): PrivateKey {.raises: [
    BLSError
].} =
    if key.len != G1_LEN:
        raise newException(BLSError, "Invalid Private Key length.")

    var r: Big384
    result.value.loadBytes(key, cint(G1_LEN))
    r.copy(R)
    result.value.mod(r)

#Serialize a Private Key.
proc serialize*(
    key: PrivateKey
): string {.raises: [].} =
    result = newString(G1_LEN)
    result.saveBytes(key.value)
