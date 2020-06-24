import Foundation

struct MacdData {
    let macd: [Decimal]
    let signal: [Decimal]
    let histogram: [Decimal]
}

class ChartIndicators {

    static func ma(period: Int, values: [Decimal]) -> [Decimal] {
        var result = [Decimal]()

        var prev = values[0..<period].reduce(0, +) / Decimal(period)
        result.append(prev)

        for i in (0..<(values.count - period)) {
            prev = values[i..<(i + period)].reduce(0, +) / Decimal(period)

            result.append(prev)
        }
        return result
    }

    static func ema(period: Int, values: [Decimal]) -> [Decimal] {
        guard values.count >= period else {
            return []
        }

        let a = 2 / (1 + Decimal(period))

        var result = [Decimal]()

        var prev = values[0..<period].reduce(0, +) / Decimal(period)
        result.append(prev)

        for i in (period..<values.count) {
            prev = a * values[i] + (1 - a) * prev

            result.append(prev)
        }
        return result
    }

    static func rsi(period: Int, values: [Decimal]) -> [Decimal] {
        let decPeriod = Decimal(period)

        var upMove = [Decimal]()
        var downMove = [Decimal]()

        for i in 1..<values.count {
            let change = values[i] - values[i - 1]
            upMove.append(change > 0 ? change : 0)
            downMove.append(change < 0 ? abs(change) : 0)
        }

        var emaUp = [Decimal]()
        var emaDown = [Decimal]()
        var relativeStrength = [Decimal]()
        var rsi = [Decimal]()

        var maUp: Decimal = 0
        var maDown: Decimal = 0
        var rStrength: Decimal = 0

        for i in 0..<upMove.count {
            let up = upMove[i]
            let down = downMove[i]

            // SMA
            if i < period {
                maUp += up
                maDown += down
                continue
            }

            if i == period {
                maUp /= decPeriod
                maDown /= decPeriod

                emaUp.append(maUp)
                emaDown.append(maDown)
                if maDown.isZero {
                    rsi.append(100)
                } else {
                    rStrength = maUp / maDown

                    relativeStrength.append(rStrength)
                    rsi.append(100 - 100 / (rStrength + 1))
                }
            }

            // EMA
            maUp = (maUp * (decPeriod - 1) + up) / decPeriod
            maDown = (maDown * (decPeriod - 1) + down) / decPeriod
            rStrength = maUp / maDown

            emaUp.append(maUp)
            emaDown.append(maDown)
            relativeStrength.append(rStrength)
            rsi.append(100 - 100 / (rStrength + 1))
        }
        return rsi
    }

    static func macd(fast: Int, long: Int, signal: Int, values: [Decimal]) -> MacdData {
        let diff = long - fast
        guard diff > 0 else {
            return MacdData(macd: [], signal: [], histogram: [])
        }

        let emaFast = ema(period: fast, values: values)
        let emaLong = ema(period: long, values: values)
        let macd = emaLong.enumerated().map { (index, long) in
            emaFast[index + diff] - long
        }
        let emaSignal = ema(period: signal, values: macd)

        let signalDiff = macd.count - emaSignal.count
        let histogram: [Decimal]

        histogram = emaSignal.enumerated().compactMap { (index, signal) in
            macd[index + signalDiff] - signal
        }

        return MacdData(macd: macd, signal: emaSignal, histogram: histogram)
    }

}
