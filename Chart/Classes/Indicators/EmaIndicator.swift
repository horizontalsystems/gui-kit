// TODO: refactor indicator factory
//import Foundation
//
//class EmaIndicator {
//    private let period: Int
//
//    init(period: Int) {
//        self.period = period
//    }
//
//    func calculate(values: [Decimal]) -> [ChartIndicatorName: [Decimal]] {
//        let a = 2 / (1 + Decimal(period))
//
//        var result = [Decimal]()
//
//        var prev = values[0..<period].reduce(0, +) / Decimal(period)
//        result.append(prev)
//
//        for i in (period..<values.count) {
//            prev = a * values[i] + (1 - a) * prev
//
//            result.append(prev)
//        }
//        return [.emaShort: result]
//    }
//
//}
