import UIKit

protocol HUDViewInterface: class {
    var presenter: HUDViewPresenterInterface { get }

    func adjustPlace()
    var showCompletion: (() -> ())? { get set }
    var dismissCompletion: (() -> ())? { get set }
    func safeCorrectedOffset(for inset: CGPoint, style: HUDBannerStyle?, relativeWindow: Bool) -> CGPoint
}

protocol HUDViewRouterInterface: class {
    var view: HUDView? { get set }
    func show()
    func hide()
}

protocol HUDViewPresenterInterface: class {
    var interactor: HUDViewInteractorInterface { get }
    var view: HUDViewInterface? { get set }
    var feedbackGenerator: HUDFeedbackGenerator? { get set }

    func viewDidLoad()
    func addActionTimers(_ timeActions: [HUDTimeAction])
    func updateCover()
    func show(animated: Bool, completion: (() -> ())?)
    func dismiss(animated: Bool, completion: (() -> ())?)
}

protocol HUDViewInteractorInterface: class {
    var delegate: HUDViewInteractorDelegate? { get set }
}

protocol HUDViewInteractorDelegate: class {
    func updateCover()
    func showContainerView(animated: Bool, completion: (() -> ())?)
    func dismiss(animated: Bool, completion: (() -> ())?)
}

