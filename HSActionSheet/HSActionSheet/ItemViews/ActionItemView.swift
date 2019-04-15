import SnapKit

open class ActionItemView: BaseActionItemView {

    override open var item: ActionItem? { return _item as? ActionItem }

    var titleLabel = UILabel()
    var iconImageView = UIImageView()

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    required public init(item: BaseActionItem) {
        super.init(item: item)

        addSubview(titleLabel)
        addSubview(iconImageView)

        if let iconImage = self.item?.iconImage {
            iconImageView.image = iconImage
            iconImageView.contentMode = .center
            iconImageView.snp.makeConstraints { maker in
                maker.width.height.equalTo(30)
                maker.leading.equalToSuperview().offset(15)
                maker.centerY.equalToSuperview()
            }
            titleLabel.textAlignment = .left
            titleLabel.snp.makeConstraints { maker in
                maker.leading.equalTo(iconImageView.snp.trailing).offset(20)
                maker.trailing.equalToSuperview().offset(-20)
                maker.centerY.equalToSuperview()
            }
        } else {
            titleLabel.textAlignment = .center
            titleLabel.snp.makeConstraints { maker in
                maker.center.equalToSuperview()
            }
        }
        setTitle()
    }

    func setTitle() {
        titleLabel.textColor = item?.titleColor ?? ItemActionTheme.titleColor
        titleLabel.font = (item?.bold ?? false) ? ItemActionTheme.boldTitleFont : ItemActionTheme.titleFont
        iconImageView.image = item?.iconImage

        UIView.performWithoutAnimation {
            titleLabel.text = self.item?.title
        }
    }

    override open func initView() {
        super.initView()

        titleLabel.frame = frame
        layoutIfNeeded()
    }

    override open func updateView() {
        ActionSheetAnimation.animation({ [weak self] in
            self?.setTitle()
            self?.layoutIfNeeded()
        })
    }

}
