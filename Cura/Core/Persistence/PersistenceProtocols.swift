import Foundation

public protocol CaptureSessionRepository: Sendable {
    func save(_ session: CaptureSession) async throws
    func fetchAll() async throws -> [CaptureSession]
    func fetch(id: UUID) async throws -> CaptureSession?
}

public protocol CaptureSourceRepository: Sendable {
    func save(_ source: CaptureSource) async throws
    func fetchSources(for sessionID: UUID) async throws -> [CaptureSource]
}

public protocol FolderRepository: Sendable {
    func save(_ folder: Folder) async throws
    func fetchAll() async throws -> [Folder]
}

public protocol TagRepository: Sendable {
    func save(_ tag: Tag) async throws
    func fetchAll() async throws -> [Tag]
}

public protocol FavoriteRepository: Sendable {
    func save(_ favorite: Favorite) async throws
    func delete(sessionID: UUID) async throws
    func fetchAll() async throws -> [Favorite]
    func fetch(sessionID: UUID) async throws -> Favorite?
}

public protocol CuratedNoteRepository: Sendable {
    func save(_ note: CuratedNote) async throws
    func fetchNote(for sessionID: UUID) async throws -> CuratedNote?
}

public protocol OutputPackRepository: Sendable {
    func save(_ pack: OutputPack) async throws
    func fetchPacks(for sessionID: UUID) async throws -> [OutputPack]
}

public protocol GeneratedOutputRepository: Sendable {
    func save(_ output: GeneratedOutput) async throws
    func fetchOutputs(for sessionID: UUID) async throws -> [GeneratedOutput]
}

public struct StoredMediaFile: Equatable, Sendable {
    public var url: URL
    public var originalFilename: String
    public var mimeType: String

    public init(url: URL, originalFilename: String, mimeType: String) {
        self.url = url
        self.originalFilename = originalFilename
        self.mimeType = mimeType
    }
}

public protocol MediaFileStorage: Sendable {
    func copyImportedVideo(for sessionID: UUID, from sourceURL: URL) async throws -> StoredMediaFile
}

public protocol LocalLibraryMaintenance: Sendable {
    func reset() async throws
}

public struct CaptureLibrarySnapshot: Codable, Equatable, Sendable {
    public var sessions: [CaptureSession]
    public var sources: [CaptureSource]
    public var folders: [Folder]
    public var favorites: [Favorite]
    public var curatedNotes: [CuratedNote]
    public var outputPacks: [OutputPack]
    public var generatedOutputs: [GeneratedOutput]

    public init(
        sessions: [CaptureSession] = [],
        sources: [CaptureSource] = [],
        folders: [Folder] = [],
        favorites: [Favorite] = [],
        curatedNotes: [CuratedNote] = [],
        outputPacks: [OutputPack] = [],
        generatedOutputs: [GeneratedOutput] = []
    ) {
        self.sessions = sessions
        self.sources = sources
        self.folders = folders
        self.favorites = favorites
        self.curatedNotes = curatedNotes
        self.outputPacks = outputPacks
        self.generatedOutputs = generatedOutputs
    }
}

public actor JSONLocalLibraryStore:
    CaptureSessionRepository,
    CaptureSourceRepository,
    FolderRepository,
    FavoriteRepository,
    CuratedNoteRepository,
    OutputPackRepository,
    GeneratedOutputRepository,
    MediaFileStorage,
    LocalLibraryMaintenance
{
    public let rootDirectory: URL
    public let storeURL: URL

    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    public init(rootDirectory: URL) {
        self.rootDirectory = rootDirectory
        self.storeURL = rootDirectory.appendingPathComponent("library.json")
        self.encoder = JSONEncoder()
        self.decoder = JSONDecoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        decoder.dateDecodingStrategy = .iso8601
    }

    public func load() async throws -> CaptureLibrarySnapshot {
        guard FileManager.default.fileExists(atPath: storeURL.path) else {
            return CaptureLibrarySnapshot()
        }

        let data = try Data(contentsOf: storeURL)
        return try decoder.decode(CaptureLibrarySnapshot.self, from: data)
    }

    public func save(_ snapshot: CaptureLibrarySnapshot) async throws {
        try FileManager.default.createDirectory(at: rootDirectory, withIntermediateDirectories: true)
        let data = try encoder.encode(snapshot)
        try data.write(to: storeURL, options: [.atomic])
    }

    public func reset() async throws {
        if FileManager.default.fileExists(atPath: rootDirectory.path) {
            try FileManager.default.removeItem(at: rootDirectory)
        }
    }

    public func mediaDirectory(for sessionID: UUID) throws -> URL {
        let directory = rootDirectory
            .appendingPathComponent("Media")
            .appendingPathComponent(sessionID.uuidString)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        return directory
    }

    public func save(_ session: CaptureSession) async throws {
        var snapshot = try await load()
        snapshot.sessions.removeAll { $0.id == session.id }
        snapshot.sessions.append(session)
        try await save(snapshot)
    }

    public func fetchAll() async throws -> [CaptureSession] {
        try await load().sessions.sorted { $0.updatedAt > $1.updatedAt }
    }

    public func fetch(id: UUID) async throws -> CaptureSession? {
        try await load().sessions.first { $0.id == id }
    }

    public func save(_ source: CaptureSource) async throws {
        var snapshot = try await load()
        snapshot.sources.removeAll { $0.id == source.id }
        snapshot.sources.append(source)
        try await save(snapshot)
    }

    public func fetchSources(for sessionID: UUID) async throws -> [CaptureSource] {
        try await load().sources.filter { $0.sessionID == sessionID }
    }

    public func save(_ folder: Folder) async throws {
        var snapshot = try await load()
        snapshot.folders.removeAll { $0.id == folder.id }
        snapshot.folders.append(folder)
        try await save(snapshot)
    }

    public func fetchAll() async throws -> [Folder] {
        try await load().folders.sorted { $0.name < $1.name }
    }

    public func save(_ favorite: Favorite) async throws {
        var snapshot = try await load()
        snapshot.favorites.removeAll { $0.sessionID == favorite.sessionID }
        snapshot.favorites.append(favorite)
        try await save(snapshot)
    }

    public func delete(sessionID: UUID) async throws {
        var snapshot = try await load()
        snapshot.favorites.removeAll { $0.sessionID == sessionID }
        try await save(snapshot)
    }

    public func fetchAll() async throws -> [Favorite] {
        try await load().favorites.sorted { $0.createdAt > $1.createdAt }
    }

    public func fetch(sessionID: UUID) async throws -> Favorite? {
        try await load().favorites.first { $0.sessionID == sessionID }
    }

    public func save(_ note: CuratedNote) async throws {
        var snapshot = try await load()
        snapshot.curatedNotes.removeAll { $0.sessionID == note.sessionID }
        snapshot.curatedNotes.append(note)
        try await save(snapshot)
    }

    public func fetchNote(for sessionID: UUID) async throws -> CuratedNote? {
        try await load().curatedNotes.first { $0.sessionID == sessionID }
    }

    public func save(_ pack: OutputPack) async throws {
        var snapshot = try await load()
        snapshot.outputPacks.removeAll { $0.sessionID == pack.sessionID && $0.packKey == pack.packKey }
        snapshot.outputPacks.append(pack)
        try await save(snapshot)
    }

    public func fetchPacks(for sessionID: UUID) async throws -> [OutputPack] {
        try await load().outputPacks.filter { $0.sessionID == sessionID }
    }

    public func save(_ output: GeneratedOutput) async throws {
        var snapshot = try await load()
        snapshot.generatedOutputs.removeAll { $0.id == output.id }
        snapshot.generatedOutputs.append(output)
        try await save(snapshot)
    }

    public func fetchOutputs(for sessionID: UUID) async throws -> [GeneratedOutput] {
        try await load().generatedOutputs.filter { $0.sessionID == sessionID }
    }

    public func copyImportedVideo(for sessionID: UUID, from sourceURL: URL) async throws -> StoredMediaFile {
        let didStartAccessing = sourceURL.startAccessingSecurityScopedResource()
        defer {
            if didStartAccessing {
                sourceURL.stopAccessingSecurityScopedResource()
            }
        }

        let directory = try mediaDirectory(for: sessionID)
        let destination = directory.appendingPathComponent(sourceURL.lastPathComponent)
        if FileManager.default.fileExists(atPath: destination.path) {
            try FileManager.default.removeItem(at: destination)
        }
        try FileManager.default.copyItem(at: sourceURL, to: destination)

        return StoredMediaFile(
            url: destination,
            originalFilename: sourceURL.lastPathComponent,
            mimeType: "video/quicktime"
        )
    }
}

public actor InMemoryCaptureSessionRepository: CaptureSessionRepository {
    private var sessions: [UUID: CaptureSession] = [:]

    public init(seed: [CaptureSession] = []) {
        for session in seed {
            sessions[session.id] = session
        }
    }

    public func save(_ session: CaptureSession) async throws {
        sessions[session.id] = session
    }

    public func fetchAll() async throws -> [CaptureSession] {
        sessions.values.sorted { $0.createdAt > $1.createdAt }
    }

    public func fetch(id: UUID) async throws -> CaptureSession? {
        sessions[id]
    }
}

public actor InMemoryCaptureSourceRepository: CaptureSourceRepository {
    private var sources: [UUID: [CaptureSource]] = [:]

    public init() {}

    public func save(_ source: CaptureSource) async throws {
        var sessionSources = sources[source.sessionID, default: []]
        sessionSources.removeAll { $0.id == source.id }
        sessionSources.append(source)
        sources[source.sessionID] = sessionSources
    }

    public func fetchSources(for sessionID: UUID) async throws -> [CaptureSource] {
        sources[sessionID, default: []]
    }
}

public actor InMemoryFolderRepository: FolderRepository {
    private var folders: [UUID: Folder] = [:]

    public init() {}

    public func save(_ folder: Folder) async throws {
        folders[folder.id] = folder
    }

    public func fetchAll() async throws -> [Folder] {
        folders.values.sorted { $0.name < $1.name }
    }
}

public actor InMemoryTagRepository: TagRepository {
    private var tags: [UUID: Tag] = [:]

    public init() {}

    public func save(_ tag: Tag) async throws {
        tags[tag.id] = tag
    }

    public func fetchAll() async throws -> [Tag] {
        tags.values.sorted { $0.name < $1.name }
    }
}

public actor InMemoryFavoriteRepository: FavoriteRepository {
    private var favorites: [UUID: Favorite] = [:]

    public init() {}

    public func save(_ favorite: Favorite) async throws {
        favorites[favorite.sessionID] = favorite
    }

    public func delete(sessionID: UUID) async throws {
        favorites.removeValue(forKey: sessionID)
    }

    public func fetchAll() async throws -> [Favorite] {
        favorites.values.sorted { $0.createdAt > $1.createdAt }
    }

    public func fetch(sessionID: UUID) async throws -> Favorite? {
        favorites[sessionID]
    }
}

public actor InMemoryCuratedNoteRepository: CuratedNoteRepository {
    private var notes: [UUID: CuratedNote] = [:]

    public init() {}

    public func save(_ note: CuratedNote) async throws {
        notes[note.sessionID] = note
    }

    public func fetchNote(for sessionID: UUID) async throws -> CuratedNote? {
        notes[sessionID]
    }
}

public actor InMemoryOutputPackRepository: OutputPackRepository {
    private var packs: [UUID: [OutputPack]] = [:]

    public init() {}

    public func save(_ pack: OutputPack) async throws {
        var sessionPacks = packs[pack.sessionID, default: []]
        sessionPacks.removeAll { $0.packKey == pack.packKey }
        sessionPacks.append(pack)
        packs[pack.sessionID] = sessionPacks
    }

    public func fetchPacks(for sessionID: UUID) async throws -> [OutputPack] {
        packs[sessionID, default: []]
    }
}

public actor InMemoryGeneratedOutputRepository: GeneratedOutputRepository {
    private var outputs: [UUID: [GeneratedOutput]] = [:]

    public init() {}

    public func save(_ output: GeneratedOutput) async throws {
        var sessionOutputs = outputs[output.sessionID, default: []]
        sessionOutputs.removeAll { $0.id == output.id }
        sessionOutputs.append(output)
        outputs[output.sessionID] = sessionOutputs
    }

    public func fetchOutputs(for sessionID: UUID) async throws -> [GeneratedOutput] {
        outputs[sessionID, default: []]
    }
}

public actor InMemoryMediaFileStorage: MediaFileStorage, LocalLibraryMaintenance {
    private let rootDirectory: URL

    public init(rootDirectory: URL = FileManager.default.temporaryDirectory.appendingPathComponent("cura-in-memory-media")) {
        self.rootDirectory = rootDirectory.appendingPathComponent(UUID().uuidString)
    }

    public func copyImportedVideo(for sessionID: UUID, from sourceURL: URL) async throws -> StoredMediaFile {
        let directory = rootDirectory
            .appendingPathComponent("Media")
            .appendingPathComponent(sessionID.uuidString)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        let destination = directory.appendingPathComponent(sourceURL.lastPathComponent)
        if FileManager.default.fileExists(atPath: destination.path) {
            try FileManager.default.removeItem(at: destination)
        }
        try FileManager.default.copyItem(at: sourceURL, to: destination)
        return StoredMediaFile(url: destination, originalFilename: sourceURL.lastPathComponent, mimeType: "video/quicktime")
    }

    public func reset() async throws {
        if FileManager.default.fileExists(atPath: rootDirectory.path) {
            try FileManager.default.removeItem(at: rootDirectory)
        }
    }
}
