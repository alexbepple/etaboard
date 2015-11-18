import Foundation
import CoreGraphics


let iPhone6Layout = ConcreteLayout(schematicLayout: SchematicLayout.Lowercase, size: CGSizeMake(375, 182))
func distanceBetween(charA: Character, and charB: Character) -> Distance {
    return iPhone6Layout.normalizedDistanceBetween(String(charA), and: String(charB))
}

let alphabet = "abcdefghijklmnopqrstuvwxyz"
let allLowercaseSimilarChars = [
    "a": "äáàâ",
    "o": "öø",
    "s": "ß",
    "u": "üú",
]

let similarDistance = 0.02

func similarCharsFor(char: Character) -> [Character] {
    let uppercaseChar = [char.uppercase()]
    if let similarChars = allLowercaseSimilarChars[String(char)] {
        return uppercaseChar + Array(similarChars.characters)
    }
    return uppercaseChar
}
func similarCodesFor(char: Character) -> String {
    return similarCharsFor(char).map { $0.code() }
        .map(String.init).joinWithSeparator(",")
}



var lines = [
    "// generated",
    "import Foundation",
    "func distanceBetweenUInt16Chars(codeA: UInt16, and codeB: UInt16) -> Distance {",
    "if codeA == codeB { return 0 }",
    "switch (codeA) {",
]

for charA in alphabet.characters {
    lines.appendContentsOf([
        "case \(charA.code()):  // \(charA)",
        "    switch (codeB) {",
        ])
    for charB in alphabet.characters {
        let distance = distanceBetween(charA, and: charB)
        if distance < 0.15 {
            lines.append("    case \(charB.code()): return \(distance)  // \(charB)")
        }
    }
    lines.appendContentsOf([
        "    case \(charA.uppercase().code()): return \(0.01)  // \(charA.uppercase()))",
        ])
    lines.appendContentsOf([
        "    case \(similarCodesFor(charA)): return \(similarDistance)  // \(similarCharsFor(charA))",
        ])
    lines.appendContentsOf([
        "    default: return 1",
        "    }",
        ])

    lines.appendContentsOf([
        "case \(charA.uppercase().code()):  // \(charA.uppercase())",
        "    switch (codeB) {",
        "    case \(charA.code()): return \(0.01)  // \(charA)",
        "    default: return 1",
        "    }",
        "case \(similarCodesFor(charA)):  // \(similarCharsFor(charA))",
        "    switch (codeB) {",
        "    case \(charA.code()): return \(similarDistance)  // \(charA)",
        "    default: return 1",
        "    }",
        ])
}

lines.appendContentsOf([
    "default: return 1",
    "}",
    "}",
    ])
print(lines.joinWithSeparator("\n"))
