import UIKit

public func < (lhs: BaseActionItem, rhs: BaseActionItem) -> Bool {
    return (lhs.tag ?? 0) < (rhs.tag ?? 0)
}

public func == (lhs: BaseActionItem, rhs: BaseActionItem) -> Bool {
    if let lTag = lhs.tag , let rTag = rhs.tag {
        return lTag == rTag
    }

    return false
}

open class BaseActionItem: Comparable {

    public var selectable = false
    public var showSeparator = true
    public var hidden = false
    public var showState = true
    public var required = true
    public var nibType = false
    public var cellType: BaseActionItemView.Type

    public var tag: Int?
    public var action: ((BaseActionItemView) -> ())?
    public var height: CGFloat = ItemActionTheme.defaultItemHeight

    public init(cellType: BaseActionItemView.Type = BaseActionItemView.self, tag: Int? = nil, hidden: Bool = false, required: Bool = false, action: ((BaseActionItemView) -> ())? = nil) {
        self.cellType = cellType
        self.tag = tag
        self.required = required
        self.hidden = hidden
        self.action = action
    }

    open func changeHeight(for: CGFloat) -> Bool {
        return false
    }

}
