import Foundation

public struct ChartPoint {
    public let timestamp: TimeInterval
    public let value: Decimal

    public init(timestamp: TimeInterval, value: Decimal) {
        self.timestamp = timestamp
        self.value = value
    }
}

extension ChartPoint: Equatable {

    public static func ==(lhs: ChartPoint, rhs: ChartPoint) -> Bool {
        lhs.timestamp == rhs.timestamp && lhs.value == rhs.value
    }

}
