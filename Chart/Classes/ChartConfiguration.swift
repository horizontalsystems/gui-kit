import UIKit

public class ChartConfiguration {
    public var showGrid: Bool = true
    public var showLimitValues: Bool = true
    public var showVolumeValues: Bool = true

    public var animationDuration: TimeInterval = 0.3

    public var backgroundColor: UIColor = .clear

    public var chartInsets: UIEdgeInsets = .zero
    public var curveWidth: CGFloat = 1
    public var curvePositiveColor: UIColor = .green
    public var curveNegativeColor: UIColor = .red
    public var curveIncompleteColor: UIColor = .gray

    public var curvePercentPadding: CGFloat = 0.1

    public var gradientPositiveColor: UIColor = .green
    public var gradientNegativeColor: UIColor = .red
    public var gradientIncompleteColor: UIColor = .gray
    public var gradientStartTransparency: CGFloat = 0.8
    public var gradientFinishTransparency: CGFloat = 0.05

    public var gridNonVisibleLineDeltaX: CGFloat = 5                           // if timestamp line drawing near sides lines we must draw only sides line
    public var valueDigitDiff: Int = 5
    public var gridMaxScale: Int = 8

    public var limitColor: UIColor = .white

    public var gridColor: UIColor = .white
    public var gridTextColor: UIColor = .white
    public var gridTextFont: UIFont = .systemFont(ofSize: 12)

    public var gridTextMargin: CGFloat = 4

    public var limitTextFont: UIFont = .systemFont(ofSize: 12)
    public var limitTextColor: UIColor = .white
    public var limitTextOutMargin: CGFloat = 8
    public var limitTextInMargin: CGFloat = 4
    public var limitTextLeftMargin: CGFloat = 16

    public var limitTextFormatter: NumberFormatter?
    public var dateFormatter: DateFormatter?

    public var volumeMaximumHeightRatio: CGFloat = 0.4
    public var volumeBarColor: UIColor = UIColor.lightGray.withAlphaComponent(0.2)
    public var volumeBarWidth: CGFloat = 2

    public var selectedCircleRadius: CGFloat = 5.5
    public var selectedIndicatorColor: UIColor = .white
    public var selectedCurveColor: UIColor = .white
    public var selectedGradientColor: UIColor = .white

    public init() {}

}
