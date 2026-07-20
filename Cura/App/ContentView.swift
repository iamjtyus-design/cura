import SwiftUI
import CuraCore

struct ContentView: View {
    let container: DependencyContainer

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("CURA")
                .font(.largeTitle.bold())
            Text("Capture. Understand. Refine. Activate.")
                .font(.headline)
            Text("Phase 0 foundation is ready for the first vertical slice.")
                .font(.body)
        }
        .padding(24)
    }
}
