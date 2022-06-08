import UIKit
import HUD
import SectionsTableView
import UIExtensions
import ActionSheet
import SnapKit
import Chart

class ViewController: UIViewController {
    private var chartView = RateChartView()

    override func viewDidLoad() {
        super.viewDidLoad()

        let someText = UILabel()
        view.addSubview(someText)

        someText.snp.makeConstraints { maker in
            maker.top.equalToSuperview()
            maker.leading.trailing.equalToSuperview()
        }

        someText.numberOfLines = 0
        someText.font = UIFont.body.with(traits: .traitBold)
        someText.textColor = .themeSteelLight
        someText.backgroundColor = .themeDark
        someText.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum dignissim urna a odio auctor, eget semper felis eleifend. Nulla eget libero ipsum. Nullam nec dolor ut quam ornare sodales nec non ex. Morbi suscipit varius ipsum eget pretium. Vivamus imperdiet vel orci id mollis. Aenean ornare mollis rhoncus. Suspendisse potenti. Vestibulum eu sem neque. Sed at neque at urna ullamcorper ultricies sed vel quam. Nunc est est, lacinia eu tempor at, iaculis mattis magna."

        let addWalletButton = UIButton()
        view.addSubview(addWalletButton)

        addWalletButton.snp.makeConstraints { maker in
            maker.top.equalToSuperview().offset(250)
            maker.centerX.equalToSuperview()
            maker.height.equalTo(30)
        }

        addWalletButton.setTitleColor(.black, for: .normal)
        addWalletButton.setTitle("Show success HUD", for: .normal)
        addWalletButton.addTarget(self, action: #selector(showTopHud), for: .touchUpInside)

        let disconnectingButton = UIButton()
        view.addSubview(disconnectingButton)

        disconnectingButton.snp.makeConstraints { maker in
            maker.top.equalTo(addWalletButton.snp.bottom).offset(20)
            maker.centerX.equalToSuperview()
            maker.height.equalTo(30)
        }

        disconnectingButton.setTitleColor(.black, for: .normal)
        disconnectingButton.setTitle("Show loading HUD", for: .normal)
        disconnectingButton.addTarget(self, action: #selector(showLoadingHud), for: .touchUpInside)

        let bottomSheetButton = UIButton()
        view.addSubview(bottomSheetButton)

        let alertButton = UIButton()
        view.addSubview(alertButton)

        bottomSheetButton.snp.makeConstraints { maker in
            maker.top.equalTo(disconnectingButton.snp.bottom).offset(20)
            maker.leading.equalToSuperview().offset(32)
            maker.trailing.equalTo(alertButton.snp.leading).offset(16)
            maker.height.equalTo(30)
        }

        bottomSheetButton.setTitleColor(.black, for: .normal)
        bottomSheetButton.setTitle("Sheet", for: .normal)
        bottomSheetButton.addTarget(self, action: #selector(showBottomSheet), for: .touchUpInside)


        alertButton.snp.makeConstraints { maker in
            maker.top.equalTo(disconnectingButton.snp.bottom).offset(20)
            maker.trailing.equalToSuperview().inset(32)
            maker.height.equalTo(30)
            maker.width.equalTo(bottomSheetButton.snp.width)
        }

        alertButton.setTitleColor(.black, for: .normal)
        alertButton.setTitle("Alert", for: .normal)
        alertButton.addTarget(self, action: #selector(showAlert), for: .touchUpInside)

        let chartButton = UIButton()
        view.addSubview(chartButton)

        chartButton.snp.makeConstraints { maker in
            maker.top.equalTo(bottomSheetButton.snp.bottom).offset(20)
            maker.centerX.equalToSuperview()
            maker.height.equalTo(30)
        }

        chartButton.setTitleColor(.black, for: .normal)
        chartButton.setTitle("Show Chart", for: .normal)
        chartButton.addTarget(self, action: #selector(showChart), for: .touchUpInside)

        let configuration = ChartConfiguration()
        chartView.apply(configuration: configuration)
        view.addSubview(chartView)

        chartView.snp.makeConstraints { maker in
            maker.top.equalToSuperview().offset(200)
            maker.leading.trailing.equalToSuperview().inset(32)
        }

        chartView.backgroundColor = .gray

    }

    @objc func showTopHud() {
        HUD.instance.show(config: bannerConfig(isUserInteractionEnabled: true), viewItem: HudMode.addedToWallet.viewItem, forced: true)
    }

    @objc func showLoadingHud() {
        let viewItem = HudMode.disconnecting.viewItem
        HUD.instance.show(config: bannerConfig(isUserInteractionEnabled: false), viewItem: viewItem, forced: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [unowned self] in
            let viewItem = HudMode.disconnected.viewItem
            HUD.instance.show(config: self.bannerConfig(isUserInteractionEnabled: true), viewItem: viewItem, forced: false)
        }
    }

    private func bannerConfig(isUserInteractionEnabled: Bool) -> HUDConfig {
        var config = HUDConfig()

        config.style = .banner(.top)
        config.appearStyle = .moveOut
        config.userInteractionEnabled = isUserInteractionEnabled
        config.preferredSize = CGSize(width: 114, height: 56)

        config.coverBlurEffectStyle = nil
        config.coverBlurEffectIntensity = nil
        config.coverBackgroundColor = .themeBlack50

        config.blurEffectStyle = .themeHud
        config.backgroundColor = .themeAndy
        config.blurEffectIntensity = 0.4

        config.cornerRadius = 28
        return config
    }

    @objc func showBottomSheet() {
        present(SectionsViewController().toBottomSheet, animated: true)
    }

    @objc func showAlert() {
        present(ContentViewController().toAlert, animated: true)
    }

    @objc func showChart() {
        let sevenDays = 7 * 24 * 60 * 60
        let pointCount = 100
        let minValue = 10
        let maxValue = 1000

        let powScale = pow(10, Int.random(in: 2...6))

        let endInterval = Date().timeIntervalSince1970
        let startInterval = endInterval - TimeInterval(sevenDays)
        let deltaInterval = TimeInterval(sevenDays / pointCount)

        var items = [ChartItem]()
        for index in 0..<pointCount {
            let chartItem = ChartItem(timestamp: startInterval + TimeInterval(index) * deltaInterval)
            chartItem.added(name: .rate, value: randomValue(start: minValue, end: maxValue, powScale: powScale))
            chartItem.added(name: .volume, value: randomValue(start: minValue, end: maxValue, powScale: powScale))

            items.append(chartItem)
        }

        let data = ChartData(items: items, startTimestamp: startInterval, endTimestamp: endInterval)
        chartView.set(chartData: data, animated: true)

    }

    private func randomValue(start: Int, end: Int, powScale: Decimal) -> Decimal {
        let scale = (powScale as NSNumber).intValue
        let scaledStart = start * scale
        let scaledEnd = end * scale

        return Decimal(Int.random(in: scaledStart...scaledEnd)) / powScale
    }

    private func show(title: String?) {
        var config = HUDConfig()
        config.style = .center
        config.startAdjustSize = 0.8
        config.finishAdjustSize = 0.8
        config.preferredSize = CGSize(width: 146, height: 114)
        config.backgroundColor = .lightGray
        config.blurEffectStyle = .regular

        HUD.instance.config = config

        let content = HUDStatusFactory.instance.view(type: .success, title: title)
        HUD.instance.showHUD(content, onTapHUD: { hud in
            hud.hide()
        })
    }

}
