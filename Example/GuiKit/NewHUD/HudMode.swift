import UIKit
import ThemeKit
import HUD

enum HudMode {
    case addedToWallet
    case disconnecting
    case disconnected

    var viewItem: HUD.ViewItem {
        switch self {
        case .addedToWallet: return HUD.ViewItem(
                icon: UIImage(named: "add_to_wallet_24")?.withRenderingMode(.alwaysTemplate),
                iconColor: .themeRemus,
                title: "Added to Wallet"
        )

        case .disconnecting: return HUD.ViewItem(icon: UIImage(named: "disconnecting_24")?.withRenderingMode(.alwaysTemplate),
                iconColor: .themeGray,
                title: "Disconnecting",
                showingTime: nil,
                isLoading: true
        )

        case .disconnected: return HUD.ViewItem(icon: UIImage(named: "disconnecting_24")?.withRenderingMode(.alwaysTemplate),
                iconColor: .themeLucian,
                title: "Disconnected Success"
        )
        }
    }

}
