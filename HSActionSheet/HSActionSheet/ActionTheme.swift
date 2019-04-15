import Foundation
import UIKit

public struct ActionSheetThemeConfig {
    public let sideMargin: CGFloat
    public let topMargin: CGFloat
    public let cornerRadius: CGFloat
    public var separatorColor: UIColor?
    public var actionStyle: ActionStyle
    public var backgroundStyle: BackgroundStyle

    public init(actionStyle: ActionStyle = .sheet(showDismiss: true), sideMargin: CGFloat = ActionSheetTheme.sideMargin, topMargin: CGFloat = ActionSheetTheme.topMargin, cornerRadius: CGFloat = ActionSheetTheme.cornerRadius, separatorColor: UIColor? = nil, backgroundStyle: BackgroundStyle = .color(color: UIColor.black.withAlphaComponent(0.7))) {
        self.sideMargin = sideMargin
        self.topMargin = topMargin
        self.cornerRadius = cornerRadius
        self.separatorColor = separatorColor
        self.actionStyle = actionStyle
        self.backgroundStyle = backgroundStyle
    }

}

    public struct ActionSheetTheme {
        static public let sideMargin: CGFloat = 10
        static public let topMargin: CGFloat = 24
        static public let cornerRadius: CGFloat = 10
    }

public struct ItemActionTheme {

    static public let defaultItemHeight: CGFloat = 57
    static public let titleColor = UIColor(hex: 0x007AFF)
    static public let titleFont = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.regular)
    static public let boldTitleFont = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.semibold)
    static public let selectedBackground = UIColor(hex: 0xDBDDDB)
    static public let defaultBackground = UIColor.white

}

public struct TitleItemTheme {

    static let defaultItemHeight: CGFloat = 33
    static let titleColor = UIColor(hex: 0x828282)
    static let titleFont = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.regular)
    static let topOffset: CGFloat = 8
    static let sideOffset: CGFloat = 8

}

