import Foundation
import SwiftUI

@MainActor
public final class PhaseOneViewModel: ObservableObject {
    @Published public var sessions: [CaptureSession] = []
    @Published public var folders: [Folder] = []
    @Published public var draftSession: CaptureSession?
    @Published public var selectedSession: CaptureSession?
    @Published public var showingImporter = false
    @Published public var newFolderName = ""
    @Published public var setupTitle = ""
    @Published public var setupMode: CaptureMode = .create
    @Published public var setupFolderID: UUID?
    @Published public var setupProcessingMode: ProcessingMode = .smart
    @Published public var activeStage: PhaseOneProcessingStage?
    @Published public var completedStages: Set<PhaseOneProcessingStage> = []
    @Published public var errorMessage = ""
    @Published public var shareItem: ShareItem?
    @Published public var showingAudioRecorder = false

    private var notesBySessionID: [UUID: CuratedNote] = [:]
    private var outputsBySessionID: [UUID: [GeneratedOutput]] = [:]
    private var sourcesBySessionID: [UUID: [CaptureSource]] = [:]
    private var didLoad = false
    private let container: DependencyContainer
    private let isUITesting: Bool
    private let shouldResetOnLoad: Bool

    public var showingError: Binding<Bool> {
        Binding(
            get: { !self.errorMessage.isEmpty },
            set: { if !$0 { self.errorMessage = "" } }
        )
    }

    public init(container: DependencyContainer, arguments: [String] = ProcessInfo.processInfo.arguments) {
        self.container = container
        self.isUITesting = arguments.contains("-ui-testing")
        self.shouldResetOnLoad = arguments.contains("-reset-phase1-store")
    }

    public func loadIfNeeded() async {
        guard !didLoad else { return }
        didLoad = true
        if shouldResetOnLoad {
            try? await container.libraryMaintenance?.reset()
        }
        await refreshPublishedState()
    }

    public func importVideoTapped() {
        if isUITesting {
            Task { await importUITestVideo() }
        } else {
            showingImporter = true
        }
    }

    public func handleImportResult(_ result: Result<[URL], Error>) async {
        do {
            guard let url = try result.get().first else { return }
            try await importVideo(url)
        } catch {
            errorMessage = "The video could not be imported."
        }
    }

    public func addFolder() async {
        let trimmed = newFolderName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        try? await container.folders.save(Folder(name: trimmed))
        newFolderName = ""
        await refreshPublishedState()
    }

    public func startProcessing() async {
        guard var session = draftSession else { return }
        session.title = setupTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? session.title : setupTitle
        session.mode = setupMode
        session.folderID = setupFolderID
        session.processingMode = setupProcessingMode
        session.status = .processing
        session.updatedAt = Date()
        draftSession = nil
        selectedSession = session

        do {
            try await container.sessions.save(session)
            await refreshPublishedState()
            let sources = try await container.sources.fetchSources(for: session.id)
            let result = try await container.processing.processCreatorPack(session: session, sources: sources) { [weak self] stage in
                self?.mark(stage)
            }

            var completedSession = session
            completedSession.status = .completed
            completedSession.updatedAt = Date()
            try await container.sessions.save(completedSession)
            try await container.curatedNotes.save(result.note)
            try await container.outputPacks.save(result.pack)
            for output in result.outputs {
                try await container.generatedOutputs.save(output)
            }
            selectedSession = completedSession
            activeStage = nil
            await refreshPublishedState()
        } catch {
            session.status = .failed
            session.updatedAt = Date()
            try? await container.sessions.save(session)
            activeStage = nil
            selectedSession = session
            errorMessage = "Mock processing failed. Your imported video remains in the local library."
            await refreshPublishedState()
        }
    }

    public func cancelDraft() async {
        guard var session = draftSession else { return }
        session.status = .cancelled
        session.updatedAt = Date()
        try? await container.sessions.save(session)
        draftSession = nil
        selectedSession = nil
        await refreshPublishedState()
    }

    public func toggleFavorite(_ session: CaptureSession) async {
        var updated = session
        updated.isFavorite.toggle()
        updated.updatedAt = Date()
        do {
            try await container.sessions.save(updated)
            if updated.isFavorite {
                try await container.favorites.save(Favorite(sessionID: updated.id))
            } else {
                try await container.favorites.delete(sessionID: updated.id)
            }
            selectedSession = updated
            await refreshPublishedState()
        } catch {
            errorMessage = "Favorite could not be updated."
        }
    }

    public func note(for sessionID: UUID) -> CuratedNote? {
        notesBySessionID[sessionID]
    }

    public func instagramCaption(for sessionID: UUID) -> GeneratedOutput? {
        outputsBySessionID[sessionID]?.first { $0.outputType == .creatorPack }
    }

    public func sources(for sessionID: UUID) -> [CaptureSource] {
        sourcesBySessionID[sessionID, default: []]
    }

    public func audioSource(for sessionID: UUID) -> CaptureSource? {
        sources(for: sessionID).first { $0.sourceType == .liveAudio || $0.sourceType == .uploadedAudio }
    }

    public func saveSessionMetadata(
        _ session: CaptureSession,
        title: String,
        mode: CaptureMode,
        folderID: UUID?,
        processingMode: ProcessingMode
    ) async {
        var updated = session
        updated.title = title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? session.title : title
        updated.mode = mode
        updated.folderID = folderID
        updated.processingMode = processingMode
        updated.updatedAt = Date()
        do {
            try await container.sessions.save(updated)
            selectedSession = updated
            await refreshPublishedState()
        } catch {
            errorMessage = "Session changes could not be saved."
        }
    }

    public func deleteRecording(_ source: CaptureSource) async {
        do {
            if let url = source.sourceURL {
                try await container.mediaStorage.deleteMedia(at: url)
            }
            try await container.sources.deleteSource(id: source.id)
            await refreshPublishedState()
        } catch {
            errorMessage = "The recording could not be deleted."
        }
    }

    public func deleteSession(_ session: CaptureSession) async {
        do {
            for source in try await container.sources.fetchSources(for: session.id) {
                if let url = source.sourceURL {
                    try await container.mediaStorage.deleteMedia(at: url)
                }
            }
            try await container.sources.deleteSources(for: session.id)
            try await container.sessions.delete(id: session.id)
            selectedSession = nil
            await refreshPublishedState()
        } catch {
            errorMessage = "The session could not be deleted."
        }
    }

    public func refreshLibrary() async {
        await refreshPublishedState()
    }

    public func copy(_ text: String) async {
        await container.quickSend.copy(text)
    }

    public func copyAndOpenInstagram(_ text: String) async {
        let result = await container.quickSend.copyAndOpenInstagram(text)
        if result.shouldPresentShareSheet {
            shareItem = ShareItem(text: text)
        }
    }

    public func importVideoForTesting(_ url: URL) async {
        do {
            try await importVideo(url)
        } catch {
            errorMessage = "The video could not be imported."
        }
    }

    public func reloadForTesting() async {
        didLoad = false
        await loadIfNeeded()
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

        let title = url.deletingPathExtension().lastPathComponent.isEmpty ? "Imported Video" : url.deletingPathExtension().lastPathComponent
        let session = CaptureSession(title: title, mode: .create, status: .draft)
        let storedMedia = try await container.mediaStorage.copyImportedVideo(for: session.id, from: url)
        let source = CaptureSource(
            sessionID: session.id,
            sourceType: .uploadedVideo,
            localIdentifier: storedMedia.url.path,
            originalFilename: storedMedia.originalFilename,
            mimeType: storedMedia.mimeType,
            sourceURL: storedMedia.url,
            transcriptOrigin: .unavailable
        )

        try await container.sessions.save(session)
        try await container.sources.save(source)
        draftSession = session
        setupTitle = session.title
        setupMode = .create
        setupFolderID = folders.first?.id
        setupProcessingMode = .smart
        await refreshPublishedState(keepDraft: session)
    }

    private func mark(_ stage: PhaseOneProcessingStage) {
        activeStage = stage
        completedStages.insert(stage)
    }

    private func isSupportedVideo(_ url: URL) -> Bool {
        ["mov", "mp4", "m4v"].contains(url.pathExtension.lowercased())
    }

    private func refreshPublishedState(keepDraft: CaptureSession? = nil) async {
        do {
            sessions = try await container.sessions.fetchAll().sorted { $0.updatedAt > $1.updatedAt }
            folders = try await container.folders.fetchAll().sorted { $0.name < $1.name }
            notesBySessionID = [:]
            outputsBySessionID = [:]
            sourcesBySessionID = [:]
            for session in sessions {
                notesBySessionID[session.id] = try await container.curatedNotes.fetchNote(for: session.id)
                outputsBySessionID[session.id] = try await container.generatedOutputs.fetchOutputs(for: session.id)
                sourcesBySessionID[session.id] = try await container.sources.fetchSources(for: session.id)
            }
            if let selectedID = selectedSession?.id {
                selectedSession = sessions.first { $0.id == selectedID }
            }
            if let keepDraft {
                draftSession = keepDraft
            }
        } catch {
            errorMessage = "The local library could not be loaded."
        }
    }
}
