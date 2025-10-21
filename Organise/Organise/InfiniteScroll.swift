import SwiftUI

struct InfiniteCalendarView: View {
    @State private var days: [Date] = []
    @State private var selectedDate: Date?
    @State private var isLoadingMore = false
    @State private var hasScrolled = false
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(Array(days.enumerated()), id: \.element) { index, day in
                        DayCalendarView(date: day, selectedDate: $selectedDate)
                            .id(day)
                            .background(
                                GeometryReader { geo in
                                    Color.clear.preference(
                                        key: ViewOffsetKey.self,
                                        value: [index: geo.frame(in: .named("scroll")).minY]
                                    )
                                }
                            )
                    }
                }
                .onPreferenceChange(ViewOffsetKey.self) { positions in
                    checkScrollPosition(positions: positions)
                }
            }
            .coordinateSpace(name: "scroll")
            .navigationTitle("Infinite Calendar")
            .onAppear {
                if days.isEmpty {
                    days = generateInitialDays()
                    // Scroll to today after a brief delay
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        let today = startOfDay(Date())
                        if days.contains(today) {
                            proxy.scrollTo(today, anchor: .center)
                        }
                        // Enable loading after initial scroll completes
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            hasScrolled = true
                            print("✅ Ready for infinite scroll")
                        }
                    }
                }
            }
        }
    }
    
    private func generateInitialDays() -> [Date] {
        var days: [Date] = []
        let calendar = Calendar.current
        let today = Date()
        
        // Generate 15 days: 7 before today, today, and 7 after
        for i in -7...7 {
            if let day = calendar.date(byAdding: .day, value: i, to: today) {
                days.append(startOfDay(day))
            }
        }
        
        print("📦 Initial load: \(days.count) days")
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        if let first = days.first, let last = days.last {
            print("   Range: \(formatter.string(from: first)) to \(formatter.string(from: last))")
        }
        
        return days
    }
    
    private func checkScrollPosition(positions: [Int: CGFloat]) {
        guard hasScrolled, !isLoadingMore else { return }
        
        // Find visible items (those with Y position between -500 and 1000)
        let visible = positions.filter { $0.value > -500 && $0.value < 1000 }
        
        guard !visible.isEmpty else { return }
        
        let indices = visible.keys.sorted()
        let minVisibleIndex = indices.min() ?? 0
        let maxVisibleIndex = indices.max() ?? 0
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        
        // Check if we're near the top (scrolling to past dates)
        if minVisibleIndex <= 2 && minVisibleIndex < days.count {
            let date = days[minVisibleIndex]
            print("🔼 Near top - viewing \(formatter.string(from: date)) at index \(minVisibleIndex)")
            loadDaysBefore()
        }
        // Check if we're near the bottom (scrolling to future dates)
        else if maxVisibleIndex >= days.count - 3 && maxVisibleIndex < days.count {
            let date = days[maxVisibleIndex]
            print("🔽 Near bottom - viewing \(formatter.string(from: date)) at index \(maxVisibleIndex)")
            loadDaysAfter()
        }
    }
    
    private func loadDaysBefore() {
        guard let firstDay = days.first,
              days.count < 100,
              !isLoadingMore else { return }
        
        isLoadingMore = true
        
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        
        print("   Loading 7 days before \(formatter.string(from: firstDay))")
        
        var newDays: [Date] = []
        for i in 1...7 {
            if let newDay = calendar.date(byAdding: .day, value: -i, to: firstDay) {
                newDays.insert(startOfDay(newDay), at: 0)
            }
        }
        days.insert(contentsOf: newDays, at: 0)
        
        print("   ✅ Total days: \(days.count)")
        
        // Reset flag after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            isLoadingMore = false
        }
    }
    
    private func loadDaysAfter() {
        guard let lastDay = days.last,
              days.count < 100,
              !isLoadingMore else { return }
        
        isLoadingMore = true
        
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        
        print("   Loading 7 days after \(formatter.string(from: lastDay))")
        
        for i in 1...7 {
            if let newDay = calendar.date(byAdding: .day, value: i, to: lastDay) {
                days.append(startOfDay(newDay))
            }
        }
        
        print("   ✅ Total days: \(days.count)")
        
        // Reset flag after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            isLoadingMore = false
        }
    }
    
    private func startOfDay(_ date: Date) -> Date {
        Calendar.current.startOfDay(for: date)
    }
}

struct DayCalendarView: View {
    let date: Date
    @Binding var selectedDate: Date?
    @State private var isExpanded = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Month header (only show if it's the first day of the month)
            if isFirstOfMonth {
                HStack {
                    Text(monthYearString)
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                        .padding(.top, 20)
                    Spacer()
                }
                .background(Color(uiColor: .systemBackground))
            }
            
            // Day header card
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(weekdayString)
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text(dayString)
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(isToday ? .blue : .primary)
                    }
                    
                    Spacer()
                    
                    if isToday {
                        Text("Today")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                }
                
                // Expand/collapse button
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        isExpanded.toggle()
                    }
                }) {
                    HStack {
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .font(.caption)
                        Text(isExpanded ? "Hide hours" : "Show hours")
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.blue)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                }
            }
            .padding()
            .background(Color(uiColor: .secondarySystemBackground))
            .cornerRadius(16)
            .padding(.horizontal)
            .padding(.top, 8)
            
            // Hourly timeline (collapsible)
            if isExpanded {
                VStack(spacing: 0) {
                    ForEach(0..<24) { hour in
                        HourRowView(date: date, hour: hour)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }
    
    private var isFirstOfMonth: Bool {
        Calendar.current.component(.day, from: date) == 1
    }
    
    private var isToday: Bool {
        Calendar.current.isDateInToday(date)
    }
    
    private var weekdayString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }
    
    private var dayString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    private var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
}

struct HourRowView: View {
    let date: Date
    let hour: Int
    
    private var hourDate: Date {
        Calendar.current.date(bySettingHour: hour, minute: 0, second: 0, of: date) ?? date
    }
    
    private var isCurrentHour: Bool {
        let now = Date()
        let calendar = Calendar.current
        return calendar.isDate(hourDate, equalTo: now, toGranularity: .hour)
    }
    
    private var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h a"
        return formatter.string(from: hourDate)
    }
    
    var body: some View {
        HStack(spacing: 0) {
            // Time label
            Text(timeString)
                .font(.system(size: 14))
                .foregroundColor(isCurrentHour ? .blue : .secondary)
                .fontWeight(isCurrentHour ? .semibold : .regular)
                .frame(width: 60, alignment: .trailing)
                .padding(.trailing, 12)
            
            // Timeline area
            VStack(spacing: 0) {
                Divider()
                    .background(isCurrentHour ? Color.blue : Color.gray.opacity(0.3))
                
                Rectangle()
                    .fill(Color.clear)
                    .frame(height: 60)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(isCurrentHour ? Color.blue.opacity(0.3) : Color.clear, lineWidth: 2)
                    )
            }
        }
        .background(isCurrentHour ? Color.blue.opacity(0.05) : Color.clear)
    }
}

struct ViewOffsetKey: PreferenceKey {
    static var defaultValue: [Int: CGFloat] = [:]
    
    static func reduce(value: inout [Int: CGFloat], nextValue: () -> [Int: CGFloat]) {
        value.merge(nextValue()) { $1 }
    }
}

#Preview {
    NavigationStack {
        InfiniteCalendarView()
    }
}
