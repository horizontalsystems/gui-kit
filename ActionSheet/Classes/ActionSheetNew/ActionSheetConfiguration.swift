import Foundation

public struct ActionSheetConfiguration {
    public var style: ActionStyleNew
    public var tapToDismiss: Bool = true

    public var coverBackgroundColor: UIColor = UIColor(white: 0, alpha: 0.5)

    public var animationDuration: TimeInterval = 0.3
    public var animationCurve: UIView.AnimationCurve = .easeInOut

    public var sideMargin: CGFloat
    public var cornerRadius: CGFloat = 16

    public init(style: ActionStyleNew) {
        self.style = style

        switch style {
        case .alert:
            sideMargin = 52
        case .sheet:
            sideMargin = 10
        }
    }

}
