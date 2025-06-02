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
    
    var body: some View {
        ZStack {
            Button {
                withAnimation {
                    showing = true
                }
            } label: {
                Image(systemName: "calendar")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
            
            if showing {
                DatePicker("", selection: $date, displayedComponents: .date)
                    .allowsHitTesting(true)
                    .datePickerStyle(.wheel)
//                    .frame(width: 200, height: 150)
                    .background(.regularMaterial)
                    .cornerRadius(16)
                    .shadow(radius: 10)
                    .scaleEffect(showing ? 1 : 0.8)
            }
        }
    }
}

#Preview {
    @Previewable @State var date = Date()
    @Previewable @State var showingPicker = false
    DatePickerView(date: $date, showing: $showingPicker)
}
