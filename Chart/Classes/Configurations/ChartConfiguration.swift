import UIKit

public class ChartConfiguration {
    private static let onePixel = 1 / UIScreen.main.scale

    public var showBorders = true
    public var showIndicators = true
    public var showDominance = false
    public var showLimits = true
    public var showVericalLines = true
    public var isInteractive = true

    public var mainHeight: CGFloat = 160
    public var indicatorHeight: CGFloat = 56
    public var timelineHeight: CGFloat = 21

    public var animationDuration: TimeInterval = 0.35
    public var timingFunction: CAMediaTimingFunctionName = .easeInEaseOut

    public var borderWidth: CGFloat = 1
    public var borderColor: UIColor = UIColor.clear.withAlphaComponent(0.5)

    public var backgroundColor: UIColor = .clear

    public var curveWidth: CGFloat = onePixel
    public var curvePadding: UIEdgeInsets = UIEdgeInsets(top: 18, left: 0, bottom: 18, right: 0)

    public var trendUpColor = UIColor.green
    public var trendDownColor = UIColor.red
    public var pressedColor: UIColor = UIColor.white
    public var outdatedColor: UIColor = UIColor.white

    public var trendUpGradient = [UIColor.green, UIColor.green]
    public var trendDownGradient = [UIColor.red, UIColor.red]
    public var pressedGradient = [UIColor.lightGray, UIColor.lightGray]
    public var neutralGradient = [UIColor.gray, UIColor.gray]

    public var gradientAlphas: [CGFloat] = [0.05, 0.5]

    public var limitLinesWidth: CGFloat = onePixel
    public var limitLinesDashPattern: [NSNumber]? = [2, 2]
    public var limitLinesColor: UIColor = UIColor.white.withAlphaComponent(0.5)
    public var limitLinesPadding: UIEdgeInsets = UIEdgeInsets(top: 18, left: 0, bottom: 18, right: 0)

    public var limitTextColor: UIColor = UIColor.white.withAlphaComponent(0.5)
    public var limitTextFont: UIFont = .systemFont(ofSize: 12)
    public var highLimitTextInsets: UIEdgeInsets = UIEdgeInsets(top: 4, left: 16, bottom: -1, right: 32)
    public var highLimitTextSize: CGSize = CGSize(width: 0, height: 14)
    public var lowLimitTextInsets: UIEdgeInsets = UIEdgeInsets(top: -1, left: 16, bottom: 4, right: 32)
    public var lowLimitTextSize: CGSize = CGSize(width: 0, height: 14)

    public var verticalLinesWidth: CGFloat = onePixel
    public var verticalLinesColor: UIColor = UIColor.gray.withAlphaComponent(0.5)
    public var verticalInvisibleIndent: CGFloat? = 5

    public var volumeBarsFillColor: UIColor = .lightGray
    public var volumeBarsColor: UIColor = .clear
    public var volumeBarsInsets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)

    public var timelineTextColor: UIColor = UIColor.white.withAlphaComponent(0.5)
    public var timelineFont: UIFont = .systemFont(ofSize: 12)
    public var timelineInsets: UIEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 0, right: 0)

    public var touchLineWidth: CGFloat = onePixel
    public var touchCircleRadius: CGFloat = 3.5
    public var touchLineColor: UIColor = UIColor.white
    public var touchCircleColor: UIColor = UIColor.white

    public var emaShortColor: UIColor = UIColor.blue
    public var emaShortLineWidth: CGFloat = 1
    public var emaShortInsets: UIEdgeInsets = UIEdgeInsets(top: -1, left: -1, bottom: 4, right: 35)
    public var emaShortSize: CGSize? = CGSize(width: 15, height: 14)
    public var emaShortText: String = "25"

    public var emaLongColor: UIColor = UIColor.orange
    public var emaLongLineWidth: CGFloat = 1
    public var emaLongInsets: UIEdgeInsets = UIEdgeInsets(top: -1, left: -1, bottom: 4, right: 16)
    public var emaLongSize: CGSize? = CGSize(width: 15, height: 14)
    public var emaLongText: String = "50"

    public var emaTextFont: UIFont = .systemFont(ofSize: 12)

    public var dominanceLineColor = UIColor.orange
    public var dominanceLineWidth: CGFloat = 1

    public var dominanceTextFont: UIFont = .systemFont(ofSize: 12)
    public var dominanceTextColor = UIColor.orange
    public var dominanceInsets: UIEdgeInsets = UIEdgeInsets(top: -1, left: -1, bottom: 4, right: 72)
    public var dominanceSize: CGSize? = CGSize(width: 180, height: 14)
    public var dominanceTextPrefix: String = "BTC Dominance"

    public var dominanceDiffPositiveColor: UIColor = UIColor.green
    public var dominanceDiffNegativeColor: UIColor = UIColor.red
    public var dominanceDiffTextFont: UIFont = .systemFont(ofSize: 12)
    public var dominanceDiffInsets: UIEdgeInsets = UIEdgeInsets(top: -1, left: -1, bottom: 4, right: 16)
    public var dominanceDiffSize: CGSize? = CGSize(width: 52, height: 14)

    public var macdHistogramInsets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
    public var macdLinesInsets: UIEdgeInsets = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)

    public var macdSelectedColor: UIColor = UIColor.white.withAlphaComponent(0.5)
    public var macdSignalColor: UIColor = .blue
    public var macdSignalLineWidth: CGFloat = 1
    public var macdColor: UIColor = .orange
    public var macdLineWidth: CGFloat = 1
    public var macdPositiveColor: UIColor = UIColor.green.withAlphaComponent(0.5)
    public var macdNegativeColor: UIColor = UIColor.red.withAlphaComponent(0.5)

    public var macdTextColor: UIColor = .gray
    public var macdTextFont: UIFont = .systemFont(ofSize: 12)

    public var macdLongInsets: UIEdgeInsets = UIEdgeInsets(top: -1, left: -1, bottom: 4, right: 45)
    public var macdLongSize: CGSize? = CGSize(width: 15, height: 14)
    public var macdLongText: String = "26"

    public var macdShortInsets: UIEdgeInsets = UIEdgeInsets(top: -1, left: -1, bottom: 4, right: 28)
    public var macdShortSize: CGSize? = CGSize(width: 13, height: 14)
    public var macdShortText: String = "12"

    public var macdSignalInsets: UIEdgeInsets = UIEdgeInsets(top: -1, left: -1, bottom: 4, right: 16)
    public var macdSignalSize: CGSize? = CGSize(width: 8, height: 14)
    public var macdSignalText: String = "9"

    public var rsiLineColor: UIColor = .blue
    public var rsiLineWidth: CGFloat = 1

    public var rsiPadding: UIEdgeInsets = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
    public var rsiTopLimitValue: CGFloat = 0.7
    public var rsiBottomLimitValue: CGFloat = 0.3

    public var rsiHighTextInsets: UIEdgeInsets = UIEdgeInsets(top: 4, left: -1, bottom: -1, right: 16)
    public var rsiLowTextInsets: UIEdgeInsets = UIEdgeInsets(top: -1, left: -1, bottom: 4, right: 16)

    public var rsiTextSize: CGSize = CGSize(width: 15, height: 14)

    public init() {
    }

}
