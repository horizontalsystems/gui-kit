import UIKit

public class TintImageView: UIImageView, RespondViewDelegate {
    public var touchTransparent: Bool { return false }

    private var _tintColor: UIColor?
    private var selectedTintColor: UIColor?
    private var tintMode = false
    public override var tintColor: UIColor! {
        get {
            return super.tintColor
        }
        set {
            tintMode = newValue != nil
            super.tintColor = newValue
        }
    }
    public override var image: UIImage? {
        get {
            return super.image
        }
        set {
            guard tintMode else {
                super.image = newValue
                return
            }
            super.image = newValue?.withRenderingMode(.alwaysTemplate)
        }
    }

    public init() {
        super.init(frame: .zero)
    }

    public init(image: UIImage?, tintColor: UIColor, selectedTintColor: UIColor) {
        super.init(image: image?.withRenderingMode(.alwaysTemplate))
        self.tintColor = tintColor
        self.selectedTintColor = selectedTintColor
    }

    public init(image: UIImage?, selectedImage: UIImage?) {
        super.init(image: image)
        self.highlightedImage = selectedImage
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

    public func touchBegan() {
        if highlightedImage != nil {
            isHighlighted = true
        } else {
            _tintColor = tintColor
            tintColor = selectedTintColor
        }
    }

    public func touchEnd() {
        isHighlighted = false
        tintColor = _tintColor
    }

}
