import UIKit

class LayerFrameHelper {
    static let halfDp = 0.5 / UIScreen.main.scale

    /** calculate frame using layer insets and size.
        for use size each one of axis inset must be negative(not using)
    */
    static func frame(insets: UIEdgeInsets, size: CGSize?, in bounds: CGRect) -> CGRect {
        guard let size = size else {  // no need to calculate frame, just add insets
            return bounds.inset(by: insets)
        }
        var newFrame = CGRect(origin: .zero, size: size)
        if insets.left < 0 {            // When left inset is negative, right is required
            newFrame.origin.x = bounds.width - insets.right - size.width
        } else if insets.right < 0 {    // When right inset is negative, left is required
            newFrame.origin.x = insets.left
        } else {                        // When both insets are positive, size.width is ignored
            newFrame.origin.x = insets.left
            newFrame.size.width = bounds.width - insets.right - insets.left
        }
        if insets.top < 0 {           // if top inset is negative, bottom inset is required
            newFrame.origin.y = bounds.height - insets.bottom - size.height
        } else if insets.bottom < 0 {
            newFrame.origin.y = insets.top
        } else {
            newFrame.origin.y = insets.top
            newFrame.size.height = bounds.height - insets.top - insets.bottom
        }
        return newFrame
    }

    static func offset(lineWidth: CGFloat) -> CGFloat {
        lineWidth.truncatingRemainder(dividingBy: 1) > 0 ? halfDp : 0
    }

}
