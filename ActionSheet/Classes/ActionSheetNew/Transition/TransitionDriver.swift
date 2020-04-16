import UIKit

enum TransitionDirection: Int { case present, dismiss }

class TransitionDriver: UIPercentDrivenInteractiveTransition {
    private weak var presentedController: UIViewController?
    private var panRecognizer: UIPanGestureRecognizer?

    var direction: TransitionDirection = .present
    var speedMultiplier: CGFloat = 1

    func add(to controller: UIViewController) {
        presentedController = controller
        
        panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handle(_ :)))
        presentedController?.view.addGestureRecognizer(panRecognizer!)
    }

    override var wantsInteractiveStart: Bool {
        get {
            switch direction {
            case .present:
                return false
            case .dismiss:
                let gestureIsActive = panRecognizer?.state == .began
                return gestureIsActive
            }
        }
        
        set { }
    }

    @objc private func handle(_ recognizer: UIPanGestureRecognizer) {
        switch direction {
        case .present:
            handlePresentation(recognizer: recognizer)
        case .dismiss:
            handleDismiss(recognizer: recognizer)
        }
    }

    deinit {
//        print("deinit \(self)")
    }

}

extension TransitionDriver {                    // Gesture Handling
    
    private func handlePresentation(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            pause()
        case .changed:
            let increment = -recognizer.incrementToBottom(maxTranslation: maxTranslation)
            update(percentComplete + increment)
            
        case .ended, .cancelled:
            speedMultiplier = recognizer.swipeMultiplier(maxTranslation: maxTranslation)
            if speedMultiplier < 0.5 {
                speedMultiplier = 1
                cancel()
            } else {
                finish()
            }
            
        case .failed:
            cancel()
            
        default:
            break
        }
    }
    
    private func handleDismiss(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            pause() // Pause allows to detect isRunning
            
            if !isRunning {
                speedMultiplier = recognizer.swipeMultiplier(maxTranslation: maxTranslation)
                presentedController?.dismiss(animated: true) // Start the new one
            }
        
        case .changed:
            update(percentComplete + recognizer.incrementToBottom(maxTranslation: maxTranslation))
            
        case .ended, .cancelled:
            speedMultiplier = recognizer.swipeMultiplier(maxTranslation: maxTranslation)
            if speedMultiplier < 0.5 {
                finish()
            } else {
                speedMultiplier = 1
                cancel()
            }

        case .failed:
            speedMultiplier = 1
            cancel()
            
        default:
            break
        }
    }
    
    var maxTranslation: CGFloat {
        presentedController?.view.frame.height ?? 0
    }
    
    private var isRunning: Bool {
        percentComplete != 0
    }
}

private extension UIPanGestureRecognizer {

    func projectedLocation(decelerationRate: UIScrollView.DecelerationRate) -> CGPoint {
        guard let view = view else {
            return .zero
        }
        var loc = location(in: view)
        let velocityOffset = velocity(in: view)

        loc.x += velocityOffset.x / (1 - decelerationRate.rawValue) / 1000
        loc.y += velocityOffset.y / (1 - decelerationRate.rawValue) / 1000

        return velocityOffset
    }

    func swipeMultiplier(maxTranslation: CGFloat) -> CGFloat {
        let endLocation = projectedLocation(decelerationRate: .fast)
        guard endLocation.y.sign == .plus else {    // user swipe up after try dismiss
            return 1
        }
        return max(0.3, min(1, abs(maxTranslation / endLocation.y)))  // when calculate speed for dismiss animation make range 0.3...1 for multiplier
    }
    
    func incrementToBottom(maxTranslation: CGFloat) -> CGFloat {
        let translation = self.translation(in: view).y
        setTranslation(.zero, in: nil)
        
        let percentIncrement = translation / maxTranslation
        return percentIncrement
    }

}
