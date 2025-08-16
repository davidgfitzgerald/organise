//
//  DatePickerView.swift
//  Organise
//
//  Created by David Fitzgerald on 02/06/2025.
//

import SwiftUI


struct DatePickerView: View {
    /**
     * Date picker that automatically closes when
     * the selected date changes.
     */
    @Binding var selectedDate: Date
    @State private var showCalendar: Bool = false
    
    var body: some View {
        Button(action: {
            showCalendar = true
        }, label: {
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.primary)
                Text(selectedDate, style: .date)
                    .foregroundColor(.primary)
            }
            .padding()
            .background(Color(.systemGray5))
            .cornerRadius(10)

        })
        .popover(isPresented: $showCalendar) {
            DatePicker(
                "Select date",
                selection: $selectedDate,
                displayedComponents: .date
            )
            .datePickerStyle(.graphical)
            .padding()
            .frame(width: 365, height: 365)
            /**
             * The smallest device this will support is iPhone SE (3rd Gen), which has screen width 375.
             * From https://stackoverflow.com/a/78116229
             */
            .presentationCompactAdaptation(.popover)
        }
        .onChange(of: selectedDate) { _, _ in
            showCalendar = false
        }
    }
}

#Preview {
    @Previewable @State var date = Date()
    DatePickerView(selectedDate: $date)
}
