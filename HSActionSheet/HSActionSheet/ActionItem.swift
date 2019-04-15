import UIKit

open class ActionItem: BaseActionItem {

    public var title: String?
    public var titleColor: UIColor?
    public var iconImage: UIImage?
    public var bold = false

    public init(iconImage: UIImage? = nil, title: String? = nil, titleColor: UIColor? = nil, bold: Bool = false, tag: Int? = nil, hidden: Bool = false, required: Bool = false, action: ((BaseActionItemView) -> ())? = nil) {
        super.init(cellType: ActionItemView.self, tag: tag, hidden: hidden, required: required, action: action)

        self.bold = bold
        self.selectable = true
        self.iconImage = iconImage
        self.title = title
        self.titleColor = titleColor
    }

}
