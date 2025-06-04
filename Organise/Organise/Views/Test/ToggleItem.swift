import SwiftUI
import SwiftData

@Model
final class ToggleItem {
    var name: String
    var isToggled: Bool
    
    init(name: String, isToggled: Bool = false) {
        self.name = name
        self.isToggled = isToggled
    }
}

struct ToggleItemRow: View {
    @Environment(\.modelContext) private var context
    let item: ToggleItem
    
    var body: some View {
        HStack {
            Text(item.name)
                .foregroundColor(item.isToggled ? .secondary : .primary)
            Spacer()
            if item.isToggled {
                Button {
                    item.isToggled = false
                    try? context.save()
                } label: {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
                .buttonStyle(PlainButtonStyle())
            } else {
                Button {
                    item.isToggled = true
                    try? context.save()
                } label: {
                    Image(systemName: "circle")
                        .foregroundColor(.secondary)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

struct ToggleItemList: View {
    @Query(sort: \ToggleItem.name) private var items: [ToggleItem]
    
    var body: some View {
        List {
            ForEach(items) { item in
                ToggleItemRow(item: item)
                    .id(item.id)
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: ToggleItem.self, configurations: config)
    
    // Create and insert items in a single batch
    let items = [
        ToggleItem(name: "First Item", isToggled: true),
        ToggleItem(name: "Second Item", isToggled: false),
        ToggleItem(name: "Third Item", isToggled: true)
    ]
    
    items.forEach { container.mainContext.insert($0) }
    try? container.mainContext.save()
    
    return ToggleItemList()
        .modelContainer(container)
} 
