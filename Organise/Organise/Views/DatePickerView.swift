//
//  DatePickerView.swift
//  Organise
//
//  Created by David Fitzgerald on 02/06/2025.
//

import SwiftUI


struct DatePickerView: View {
    @Binding var date: Date
    @Binding var showing: Bool
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    var body: some View {
        HStack {
            Spacer()
            
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    showing.toggle()
                }
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "calendar")
                        .foregroundStyle(.secondary)
                    
                    Text(dateFormatter.string(from: date))
                        .font(.headline)
                        .foregroundStyle(.primary)
                    
                    Image(systemName: showing ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .animation(.easeInOut(duration: 0.2), value: showing)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 10))
            }
            .buttonStyle(.plain)
            
            Spacer()
        }
        .padding(.horizontal)
        .onChange(of: date) {
            showing = false
            print("Selected \(date.shortest)")
        }
        
        if showing {
            DatePicker(
                "Select Date",
                selection: $date,
                displayedComponents: .date
            )
            .datePickerStyle(.graphical)
            .padding(.horizontal)
            .transition(.opacity.combined(with: .scale(scale: 0.95)))
            .animation(.easeInOut(duration: 0.3), value: showing)
        }
    }
}

// TODO - nice idea but buggy
extension View {
    func dismissDatePicker(when showing: Bool, action: @escaping () -> Void) -> some View {
        self.onTapGesture {
            if showing {
                action()
            }
        }
    }
}

#Preview {
    @Previewable @State var date = Date()
    @Previewable @State var showingPicker = false
    DatePickerView(date: $date, showing: $showingPicker)
}
