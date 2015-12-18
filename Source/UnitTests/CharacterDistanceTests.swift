import XCTest
import Nimble

class CharacterDistanceTests: XCTestCase {
    func testIs0ToItself() {
        expect(distanceBetweenChars("a", "a")) == 0
    }
    
    func testIs1ToCharFarApart() {
        expect(distanceBetweenChars("a", "l")) == 1
    }
    
    func testIsInBetweenToNeighboringChar() {
        expect(distanceBetweenChars("a", "s")) > 0
        expect(distanceBetweenChars("a", "s")) < 1
    }
    
    func testIsCommutative() {
        expect(distanceBetweenChars("A", "a")) ==
            distanceBetweenChars("a", "A")
    }
    
    func testUppercaseAndDiacriticalVariantsArePartOfTheFamily() {
        expect("ä").to(beSimilarTo("a"))
        expect("Ä").to(beSimilarTo("a"))
        expect("A").to(beSimilarTo("a"))
        
        expect("A").to(beSimilarTo("Ä"))
        expect("A").to(beSimilarTo("ä"))
        
        expect("Ä").to(beSimilarTo("ä"))
    }
    

    func testCharsWithDiacricticalMarksRemainCloseToNeighboringChars() {
        expect(distanceBetweenChars("ä", "s")) ≈
               distanceBetweenChars("ä", "a") + distanceBetweenChars("a", "s")
    }

    func testUppercaseCharsRemainCloseToNeighboringChars() {
        expect(distanceBetweenChars("A", "s")) ≈
            distanceBetweenChars("A", "a") + distanceBetweenChars("a", "s")
    }

    func testUppercaseIsCloserThanWithDiacriticalMark() {
        expect(distanceBetweenChars("a", "A")) <
               distanceBetweenChars("a", "ä")
    }
    
    func testUppercaseVariantsOfBaseCharactersHaveSameDistanceAsLowercaseVariants() {
        expect(distanceBetweenChars("K", "L")) ==
               distanceBetweenChars("k", "l")
    }

    func testUppercaseVariantsOfDiacriticalCharactersHaveSameDistanceAsLowercaseVariants() {
        expect(distanceBetweenChars("A", "Ä")) ==
               distanceBetweenChars("a", "ä")
    }
    
}


func distanceBetweenChars(charA: Character, _ charB: Character) -> Distance {
    return distanceBetweenUInt16Chars(charA.code(), and: charB.code())
}

private func formatDistance(distance: Distance) -> String {
    return String(format: "%.3f", distance)
}

func beSimilarTo(expected: Character) -> MatcherFunc<String> {
    let limit = distanceBetweenChars("a", "s")
    
    return MatcherFunc { actualExpression, failureMessage in
        guard let actual = try actualExpression.evaluate() else {
            return false
        }
        
        let distance = distanceBetweenChars(expected, actual.first())
        failureMessage.postfixMessage = "be closer than <\(formatDistance(limit))>"
        failureMessage.postfixActual = " (distance: \(formatDistance(distance)))"
        return distance > 0 && distance < limit
    }
}
