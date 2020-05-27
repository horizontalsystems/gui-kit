// TODO: refactor indicator factory
//import Foundation
//
//class MaIndicator {
//    private let period: Int
//
//    init(period: Int) {
//        self.period = period
//    }
//
//    func calculate(values: [Decimal]) -> [ChartIndicatorName: [Decimal]] {
//        var result = [Decimal]()
//
//        var prev = values[0..<period].reduce(0, +) / Decimal(period)
//        result.append(prev)
//
//        for i in (0..<(values.count - period)) {
//            prev = values[i..<(i + period)].reduce(0, +) / Decimal(period)
//
//            result.append(prev)
//        }
//        return [.ma: result]
//    }
//
//}
