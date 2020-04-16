import UIKit
import SnapKit

class AlphaPresentAnimation: NSObject {
    private let duration: TimeInterval
    private let animationCurve: UIView.AnimationCurve

    init(duration: TimeInterval, animationCurve: UIView.AnimationCurve) {
        self.duration = duration
        self.animationCurve = animationCurve
    }

    private func animator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        let to = transitionContext.view(forKey: .to)

        let animator = UIViewPropertyAnimator(duration: duration, curve: animationCurve) {
                to?.alpha = 1
        }
        
        animator.addCompletion { (position) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        return animator
    }

}

extension AlphaPresentAnimation: UIViewControllerAnimatedTransitioning {

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
