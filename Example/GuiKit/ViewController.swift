import UIKit
import HUD
import SectionsTableView
import UIExtensions
import ActionSheet
import SnapKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Show HUD", for: .normal)
        button.addTarget(self, action: #selector(showHud), for: .touchUpInside)

        view.addSubview(button)

        button.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
        }
    }
    
    @objc func showHud() {
        show(title: "Hello World")
    }

    private func show(title: String?) {
        var config = HUDConfig()
        config.style = .center
        config.startAdjustSize = 0.8
        config.finishAdjustSize = 0.8
        config.preferredSize = CGSize(width: 146, height: 114)
        config.backgroundColor = .lightGray
        config.blurEffectStyle = .regular

        HUD.instance.config = config

        let content = HUDStatusFactory.instance.view(type: .success, title: title)
        HUD.instance.showHUD(content, onTapHUD: { hud in
            hud.hide()
        })
    }

}
