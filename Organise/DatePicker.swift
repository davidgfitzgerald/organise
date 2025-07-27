//
//  DatePicker.swift
//  Organise
//
//  Created by David Fitzgerald on 27/07/2025.
//


            // From https://stackoverflow.com/a/78116229
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
                .presentationCompactAdaptation(.popover)
            }
            .onChange(of: selectedDate) { _, _ in
                showCalendar = false
            }