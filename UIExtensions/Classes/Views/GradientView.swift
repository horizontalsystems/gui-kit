import UIKit

open class GradientView: UIView {
    private let gradientLayer = CAGradientLayer()

    private let fromColor: UIColor
    private let toColor: UIColor
    private let gradientHeight: CGFloat

    public init(gradientHeight: CGFloat, fromColor: UIColor, toColor: UIColor) {
        self.gradientHeight = gradientHeight
        self.fromColor = fromColor
        self.toColor = toColor

        super.init(frame: .zero)

        gradientLayer.locations = [0, 1]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        layer.addSublayer(gradientLayer)

        updateUI()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        let endPosition: CGFloat = gradientHeight / bounds.height
        gradientLayer.endPoint = CGPoint(x: 0.5, y: endPosition)
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        updateUI()
    }

    private func updateUI() {
        gradientLayer.colors = [fromColor.cgColor, toColor.cgColor]
    }

}
