import SwiftUI
#if os(iOS) && canImport(AVFoundation)
import AVFoundation
#endif

public struct SessionDetailView: View {
    @ObservedObject public var model: PhaseOneViewModel
    @ObservedObject public var recordingModel: AudioRecordingViewModel
    public let session: CaptureSession
    @State private var title: String
    @State private var mode: CaptureMode
    @State private var folderID: UUID?
    @State private var processingMode: ProcessingMode

    public init(model: PhaseOneViewModel, recordingModel: AudioRecordingViewModel, session: CaptureSession) {
        self.model = model
        self.recordingModel = recordingModel
        self.session = session
        _title = State(initialValue: session.title)
        _mode = State(initialValue: session.mode)
        _folderID = State(initialValue: session.folderID)
        _processingMode = State(initialValue: session.processingMode)
    }

    public var note: CuratedNote? { model.note(for: session.id) }
    public var caption: GeneratedOutput? { model.instagramCaption(for: session.id) }
    public var audioSource: CaptureSource? { model.audioSource(for: session.id) }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 6) {
                        TextField("Session title", text: $title)
                            .font(.title2.weight(.semibold))
                            .textFieldStyle(.plain)
                            .accessibilityLabel("Session title")
                            .accessibilityIdentifier("topSessionTitleField")
                        Text("\(mode.displayName) • Local processing")
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Button {
                        Task { await model.toggleFavorite(session) }
                    } label: {
                        Image(systemName: session.isFavorite ? "star.fill" : "star")
                            .imageScale(.large)
                    }
                    .accessibilityLabel(session.isFavorite ? "Remove Favorite" : "Add Favorite")
                    .accessibilityIdentifier("favoriteButton")
                }

                if model.shouldShowProcessing(for: session) {
                    ProcessingStagesView(model: model, sourceType: model.primarySourceType(for: session.id))
                }

                if let audioSource {
                    AudioPlaybackView(recordingModel: recordingModel, source: audioSource)

                    Button("Delete Recording", role: .destructive) {
                        Task { await model.deleteRecording(audioSource) }
                    }
                    .buttonStyle(.bordered)
                    .accessibilityLabel("Delete Recording")
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Session Details")
                        .font(.headline)
                    Picker("Mode", selection: $mode) {
                        ForEach(CaptureMode.allCases, id: \.self) { mode in
                            Text(mode.displayName).tag(mode)
                        }
                    }
                    Text(mode.guidance)
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Picker("Folder", selection: $folderID) {
                        Text("No Folder").tag(UUID?.none)
                        ForEach(model.folders) { folder in
                            Text(folder.name).tag(Optional(folder.id))
                        }
                    }
                    HStack {
                        TextField("New folder name", text: $model.newFolderName)
                            .textFieldStyle(.roundedBorder)
                            .accessibilityLabel("New folder name")
                        Button("Add Folder") {
                            Task {
                                if let folder = await model.addFolder() {
                                    folderID = folder.id
                                }
                            }
                        }
                        .buttonStyle(.bordered)
                        .accessibilityLabel("Add Folder")
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Processing")
                            .font(.subheadline.weight(.semibold))
                        Text("Private and Smart currently use the same local mock processing in this build. Smart enhancements are unavailable until a later approved phase.")
                            .foregroundStyle(.secondary)
                    }
                        .font(.caption)

                    Button("Save Session Details") {
                        Task {
                            await model.saveSessionMetadata(
                                session,
                                title: title,
                                mode: mode,
                                folderID: folderID,
                                processingMode: processingMode
                            )
                        }
                    }
                    .buttonStyle(.bordered)
                    .accessibilityLabel("Save Session Details")
                }
                .padding()
                .background(PhaseOneSurface.secondary)
                .clipShape(RoundedRectangle(cornerRadius: 8))

                if let note {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Curated Note")
                            .font(.headline)
                        Text(note.smartSummary)
                        ForEach(note.keyIdeas, id: \.self) { idea in
                            Label(idea, systemImage: "checkmark.circle")
                                .font(.subheadline)
                        }
                    }
                    .padding()
                    .background(PhaseOneSurface.secondary)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .accessibilityIdentifier("curatedNote")
                }

                if let caption {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Instagram Caption")
                            .font(.headline)
                        Text(caption.content)
                            .font(.body)
                            .accessibilityIdentifier("instagramCaption")
                        HStack {
                            Button {
                                Task { await model.copy(caption.content) }
                            } label: {
                                Label("Copy", systemImage: "doc.on.doc")
                            }
                            .buttonStyle(.bordered)
                            .accessibilityIdentifier("copyCaptionButton")

                            Button {
                                Task { await model.copyAndOpenInstagram(caption.content) }
                            } label: {
                                Label("Copy and Open Instagram", systemImage: "square.and.arrow.up")
                            }
                            .buttonStyle(.borderedProminent)
                            .accessibilityIdentifier("copyOpenInstagramButton")
                        }
                    }
                    .padding()
                    .background(PhaseOneSurface.secondary)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .accessibilityIdentifier("creatorPack")
                }

                Button("Back to Sessions") {
                    model.selectedSession = nil
                }
                .accessibilityIdentifier("backToSessionsButton")

                Button("Delete Session", role: .destructive) {
                    Task { await model.deleteSession(session) }
                }
                .accessibilityLabel("Delete Session")
            }
            .padding()
        }
        .navigationTitle("Session")
#if os(iOS) && canImport(AVFoundation)
        .onReceive(NotificationCenter.default.publisher(for: AVAudioSession.interruptionNotification)) { _ in
            Task { await recordingModel.handlePlaybackInterruption() }
        }
        .onReceive(NotificationCenter.default.publisher(for: AVAudioSession.routeChangeNotification)) { _ in
            Task { await recordingModel.handlePlaybackInterruption() }
        }
#endif
    }
}
