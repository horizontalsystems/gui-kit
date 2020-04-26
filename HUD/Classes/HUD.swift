import UIKit
import UIExtensions

public enum HUDType { case success, error, progress, custom }

public class HUD {
    static public let instance = HUD()

    let keyboardNotificationHandler: HUDKeyboardHelper

    public var config: HUDConfig
    internal var view: HUDView?

    internal var _coverView: HUDCoverView?
    func defaultCoverView(onTap: (() -> ())? = nil) -> HUDCoverView {
        if let coverView = _coverView  {
            coverView.onTapCover = onTap
            return coverView
        }
        var view: UIView?
        if let intensity = config.coverBlurEffectIntensity, let style = config.coverBlurEffectStyle {
            let effect = UIBlurEffect(style: style)
            view = CustomIntensityVisualEffectView(effect: effect, intensity: intensity)
        }
        let cover = DimCoverView(withModel: config, backgroundView: view)
        cover.onTapCover = onTap
        return cover
    }

    public var animated: Bool = true

    init(config: HUDConfig? = nil, keyboardNotifications: HUDKeyboardHelper = .shared) {
        self.config = config ?? HUDConfig()
        self.keyboardNotificationHandler = keyboardNotifications
    }

    public func show(error: String?) {
        HUDStatusFactory.instance.config.dismissTimeInterval = 2
        let content = HUDStatusFactory.instance.view(type: .error, title: error)
        showHUD(content, onTapHUD: { hud in
            hud.hide()
        })
    }

    public func showHUD(_ content: UIView & HUDContentViewInterface, animated: Bool = true, showCompletion: (() -> ())? = nil, dismissCompletion: (() -> ())? = nil, onTapCoverView: ((HUD) -> ())? = nil, onTapHUD: ((HUD) -> ())? = nil) {
        self.animated = animated

        let maxSize = CGSize(width: UIScreen.main.bounds.width * config.allowedMaximumSize.width, height: UIScreen.main.bounds.height * config.allowedMaximumSize.height)

        if let view = view {                                                             // when user want to change already showing hud, we must try to move/show smoothly
            if view.config.userInteractionEnabled == config.userInteractionEnabled {     // if type of hud (with cover, interaction and other) same, just change config, position and content
                view.set(config: config)
                view.containerView.setContent(content: content, preferredSize: config.preferredSize, maxSize: maxSize, exact: config.exactSize)
                view.adjustPlace()
            } else {                                                                    // if type changed (with/without cover ex.) must reset and create again
                view.window = nil
                self.view = nil
            }
        }
        if view == nil {                                                                // if it's no view, create new and show
            var coverView: HUDCoverView?
            if !config.userInteractionEnabled {
                coverView = _coverView ?? defaultCoverView(onTap: {[weak self] in
                    if let weakSelf = self {
                        onTapCoverView?(weakSelf)
                    }
                })
            }
            let containerView = HUDContainerView(withModel: config)
            containerView.onTapContainer = { [weak self] in
                if let weakSelf = self {
                    onTapHUD?(weakSelf)
                }
            }
            containerView.isHidden = true
            containerView.setContent(content: content, preferredSize: config.preferredSize, maxSize: maxSize, exact: config.exactSize)

            view = HUD.create(config: config, router: self, coverView: coverView, containerView: containerView)
            view?.keyboardNotificationHandler = keyboardNotificationHandler

            if content.actions.firstIndex(where: { $0.type == .show }) == nil {
                show()
            }
        }
        view?.presenter.addActionTimers(content.actions)
        view?.showCompletion = showCompletion
        view?.dismissCompletion = dismissCompletion
    }

}

extension HUD: HUDViewRouterInterface {

    class func create(config: HUDConfig, router: HUDViewRouterInterface, coverView: HUDCoverView?, containerView: HUDContainerView) -> HUDView {

        let interactor: HUDViewInteractorInterface = HUDViewInteractor()
        let presenter: HUDViewPresenterInterface & HUDViewInteractorDelegate = HUDViewPresenter(interactor: interactor, router: router, coverView: coverView, containerView: containerView, config: config)
        let view = HUDView(presenter: presenter, config: config, coverView: coverView, containerView: containerView)

        presenter.feedbackGenerator = HapticGenerator.instance
        presenter.view = view
        interactor.delegate = presenter

        let window = HUDWindow(frame: UIScreen.main.bounds, rootController: view)
        view.window = window

        view.place()

        return view
    }

    public func show() {
        view?.presenter.show(animated: animated, completion: { [weak view] in
            view?.showCompletion?()
        })
    }

    public func hide() {
        view?.presenter.dismiss(animated: animated, completion: { [weak view, weak self] in
            view?.dismissCompletion?()
            self?.view = nil
        })
    }

}
