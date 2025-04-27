import Foundation

enum ActivityType: String, CaseIterable {
    case habit = "Habit"
    case oneOff = "One-off Task"
    case goal = "Goal"
}

enum HabitFrequency: String, CaseIterable {
    case daily = "Daily"
    case weekly = "Weekly"
    case custom = "Custom"
}

enum Weekday: Int, CaseIterable {
    case sunday = 1
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7
    
    var displayName: String {
        switch self {
        case .sunday: return "Sunday"
        case .monday: return "Monday"
        case .tuesday: return "Tuesday"
        case .wednesday: return "Wednesday"
        case .thursday: return "Thursday"
        case .friday: return "Friday"
        case .saturday: return "Saturday"
        }
    }
} 