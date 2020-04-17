import UIKit
import SnapKit
import ActionSheet
import SectionsTableView

class ContentViewController: UIViewController {
    weak var actionSheetView: ActionSheetView?

    private let closeButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black
        let label = UILabel()
        view.addSubview(label)
        label.snp.makeConstraints { maker in
            maker.leading.trailing.top.equalToSuperview().inset(16)
        }
        label.textColor = .white
        label.numberOfLines = 0
        label.text = """
                     Lorem Ipsum is simply dummy text of the printing and typesetting industry. 
                     Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,
                     when an unknown printer took a galley of type and scrambled it to make a type specimen book.
                     It has survived not only five centuries, but also the leap into electronic typesetting,
                     remaining essentially unchanged. It was popularised in the 1960s with the release
                     of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop
                     publishing software like Aldus PageMaker including versions of Lorem Ipsum.
                     """

//      animation change height not working for .sheet. ContentView height change immediately when try change height or constraints.

//        let switchLabel = UILabel()
//        view.addSubview(switchLabel)
//        view.addSubview(switchButton)
//
//        switchLabel.snp.makeConstraints { maker in
//            maker.leading.equalToSuperview().inset(16)
//            maker.trailing.equalTo(switchButton.snp.leading).offset(16)
//            maker.top.equalTo(label.snp.bottom).offset(8)
//        }
//        switchLabel.textColor = .white
//        switchLabel.text = "expand view"
//
//        switchButton.snp.makeConstraints { maker in
//            maker.trailing.equalToSuperview().inset(16)
//            maker.centerY.equalTo(switchLabel)
//        }
//        switchButton.addTarget(self, action: #selector(changeSize), for: .valueChanged)

        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview()
            maker.top.equalTo(label.snp.bottom).offset(16)
            maker.bottom.equalToSuperview().inset(16)
        }
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.setTitle("Close", for: .normal)
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
    }

    @objc func close() {
        dismiss(animated: true)
    }

    deinit {
//        print("deinit \(self)")
    }

}

// ActionSheetViewDelegate is optional protocol. You may ignore it if you wan't set height or dismiss action sheet from content
// no need to set height if view calculate height by constraints

extension ContentViewController: ActionSheetViewDelegate {}