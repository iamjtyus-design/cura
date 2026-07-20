import SwiftUI
import CuraCore

struct ContentView: View {
    let container: DependencyContainer
    @StateObject private var model: PhaseOneViewModel
    @StateObject private var audioModel: AudioRecordingViewModel

    init(container: DependencyContainer) {
        self.container = container
        _model = StateObject(wrappedValue: PhaseOneViewModel(container: container))
        _audioModel = StateObject(wrappedValue: AudioRecordingViewModel(container: container))
    }

    var body: some View {
        NavigationStack {
            Group {
                if model.showingAudioRecorder {
                    AudioRecordingView(
                        model: audioModel,
                        onSave: { session in
                            Task {
                                await model.refreshLibrary()
                                model.selectedSession = session
                                model.showingAudioRecorder = false
                            }
                        },
                        onCancel: {
                            model.showingAudioRecorder = false
                        }
                    )
                } else if let draft = model.draftSession {
                    SessionSetupView(model: model, session: draft)
                } else if let selected = model.selectedSession {
                    SessionDetailView(model: model, recordingModel: audioModel, session: selected)
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
