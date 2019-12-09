#Flags.
const
    #Larger or smaller Y.
    A_FLAG*: uint8 = 0b00100000
    #Infinity or not.
    B_FLAG*: uint8 = 0b01000000
    #Compressed or not.
    C_FLAG*: uint8 = 0b10000000
    #Mask to clear the flags.
    CLEAR_FLAGS*: uint8 = 0b00011111

#Custom Exception type.
type BLSError* = object of Exception
