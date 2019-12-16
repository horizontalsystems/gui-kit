import UIKit

public protocol RespondViewDelegate: class {
    var touchTransparent: Bool { get }
    func touchBegan()
    func touchEnd()
}

public class RespondView: UIView {
    private static let touchableAreaInset: CGFloat = 50
    public weak var delegate: RespondViewDelegate?

    public var handleTouch: (() -> ())?

    private var firstTouch: UITouch?
    private var began = false

    private var isValidTouch: Bool {
        guard let touch = firstTouch else {
            return false
        }

        let touchArea = self.bounds.insetBy(dx: -RespondView.touchableAreaInset, dy: -RespondView.touchableAreaInset)
        return touchArea.contains(touch.location(in: self))
    }

    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.touchBegan()

        firstTouch = touches.first
        began = true

        if delegate?.touchTransparent ?? true {
            super.touchesBegan(touches, with: event)
        }


    }

    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.touchEnd()
        if isValidTouch {
            handleTouch?()
        }

        began = false
        firstTouch = nil

        if delegate?.touchTransparent ?? true {
            super.touchesEnded(touches, with: event)
        }
    }

    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)

        let valid = isValidTouch
        if (began && !valid) || (!began && valid) {
            began = isValidTouch
            if began {
                delegate?.touchBegan()
            } else {
                delegate?.touchEnd()
            }
        }
    }

    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.touchEnd()

        began = false
        firstTouch = nil

        super.touchesCancelled(touches, with: event)
    }

}
