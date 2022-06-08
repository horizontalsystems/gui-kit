import UIKit

class DimHUDWindow: BackgroundHUDWindow {
    private var dimViewController: DimViewController?

    init(frame: CGRect, level: Level = UIWindow.Level.normal, config: HUDConfig = HUDConfig(), cornerRadius: CGFloat = 0) {
        let coverView = DimCoverView(withModel: config)

        let dimViewController = DimViewController(coverView: coverView)
        self.dimViewController = dimViewController

        super.init(frame: frame, rootController: dimViewController, coverView: coverView, level: level, cornerRadius: cornerRadius)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

}

extension DimHUDWindow {

    var onTap: (() -> ())? {
        get { dimViewController?.onTap }
        set { dimViewController?.onTap = newValue }
    }

}
