import UIKit
import SnapKit

class MovingPresentAnimation: NSObject {
    private let duration: TimeInterval
    private let animationCurve: UIView.AnimationCurve

    init(duration: TimeInterval, animationCurve: UIView.AnimationCurve) {
        self.duration = duration
        self.animationCurve = animationCurve
    }

    private func animator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        let to = transitionContext.view(forKey: .to)

        to?.snp.remakeConstraints { maker in
            maker.leading.trailing.equalToSuperview()
            maker.bottom.equalToSuperview()
        }
        let animator = UIViewPropertyAnimator(duration: duration, curve: animationCurve) {
            to?.superview?.layoutIfNeeded()
        }
        
        animator.addCompletion { (position) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        return animator
    }

}

extension MovingPresentAnimation: UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        animator(using: transitionContext).startAnimation()
    }
    
    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        animator(using: transitionContext)
    }

}
