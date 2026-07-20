import SwiftUI
import UniformTypeIdentifiers

public struct HomeView: View {
    @ObservedObject public var model: PhaseOneViewModel

    public init(model: PhaseOneViewModel) {
        self.model = model
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Capture. Understand. Refine. Activate.")
                        .font(.title2.weight(.semibold))
                    Text("Import a video, review the setup, and create a mock Creator Pack.")
                        .font(.body)
                        .foregroundStyle(.secondary)
                }

                Button {
                    model.importVideoTapped()
                } label: {
                    Label("Import Video", systemImage: "video.badge.plus")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .accessibilityLabel("Import Video")

                Button {
                    model.showingAudioRecorder = true
                } label: {
                    Label("Record Audio", systemImage: "mic.circle")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
                .accessibilityLabel("Record Audio")

                FolderComposer(model: model)

                if model.sessions.isEmpty {
                    ContentUnavailableView(
                        "No sessions yet",
                        systemImage: "tray",
                        description: Text("Import a video to create your first Capture Session.")
                    )
                    .accessibilityIdentifier("emptySessions")
                } else {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Sessions")
                            .font(.headline)
                        ForEach(model.sessions) { session in
                            SessionRow(model: model, session: session)
                        }
                    }
                }
            }
            .padding()
        }
        .fileImporter(
            isPresented: $model.showingImporter,
            allowedContentTypes: [.movie, .mpeg4Movie, .quickTimeMovie],
            allowsMultipleSelection: false
        ) { result in
            Task { await model.handleImportResult(result) }
        }
    }
}
