import UIKit

class ActionSheetPresentationController: UIPresentationController {
    private let coverView = UIView()
    private let coverColor: UIColor
    private let style: ActionStyleNew
    private var driver: TransitionDriver?

    init(driver: TransitionDriver?, presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, coverColor: UIColor, style: ActionStyleNew) {
        self.driver = driver
        self.coverColor = coverColor
        self.style = style
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }

    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()

        guard let presentedView = presentedView else {
            return
        }
        containerView?.addSubview(coverView)
        containerView?.addSubview(presentedView)

        coverView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }

        switch style {
        case .alert:
            presentedView.alpha = 0
            presentedView.snp.makeConstraints { maker in
                maker.edges.equalToSuperview()
            }
        case .sheet:
            presentedView.snp.makeConstraints { maker in
                maker.leading.trailing.equalToSuperview()
                maker.top.equalTo(containerView!.snp.bottom)
            }
            containerView?.layoutIfNeeded()
        }

        coverView.backgroundColor = coverColor
        coverView.alpha = 0
        alongsideTransition { [weak self] in
            self?.coverView.alpha = 1
        }
    }

    override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)

        if completed {
            driver?.direction = .dismiss
        } else {
            self.coverView.removeFromSuperview()
        }
    }

    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        
        alongsideTransition { [weak self] in
            self?.coverView.alpha = 0
        }
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)
        
        if completed {
            self.coverView.removeFromSuperview()
        }
    }
    
    private func alongsideTransition(_ action: @escaping () -> Void) {
        guard let coordinator = self.presentedViewController.transitionCoordinator else {
            action()
            return
        }
            
        coordinator.animate(alongsideTransition: { (_) in
            action()
        }, completion: nil)
    }

}
