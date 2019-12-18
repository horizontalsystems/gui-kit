import Foundation

class TimestampFormatter {

    static public func text(timestamp: TimeInterval, gridIntervalType: GridIntervalType, dateFormatter: DateFormatter) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour], from: date)

        switch gridIntervalType {
        case .hour:
            guard let hour = components.hour else {
                return "--"
            }
            return String("\(hour)")
        case .day(let count):
            if count <= 3 {               // half week for show minimum 2 values
                dateFormatter.setLocalizedDateFormatFromTemplate("E")
                return dateFormatter.string(from: date)
            } else {
                guard let day = components.day else {
                    return "--"
                }
                return String("\(day)")
            }
        case .month:
            dateFormatter.setLocalizedDateFormatFromTemplate("MMM")
            return dateFormatter.string(from: date)
        }
    }

}
