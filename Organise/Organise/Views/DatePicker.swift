import SwiftUI

struct ClickableDatePicker: View {
    @Binding var selectedDate: Date
    var title: String
    var dateFormat: DateFormat = .medium
    
    // Animation states
    @State private var isHovering = false
    @State private var isPressed = false
    @State private var showPicker = false
    @State private var contentOffset: CGFloat = -UIScreen.main.bounds.width // Start off-screen to the left
    
    // For animation
    @Namespace private var buttonAnimation
    
    var body: some View {
        VStack {
            // The clickable date display
            Button {
                if showPicker {
                    // Close the picker - animate to the right
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        contentOffset = UIScreen.main.bounds.width * 1.5 // Move far right
                    }
                    
                    // Delay toggling the showPicker flag to allow animation to complete
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        showPicker = false
                        // Reset position for next opening
                        contentOffset = -UIScreen.main.bounds.width
                    }
                } else {
                    // Show the picker
                    showPicker = true
                    // Animate from left to center
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        contentOffset = 0 // Move to center
                    }
                }
            } label: {
                HStack(spacing: 8) {
                    // Calendar icon with bouncy animation
                    Image(systemName: "calendar")
                        .font(.system(size: 18))
                        .foregroundColor(isPressed ? .gray : (isHovering ? .accentColor : .gray))
                        .matchedGeometryEffect(id: "calendarIcon", in: buttonAnimation)
                        .scaleEffect(isPressed ? 0.9 : 1.0)
                    
                    // Date text
                    Text(dateFormatter.string(from: selectedDate))
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    // Rotating chevron icon
                    Image(systemName: "chevron.down")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .rotationEffect(Angle(degrees: showPicker ? 180 : 0))
                        .animation(.interpolatingSpring(stiffness: 300, damping: 15), value: showPicker)
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 12)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            isPressed ? Color.gray.opacity(0.15) :
                                (isHovering ? Color.gray.opacity(0.1) : Color.gray.opacity(0.05))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(isHovering ? Color.accentColor.opacity(0.5) : Color.gray.opacity(0.2), lineWidth: 1)
                        )
                )
                .scaleEffect(isPressed ? 0.98 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: isHovering)
                .animation(.easeInOut(duration: 0.1), value: isPressed)
            }
            .buttonStyle(PlainButtonStyle())
            .onHover { hovering in
                isHovering = hovering
            }
            .pressAction {
                isPressed = true
            } onRelease: {
                isPressed = false
            }
            
            // The actual date picker with direct animation control
            if showPicker {
                GeometryReader { geometry in
                    VStack(alignment: .leading) {
                        Text(title)
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.horizontal, 12)
                            .padding(.top, 4)
                        
                        DatePicker(
                            "",
                            selection: $selectedDate,
                            displayedComponents: .date
                        )
                        .datePickerStyle(.graphical)
                        .labelsHidden()
                        .padding(.horizontal, 8)
                        .padding(.bottom, 8)
                    }
                    .frame(width: geometry.size.width)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.systemBackground))
                            .shadow(color: Color.black.opacity(0.15), radius: 6, x: 0, y: 3)
                    )
                    .padding(.top, 4)
                    .offset(x: contentOffset)
                }
                .zIndex(1)
            }
        }
    }
    
    // Date formatter based on the selected style
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        
        switch dateFormat {
        case .short:
            formatter.dateStyle = .short
        case .medium:
            formatter.dateStyle = .medium
        case .long:
            formatter.dateStyle = .long
        case .full:
            formatter.dateStyle = .full
        case .custom(let format):
            formatter.dateFormat = format
        }
        
        return formatter
    }
    
    // Date format options
    enum DateFormat {
        case short      // "5/20/25"
        case medium     // "May 20, 2025"
        case long       // "May 20, 2025"
        case full       // "Tuesday, May 20, 2025"
        case custom(String)  // Custom format like "EEE, MMM d, yyyy"
    }
}

// Extension to handle press events
extension View {
    func pressAction(onPress: @escaping () -> Void, onRelease: @escaping () -> Void) -> some View {
        modifier(PressActionModifier(onPress: onPress, onRelease: onRelease))
    }
}

struct PressActionModifier: ViewModifier {
    var onPress: () -> Void
    var onRelease: () -> Void
    
    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        onPress()
                    }
                    .onEnded { _ in
                        onRelease()
                    }
            )
    }
}

// MARK: - Preview
struct ClickableDatePicker_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper()
    }
    
    struct PreviewWrapper: View {
        @State private var date = Date()
        
        var body: some View {
            VStack(spacing: 40) {
                Text("Select a Date")
                    .font(.title)
                    .padding(.top, 40)
                
                // First picker
                ClickableDatePicker(
                    selectedDate: $date,
                    title: "Event Date"
                )
                
                // Second picker
                ClickableDatePicker(
                    selectedDate: $date,
                    title: "Schedule For",
                    dateFormat: .full
                )
                
                // Third picker
                ClickableDatePicker(
                    selectedDate: $date,
                    title: "Custom Format",
                    dateFormat: .custom("EEE, MMM d, yyyy")
                )
                
                Spacer()
            }
            .padding(.horizontal, 20)
        }
    }
}
