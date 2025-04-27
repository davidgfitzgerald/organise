import CoreData
import Foundation

class PersistenceManager {
    static let shared = PersistenceManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDo")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    // MARK: - Activity Operations
    
    func createActivity(title: String, description: String? = nil, points: Int, type: String, frequency: String? = nil, dueDate: Date? = nil, targetDate: Date? = nil) -> Activity {
        let activity = Activity(context: context)
        activity.id = UUID()
        activity.title = title
        activity.descriptionText = description
        activity.points = Int32(points)
        activity.type = type
        activity.frequency = frequency
        activity.dueDate = dueDate
        activity.targetDate = targetDate
        activity.createdAt = Date()
        activity.isActive = true
        
        saveContext()
        return activity
    }
    
    func fetchActivities() -> [Activity] {
        let request: NSFetchRequest<Activity> = Activity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Activity.createdAt, ascending: false)]
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching activities: \(error)")
            return []
        }
    }
    
    // MARK: - Completion Record Operations
    
    func createCompletionRecord(for activity: Activity) -> CompletionRecord {
        let record = CompletionRecord(context: context)
        record.id = UUID()
        record.completedAt = Date()
        record.pointsEarned = activity.points
        record.activity = activity
        
        activity.lastCompleted = Date()
        
        saveContext()
        return record
    }
    
    // MARK: - Streak Operations
    
    func updateStreak(for activity: Activity) {
        let streak = activity.streak ?? Streak(context: context)
        streak.id = UUID()
        streak.activity = activity
        
        // Calculate streak logic here
        // This is a placeholder - we'll implement the actual streak calculation logic later
        
        saveContext()
    }
} 