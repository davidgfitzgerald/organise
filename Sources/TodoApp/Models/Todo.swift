import Foundation

struct Todo: Identifiable {
    let id: UUID
    var title: String
    var isCompleted: Bool
    var dueDate: Date?
    var category: String?
    var priority: Priority
    
    enum Priority: Int {
        case low = 0
        case medium = 1
        case high = 2
    }
    
    init(id: UUID = UUID(), title: String, isCompleted: Bool = false, dueDate: Date? = nil, category: String? = nil, priority: Priority = .medium) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.dueDate = dueDate
        self.category = category
        self.priority = priority
    }
} 