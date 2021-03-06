private func myMin(a: Distance, _ b: Distance, _ c: Distance) -> Distance {
    if a < b { return a < c ? a : c }
    else { return b < c ? b : c }
}

private class Array2D {
    var cols: Int, rows: Int
    var matrix: [Distance]
    
    init(cols: Int, rows: Int) {
        self.cols = cols
        self.rows = rows
        matrix = Array(count:cols*rows, repeatedValue: 0)
    }
    
    subscript(col: Int, row: Int) -> Distance {
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

func wordDistance(aStr: String, _ bStr: String, threshold: Distance = .max) -> Distance {
    let a = Array(aStr.utf16)
    let b = Array(bStr.utf16)
    
    if a.count == 0 { return Distance(b.count) }
    if b.count == 0 { return Distance(a.count) }
    
    let dist = Array2D(cols: a.count + 1, rows: b.count + 1)
    
    // 'a' prefixes can be transformed into empty string by deleting every char
    for i in 1...a.count {
        dist[i, 0] = Distance(i)
    }
    
    // 'b' prefixes can be created from empty string by inserting every char
    for j in 1...b.count {
        dist[0, j] = Distance(j)
    }
    
    for i in 1...a.count {
        var couldUndercutThreshold = false
        for j in 1...b.count {
            var newValue: Distance
            if a[i-1] == b[j-1] {
                newValue = dist[i-1, j-1]  // noop
                dist[i, j] = newValue
            } else {
                let delete = dist[i-1, j] + 1
                let insert = dist[i, j-1] + 1
                let substitute = dist[i-1, j-1] + distanceBetweenUInt16Chars(a[i-1], and: b[j-1])
                newValue = myMin(delete, insert, substitute)
                dist[i, j] = newValue
            }
            if newValue < threshold { couldUndercutThreshold = true }
        }
        if !couldUndercutThreshold { return Distance.max }
    }
    
    return dist[a.count, b.count]
}
