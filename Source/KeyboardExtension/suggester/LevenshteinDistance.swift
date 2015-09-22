private class Array2D {
    var cols: Int, rows: Int
    var matrix: [Int]
    
    init(cols: Int, rows: Int) {
        self.cols = cols
        self.rows = rows
        matrix = Array(count:cols*rows, repeatedValue:0)
    }
    
    subscript(col: Int, row: Int) -> Int {
        get {
            return matrix[cols * row + col]
        }
        set {
            matrix[cols * row + col] = newValue
        }
    }
    
    func colCount() -> Int {
        return self.cols
    }
    
    func rowCount() -> Int {
        return self.rows
    }
}

func levenshteinDistance(aStr: String, s2 bStr: String) -> Int {
    let a = Array(aStr.characters)
    let b = Array(bStr.characters)
    
    if a.count == 0 { return b.count }
    if b.count == 0 { return a.count }
    
    let dist = Array2D(cols: a.count + 1, rows: b.count + 1)
    
    // 'a' prefixes can be transformed into empty string by deleting every char
    for i in 1...a.count {
        dist[i, 0] = i
    }
    
    // 'b' prefixes can be created from empty string by inserting every char
    for j in 1...b.count {
        dist[0, j] = j
    }
    
    for i in 1...a.count {
        for j in 1...b.count {
            if a[i-1] == b[j-1] {
                dist[i, j] = dist[i-1, j-1]  // noop
            } else {
                let delete = dist[i-1, j] + 1
                let insert = dist[i, j-1] + 1
                let substitute = dist[i-1, j-1] + 1
                dist[i, j] = min(
                    delete,
                    insert,
                    substitute
                )
            }
        }
    }
    
    return dist[a.count, b.count]
}
