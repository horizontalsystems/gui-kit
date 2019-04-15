import UIKit

open class TitleItem: BaseActionItem {

    public var title: NSAttributedString?
    public var titleColor: UIColor?
    public var titleFont: UIFont?

    public var addOffset: Bool = false
    public var sideOffset: CGFloat?
    public var topOffset: CGFloat?

    public init(title: NSAttributedString? = nil, tag: Int? = nil, hidden: Bool = false, required: Bool = false, action: ((BaseActionItemView) -> ())? = nil) {
        super.init(cellType: TitleItemView.self, tag: tag, hidden: hidden, required: required, action: action)

        height = TitleItemTheme.defaultItemHeight
        showSeparator = false
        selectable = false
        self.title = title
    }

}
