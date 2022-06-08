import Foundation

public enum HUDTimeActionType { case show, dismiss, custom }

public struct HUDTimeAction {
    var type: HUDTimeActionType
    var interval: TimeInterval
    var action: (() -> ())?

    init(type: HUDTimeActionType, interval: TimeInterval, action: (() -> ())? = nil) {
        self.type = type
        self.interval = interval
        self.action = action
    }

}

class HUDViewInteractor: HUDViewInteractorInterface {
    weak var delegate: HUDViewInteractorDelegate?

    deinit {
//        print("Deinit HUDView interactor \(self)")
    }

}
