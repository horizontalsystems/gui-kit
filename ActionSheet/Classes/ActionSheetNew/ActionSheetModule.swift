public protocol ActionSheetView: class {
    func dismissView(animated: Bool)       // child viewController can't get access to parentVC from iOS 5.*
//    func didChangeHeight()               // Change height flicker for .sheet
}

public protocol ActionSheetViewDelegate: class {
    var parentView: ActionSheetView? { get set }
    var height: CGFloat? { get }
}

extension ActionSheetViewDelegate {

    public var parentView: ActionSheetView? {
        get { nil }
        set { ()  }
    }

    public var height: CGFloat? {
        nil
    }

}
