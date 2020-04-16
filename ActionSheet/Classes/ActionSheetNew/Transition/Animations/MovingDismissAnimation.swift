import UIKit

class MovingDismissAnimation: NSObject {
    private let duration: TimeInterval
    private let animationCurve: UIView.AnimationCurve

    init(duration: TimeInterval, animationCurve: UIView.AnimationCurve) {
        self.duration = duration
        self.animationCurve = animationCurve
    }

    private func animator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        guard let from = transitionContext.view(forKey: .from) else {
            return UIViewPropertyAnimator(duration: duration, curve: animationCurve)
        }

        let animator = UIViewPropertyAnimator(duration: duration, curve: animationCurve) {
            from.frame = from.frame.offsetBy(dx: 0, dy: from.height)
        }
        
        animator.addCompletion { (position) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        return animator
    }

}

extension MovingDismissAnimation: UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        animator(using: transitionContext).startAnimation()
    }
    
    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        self.animator(using: transitionContext)
    }

}
