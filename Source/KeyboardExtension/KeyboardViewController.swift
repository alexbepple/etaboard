import UIKit

class KeyboardViewController: UIInputViewController {
    var document: Document!

    var suggestionBar: SuggestionBarView!

    var keyboardModel = KeyboardModel()
    var keyboardView: KeyboardView!
    var keyPressHandler: KeyPressHandler?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.darkGrayColor()
        document = Document(proxy: textDocumentProxy )
        initSuggestionBar()
        initKeyboardView()
        layoutSubviews()
    }
    
    private func layoutSubviews() {
        self.view.align([.Top, .Width], of: suggestionBar)
        self.view.align([.Width, .Bottom], of: keyboardView!)
        self.view.align(.Top, of: keyboardView!, with: .Bottom, of: suggestionBar)
    }
}

extension KeyboardViewController {
    private func initKeyboardView() {
        keyPressHandler = KeyPressHandler(
            inputViewController: self,
            keyboard: keyboardModel,
            document: document!)
        
        keyboardView = KeyboardView.create(keyboardModel)
        keyboardView.translatesAutoresizingMaskIntoConstraints = false
        keyboardModel.delegate = keyboardView
        
        self.view.addSubview(keyboardView)
        
        let tapRecognizer = MyTapRecognizer(
            target: self, action: "handleTap:")
        keyboardView.addGestureRecognizer(tapRecognizer)
    }
    
    func handleTap(recognizer: UIGestureRecognizer) {
        let touchPoint = recognizer.locationInView(self.keyboardView)
        let key = keyboardModel.closestKey(to: touchPoint)
        keyPressHandler?.handle(key)
    }
}

extension KeyboardViewController {
    private func initSuggestionBar() {
        suggestionBar = SuggestionBarView(target: self, action: "didTapSuggestion:")
        suggestionBar.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(suggestionBar)
        
        document.delegate = suggestionBar
    }
    
    func didTapSuggestion(sender: AnyObject?) {
        let button = sender as! UIButton
        let title = button.titleForState(.Normal)
        
        document?.replaceCurrentWord(title!)
    }
}
