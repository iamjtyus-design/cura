import SwiftUI
import CuraCore

@main
struct CuraApp: App {
    private let container = DependencyContainer.live

    var body: some Scene {
        WindowGroup {
            ContentView(container: container)
        }
    }
}
