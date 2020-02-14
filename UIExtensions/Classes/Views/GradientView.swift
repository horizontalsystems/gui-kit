import UIKit

public class GradientView: UIView {
    private let gradientLayer = CAGradientLayer()

    private let gradientHeight: CGFloat

    public init(gradientHeight: CGFloat, fromColor: UIColor, toColor: UIColor) {
        self.gradientHeight = gradientHeight
        super.init(frame: .zero)
        gradientLayer.colors = [fromColor.cgColor, toColor.cgColor]
        gradientLayer.locations = [0, 1]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        layer.addSublayer(gradientLayer)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        let endPosition: CGFloat = gradientHeight / bounds.height
        gradientLayer.endPoint = CGPoint(x: 0.5, y: endPosition)
    }

}
