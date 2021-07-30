import Foundation

extension Date {

    var long: Int64 {
        get {
            let long = self.timeIntervalSince1970
            let result = Int64(long) //* 1000 + Int64(long.truncatingRemainder(dividingBy: 1.0) * 1000.0)
            return result
        }
    }

    var timeIntervalSince1970Long: Int64 {
        get {
            let long = self.timeIntervalSince1970
            let result = Int64(long) * 1000 + Int64(long.truncatingRemainder(dividingBy: 1.0) * 1000.0)
            return result
        }
    }

    init(timeIntervalSince1970Long: Int64) {
        let long = timeIntervalSince1970Long / 1000
        let ost = timeIntervalSince1970Long % 1000
        let timeIntervalSince1970 = TimeInterval(long) + (Double(ost) / 1000.0)
        self.init(timeIntervalSince1970: timeIntervalSince1970)
    }

    var text: String {
        return "\(self)".replace(target: " +000", withString: "")
    }

    func format(_ f: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = f // "HH:mm:"//yyyy-MM-dd HH:mm:ss +zzzz
        return dateFormatter.string(from: self)
    }

}
