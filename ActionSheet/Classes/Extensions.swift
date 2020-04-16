import UIKit

extension UIImage {

    convenience init?(nameInBundle: String) {
        self.init(named: nameInBundle, in: GrouviActionSheet.bundle, compatibleWith: nil)
    }

}

extension UIViewController {

    public var toBottomSheet: UIViewController {
        ActionSheetControllerNew(content: self, configuration: ActionSheetConfiguration(style: .sheet))
    }

    public var toAlert: UIViewController {
        ActionSheetControllerNew(content: self, configuration: ActionSheetConfiguration(style: .alert))
    }

    public func toActionSheet(configuration: ActionSheetConfiguration) -> UIViewController {
        ActionSheetControllerNew(content: self, configuration: configuration)
    }

}