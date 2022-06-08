import Foundation


class BackgroundHUDWindow: HUDWindow {
    private(set) var coverView: CoverViewInterface

    init(frame: CGRect, rootController: UIViewController, coverView: CoverViewInterface, level: UIWindow.Level = UIWindow.Level.normal, cornerRadius: CGFloat = 0) {
        self.coverView = coverView
        super.init(frame: frame, rootController: rootController, level: level, cornerRadius: cornerRadius)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    func set(transparent: Bool) {
        self.transparent = transparent
        coverView.transparent = transparent
    }

}
