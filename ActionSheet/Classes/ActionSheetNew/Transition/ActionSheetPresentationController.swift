import UIKit
import SnapKit

class ActionSheetPresentationController: UIPresentationController {
    private let coverButton = UIButton()
    private let configuration: ActionSheetConfiguration
    private var driver: TransitionDriver?

    init(driver: TransitionDriver?, presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, configuration: ActionSheetConfiguration) {
        self.driver = driver
        self.configuration = configuration
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)

        if configuration.tapToDismiss {
            coverButton.addTarget(self, action: #selector(didTapCover), for: .touchUpInside)
        }
    }

    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()

        guard let presentedView = presentedView else {
            return
        }
        containerView?.addSubview(coverButton)
        containerView?.addSubview(presentedView)

        coverButton.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }

        switch configuration.style {
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

        coverButton.backgroundColor = configuration.coverBackgroundColor
        coverButton.alpha = 0
        alongsideTransition { [weak self] in
            self?.coverButton.alpha = 1
        }
    }

    override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)

        if completed {
            driver?.direction = .dismiss
        } else {
            self.coverButton.removeFromSuperview()
        }
    }

    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()

        alongsideTransition { [weak self] in
            self?.coverButton.alpha = 0
        }
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)
        
        if completed {
            self.coverButton.removeFromSuperview()
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

    @objc private func didTapCover() {
        presentedViewController.dismiss(animated: true)
    }

}
