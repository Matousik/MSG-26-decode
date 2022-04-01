binMessage = hexToBinaryVector('536913FDE0A9043819C0CE067023FFBFFDFFEF04B821C0CE078033803C8C4A80',256);

preamble = binaryVectorToHex(binMessage(1,1:8))

type = binaryVectorToHex(binMessage(1,9:14))

Band = binaryVectorToHex(binMessage(1,15:18))

block = string(binaryVectorToHex(binMessage(1,19:22)))

blockindec = string(hex2dec(block))