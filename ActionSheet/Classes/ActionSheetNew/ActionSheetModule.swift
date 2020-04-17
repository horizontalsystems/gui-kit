public protocol ActionSheetView: class {
    func dismissView(animated: Bool)       // child viewController can't get access to parentVC from iOS 5.*
//    func didChangeHeight()               // Change height flicker for .sheet
}

public protocol ActionSheetViewDelegate: class {
    var actionSheetView: ActionSheetView? { get set }
    var height: CGFloat? { get }
}

extension ActionSheetViewDelegate {

    public var actionSheetView: ActionSheetView? {
        get { nil }
        set { ()  }
    }

    public var height: CGFloat? {
        nil
    }

}
