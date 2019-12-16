import UIKit

public class LayoutHelper {
    public static let instance = LayoutHelper()
    public static let insetZero: UIEdgeInsets = UIEdgeInsets(top: 0, left: -64, bottom: 0, right: 0) // 44 - max safe area, 20 - max margin

    private init() {}

    public lazy var marginContentInset: CGFloat = {
        let width = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        return width < 385 || width > 760 ? 15 : 20
    }()

    public func safeInsets(for view: UIView? = nil) -> UIEdgeInsets {
        if #available(iOS 11, *) {
            if let view = view {
                return view.safeAreaInsets
            } else {
                return UIApplication.shared.keyWindow?.safeAreaInsets ?? UIEdgeInsets.zero
            }
        } else {
            return UIEdgeInsets.zero
        }
    }

    public var contentMarginWidth: CGFloat {
        return marginContentInset * 2 + safeInsets().width
    }

    static public func sizeForContainer(size: CGSize?) -> CGSize {
        var size = size ?? UIScreen.main.bounds.size
        let insets = LayoutHelper.instance.safeInsets(for: nil)
        size.width = max(0, size.width - insets.width)
        size.height = max(0, size.height - insets.height)
        return size
    }

    public func getSingleMediaSize(width: Int, height: Int, minHeight: CGFloat = 50, maxHeight: CGFloat = 150, minWidth: CGFloat, maxWidth: CGFloat) -> CGSize {
        let imageWidth = width > 0 ? CGFloat(abs(width)) / UIScreen.main.scale : minWidth
        let imageHeight = height > 0 ? CGFloat(abs(height)) / UIScreen.main.scale : minHeight

        let imageRatio = imageWidth / imageHeight
        let containerRatio = maxWidth / maxHeight

        var width = containerRatio > imageRatio ? imageWidth * maxHeight / imageHeight : maxWidth
        var height = containerRatio > imageRatio ? maxHeight : imageHeight * maxWidth / imageWidth

        if width < minWidth {
            width = minWidth
            height = min(maxHeight, height * minWidth / width)
        } else if height < minHeight {
            width = min(maxWidth, width * minHeight / height)
            height = minHeight
        }

        return CGSize(width: floor(width), height: floor(height))
    }

}
