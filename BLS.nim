#Make sure C++ is the backend.
when not defined(cpp):
    {.fatal: "The BLS lib requires C++.".}

#Include the BLS headers.
{.passC: "-IChia/src/".}
{.passC: "-IChia/contrib/relic/include".}
{.passC: "-IChia/build/contrib/relic/include".}

#Link against BLS.
{.passL: "-lbls".}

#Init BLS.
proc init(): bool {.header: "bls.hpp", importcpp: "bls::BLS::Init".}
if not init():
    raise newException(Exception, "Couldn't init the BLS lib.")

#Import each of the BLS files.
import BLS/Objects
import BLS/PrivateKey
import BLS/PublicKey
import BLS/Signature
import BLS/AggregationInfo

#Export the public objects and tbe sublibraries.
export Objects.PrivateKey, Objects.PublicKey
export Objects.Signature, Objects.AggregationInfo
export PrivateKey, PublicKey, Signature, AggregationInfo
