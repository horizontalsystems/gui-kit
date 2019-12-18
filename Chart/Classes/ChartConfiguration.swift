import UIKit

public class ChartConfiguration {
    var showGrid: Bool = true
    var showLimitValues: Bool = true

    var animationDuration: TimeInterval = 0.3

    var backgroundColor: UIColor = .clear

    var chartInsets: UIEdgeInsets = .zero
    var curveWidth: CGFloat = 1
    var curvePositiveColor: UIColor = .green
    var curveNegativeColor: UIColor = .red
    var curveIncompleteColor: UIColor = .gray

    var curvePercentPadding: CGFloat = 0.1

    var gradientPositiveColor: UIColor = .green
    var gradientNegativeColor: UIColor = .red
    var gradientIncompleteColor: UIColor = .gray
    var gradientStartTransparency: CGFloat = 0.8
    var gradientFinishTransparency: CGFloat = 0.05

    var gridNonVisibleLineDeltaX: CGFloat = 5                           // if timestamp line drawing near sides lines we must draw only sides line
    var valueDigitDiff: Int = 5
    var gridMaxScale: Int = 8

    var limitColor: UIColor = .white

    var gridColor: UIColor = .white
    var gridTextColor: UIColor = .white
    var gridTextFont: UIFont = .systemFont(ofSize: 12)

    var gridTextMargin: CGFloat = 4

    var limitTextFont: UIFont = .systemFont(ofSize: 12)
    var limitTextColor: UIColor = .white
    var limitTextOutMargin: CGFloat = 8
    var limitTextInMargin: CGFloat = 4
    var limitTextLeftMargin: CGFloat = 16

    var limitTextFormatter: NumberFormatter?
    var dateFormatter: DateFormatter?

    var selectedCircleRadius: CGFloat = 5.5
    var selectedIndicatorColor: UIColor = .white
    var selectedCurveColor: UIColor = .white
    var selectedGradientColor: UIColor = .white

    public init() {}

}
