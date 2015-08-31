import UIKit

class KeyboardModel {
    static let ENTER = "<cr>"
    
    let rows = [
        "1 2 3 4 5 6 7 8 9 0 ß",
        "q w e r t z u i o p ü",
        "a s d f g h j k l ö ä \(ENTER)",
        "y x c v b n m , ."
    ]
    
    var coordinates = [String: (CGFloat, CGFloat)]()

    var keyboardSize: CGSize {
        get {
            // this is crap
            return self.keyboardSize
        }
        set(newSize) {
            let noOfRowSegments = CGFloat(rows.count * 2)
            for (rowIdx, row) in enumerate(rows) {
                let y = newSize.height / noOfRowSegments * (CGFloat(rowIdx) * 2 + 1)
                
                let keysInRow = split(row) {$0 == " "}
                let numberOfKeySegments = CGFloat(keysInRow.count * 2)
                for (posInRow, key) in enumerate(keysInRow) {
                    var x = newSize.width / numberOfKeySegments * (CGFloat(posInRow) * 2 + 1)
                    coordinates[key] = (x, y)
                }
            }
        }
    }
    
    init() {
        self.keyboardSize = CGSize(width: 0, height: 0)
    }

    
    func keysWithCoordinates() -> [String: (CGFloat, CGFloat)] {
        return coordinates
    }
    
    func distanceBetween(pointA: (CGFloat, CGFloat), and: CGPoint) -> CGFloat {
        let dx = pointA.0 - and.x
        let dy = pointA.1 - and.y
        return sqrt(dx*dx + dy*dy)
    }
    
    func key(tap: CGPoint) -> String {
        var keyForDistance = [CGFloat: String]()
        
        for (key, keyCoordinates) in coordinates {
            keyForDistance[distanceBetween(keyCoordinates, and: tap)] = key
        }
        
        return keyForDistance[minElement(keyForDistance.keys)]!
    }
}