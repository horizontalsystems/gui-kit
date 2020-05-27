import Foundation

public protocol ITimelineHelper {
    func timestamps(startTimestamp: TimeInterval, endTimestamp: TimeInterval, separateHourlyInterval: Int) -> [TimeInterval]
    func text(timestamp: TimeInterval, separateHourlyInterval: Int, dateFormatter: DateFormatter) -> String
}

public class TimelineHelper: ITimelineHelper {
    private let day = 24
    private let month = 30 * 24

    private func stepBack(for timestamp: TimeInterval, separateHourlyInterval: Int) -> TimeInterval {
        let hourInSeconds: TimeInterval = 60 * 60
        switch separateHourlyInterval {
        case 0..<24: return timestamp - TimeInterval(separateHourlyInterval) * hourInSeconds
        case 24..<(24 * 30): return timestamp - TimeInterval(separateHourlyInterval) * hourInSeconds
        default:
            let date = Date(timeIntervalSince1970: timestamp)
            let ago = date.startOfMonth(ago: separateHourlyInterval / (24 * 30))
            return ago?.timeIntervalSince1970 ?? timestamp
        }
    }

    // return timestamps in minutes for grid vertical lines
    public func timestamps(startTimestamp: TimeInterval, endTimestamp: TimeInterval, separateHourlyInterval: Int) -> [TimeInterval] {
        var timestamps = [TimeInterval]()

        let lastDate = Date(timeIntervalSince1970: endTimestamp)
        var lastTimestamp: TimeInterval

        switch separateHourlyInterval {
        case 0..<day: lastTimestamp = lastDate.startOfHour?.timeIntervalSince1970 ?? endTimestamp
        case 24..<month: lastTimestamp = lastDate.startOfDay.timeIntervalSince1970
        default: lastTimestamp = lastDate.startOfMonth?.timeIntervalSince1970 ?? endTimestamp
        }

        while lastTimestamp >= startTimestamp {
            timestamps.append(lastTimestamp)
            lastTimestamp = stepBack(for: lastTimestamp, separateHourlyInterval: separateHourlyInterval)
        }

        return timestamps.sorted()
    }

    public func text(timestamp: TimeInterval, separateHourlyInterval: Int, dateFormatter: DateFormatter) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour], from: date)

        switch separateHourlyInterval {
        case 0..<day:
            guard let hour = components.hour else {
                return "--"
            }
            return String("\(hour)")
        case 24...(24 * 3):             // half week for show minimum 2 values
            dateFormatter.setLocalizedDateFormatFromTemplate("E")
            return dateFormatter.string(from: date)
        case (24 * 3 + 1)..<month:
            guard let day = components.day else {
                return "--"
            }
            return String("\(day)")
        default:
            dateFormatter.setLocalizedDateFormatFromTemplate("MMM")
            return dateFormatter.string(from: date)

        }
    }

    public init() {
    }

}
