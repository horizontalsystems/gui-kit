import Foundation

public class ChartItem: Comparable {
    public var indicators = [ChartIndicatorName: Decimal]()

    public let timestamp: TimeInterval

    public init(timestamp: TimeInterval) {
        self.timestamp = timestamp
    }

    public func add(name: ChartIndicatorName, value: Decimal) {
        indicators[name] = value
    }

    static public func <(lhs: ChartItem, rhs: ChartItem) -> Bool {
        lhs.timestamp < rhs.timestamp
    }

    static public func ==(lhs: ChartItem, rhs: ChartItem) -> Bool {
        lhs.timestamp == rhs.timestamp
    }
}
