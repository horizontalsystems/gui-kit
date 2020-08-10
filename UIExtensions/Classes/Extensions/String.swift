import UIKit

extension String {

    public func height(forContainerWidth containerWidth: CGFloat, font: UIFont) -> CGFloat {
        size(containerWidth: containerWidth, font: font).height
    }

    public func size(containerWidth: CGFloat, font: UIFont) -> CGSize {
        let size = (self as NSString).boundingRect(
                with: CGSize(width: containerWidth, height: .greatestFiniteMagnitude),
                options: [.usesFontLeading, .usesLineFragmentOrigin],
                attributes: [.font: font],
                context: nil).size
        return CGSize(width: ceil(size.width), height: ceil(size.height))
    }

    public func stripHexPrefix() -> String {
        let prefix = "0x"

        if self.hasPrefix(prefix) {
            return String(self.dropFirst(prefix.count))
        }

        return self
    }

}
