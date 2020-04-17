import UIKit

public class ActionSheetAnimator: NSObject, UIViewControllerTransitioningDelegate {
    private var driver: TransitionDriver?
    private let configuration: ActionSheetConfiguration

    public init(configuration: ActionSheetConfiguration) {
        self.configuration = configuration
        super.init()

        if configuration.style == .sheet {
            driver = TransitionDriver()
        }
    }

    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        driver?.add(to: presented)
        return ActionSheetPresentationController(driver: driver, presentedViewController: presented,
                                                                presenting: presenting ?? source, configuration: configuration)
    }
    
    // Animation
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch configuration.style {
        case .sheet: return MovingPresentAnimation(duration: configuration.animationDuration, animationCurve: configuration.animationCurve)
        case .alert: return AlphaPresentAnimation(duration: configuration.animationDuration, animationCurve: configuration.animationCurve)
        }
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch configuration.style {
        case .sheet: return MovingDismissAnimation(duration: configuration.animationDuration, animationCurve: configuration.animationCurve)
        case .alert: return AlphaDismissAnimation(duration: configuration.animationDuration, animationCurve: configuration.animationCurve)
        }
    }
    
    // Interaction
    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        driver
    }

    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        driver
    }

    deinit {
//        print("deinit \(self)")
    }

}
