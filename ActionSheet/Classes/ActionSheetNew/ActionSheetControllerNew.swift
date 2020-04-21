import UIKit
import SnapKit

public class ActionSheetControllerNew: UIViewController {
    private let content: UIViewController
    private var viewDelegate: ActionSheetViewDelegate?

    private var dismissAreaButton: UIButton?
    private let configuration: ActionSheetConfiguration

    private var animator: ActionSheetAnimator?

    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    public init(content: UIViewController, configuration: ActionSheetConfiguration) {
        self.content = content
        if let viewDelegate = content as? ActionSheetViewDelegate {
            self.viewDelegate = viewDelegate
        }
        self.configuration = configuration

        super.init(nibName: nil, bundle: nil)

        let animator = ActionSheetAnimator(configuration: configuration)
        self.animator = animator
        transitioningDelegate = animator

        modalPresentationStyle = .custom
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        if configuration.tapToDismiss {
            let dismissAreaButton = UIButton()
            view.addSubview(dismissAreaButton)
            dismissAreaButton.snp.makeConstraints { maker in
                maker.edges.equalToSuperview()
            }
            dismissAreaButton.addTarget(self, action: #selector(didTapDismissArea), for: .touchUpInside)
        }

        // add and setup content as child view controller
        addChildController()
        viewDelegate?.actionSheetView = self
    }

    public override func viewWillDisappear(_ animated: Bool) {
        content.willMove(toParent: nil)

        super.viewWillDisappear(animated)
    }

    public override func viewDidDisappear(_ animated: Bool) {
        removeChildController(animated)
        super.viewDidDisappear(animated)
    }

    @objc private func didTapDismissArea() {
        dismiss(animated: true)
    }

    deinit {
//        print("deinit \(self)")
    }

}

// Child management
extension ActionSheetControllerNew {

    private func addChildController() {
        addChild(content)
        view.addSubview(content.view)
        setContentViewPosition(animation: false)
        content.view.clipsToBounds = true
        content.view.cornerRadius = configuration.cornerRadius
        content.view.layoutIfNeeded()

        content.didMove(toParent: self)
    }

    private func removeChildController(_ animated: Bool) {
        content.viewDidDisappear(animated)
        content.removeFromParent()
        content.view.removeFromSuperview()
    }

    func setContentViewPosition(animation: Bool) {
        content.view.snp.remakeConstraints { maker in
            maker.leading.trailing.equalToSuperview().inset(configuration.sideMargin)
            if configuration.style == .sheet {      // content controller from bottom of superview
                maker.top.equalToSuperview()
                maker.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin).inset(configuration.sideMargin).priority(.required)
            } else {                                // content controller by center of superview
                maker.center.equalToSuperview()
            }
            if let height = viewDelegate?.height {
                maker.height.equalTo(height)
            }
        }
        if animation {
            UIView.animate(withDuration: configuration.animationDuration) { () -> Void in
                self.view.layoutIfNeeded()
            }
        } else {
            view.layoutIfNeeded()
        }
    }

}

extension ActionSheetControllerNew: ActionSheetView {

    public func dismissView(animated: Bool) {
        DispatchQueue.main.async {
            self.dismiss(animated: animated)
        }
    }

//    public func didChangeHeight() {
//        setContentViewPosition(animation: true)
//    }

}

extension ActionSheetControllerNew {

    override open var childForStatusBarStyle: UIViewController? {
        content
    }

    override open var childForStatusBarHidden: UIViewController? {
        content
    }

}
