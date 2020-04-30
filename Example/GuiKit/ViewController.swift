import UIKit
import HUD
import SectionsTableView
import UIExtensions
import ActionSheet
import SnapKit
import Chart

class ViewController: UIViewController {
    private var chartView: ChartView?

    override func viewDidLoad() {
        super.viewDidLoad()

        let hudButton = UIButton()
        view.addSubview(hudButton)

        hudButton.snp.makeConstraints { maker in
            maker.top.equalToSuperview().offset(50)
            maker.centerX.equalToSuperview()
            maker.height.equalTo(30)
        }
        
        hudButton.setTitleColor(.black, for: .normal)
        hudButton.setTitle("Show HUD", for: .normal)
        hudButton.addTarget(self, action: #selector(showHud), for: .touchUpInside)

        let bottomSheetButton = UIButton()
        view.addSubview(bottomSheetButton)

        let alertButton = UIButton()
        view.addSubview(alertButton)

        bottomSheetButton.snp.makeConstraints { maker in
            maker.top.equalTo(hudButton.snp.bottom).offset(20)
            maker.leading.equalToSuperview().offset(32)
            maker.trailing.equalTo(alertButton.snp.leading).offset(16)
            maker.height.equalTo(30)
        }

        bottomSheetButton.setTitleColor(.black, for: .normal)
        bottomSheetButton.setTitle("Sheet", for: .normal)
        bottomSheetButton.addTarget(self, action: #selector(showBottomSheet), for: .touchUpInside)


        alertButton.snp.makeConstraints { maker in
            maker.top.equalTo(hudButton.snp.bottom).offset(20)
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
        let chartView = ChartView(configuration: configuration, gridIntervalType: .day(2))
        view.addSubview(chartView)

        chartView.snp.makeConstraints { maker in
            maker.top.equalToSuperview().offset(200)
            maker.leading.trailing.equalToSuperview().inset(32)
            maker.height.equalTo(200)
        }

        chartView.backgroundColor = .gray

        self.chartView = chartView
    }
    
    @objc func showHud() {
        show(title: "Hello World")
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

        var chartPoint = [ChartPoint]()
        for index in 0..<pointCount {
            chartPoint.append(ChartPoint(timestamp: startInterval + TimeInterval(index) * deltaInterval, value: randomValue(start: minValue, end: maxValue, powScale: powScale), volume: randomValue(start: minValue, end: maxValue, powScale: powScale)))
        }


        chartView?.set(gridIntervalType: .day(2), data: chartPoint, animated: true)
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
