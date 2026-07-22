import SwiftUI
#if canImport(UIKit)
import UIKit
#endif
#if os(iOS) && canImport(AVFoundation)
import AVFoundation
#endif

private enum SessionDetailContentTab: String, CaseIterable, Identifiable {
    case curatedNote = "Curated Note"
    case transcript = "Transcript"
    case recording = "Recording"

    var id: String { rawValue }
}

public struct SessionDetailView: View {
    @Environment(\.scenePhase) private var scenePhase
    @ObservedObject public var model: PhaseOneViewModel
    @ObservedObject public var recordingModel: AudioRecordingViewModel
    public let session: CaptureSession
    @State private var title: String
    @State private var mode: CaptureMode
    @State private var folderID: UUID?
    @State private var processingMode: ProcessingMode
    @State private var selectedContentTab: SessionDetailContentTab = .curatedNote
    @State private var showingDeleteRecordingConfirmation = false
    @State private var isAddingFolder = false
    @State private var detailFolderName = ""
    @State private var isShowingSessionInfo = false

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
                        Text("\(mode.displayName) • \(session.createdAt.formatted(date: .abbreviated, time: .shortened))\(durationText)")
                            .foregroundStyle(.secondary)
                            .font(.subheadline)
                        if let note, shouldShowGeneratedTitleUndo(for: note) {
                            Button("Undo Generated Title") {
                                Task { await model.undoGeneratedTitle(for: session, note: note) }
                            }
                            .font(.caption.weight(.semibold))
                            .buttonStyle(.bordered)
                            .accessibilityIdentifier("undoGeneratedTitleButton")
                        }
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

                if shouldShowAudioProcessingControls {
                    audioProcessingControls
                }

                if audioSource != nil || note != nil {
                    VStack(alignment: .leading, spacing: 14) {
                        Picker("Session content", selection: $selectedContentTab) {
                            ForEach(SessionDetailContentTab.allCases) { tab in
                                Text(tab.rawValue).tag(tab)
                            }
                        }
                        .pickerStyle(.segmented)
                        .accessibilityIdentifier("sessionContentTabs")

                        switch selectedContentTab {
                        case .curatedNote:
                            curatedNoteContent
                        case .transcript:
                            transcriptContent
                        case .recording:
                            recordingContent
                        }
                    }
                }

                DisclosureGroup("Session Info", isExpanded: $isShowingSessionInfo) {
                    VStack(alignment: .leading, spacing: 12) {
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
                        if isAddingFolder {
                            VStack(alignment: .leading, spacing: 8) {
                                TextField("New folder name", text: $detailFolderName)
                                    .textFieldStyle(.roundedBorder)
                                    .accessibilityLabel("New folder name")
                                HStack {
                                    Button("Save Folder") {
                                        model.newFolderName = detailFolderName
                                        Task {
                                            if let folder = await model.addFolder() {
                                                folderID = folder.id
                                                detailFolderName = ""
                                                isAddingFolder = false
                                            }
                                        }
                                    }
                                    .buttonStyle(.borderedProminent)
                                    .disabled(detailFolderName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                                    .accessibilityIdentifier("saveFolderButton")

                                    Button("Cancel") {
                                        detailFolderName = ""
                                        isAddingFolder = false
                                    }
                                    .buttonStyle(.bordered)
                                }
                            }
                        } else {
                            Button("Add Folder") {
                                isAddingFolder = true
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
                    .padding(.top, 10)
                }
                .padding()
                .background(PhaseOneSurface.secondary)
                .clipShape(RoundedRectangle(cornerRadius: 8))

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
        .confirmationDialog(
            "Delete Recording?",
            isPresented: $showingDeleteRecordingConfirmation,
            titleVisibility: .visible
        ) {
            if let audioSource {
                Button("Delete Recording", role: .destructive) {
                    Task { await model.deleteRecording(audioSource) }
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("The local audio file will be removed. Any existing transcript or Curated Note stays in this session until you delete the entire session.")
        }
#if os(iOS) && canImport(AVFoundation)
        .onReceive(NotificationCenter.default.publisher(for: AVAudioSession.interruptionNotification)) { _ in
            Task { await recordingModel.handlePlaybackInterruption() }
        }
        .onReceive(NotificationCenter.default.publisher(for: AVAudioSession.routeChangeNotification)) { notification in
            let reasonValue = notification.userInfo?[AVAudioSessionRouteChangeReasonKey] as? UInt
            let reason = AVAudioSession.RouteChangeReason(rawValue: reasonValue ?? 0)
            if reason == .oldDeviceUnavailable {
                Task { await recordingModel.handlePlaybackInterruption() }
            }
        }
#endif
        .onChange(of: scenePhase) { _, phase in
            if phase == .background {
                Task { await recordingModel.handlePlaybackInterruption() }
            }
        }
        .onChange(of: session.title) { _, newTitle in
            title = newTitle
        }
        .onChange(of: session.mode) { _, newMode in
            mode = newMode
        }
        .onChange(of: session.folderID) { _, newFolderID in
            folderID = newFolderID
        }
    }

    private var durationText: String {
        guard let duration = audioSource?.duration else { return "" }
        return " • \(Self.formatTime(duration))"
    }

    private var shouldShowAudioProcessingControls: Bool {
        guard audioSource != nil else { return false }
        if model.isCreatingCuratedNote(for: session.id) { return true }
        if note?.generationStatus == .failed { return true }
        return note == nil
    }

    @ViewBuilder
    private var audioProcessingControls: some View {
        let progress = model.curatedNoteProgress(for: session.id)
        VStack(alignment: .leading, spacing: 12) {
            if model.isCreatingCuratedNote(for: session.id) {
                Text(progress?.status.displayName ?? "Preparing Audio")
                    .font(.headline)
                    .accessibilityIdentifier("curatedNoteProcessingStage")
                if let status = progress?.status, status != .completed {
                    Text("Demo processing uses sample transcript content in this build.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                if let fraction = progress?.fractionCompleted {
                    ProgressView(value: fraction)
                        .accessibilityLabel("Curated Note progress")
                } else {
                    ProgressView()
                        .accessibilityLabel("Curated Note progress")
                }
                Button("Cancel Processing") {
                    model.cancelCuratedNoteProcessing(for: session.id)
                }
                .buttonStyle(.bordered)
                .accessibilityIdentifier("cancelCuratedNoteButton")
            } else if note?.generationStatus == .failed {
                Text(note?.generationError ?? "Transcription failed. The original recording is still available.")
                    .foregroundStyle(.secondary)
                Button("Retry Create Curated Note") {
                    model.retryCuratedNoteProcessing(for: session)
                }
                .buttonStyle(.borderedProminent)
                .accessibilityIdentifier("retryCuratedNoteButton")
            } else if note == nil {
                Button {
                    model.startCuratedNoteProcessing(for: session)
                } label: {
                    Label("Create Curated Note", systemImage: "sparkles")
                }
                .buttonStyle(.borderedProminent)
                .accessibilityIdentifier("createCuratedNoteButton")
            }
        }
        .padding()
        .background(PhaseOneSurface.secondary)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    @ViewBuilder
    private var curatedNoteContent: some View {
        if let note {
            CuratedNoteEditorView(model: model, session: session, note: note)
        } else {
            Text("Create a Curated Note to see generated summary, key points, and suggested actions.")
                .foregroundStyle(.secondary)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(PhaseOneSurface.secondary)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }

    @ViewBuilder
    private var transcriptContent: some View {
        if let note {
            VStack(alignment: .leading, spacing: 12) {
            Text("Generated transcript")
                    .font(.headline)
                Text(providerDisclosure(for: note))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .accessibilityIdentifier("transcriptProviderDisclosure")
                if note.generationStatus == .failed {
                    Text(note.generationError ?? "Transcript unavailable.")
                        .foregroundStyle(.secondary)
                } else if note.transcript.isEmpty {
                    Text("No transcript text was returned.")
                        .foregroundStyle(.secondary)
                } else {
                    Text(note.transcript)
                        .accessibilityIdentifier("transcriptText")
                    if !note.transcriptSegments.isEmpty {
                        ForEach(note.transcriptSegments) { segment in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(Self.segmentTime(segment))
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.secondary)
                                Text(segment.text)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    Button {
                        Task { await model.copy(note.transcript) }
                    } label: {
                        Label("Copy Transcript", systemImage: "doc.on.doc")
                    }
                    .buttonStyle(.bordered)
                    .accessibilityIdentifier("copyTranscriptButton")
                }
            }
            .padding()
            .background(PhaseOneSurface.secondary)
            .clipShape(RoundedRectangle(cornerRadius: 8))
        } else {
            Text("Transcript will appear after you create a Curated Note.")
                .foregroundStyle(.secondary)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(PhaseOneSurface.secondary)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }

    @ViewBuilder
    private var recordingContent: some View {
        if let audioSource {
            VStack(alignment: .leading, spacing: 12) {
                AudioPlaybackView(recordingModel: recordingModel, source: audioSource) {
                    Task { await model.deleteRecording(audioSource) }
                }

                Button("Delete Recording", role: .destructive) {
                    showingDeleteRecordingConfirmation = true
                }
                .buttonStyle(.bordered)
                .accessibilityLabel("Delete Recording")
            }
        } else {
            Text("No local audio recording is attached to this session.")
                .foregroundStyle(.secondary)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(PhaseOneSurface.secondary)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }

    private static func segmentTime(_ segment: TranscriptSegment) -> String {
        guard let start = segment.startTime else { return "Timestamp unavailable" }
        if let end = segment.endTime {
            return "\(formatTime(start)) - \(formatTime(end))"
        }
        return formatTime(start)
    }

    private static func formatTime(_ interval: TimeInterval) -> String {
        let totalSeconds = max(0, Int(interval.rounded()))
        return String(format: "%02d:%02d", totalSeconds / 60, totalSeconds % 60)
    }

    private func providerDisclosure(for note: CuratedNote) -> String {
        if note.promptVersion == "local-demo-mock" {
            return "Demo transcript - this sample content was not generated from your recording."
        }
        return "Transcript generated by the active transcription provider. Review and edit derived notes before relying on them."
    }

    private func shouldShowGeneratedTitleUndo(for note: CuratedNote) -> Bool {
        guard let confirmedTitle = note.confirmedTitle?.trimmingCharacters(in: .whitespacesAndNewlines),
              let suggestedTitle = note.suggestedTitle?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return false
        }
        return !confirmedTitle.isEmpty && confirmedTitle == suggestedTitle && session.title == suggestedTitle
    }
}

private struct CuratedNoteEditorView: View {
    @ObservedObject var model: PhaseOneViewModel
    let session: CaptureSession
    let note: CuratedNote
    @State private var suggestedTitle: String
    @State private var summary: String
    @State private var keyPoints: [String]
    @State private var actionItems: [CuratedActionItem]
    @State private var userNotes: String
    @State private var saveState: SaveState = .idle
    @State private var isSaving = false

    private enum SaveState {
        case idle
        case saving
        case saved
    }

    init(model: PhaseOneViewModel, session: CaptureSession, note: CuratedNote) {
        self.model = model
        self.session = session
        self.note = note
        _suggestedTitle = State(initialValue: note.suggestedTitle ?? "")
        _summary = State(initialValue: note.summary)
        _keyPoints = State(initialValue: note.keyPoints)
        _actionItems = State(initialValue: note.structuredActionItems)
        _userNotes = State(initialValue: note.userNotes)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Curated Note")
                .font(.headline)
            Text(providerDisclosure)
                .font(.caption)
                .foregroundStyle(.secondary)
                .accessibilityIdentifier("curatedNoteProviderDisclosure")

            if note.generationStatus == .failed {
                Text(note.generationError ?? "Curated Note generation failed.")
                    .foregroundStyle(.secondary)
            } else {
                if note.confirmedTitle == nil, note.suggestedTitle != nil {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Suggested title")
                            .font(.subheadline.weight(.semibold))
                        TextField("Suggested title", text: $suggestedTitle)
                            .textFieldStyle(.roundedBorder)
                            .accessibilityIdentifier("suggestedTitleField")
                        HStack {
                            Button("Accept Title") {
                                Task {
                                    await model.acceptSuggestedTitle(for: session, note: note, editedTitle: suggestedTitle)
                                }
                            }
                            .buttonStyle(.borderedProminent)
                            .accessibilityIdentifier("acceptSuggestedTitleButton")
                            Button("Dismiss") {
                                Task { await model.dismissSuggestedTitle(note) }
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text("Summary")
                        .font(.subheadline.weight(.semibold))
                    TextEditor(text: $summary)
                        .frame(minHeight: 96)
                        .padding(6)
                        .background(Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(.secondary.opacity(0.25))
                        )
                        .accessibilityIdentifier("summaryEditor")
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Key Points")
                        .font(.subheadline.weight(.semibold))
                    ForEach(keyPoints.indices, id: \.self) { index in
                        TextEditor(text: Binding(
                            get: { keyPoints[index] },
                            set: { keyPoints[index] = $0 }
                        ))
                        .frame(minHeight: 54)
                        .padding(6)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(.secondary.opacity(0.25))
                        )
                        .accessibilityIdentifier("keyPointEditor-\(index)")
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Suggested Actions")
                        .font(.subheadline.weight(.semibold))
                    if actionItems.isEmpty {
                        Text("No explicit action items were found.")
                            .foregroundStyle(.secondary)
                    }
                    ForEach(actionItems.indices, id: \.self) { index in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack(alignment: .top, spacing: 10) {
                                Button {
                                    actionItems[index].isCompleted.toggle()
                                } label: {
                                    Image(systemName: actionItems[index].isCompleted ? "checkmark.circle.fill" : "circle")
                                        .imageScale(.large)
                                }
                                .buttonStyle(.plain)
                                .accessibilityLabel(actionItems[index].isCompleted ? "Mark action incomplete" : "Mark action complete")
                                .accessibilityValue(actionItems[index].isCompleted ? "Complete" : "Incomplete")
                                TextField("Action item", text: Binding(
                                    get: { actionItems[index].title },
                                    set: { actionItems[index].title = $0 }
                                ))
                                .textFieldStyle(.plain)
                            }
                            Text(actionItems[index].isCompleted ? "Complete" : "Incomplete")
                                .font(.caption.weight(.semibold))
                            if let excerpt = actionItems[index].supportingExcerpt {
                                Text("\(actionItems[index].evidenceState.displayName): \(excerpt)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text("User Notes")
                        .font(.subheadline.weight(.semibold))
                    TextEditor(text: $userNotes)
                        .frame(minHeight: 88)
                        .accessibilityIdentifier("userNotesEditor")
                }

                HStack(spacing: 10) {
                    Button(saveButtonTitle) {
                        guard !isSaving else { return }
                        Task { @MainActor in
                            isSaving = true
                            saveState = .saving
                            await model.saveCuratedNoteEdits(
                                note,
                                summary: summary,
                                keyPoints: keyPoints.filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty },
                                actionItems: actionItems.filter { !$0.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty },
                                userNotes: userNotes
                            )
                            saveState = .saved
                            isSaving = false
#if canImport(UIKit)
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
#endif
                            try? await Task.sleep(nanoseconds: 3_000_000_000)
                            if saveState == .saved {
                                saveState = .idle
                            }
                        }
                    }
                    .buttonStyle(.bordered)
                    .disabled(isSaving)
                    .accessibilityLabel(saveButtonTitle)
                    .accessibilityIdentifier("saveCuratedNoteButton")

                    if didRecentlySave {
                        Text("Saved")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.secondary)
                            .accessibilityIdentifier("curatedNoteSaveConfirmation")
                    }
                }
            }
        }
        .padding()
        .background(PhaseOneSurface.secondary)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private var providerDisclosure: String {
        if note.promptVersion == "local-demo-mock" {
            return "Demo Curated Note - this sample content was not generated from your recording."
        }
        return "Generated from the transcript. Edit before using."
    }

    private var didRecentlySave: Bool {
        saveState == .saved || model.recentlySavedCuratedNoteID == note.id
    }

    private var saveButtonTitle: String {
        switch saveState {
        case .idle:
            "Save Curated Note"
        case .saving:
            "Saving"
        case .saved:
            "Saved"
        }
    }
}

private extension CuratedNoteGenerationStatus {
    var displayName: String {
        switch self {
        case .notStarted:
            "Not Started"
        case .preparing:
            "Preparing Audio"
        case .transcribing:
            "Transcribing"
        case .buildingCuratedNote:
            "Building Curated Note"
        case .completed:
            "Ready"
        case .failed:
            "Failed"
        case .cancelled:
            "Cancelled"
        }
    }
}

private extension ActionEvidenceState {
    var displayName: String {
        switch self {
        case .explicit:
            "Explicit"
        case .stronglySupported:
            "Strongly supported"
        case .uncertain:
            "Uncertain"
        }
    }
}
