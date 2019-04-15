import UIKit

extension UIImage {

    convenience init?(nameInBundle: String) {
        self.init(named: nameInBundle, in: GrouviActionSheet.bundle, compatibleWith: nil)
    }

}
