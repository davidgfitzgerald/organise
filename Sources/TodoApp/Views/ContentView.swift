import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = TodoViewModel()
    @State private var newTodoTitle = ""
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Today")) {
                    ForEach(viewModel.todos) { todo in
                        TodoRowView(todo: todo, onToggle: {
                            viewModel.toggleTodo(todo)
                        })
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { index in
                            viewModel.deleteTodo(viewModel.todos[index])
                        }
                    }
                }
            }
            .navigationTitle("Todo List")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Add new todo
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}

struct TodoRowView: View {
    let todo: Todo
    let onToggle: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                .foregroundColor(todo.isCompleted ? .green : .gray)
                .onTapGesture(perform: onToggle)
            
            Text(todo.title)
                .strikethrough(todo.isCompleted)
            
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
} 