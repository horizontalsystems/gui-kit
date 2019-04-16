import UIKit
import UIExtensions
import SnapKit

open class BaseActionItemView: UIView {

    open var _item: BaseActionItem
    open var item: BaseActionItem? { return _item }

    public var separatorView = UIView()
    var separatorInset: UIEdgeInsets = UIEdgeInsets.zero {
        didSet {
            changeSeparatorInsets()
        }
    }

    var previousBackgroundColor: UIColor = .clear

    public required init?(coder aDecoder: NSCoder) {
        _item = BaseActionItem()

        super.init(coder: aDecoder)

        commonInit()
    }

    required public init(item: BaseActionItem) {
        _item = item

        super.init(frame: CGRect.zero)

        commonInit()
    }

    open func commonInit() {
        addSubview(separatorView)
        separatorView.snp.makeConstraints { maker in
            maker.leading.trailing.bottom.equalToSuperview()
            maker.height.equalTo(1 / UIScreen.main.scale)
        }

        separatorView.isHidden = !_item.showSeparator

        self.clipsToBounds = true
    }

    open func initView() {
        separatorView.isHidden = !_item.showSeparator
    }

    open func updateView() {
        separatorView.isHidden = !_item.showSeparator
    }

    func changeSeparatorInsets() {
        separatorView.snp.updateConstraints { maker in
            maker.leading.equalToSuperview().offset(separatorInset.left)
            maker.trailing.equalToSuperview().offset(-separatorInset.right)
            maker.bottom.equalToSuperview().offset(-separatorInset.bottom)
        }

        layoutIfNeeded()
    }

    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if item?.action == nil {
            super.touchesBegan(touches, with: event)
        }

        if _item.selectable {
            UIView.animate(withDuration: 0.1, delay: 0.0, animations: {
                self.backgroundColor = ItemActionTheme.selectedBackground
            }, completion:nil)
        }
    }

    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let action = item?.action {
            action(self)
        } else {
            super.touchesEnded(touches, with: event)
        }

        if _item.selectable {
            UIView.animate(withDuration: 0.3, delay: 0.0, animations: {
                self.backgroundColor = self.previousBackgroundColor
            }, completion:nil)
        }
    }

    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)

        if _item.selectable {
            UIView.animate(withDuration: 0.3, delay: 0.0, animations: {
                self.backgroundColor = self.previousBackgroundColor
            }, completion:nil)
        }
    }

}
