# Life Progress Tracker

An iOS application to help organize and track life progress through habits, tasks, activities and goals.

## Core Concepts

### 1. Activity Types
We use the umbrella term "Activities" to encompass all types of activities. The app supports three main types:

1. **Habits**
   - Daily habits (e.g., brushing teeth)
   - Weekly habits (e.g., playing squash)
   - Custom frequency habits
   - Streak tracking
   - Point system

2. **One-off Tasks**
   - Single completion items
   - Due dates
   - Dynamic urgency coloring
   - Point system

3. **Goals**
   - Long-term objectives
   - Progress tracking
   - Can be linked to habits/tasks
   - Point system

## Data Model

### Core Entities

1. **Activity**
   ```swift
   struct Activity {
       let id: UUID
       var title: String
       var description: String?
       var points: Int
       var type: ActivityType
       var createdAt: Date
       var lastCompleted: Date?
       var isActive: Bool
   }
   ```

2. **ActivityType**
   ```swift
   enum ActivityType {
       case habit(frequency: HabitFrequency)
       case oneOff(dueDate: Date?)
       case goal(targetDate: Date?)
   }
   ```

3. **HabitFrequency**
   ```swift
   enum HabitFrequency {
       case daily
       case weekly
       case custom(days: [Weekday])
   }
   ```

4. **CompletionRecord**
   ```swift
   struct CompletionRecord {
       let id: UUID
       let activityId: UUID
       let completedAt: Date
       let pointsEarned: Int
   }
   ```

5. **Streak**
   ```swift
   struct Streak {
       let activityId: UUID
       var currentStreak: Int
       var bestStreak: Int
       var lastBroken: Date?
   }
   ```

## UI/UX Design

### Main Screens

1. **Home Tab**
   - Daily points summary
   - Quick access to today's habits
   - Recent activity feed
   - Current streaks display

2. **Activities Tab**
   - List of all activities
   - Filter by type (Habits/Tasks/Goals)
   - Search functionality
   - Add new activity button

3. **Stats Tab**
   - Historical points graph
   - Streak achievements
   - Activity completion rates
   - Weekly/Monthly summaries

4. **Activity Detail View**
   - Activity information
   - Completion history
   - Streak information
   - Edit options
   - For habits: quick complete button
   - For tasks: due date and urgency indicator

### Visual Design Elements

1. **Color System**
   - Base theme colors
   - Urgency gradient (green → yellow → red)
   - Success/Completion colors
   - Streak highlight colors

2. **Icons**
   - Activity type indicators
   - Completion status
   - Streak indicators
   - Urgency indicators

## Technical Implementation

### Data Storage
- Use CoreData for local persistence
- Simple file-based backup system
- No cloud sync in initial version

### Key Features Implementation

1. **Streak System**
   - Track last completion date
   - Calculate current streak
   - Update best streak when broken
   - Handle different frequency types

2. **Points System**
   - Daily points calculation
   - Historical points tracking
   - Activity-specific point values

3. **Urgency System**
   - Color gradient based on due date
   - Configurable urgency thresholds
   - Visual indicators for overdue items

## Development Phases

### Phase 1: Core Functionality
- Basic activity creation and management
- Simple completion tracking
- Local data storage
- Basic UI implementation

### Phase 2: Enhanced Features
- Streak system implementation
- Points system
- Urgency coloring
- Basic statistics

### Phase 3: Polish
- UI refinements
- Performance optimizations
- Additional statistics
- Export/backup functionality

## Next Steps

1. Set up the basic iOS project structure
2. Implement CoreData model
3. Create basic UI components
4. Implement activity management
5. Add completion tracking
6. Develop streak system
7. Implement points system
8. Add statistics and visualizations
