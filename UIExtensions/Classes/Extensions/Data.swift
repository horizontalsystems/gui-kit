import Foundation

extension Data {

    public init?(hex: String) {
        let hex = hex.stripHexPrefix()

        let len = hex.count / 2
        var data = Data(capacity: len)
        var s = ""

        for c in hex {
            s += String(c)
            if s.count == 2 {
                if var num = UInt8(s, radix: 16) {
                    data.append(&num, count: 1)
                    s = ""
                } else {
                    return nil
                }
            }
        }
        self = data
    }

    public var hex: String {
        reduce("") { $0 + String(format: "%02x", $1) }
    }

    public var reversedHex: String {
        Data(self.reversed()).hex
    }

}
