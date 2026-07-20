import SwiftUI
import CuraCore

@main
struct CuraApp: App {
    private let container = ProcessInfo.processInfo.arguments.contains("-ui-testing")
        ? DependencyContainer.uiTesting
        : DependencyContainer.live

    var body: some Scene {
        WindowGroup {
            ContentView(container: container)
        }
    }
}
