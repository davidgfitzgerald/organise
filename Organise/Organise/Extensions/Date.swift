import Foundation

public extension Date {
    var short: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
    
    var shortest: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E d MMM"
        return formatter.string(from: self)
    }
}

extension Date {
    func isOn(_ day: Date) -> Bool {
        Calendar.current.isDate(self, inSameDayAs: day)
    }
}
