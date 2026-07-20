import SwiftUI

public struct SessionSetupView: View {
    @ObservedObject public var model: PhaseOneViewModel
    public let session: CaptureSession

    public init(model: PhaseOneViewModel, session: CaptureSession) {
        self.model = model
        self.session = session
    }

    public var body: some View {
        Form {
            Section("Session Setup") {
                TextField("Title", text: $model.setupTitle)
                    .accessibilityLabel("Session title")

                Picker("Mode", selection: $model.setupMode) {
                    ForEach(CaptureMode.allCases, id: \.self) { mode in
                        Text(mode.displayName).tag(mode)
                    }
                }

                Picker("Folder", selection: $model.setupFolderID) {
                    Text("No Folder").tag(UUID?.none)
                    ForEach(model.folders) { folder in
                        Text(folder.name).tag(Optional(folder.id))
                    }
                }

                Picker("Processing Mode", selection: $model.setupProcessingMode) {
                    Text("Private").tag(ProcessingMode.private)
                    Text("Smart").tag(ProcessingMode.smart)
                }
            }

            Section {
                Button {
                    Task { await model.startProcessing() }
                } label: {
                    Label("Start Mock Processing", systemImage: "play.circle")
                }
                .accessibilityLabel("Start Mock Processing")

                Button("Cancel Session", role: .cancel) {
                    Task { await model.cancelDraft() }
                }
                .accessibilityLabel("Cancel Session")
            }
        }
        .navigationTitle("Session Setup")
    }
}
