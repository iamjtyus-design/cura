import SwiftUI
import UniformTypeIdentifiers
import CuraCore
#if canImport(UIKit)
import UIKit
#endif

struct ContentView: View {
    let container: DependencyContainer
    @StateObject private var model = PhaseOneViewModel()

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

private struct HomeView: View {
    @ObservedObject var model: PhaseOneViewModel

    var body: some View {
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

private struct FolderComposer: View {
    @ObservedObject var model: PhaseOneViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Folders")
                .font(.headline)
            HStack {
                TextField("New folder", text: $model.newFolderName)
                    .textFieldStyle(.roundedBorder)
                    .accessibilityLabel("New folder name")
                Button("Add") {
                    Task { await model.addFolder() }
                }
                .disabled(model.newFolderName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .accessibilityLabel("Add Folder")
            }
            if !model.folders.isEmpty {
                Text(model.folders.map(\.name).joined(separator: ", "))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .accessibilityLabel("Folders: \(model.folders.map(\.name).joined(separator: ", "))")
            }
        }
    }
}

private struct SessionRow: View {
    @ObservedObject var model: PhaseOneViewModel
    let session: CaptureSession

    var body: some View {
        Button {
            model.selectedSession = session
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(session.title)
                        .font(.headline)
                    Text("\(session.mode.displayName) • \(session.status.displayName)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: session.isFavorite ? "star.fill" : "star")
                    .foregroundStyle(session.isFavorite ? Color.yellow : Color.secondary)
                    .accessibilityHidden(true)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .padding()
        .background(PhaseOneSurface.secondary)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .accessibilityLabel("\(session.title), \(session.status.displayName)")
    }
}

private struct SessionSetupView: View {
    @ObservedObject var model: PhaseOneViewModel
    let session: CaptureSession

    var body: some View {
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

private struct SessionDetailView: View {
    @ObservedObject var model: PhaseOneViewModel
    let session: CaptureSession

    var note: CuratedNote? { model.note(for: session.id) }
    var caption: GeneratedOutput? { model.instagramCaption(for: session.id) }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(session.title)
                            .font(.title2.weight(.semibold))
                            .accessibilityIdentifier("sessionTitle")
                        Text("\(session.mode.displayName) • \(session.processingMode.displayName)")
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

                ProcessingStagesView(model: model)

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
                                model.copy(caption.content)
                            } label: {
                                Label("Copy", systemImage: "doc.on.doc")
                            }
                            .buttonStyle(.bordered)
                            .accessibilityIdentifier("copyCaptionButton")

                            Button {
                                model.copyAndOpenInstagram(caption.content)
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
            }
            .padding()
        }
        .navigationTitle("Session")
    }
}

private struct ProcessingStagesView: View {
    @ObservedObject var model: PhaseOneViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Processing")
                .font(.headline)
            ForEach(PhaseOneProcessingStage.allCases) { stage in
                HStack {
                    Image(systemName: model.completedStages.contains(stage) ? "checkmark.circle.fill" : "circle")
                    Text(stage.title)
                    Spacer()
                    if model.activeStage == stage {
                        ProgressView()
                            .accessibilityLabel("\(stage.title) in progress")
                    }
                }
                .accessibilityIdentifier("stage-\(stage.rawValue)")
            }
        }
        .padding()
        .background(PhaseOneSurface.secondary)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#if canImport(UIKit)
private struct ActivityView: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
#endif

private struct ShareItem: Identifiable {
    let id = UUID()
    let text: String
}

private enum PhaseOneSurface {
    static let secondary = Color.secondary.opacity(0.12)
}

private enum PhaseOneProcessingStage: String, CaseIterable, Identifiable {
    case preparing
    case readingVideo
    case buildingCuratedNote
    case creatingCreatorPack

    var id: String { rawValue }

    var title: String {
        switch self {
        case .preparing:
            return "Preparing"
        case .readingVideo:
            return "Reading Video"
        case .buildingCuratedNote:
            return "Building Curated Note"
        case .creatingCreatorPack:
            return "Creating Creator Pack"
        }
    }
}

@MainActor
private final class PhaseOneViewModel: ObservableObject {
    @Published var sessions: [CaptureSession] = []
    @Published var folders: [Folder] = []
    @Published var draftSession: CaptureSession?
    @Published var selectedSession: CaptureSession?
    @Published var showingImporter = false
    @Published var newFolderName = ""
    @Published var setupTitle = ""
    @Published var setupMode: CaptureMode = .create
    @Published var setupFolderID: UUID?
    @Published var setupProcessingMode: ProcessingMode = .smart
    @Published var activeStage: PhaseOneProcessingStage?
    @Published var completedStages: Set<PhaseOneProcessingStage> = []
    @Published var errorMessage = ""
    @Published var shareItem: ShareItem?

    private var snapshot = CaptureLibrarySnapshot()
    private var didLoad = false
    private let store: JSONLocalLibraryStore
    private let isUITesting = ProcessInfo.processInfo.arguments.contains("-ui-testing")

    var showingError: Binding<Bool> {
        Binding(
            get: { !self.errorMessage.isEmpty },
            set: { if !$0 { self.errorMessage = "" } }
        )
    }

    init() {
        let root = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("CURA")
        self.store = JSONLocalLibraryStore(rootDirectory: root)
    }

    func loadIfNeeded() async {
        guard !didLoad else { return }
        didLoad = true

        do {
            if ProcessInfo.processInfo.arguments.contains("-reset-phase1-store") {
                try await store.reset()
            }
            snapshot = try await store.load()
            refreshPublishedState()
        } catch {
            errorMessage = "The local library could not be loaded."
        }
    }

    func importVideoTapped() {
        if isUITesting {
            Task { await importUITestVideo() }
        } else {
            showingImporter = true
        }
    }

    func handleImportResult(_ result: Result<[URL], Error>) async {
        do {
            guard let url = try result.get().first else { return }
            try await importVideo(url)
        } catch {
            errorMessage = "The video could not be imported."
        }
    }

    func addFolder() async {
        let trimmed = newFolderName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        snapshot.folders.append(Folder(name: trimmed))
        newFolderName = ""
        await persistAndRefresh()
    }

    func startProcessing() async {
        guard var session = draftSession else { return }
        session.title = setupTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? session.title : setupTitle
        session.mode = setupMode
        session.folderID = setupFolderID
        session.processingMode = setupProcessingMode
        session.status = .processing
        upsert(session)
        draftSession = nil
        selectedSession = session
        await persistAndRefresh()

        do {
            try await runMockProcessing(for: session)
        } catch {
            session.status = .failed
            upsert(session)
            errorMessage = "Mock processing failed. Your imported video remains in the local library."
            await persistAndRefresh()
        }
    }

    func cancelDraft() async {
        guard var session = draftSession else { return }
        session.status = .cancelled
        upsert(session)
        draftSession = nil
        selectedSession = nil
        await persistAndRefresh()
    }

    func toggleFavorite(_ session: CaptureSession) async {
        var updated = session
        updated.isFavorite.toggle()
        upsert(updated)
        if updated.isFavorite {
            if !snapshot.favorites.contains(where: { $0.sessionID == updated.id }) {
                snapshot.favorites.append(Favorite(sessionID: updated.id))
            }
        } else {
            snapshot.favorites.removeAll { $0.sessionID == updated.id }
        }
        selectedSession = updated
        await persistAndRefresh()
    }

    func note(for sessionID: UUID) -> CuratedNote? {
        snapshot.curatedNotes.first { $0.sessionID == sessionID }
    }

    func instagramCaption(for sessionID: UUID) -> GeneratedOutput? {
        snapshot.generatedOutputs.first { $0.sessionID == sessionID && $0.outputType == .creatorPack }
    }

    func copy(_ text: String) {
#if canImport(UIKit)
        UIPasteboard.general.string = text
#endif
    }

    func copyAndOpenInstagram(_ text: String) {
#if canImport(UIKit)
        UIPasteboard.general.string = text
        guard let url = URL(string: "instagram://app") else {
            shareItem = ShareItem(text: text)
            return
        }
        UIApplication.shared.open(url, options: [:]) { [weak self] success in
            if !success {
                Task { @MainActor in
                    self?.shareItem = ShareItem(text: text)
                }
            }
        }
#else
        shareItem = ShareItem(text: text)
#endif
    }

    private func importUITestVideo() async {
        do {
            let source = FileManager.default.temporaryDirectory.appendingPathComponent("cura-ui-test-video.mov")
            if !FileManager.default.fileExists(atPath: source.path) {
                try Data("mock video".utf8).write(to: source)
            }
            try await importVideo(source)
        } catch {
            errorMessage = "The UI test video could not be imported."
        }
    }

    private func importVideo(_ url: URL) async throws {
        guard isSupportedVideo(url) else {
            errorMessage = "Choose a supported video file."
            return
        }

        let didStartAccessing = url.startAccessingSecurityScopedResource()
        defer {
            if didStartAccessing {
                url.stopAccessingSecurityScopedResource()
            }
        }

        let title = url.deletingPathExtension().lastPathComponent.isEmpty ? "Imported Video" : url.deletingPathExtension().lastPathComponent
        let session = CaptureSession(title: title, mode: .create, status: .draft)
        let directory = try await store.mediaDirectory(for: session.id)
        let destination = directory.appendingPathComponent(url.lastPathComponent)
        if FileManager.default.fileExists(atPath: destination.path) {
            try FileManager.default.removeItem(at: destination)
        }
        try FileManager.default.copyItem(at: url, to: destination)

        let source = CaptureSource(
            sessionID: session.id,
            sourceType: .uploadedVideo,
            localIdentifier: destination.path,
            originalFilename: url.lastPathComponent,
            mimeType: "video/quicktime",
            sourceURL: destination,
            transcriptOrigin: .unavailable
        )
        snapshot.sessions.append(session)
        snapshot.sources.append(source)
        draftSession = session
        setupTitle = session.title
        setupMode = .create
        setupFolderID = folders.first?.id
        setupProcessingMode = .smart
        await persistAndRefresh(keepDraft: session)
    }

    private func runMockProcessing(for initialSession: CaptureSession) async throws {
        completedStages = []
        for stage in PhaseOneProcessingStage.allCases {
            activeStage = stage
            try await Task.sleep(nanoseconds: isUITesting ? 10_000_000 : 450_000_000)
            completedStages.insert(stage)
        }
        activeStage = nil

        var session = initialSession
        session.status = .completed
        session.updatedAt = Date()
        upsert(session)

        let note = CuratedNote(
            sessionID: session.id,
            title: session.title,
            smartSummary: "CURA reviewed the imported video locally and prepared a mock Creator Pack.",
            detailedSummary: "This Phase 1 result is generated by a local mock processor. No live AI, Supabase, RevenueCat, authentication, or paid service was used.",
            keyIdeas: ["Imported video preserved locally", "Creator Pack prepared", "Ready for explicit copy or share"],
            quotes: ["Nothing is published without your approval."],
            tags: ["video", "creator-pack", "mock"],
            confidence: 1.0
        )
        let caption = GeneratedOutput(
            sessionID: session.id,
            curatedNoteID: note.id,
            outputType: .creatorPack,
            mode: .create,
            packKey: "creator",
            content: "Captured this moment and turned it into momentum. CURA pulled the key idea from the video and shaped it into a caption I can use next. #CURA #VisionBuilt",
            promptVersion: "mock-phase-1",
            model: "local-mock"
        )
        let pack = OutputPack(
            sessionID: session.id,
            curatedNoteID: note.id,
            packKey: "creator",
            mode: .create,
            outputs: [caption]
        )

        snapshot.curatedNotes.removeAll { $0.sessionID == session.id }
        snapshot.generatedOutputs.removeAll { $0.sessionID == session.id }
        snapshot.outputPacks.removeAll { $0.sessionID == session.id }
        snapshot.curatedNotes.append(note)
        snapshot.generatedOutputs.append(caption)
        snapshot.outputPacks.append(pack)
        selectedSession = session
        await persistAndRefresh()
    }

    private func isSupportedVideo(_ url: URL) -> Bool {
        ["mov", "mp4", "m4v"].contains(url.pathExtension.lowercased())
    }

    private func upsert(_ session: CaptureSession) {
        snapshot.sessions.removeAll { $0.id == session.id }
        snapshot.sessions.append(session)
    }

    private func persistAndRefresh(keepDraft: CaptureSession? = nil) async {
        do {
            try await store.save(snapshot)
            refreshPublishedState()
            if let keepDraft {
                draftSession = keepDraft
            }
        } catch {
            errorMessage = "The local library could not be saved."
        }
    }

    private func refreshPublishedState() {
        sessions = snapshot.sessions.sorted { $0.updatedAt > $1.updatedAt }
        folders = snapshot.folders.sorted { $0.name < $1.name }
        if let selectedID = selectedSession?.id {
            selectedSession = sessions.first { $0.id == selectedID }
        }
    }
}

private extension CaptureMode {
    var displayName: String {
        rawValue.capitalized
    }
}

private extension CaptureSessionStatus {
    var displayName: String {
        switch self {
        case .partiallyCompleted:
            return "Partially Complete"
        default:
            return rawValue.capitalized
        }
    }
}

private extension ProcessingMode {
    var displayName: String {
        switch self {
        case .private:
            return "Private"
        case .smart:
            return "Smart"
        case .futureSync:
            return "Future Sync"
        }
    }
}
