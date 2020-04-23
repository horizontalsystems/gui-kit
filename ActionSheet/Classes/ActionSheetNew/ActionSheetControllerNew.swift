import UIKit
import SnapKit

public class ActionSheetControllerNew: UIViewController {
    private let content: UIViewController
    private var viewDelegate: ActionSheetViewDelegate?
    weak var interactiveTransitionDelegate: InteractiveTransitionDelegate?

    private let configuration: ActionSheetConfiguration

    private var animator: ActionSheetAnimator?
    private var ignoreByInteractivePresentingBreak = false

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
        animator.interactiveTransitionDelegate = self

        if let interactiveTransitionDelegate = content as? InteractiveTransitionDelegate {
            self.interactiveTransitionDelegate = interactiveTransitionDelegate
        }
        modalPresentationStyle = .custom
    }

    public override var shouldAutomaticallyForwardAppearanceMethods: Bool {
        false
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        if configuration.tapToDismiss {
            let tapView = ActionSheetTapView()
            view.addSubview(tapView)
            tapView.snp.makeConstraints { maker in
                maker.edges.equalToSuperview()
            }
            tapView.handleTap = { [weak self] in
                self?.dismiss(animated: true)
            }
        }

        // add and setup content as child view controller
        addChildController()
        viewDelegate?.actionSheetView = self
    }

    // lifecycle
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !ignoreByInteractivePresentingBreak {
            content.beginAppearanceTransition(true, animated: animated)
        }
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !ignoreByInteractivePresentingBreak {
            content.endAppearanceTransition()
        }
        ignoreByInteractivePresentingBreak = false
    }

    public override func viewWillDisappear(_ animated: Bool) {
        let interactiveTransitionStarted = animator?.interactiveTransitionStarted ?? false

        if !(configuration.ignoreInteractiveFalseMoving && interactiveTransitionStarted) {
//            content.willMove(toParent: nil)
            content.beginAppearanceTransition(false, animated: animated)
        }
        super.viewWillDisappear(animated)
    }

    public override func viewDidDisappear(_ animated: Bool) {
        removeChildController(animated)

        content.endAppearanceTransition()
        super.viewDidDisappear(animated)
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

//        content.didMove(toParent: self)
    }

    private func removeChildController(_ animated: Bool) {
//        content.viewDidDisappear(animated)
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
        if animation, let superview = view.superview {
            UIView.animate(withDuration: configuration.presentAnimationDuration) { () -> Void in
                superview.layoutIfNeeded()
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

    public func didChangeHeight() {
        setContentViewPosition(animation: true)
    }

}

extension ActionSheetControllerNew: InteractiveTransitionDelegate {

    public func start(direction: TransitionDirection) {
        interactiveTransitionDelegate?.start(direction: direction)
    }

    public func move(direction: TransitionDirection, percent: CGFloat) {
        interactiveTransitionDelegate?.move(direction: direction, percent: percent)
    }

    public func end(direction: TransitionDirection, cancelled: Bool) {
        interactiveTransitionDelegate?.end(direction: direction, cancelled: cancelled)
        guard configuration.ignoreInteractiveFalseMoving else {
            return
        }
        if cancelled {
            ignoreByInteractivePresentingBreak = true
        } else {
//            content.willMove(toParent: nil)
            content.beginAppearanceTransition(false, animated: true)
        }
    }

    public func fail(direction: TransitionDirection) {
        interactiveTransitionDelegate?.fail(direction: direction)
    }

}

extension ActionSheetControllerNew {

    override open var childForStatusBarStyle: UIViewController? {
        content
    }

    override open var childForStatusBarHidden: UIViewController? {
        content
    }

}
