// TODO: refactor indicator factory
//import Foundation
//
//class RsiIndicator {
//    private let period: Int
//
//    init(period: Int) {
//        self.period = period
//    }
//
//    func calculate(values: [Decimal]) -> [ChartIndicatorName: [Decimal]] {
//        let decPeriod = Decimal(period)
//
//        var upMove = [Decimal]()
//        var downMove = [Decimal]()
//
//        for i in 1..<values.count {
//            let change = values[i] - values[i - 1]
//            upMove.append(change > 0 ? change : 0)
//            downMove.append(change < 0 ? abs(change) : 0)
//        }
//
//        var emaUp = [Decimal]()
//        var emaDown = [Decimal]()
//        var relativeStrength = [Decimal]()
//        var rsi = [Decimal]()
//
//        var maUp: Decimal = 0
//        var maDown: Decimal = 0
//        var rStrength: Decimal = 0
//
//        for i in 0..<upMove.count {
//            let up = upMove[i]
//            let down = downMove[i]
//
//            // SMA
//            if i < period {
//                maUp += up
//                maDown += down
//                continue
//            }
//
//            if i == period {
//                maUp /= decPeriod
//                maDown /= decPeriod
//
//                emaUp.append(maUp)
//                emaDown.append(maDown)
//                if maDown.isZero {
//                    rsi.append(100)
//                } else {
//                    rStrength = maUp / maDown
//
//                    relativeStrength.append(rStrength)
//                    rsi.append(100 - 100 / (rStrength + 1))
//                }
//            }
//
//            // EMA
//            maUp = (maUp * (decPeriod - 1) + up) / decPeriod
//            maDown = (maDown * (decPeriod - 1) + down) / decPeriod
//            rStrength = maUp / maDown
//
//            emaUp.append(maUp)
//            emaDown.append(maDown)
//            relativeStrength.append(rStrength)
//            rsi.append(100 - 100 / (rStrength + 1))
//        }
//        return [.rsi: rsi]
//    }
//
//}
