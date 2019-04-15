import UIKit

public protocol RespondViewDelegate: class {
    var touchTransparent: Bool { get }
    func touchBegan()
    func touchEnd()
}

public class RespondView: UIView {
    public weak var delegate: RespondViewDelegate?

    public var handleTouch: (() -> ())?

    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.touchBegan()
        if delegate?.touchTransparent ?? true {
            super.touchesBegan(touches, with: event)
        }
    }

    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.touchEnd()
        handleTouch?()

        if delegate?.touchTransparent ?? true {
            super.touchesEnded(touches, with: event)
        }
    }

    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.touchEnd()

        super.touchesCancelled(touches, with: event)
    }

}
