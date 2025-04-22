import Foundation
import SwiftUI

class TodoViewModel: ObservableObject {
    @Published var todos: [Todo] = []
    
    func addTodo(title: String) {
        let newTodo = Todo(title: title)
        todos.append(newTodo)
    }
    
    func toggleTodo(_ todo: Todo) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            todos[index].isCompleted.toggle()
        }
    }
    
    func deleteTodo(_ todo: Todo) {
        todos.removeAll { $0.id == todo.id }
    }
} 