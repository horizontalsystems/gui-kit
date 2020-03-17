import UIKit
import UIExtensions

public class ActionSheetAnimation: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {

    var presentedAnimation = false
    public weak var controller: ActionSheetController?

    var dismissByFade: Bool
    static let animateDuration: TimeInterval = 0.35

    public override init() {
        fatalError("Deprecated init!")
    }

    public init(withController controller: ActionSheetController, dismissByFade: Bool) {
        self.controller = controller
        self.dismissByFade = dismissByFade

        super.init()
        controller.transitioningDelegate = self
    }

    static func animationOptionsForAnimationCurve(_ curve: UInt) -> UIView.AnimationOptions {
        return UIView.AnimationOptions(rawValue: curve << 16)
    }

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return ActionSheetAnimation.animateDuration
    }

    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentedAnimation = true
        return self
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentedAnimation = false
        return self
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView

        guard let to = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
            return transitionContext.completeTransition(false)
        }

        guard let from = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else {
            return transitionContext.completeTransition(false)
        }

        if presentedAnimation == true {
            from.beginAppearanceTransition(false, animated: true)
            presentAnimationForActionSheet(container, toView: to.view, fromView: from.view) { _ in
                self.controller?.showedController = true
                from.endAppearanceTransition()
                transitionContext.completeTransition(true)
            }
        } else {
            to.beginAppearanceTransition(true, animated: true)
            dismissAnimationForActionSheet(container, toView: to.view, fromView: from.view) { _ in
                to.endAppearanceTransition()
                transitionContext.completeTransition(true)
            }
        }
    }

    static public func animation(_ animations: @escaping () -> Void) {
        ActionSheetAnimation.animation(animations, completion: nil)
    }

    static public func animation(_ animations: @escaping () -> Void, completion: ((Bool) -> Void)?) {
        UIView.animate(withDuration: 0.35, delay: 0, options: animationOptionsForAnimationCurve(5), animations: animations, completion: completion)
    }

    func presentAnimationForActionSheet(_ container: UIView, toView: UIView, fromView: UIView, completion: @escaping (Bool) -> Void) {
        if let coverView = controller?.coverView {
            coverView.frame = container.bounds
            container.addSubview(coverView)
        }

        toView.frame = container.bounds
        controller?.coverView?.addSubview(toView)

        let dismissByFade = self.dismissByFade
        ActionSheetAnimation.animation({ [weak self] in
            self?.controller?.coverView?.alpha = 1
            if dismissByFade {
                self?.controller?.backgroundView.alpha = 1
                self?.controller?.contentView.alpha = 1
            } else {
                self?.setVisibleViews(true)
            }
            self?.controller?.view.layoutIfNeeded()
        }, completion: completion)
    }

    func dismissAnimationForActionSheet(_ container: UIView, toView: UIView, fromView: UIView, completion: @escaping (Bool) -> Void) {
        container.addSubview(fromView)

        let dismissByFade = self.dismissByFade
        ActionSheetAnimation.animation({ [weak self] in
            self?.controller?.coverView?.alpha = 0
            if dismissByFade {
                self?.controller?.backgroundView.alpha = 0
                self?.controller?.contentView.alpha = 0
            } else {
                self?.setVisibleViews(false)
            }
            self?.controller?.view.layoutIfNeeded()
        }, completion: completion)
    }

    func setVisibleViews(_ visible: Bool) {
        if let height = controller?.view.frame.height {
            controller?.backgroundView.snp.updateConstraints { maker in
                maker.top.bottom.equalToSuperview().offset( visible ? 0 - (controller?.keyboardHeight ?? 0) : height)
            }
        }
    }

}
