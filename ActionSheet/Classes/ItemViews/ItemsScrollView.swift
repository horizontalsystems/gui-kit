import UIKit
import UIExtensions
import SnapKit

class ItemsScrollView: UIScrollView, UIScrollViewDelegate {

    var items = [BaseActionItemView]()
    var containerView = UIView()

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        delaysContentTouches = false
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)

        delaysContentTouches = false

        containerView.backgroundColor = .clear
        addSubview(containerView)
    }

    func addItem(_ item: BaseActionItem, separatorColor: UIColor?) {
        let view: BaseActionItemView
        if item.nibType {
            view = UINib(nibName: String(describing: item.cellType), bundle: Bundle(for: item.cellType)).instantiate(withOwner: nil, options: nil)[0] as! BaseActionItemView
            view._item = item
        } else {
            view = item.cellType.init(item: item)
        }
        view.separatorView.backgroundColor = separatorColor ?? UIColor(hex: 0xE0E0E0)

        view.frame = CGRect(x: 0, y: contentHeight(), width: superview?.bounds.width ?? bounds.width, height: item.height)
        containerView.addSubview(view)

        view.initView()

        let hidden = view._item.hidden || !view._item.showState
        let height = hidden ? 0 : view._item.height

        if let lastItem = items.last {
            view.snp.makeConstraints { maker in
                maker.top.equalTo(lastItem.snp.bottom)
                maker.leading.trailing.equalToSuperview()
                maker.height.equalTo(height)
            }
        } else {
            view.snp.makeConstraints { maker in
                maker.top.leading.trailing.equalToSuperview()
                maker.height.equalTo(height)
            }
        }

        items.append(view)
        contentSize = CGSize(width: bounds.width, height: contentHeight())
    }

    func initialSetFrame(width: CGFloat) {
        frame = CGRect(x: 0, y: 0, width: width, height: contentHeight())

        containerView.snp.makeConstraints { maker in
            maker.top.equalToSuperview()
            maker.leading.trailing.equalTo(self.containerView.superview?.superview ?? 0)
            maker.height.equalTo(0)
        }
    }

    func contentHeight() -> CGFloat {
        var height: CGFloat = 0
        items.forEach { view in
            height += !view._item.hidden && view._item.showState ? view._item.height : 0
        }

        return height
    }

    func reload() {

        items.forEach { view in
            view.updateView()

            view.snp.updateConstraints { maker in
                maker.height.equalTo((view._item.hidden || !view._item.showState) ? 0 : view._item.height)
            }
        }

        let size = CGSize(width: bounds.width, height: contentHeight())

        ActionSheetAnimation.animation({ [weak self] in
            self?.contentSize = size
            self?.changeContentViewFrame()
            self?.items.forEach { view in
                view.alpha = (view._item.hidden || !view._item.showState) ? 0 : 1
            }

            self?.layoutIfNeeded()
        })
    }

    func changeContentViewFrame() {
        containerView.snp.updateConstraints { maker in
            maker.height.equalTo(contentHeight())
        }
    }

}
