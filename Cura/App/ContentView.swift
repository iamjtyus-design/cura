import SwiftUI
import CuraCore

struct ContentView: View {
    let container: DependencyContainer
    @StateObject private var model: PhaseOneViewModel

    init(container: DependencyContainer) {
        self.container = container
        _model = StateObject(wrappedValue: PhaseOneViewModel(container: container))
    }

    var body: some View {
        NavigationStack {
            Group {
                if let draft = model.draftSession {
                    SessionSetupView(model: model, session: draft)
                } else if let selected = model.selectedSession {
                    SessionDetailView(model: model, session: selected)
                } else {
                    HomeView(model: model)
                }
            }
            .navigationTitle("CURA")
            .task {
                await model.loadIfNeeded()
            }
            .alert("CURA needs attention", isPresented: model.showingError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(model.errorMessage)
            }
            .sheet(item: $model.shareItem) { item in
#if canImport(UIKit)
                ActivityView(items: [item.text])
#else
                Text(item.text)
                    .padding()
#endif
            }
        }
    }
}
