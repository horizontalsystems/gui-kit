import UIKit
import SnapKit
import ThemeKit

class HUDWindow: ThemeWindow {
    override var frame: CGRect {
        didSet { // IMPORTANT. When window is square safeAreaInsets in willTransition controller rotate not changing!
            if abs(frame.height - frame.width) < 1 / UIScreen.main.scale {
                frame.size = CGSize(width: frame.width, height: frame.height + 1 / UIScreen.main.scale)
            }
        }
    }

    init(frame: CGRect, rootController: UIViewController, level: UIWindow.Level = UIWindow.Level.normal, cornerRadius: CGFloat = 0) {
        super.init(frame: frame)

        isHidden = false
        windowLevel = level
//        layer.cornerRadius = cornerRadius
        backgroundColor = .clear
        rootViewController = rootController
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    deinit {
//        print("deinit HUDWindow \(self)")
    }

}
