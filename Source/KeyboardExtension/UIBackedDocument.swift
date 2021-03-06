import UIKit

class UIBackedDocument: Document {
    let proxy: UITextDocumentProxy
    
    init(proxy: UITextDocumentProxy) {
        self.proxy = proxy
    }
    
    func replaceToken(text: String) {
        deleteNonWhiteSpaceToken()
        insert(text)
    }
    
    func getToken() -> String? {
        guard let input = proxy.documentContextBeforeInput else { return nil }
        if input.hasSuffix(" ") || input.hasSuffix("\n") { return nil }
        
        let options: NSLinguisticTaggerOptions = [.OmitWhitespace]
        let scheme = NSLinguisticTagSchemeTokenType
        let tagger = NSLinguisticTagger(tagSchemes: [scheme], options: Int(options.rawValue))
        let range = NSMakeRange(0, input.characters.count)
        tagger.string = input
        
        var tokens: [String] = []
        tagger.enumerateTagsInRange(range, scheme: scheme, options: options) {
            (tag, tokenRange, _, _) in
            let token = (input as NSString).substringWithRange(tokenRange)
            tokens.append(token)
        }
        NSLog("tokens: \(tokens)")
        
        return tokens.last
    }
    
    func deleteNonWhiteSpaceToken() -> Bool {
        return delete(getToken())
    }
    
    func deleteToken() -> Bool {
        guard let input = proxy.documentContextBeforeInput else { return false }
        NSLog("input: <\(input)>")
        
        let options: NSLinguisticTaggerOptions = []
        let scheme = NSLinguisticTagSchemeTokenType
        let tagger = NSLinguisticTagger(tagSchemes: [scheme], options: Int(options.rawValue))
        let range = NSMakeRange(0, input.characters.count)
        tagger.string = input
        
        var tokens: [String] = []
        tagger.enumerateTagsInRange(range, scheme: scheme, options: options) {
            (tag, tokenRange, _, _) in
                let token = (input as NSString).substringWithRange(tokenRange)
                tokens.append(token)
        }
        NSLog("tokens: \(tokens)")
        
        return delete(tokens.last)
    }
    
    private func delete(string: String?) -> Bool {
        guard let string = string else { return false }
        
        for _ in 0..<string.characters.count {
            deleteBackward()
        }
        return true
    }
    
    func deleteBackward() {
        proxy.deleteBackward()
    }
    
    func insert(text: String) {
        proxy.insertText(text)
    }
}