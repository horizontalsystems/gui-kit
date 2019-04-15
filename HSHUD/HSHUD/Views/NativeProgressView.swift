import UIKit
import SnapKit

class NativeProgressView: UIActivityIndicatorView, HUDAnimatedViewInterface {

    init(activityIndicatorStyle: UIActivityIndicatorView.Style, color: UIColor? = nil) {
        super.init(frame: .zero)

        self.style = activityIndicatorStyle
        self.color = color

        commonInit()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("Can't use decoder")
    }

    func commonInit() {
        sizeToFit()
    }

    func set(valueChanger: SmoothValueChanger?) {
        // can't set progress for native activity indicator
    }

    func set(progress: Float) {
        // can't set progress for native activity indicator
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

//        print("touch end")
    }

}
