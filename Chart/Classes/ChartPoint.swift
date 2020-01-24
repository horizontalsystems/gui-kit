import Foundation

public struct ChartPoint {
    public let timestamp: TimeInterval
    public let value: Decimal
    public let volume: Decimal?

    public init(timestamp: TimeInterval, value: Decimal, volume: Decimal?) {
        self.timestamp = timestamp
        self.value = value
        self.volume = volume
    }
}

extension ChartPoint: Equatable {

    public static func ==(lhs: ChartPoint, rhs: ChartPoint) -> Bool {
        lhs.timestamp == rhs.timestamp && lhs.value == rhs.value
    }

}
