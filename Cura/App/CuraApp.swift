import SwiftUI
import CuraCore

@main
struct CuraApp: App {
    private let container: DependencyContainer = {
        let arguments = ProcessInfo.processInfo.arguments
        guard arguments.contains("-ui-testing") else {
            return DependencyContainer.live
        }
        if arguments.contains("-mock-transcription-failure") {
            return DependencyContainer.makeLocalJSON(
                configuration: .development,
                audioRecorder: MockAudioRecordingProvider(),
                audioPlayback: MockAudioPlaybackProvider(),
                transcription: MockTranscriptionProvider(shouldFail: true)
            )
        }
        return DependencyContainer.uiTesting
    }()

    var body: some Scene {
        WindowGroup {
            ContentView(container: container)
        }
    }
}
