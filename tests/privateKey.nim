import ../BLS

var
    key: string = "003206F418C701193458C013120C5906DC12663AD1520C3E596EB6092C14FE16"
    privKey: PrivateKey = newPrivateKey(key)

assert($privKey == key)
