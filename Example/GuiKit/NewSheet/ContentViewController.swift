import UIKit
import SnapKit
import ActionSheet
import SectionsTableView

class ContentViewController: UIViewController {
    weak var actionSheetView: ActionSheetView?

    private let switchButton = UISwitch()
    private let closeButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.darkGray
        let label = UILabel()
        view.addSubview(label)
        label.snp.makeConstraints { maker in
            maker.leading.trailing.top.equalToSuperview().inset(16)
        }
        label.textColor = .white
        label.numberOfLines = 0
        label.text = """
                     Lorem Ipsum is simply dummy text of the printing and typesetting industry. 
                     Lorem Ipsum has been the industry's standard dummy text ever since the 1500s
                     """

        let switchLabel = UILabel()
        view.addSubview(switchLabel)
        view.addSubview(switchButton)

        switchLabel.snp.makeConstraints { maker in
            maker.leading.equalToSuperview().inset(16)
            maker.trailing.equalTo(switchButton.snp.leading).offset(16)
            maker.top.equalTo(label.snp.bottom).offset(8)
        }
        switchLabel.textColor = .white
        switchLabel.text = "expand view"

        switchButton.snp.makeConstraints { maker in
            maker.trailing.equalToSuperview().inset(16)
            maker.centerY.equalTo(switchLabel)
        }
        switchButton.addTarget(self, action: #selector(changeSize), for: .valueChanged)

        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview()
            maker.top.equalTo(switchButton.snp.bottom).offset(16)
            maker.bottom.equalToSuperview().inset(16)
        }
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.setTitle("Close", for: .normal)
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
    }

    @objc func close() {
        dismiss(animated: true)
    }

    @objc func changeSize() {
        closeButton.snp.updateConstraints { maker in
            maker.bottom.equalToSuperview().inset(switchButton.isOn ? 48 : 16)
        }
        actionSheetView?.didChangeHeight()
    }

    deinit {
//        print("deinit \(self)")
    }

}

// ActionSheetViewDelegate is optional protocol. You may ignore it if you won't set height or dismiss action sheet from content
// no need to set height if view calculate height by constraints or animated change size

extension ContentViewController: ActionSheetViewDelegate {}

// InteractiveTransitionDelegate is optional protocol. You may ignore it if you won't handle interactive swipe bottom sheet

extension ContentViewController: InteractiveTransitionDelegate {

    public func start(direction: TransitionDirection) {
        print("Start \(direction == .dismiss ? "dismiss" : "present") Transition")
    }

    public func move(direction: TransitionDirection, percent: CGFloat) {
        print("Move \(direction == .dismiss ? "dismiss" : "present") percent: \(percent)")
    }

    public func end(direction: TransitionDirection, cancelled: Bool) {
        print("End \(direction == .dismiss ? "dismiss" : "present") Transition with cancelled: \(cancelled)")
    }

}
