# Organise App - Requirements & Progress

## In Progress Features 🚧

### Bug Fixes & Improvements
- [ ] Fix TextField dismissal issue in HabitForm
- [ ] Improve error handling for Claude API calls
- [ ] Add loading states for better UX
- [ ] Optimize sample data loading
- [ ] Allow users to pick more/all emojis

### Basic Statistics
- [ ] Add streak counting logic
- [ ] Show current streak for each habit
- [ ] Show max streak for each habit
- [ ] Calculate completion percentage per habit
- [ ] Display completion percentage in UI

### Enhanced Date Navigation
- [ ] Improve date picker UI design
- [ ] Add quick navigation buttons (today, yesterday)
- [ ] Better date display formatting
- [ ] Week view with completion patterns

---

## Upcoming Features 📋

#### Streak Tracking
- [ ] Show current streak for each habit
- [ ] Track longest streak per habit
- [ ] Visual streak indicators (fire emoji, numbers)
- [ ] Streak reset logic
- [ ] Streak milestone celebrations

#### Habit Categories/Tags
- [ ] Add category field to Habit model
- [ ] Category selection in HabitForm
- [ ] Color coding for different categories
- [ ] Filter habits by category
- [ ] Category management (create, edit, delete)

#### Habit Details & Statistics
- [ ] Completion percentage display
- [ ] Weekly progress charts
- [ ] Monthly progress charts
- [ ] Best performing days analysis
- [ ] Habit performance insights

#### Reminders & Notifications
- [ ] Daily reminder notifications
- [ ] Custom reminder times per habit
- [ ] Push notifications for missed habits
- [ ] Notification settings management
- [ ] Quiet hours configuration

#### Goal Setting
- [ ] Set weekly/monthly goals per habit
- [ ] Progress tracking towards goals
- [ ] Goal completion celebrations
- [ ] Goal adjustment functionality
- [ ] Goal history tracking

#### Habit Templates
- [ ] Pre-built habit suggestions
- [ ] Quick-add common habits
- [ ] Import/export habit lists
- [ ] Template categories (health, work, learning)
- [ ] Custom template creation

#### Enhanced UI/UX
- [ ] Dark mode support
- [ ] Custom themes
- [ ] Improved animations
- [ ] Better visual feedback
- [ ] Accessibility improvements

#### Detailed Analytics
- [ ] Habit correlation analysis
- [ ] Mood tracking integration
- [ ] Productivity insights
- [ ] Export data to CSV/PDF
- [ ] Data visualization improvements

#### Advanced Scheduling
- [ ] Habit frequency settings (daily, weekly, custom)
- [ ] Skip days functionality
- [ ] Habit chains (complete A to unlock B)
- [ ] Recurring habit patterns
- [ ] Flexible scheduling options

#### Gamification
- [ ] Achievement badges system
- [ ] Points system
- [ ] Level progression
- [ ] Habit streaks leaderboard
- [ ] Milestone celebrations

#### Integration Features
- [ ] Health app integration
- [ ] Calendar integration
- [ ] Widget support
- [ ] Apple Watch app
- [ ] iCloud sync

#### Advanced Customization
- [ ] Custom themes and colors
- [ ] Advanced habit types (time-based, count-based)
- [ ] Custom emoji sets
- [ ] Personalized insights
- [ ] Advanced habit configurations

#### Data & Backup
- [ ] iCloud sync implementation
- [ ] Export/import data functionality
- [ ] Multiple device sync
- [ ] Data backup/restore
- [ ] Data migration tools

#### Social Features
- [ ] Share progress with friends
- [ ] Habit challenges
- [ ] Accountability partners
- [ ] Social leaderboards
- [ ] Community features

---

## Technical Requirements

### Performance
- [ ] Optimise for large datasets
- [ ] Implement caching for analytics
- [ ] Efficient streak calculations
- [ ] Smooth scrolling with many habits
- [ ] Fast app startup

### Data Management
- [x] Schema migration strategies
- [ ] Data validation
- [ ] Backup and restore functionality
- [ ] Data export capabilities
- [ ] Privacy and security

### Testing
- [ ] Unit tests for core functionality
- [ ] UI tests for critical flows
- [ ] Performance testing
- [ ] Accessibility testing
- [ ] Beta testing program

## Current Features ✅

### Core Habit Management
- [x] Users can create new habits with custom names
- [x] Users can delete habits with swipe actions
- [x] Data is persisted locally with SwiftData
- [x] Habit are listed with creation date sorting
- [x] Users can mark habits as completed/uncompleted
- [x] Users can view habits list per day
- [x] Users can view habits details
- [x] Users can view habits statistics
- [x] Users can view habits history
- [x] Users can view habits settings

### Daily Tracking
- [x] Users can tap to mark habits as completed/uncompleted
- [x] Users see visual feedback with strikethrough for completed habits
- [x] Users can use a date picker to view different days
- [x] Users can track completion status per day

### UI/UX Features
- [x] AI-suggested emojis via Claude API
- [x] Custom emoji picker for habit icons
- [x] Loading states while AI generates emojis
- [x] Sample data for testing/preview
- [x] Clean, minimal interface design

### Technical Foundation
- [x] SwiftUI frontend
- [x] SwiftData backend persistence
- [x] MVVM architecture
- [x] Claude API integration
- [x] Schema versioning support