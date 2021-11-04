import Foundation

public class ChartItem: Comparable {
    public var indicators = [ChartIndicatorName: Decimal]()

    public let timestamp: TimeInterval

    public init(timestamp: TimeInterval) {
        self.timestamp = timestamp
    }

    @discardableResult public func added(name: ChartIndicatorName, value: Decimal) -> Self {
        indicators[name] = value

        return self
    }

    static public func <(lhs: ChartItem, rhs: ChartItem) -> Bool {
        lhs.timestamp < rhs.timestamp
    }

    static public func ==(lhs: ChartItem, rhs: ChartItem) -> Bool {
        lhs.timestamp == rhs.timestamp
    }
}
