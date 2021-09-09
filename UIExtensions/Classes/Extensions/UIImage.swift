import UIKit

extension UIImage {

    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }

    public convenience init?(fromColor: UIColor, toColor: UIColor, size: CGSize, startPoint: CGPoint = CGPoint(x: 0.5, y: 0), endPoint: CGPoint = CGPoint(x: 0.5, y: 1)) {
        let layer = CAGradientLayer()
        layer.startPoint = startPoint
        layer.endPoint = endPoint
        layer.frame = CGRect(origin: CGPoint.zero, size: size)
        layer.colors = [fromColor.cgColor, toColor.cgColor]

        var image: UIImage?

        UIGraphicsBeginImageContext(size);
        if let context = UIGraphicsGetCurrentContext() {
            layer.render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext();

        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }

}
