import SwiftUI

struct ContentView: View {
    @State private var urlText: String = "No URL received"
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, World!")
            Text(urlText)
        }
        .padding()
        .onOpenURL { url in
            urlText = "Received URL: \(url.absoluteString)"
        }
    }
}

#Preview {
    ContentView()
} 