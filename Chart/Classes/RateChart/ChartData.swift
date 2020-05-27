import Foundation

public class ChartData {
    public var items: [ChartItem]
    public var startWindow: TimeInterval
    public var endWindow: TimeInterval

    public init(items: [ChartItem], startTimestamp: TimeInterval, endTimestamp: TimeInterval) {
        self.items = items
        self.startWindow = startTimestamp
        self.endWindow = endTimestamp
    }

    public func add(name: ChartIndicatorName, values: [Decimal]) {
        let start = items.count - values.count

        for i in 0..<values.count {
            items[i + start].add(name: name, value: values[i])
        }
    }

    public func append(indicators: [ChartIndicatorName: [Decimal]]) {
        for (key, values) in indicators {
            add(name: key, values: values)
        }
    }

    public func insert(item: ChartItem) {
        guard !items.isEmpty else {
            items.append(item)
            return
        }
        let index = items.firstIndex { $0.timestamp >= item.timestamp } ?? items.count
        if items[index] == item {
            items.remove(at: index)
        }
        items.insert(item, at: index)
    }

    public func values(name: ChartIndicatorName) -> [Decimal] {
        items.compactMap { $0.indicators[name] }
    }

}
