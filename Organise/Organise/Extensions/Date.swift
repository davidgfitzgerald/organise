import Foundation

public extension Date {
    static let shortFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    var short: String {
        Self.shortFormatter.string(from: self)
    }
} 

extension Date {
    func isOn(_ day: Date) -> Bool {
        Calendar.current.isDate(self, inSameDayAs: day)
    }
}
