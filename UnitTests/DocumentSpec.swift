import Quick
import Nimble
import AppExtension

class SomeTextDocumentProxy: UITextDocumentProxyAdapter {
    override func insertText(text: String) {
        expect(text).to(equal("foo"))
    }
}


class SomeSpec: QuickSpec {
    override func spec() {
        describe("Document") {
            it("passes string to proxy unchaged") {
                var document = Document(proxy: SomeTextDocumentProxy())
                document.insert("foo")
            }
        }
    }
}