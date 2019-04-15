import SnapKit

open class TitleItemView: BaseActionItemView {

    override open var item: TitleItem? { return _item as? TitleItem
    }

    var containerView = UIView()
    var titleLabel = UILabel()

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public required init(item: BaseActionItem) {
        super.init(item: item)

        addSubview(containerView)
        let offset = self.item?.addOffset ?? true
        let side = self.item?.sideOffset ?? TitleItemTheme.sideOffset
        let top = self.item?.topOffset ?? TitleItemTheme.topOffset

        containerView.snp.makeConstraints { maker in
            maker.leading.equalToSuperview().offset(offset ? side : 0)
            maker.trailing.equalToSuperview().offset(offset ? -side : 0)
            maker.top.bottom.equalToSuperview()
        }

        containerView.addSubview(titleLabel)
        titleLabel.textAlignment = .center
        setTitle()
        titleLabel.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview().offset(offset ? top : 0)
            maker.width.lessThanOrEqualTo(containerView.snp.width)
        }
    }

    func setTitle() {
        titleLabel.textColor = item?.titleColor ?? TitleItemTheme.titleColor
        titleLabel.font = item?.titleFont ?? TitleItemTheme.titleFont

        UIView.performWithoutAnimation {
            titleLabel.attributedText = self.item?.title
        }
    }

    override open func initView() {
        super.initView()

        titleLabel.frame = frame
    }

    override open func updateView() {
        ActionSheetAnimation.animation({ [weak self] in
            self?.setTitle()
            self?.layoutIfNeeded()
        })
    }

}
