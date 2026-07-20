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
