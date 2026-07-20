import Foundation

public protocol CaptureSessionRepository: Sendable {
    func save(_ session: CaptureSession) async throws
    func fetchAll() async throws -> [CaptureSession]
    func fetch(id: UUID) async throws -> CaptureSession?
}

public protocol CaptureSourceRepository: Sendable {
    func save(_ source: CaptureSource) async throws
    func fetch(for sessionID: UUID) async throws -> [CaptureSource]
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
    func fetchAll() async throws -> [Favorite]
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

public actor JSONLocalLibraryStore {
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

    public func fetch(for sessionID: UUID) async throws -> [CaptureSource] {
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

    public func fetchAll() async throws -> [Favorite] {
        favorites.values.sorted { $0.createdAt > $1.createdAt }
    }
}
