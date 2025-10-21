// First install the library via SPM:
// https://github.com/b5i/InfiniteScrollViews

import SwiftUI
import InfiniteScrollViews

// Shared constants for precise height calculations
private let dayCardInnerHeight: CGFloat = 100
private let monthHeaderHeight: CGFloat = 60
private let horizontalPadding: CGFloat = 16 // Standard SwiftUI padding

// Helper function to calculate view height
private func heightForDate(_ date: Date) -> CGFloat {
    let isFirstOfMonth = Calendar.current.component(.day, from: date) == 1
    return isFirstOfMonth ? (monthHeaderHeight + dayCardInnerHeight) : dayCardInnerHeight
}

// MARK: InfiniteScrollCalendarView
struct InfiniteScrollCalendarView: View {
    /**
     *
     */
    @State private var currentDate = Date()
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                InfiniteScrollView(
                    frame: geometry.frame(in: .local),
                    changeIndex: currentDate,
                    content: DayView.init,
                    contentFrame: {CGRect(x: 0, y: 0, width: geometry.size.width, height: heightForDate($0))},
                    increaseIndexAction: { Calendar.current.date(byAdding: .day, value: 1, to: $0) },
                    decreaseIndexAction: { Calendar.current.date(byAdding: .day, value: -1, to: $0) },
                    orientation: .vertical,
                )
            }
            .navigationTitle("Infinite Calendar")
        }
    }
}

// MARK: DayView
struct DayView: View {
    let date: Date
    
    var body: some View {
        VStack(spacing: 0) {
            // Month header (only show if first of month)
            if Calendar.current.component(.day, from: date) == 1 {
                MonthHeaderView(title: monthYearString)
            }
            
            DayCardView(
                weekdayString: weekdayString,
                dayString: dayString,
                isToday: isToday,
            )
        }
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

// MARK: MonthHeaderView
struct MonthHeaderView: View {
    let title: String

    var body: some View {
        HStack {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal, horizontalPadding)
            Spacer()
        }
        .frame(height: monthHeaderHeight)
        .background(Color(uiColor: .systemBackground))
    }
}

// MARK: DayCardView
struct DayCardView: View {
    let weekdayString: String
    let dayString: String
    let isToday: Bool

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(weekdayString)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(dayString)
                    .font(.system(size: 36, weight: .bold))
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
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
        .padding(.horizontal, horizontalPadding)
        .frame(height: dayCardInnerHeight)
    }
}

// MARK: Preview
#Preview {
    InfiniteScrollCalendarView()
}
