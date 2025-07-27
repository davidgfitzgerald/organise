//
//  DateHeaderView.swift
//  Organise
//
//  Created by David Fitzgerald on 27/07/2025.
//

import SwiftUI

// MARK: - Date Header View
struct DateHeaderView: View {
    @Binding var selectedDate: Date
    @State var showCalendar = false
    let completionPercentage: Double
    
    private var isToday: Bool {
        Calendar.current.isDateInToday(selectedDate)
    }
    
    var body: some View {
        // Date Selection
        HStack(spacing: 16) {
            DatePickerView(selectedDate: $selectedDate)
        
            Text("Today")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.orange)
                .opacity(isToday ? 1 : 0)
            
            Spacer()
            
            // Overall Progress Ring
            ProgressRing(progress: completionPercentage, color: .green, lineWidth: 4, size: 50)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
        .background(
            Color(.systemGray6)
                .opacity(0.7)
                .clipShape(RoundedCorner(radius: 20, corners: [.topLeft, .topRight]))
        )
    }
}

#Preview {
    @Previewable @State var date = Date()
    DateHeaderView(selectedDate: $date, completionPercentage: 0.3)
}
