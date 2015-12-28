import UIKit

class SuggestionBarView: UIStackView {
    override class func requiresConstraintBasedLayout() -> Bool { return true }
    
    private let verbatimButton = SuggestionBarView.createButton()
    private let primarySuggestionButton = SuggestionBarView.createButton(Colors.highlight)
    private let auxiliarySuggestionButton = SuggestionBarView.createButton()
    
    init() {
        super.init(arrangedSubviews: [])
        
        axis = .Horizontal
        distribution = .FillEqually
        alignment = .Fill
        spacing = 5.0

        verbatimButton.contentEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0)
        addArrangedSubview(verbatimButton)

        addArrangedSubview(primarySuggestionButton)
        addArrangedSubview(auxiliarySuggestionButton)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private static func createButton(titleColor: UIColor = Colors.light) -> UIButton {
        let button = UIButton()
        button.setTitleColor(titleColor, forState: .Normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        return button
    }
    
    func displayVerbatim(verbatim: String?) {
        verbatimButton.setTitle(verbatim, forState: .Normal)
    }
    func onVerbatim(target target: AnyObject, action: Selector) {
        verbatimButton.addTarget(target, action: action, forControlEvents: .TouchUpInside)
    }
    
    func displaySuggestion(suggestion: String?) {
        primarySuggestionButton.setTitle(suggestion, forState: .Normal)
        auxiliarySuggestionButton.setTitle(suggestion, forState: .Normal)
    }
    func getCurrentSuggestion() -> String? {
        return primarySuggestionButton.titleForState(.Normal)
    }
    func onSuggestion(target target: AnyObject, action: Selector) {
        primarySuggestionButton.addTarget(target, action: action, forControlEvents: .TouchUpInside)
    }
}
