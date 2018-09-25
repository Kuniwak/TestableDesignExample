import Foundation


// NOTE: In general, CharacterSet is not equivalent to Set<Character>, but equivalent to Set<Unicode.Scalar>.
// SEE: https://github.com/apple/swift/blob/swift-4.0-RELEASE/docs/StringManifesto.md#character-and-characterset
let asciiLowerAlpha = Set("abcdefghijklmnopqrstuvwxyz")
let asciiUpperAlpha = Set("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
let asciiAlpha = asciiLowerAlpha.union(asciiUpperAlpha)
let asciiDigit = Set("0123456789")
let asciiAlphaNumeric = asciiAlpha.union(asciiDigit)
let asciiSymbol = Set(" !\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~")
let asciiPrintable = asciiAlphaNumeric.union(asciiSymbol)



func characters(in text: String, without characters: Set<Character>) -> Set<Character> {
    var characterSet = Set(text)
    characterSet.subtract(characters)
    return characterSet
}



func string(from characters: Set<Character>) -> String {
    var result = ""

    characters.sorted().forEach { character in
        result.append(character)
    }

    return result
}