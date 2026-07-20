import Foundation

public struct DependencyContainer {
    public var configuration: AppConfiguration
    public var sessions: any CaptureSessionRepository
    public var sources: any CaptureSourceRepository
    public var folders: any FolderRepository
    public var tags: any TagRepository
    public var favorites: any FavoriteRepository
    public var curatedNotes: any CuratedNoteRepository
    public var outputPacks: any OutputPackRepository
    public var generatedOutputs: any GeneratedOutputRepository
    public var mediaStorage: any MediaFileStorage
    public var libraryMaintenance: (any LocalLibraryMaintenance)?
    public var processing: any ProcessingProviding
    public var export: any ExportProviding
    public var quickSend: any QuickSendProviding
    public var subscription: any SubscriptionProviding
    public var authentication: any AuthenticationProviding
    public var analytics: any AnalyticsProviding
    public var notifications: any NotificationProviding

    public init(
        configuration: AppConfiguration,
        sessions: any CaptureSessionRepository,
        sources: any CaptureSourceRepository,
        folders: any FolderRepository,
        tags: any TagRepository,
        favorites: any FavoriteRepository,
        curatedNotes: any CuratedNoteRepository,
        outputPacks: any OutputPackRepository,
        generatedOutputs: any GeneratedOutputRepository,
        mediaStorage: any MediaFileStorage,
        libraryMaintenance: (any LocalLibraryMaintenance)? = nil,
        processing: any ProcessingProviding,
        export: any ExportProviding,
        quickSend: any QuickSendProviding,
        subscription: any SubscriptionProviding,
        authentication: any AuthenticationProviding,
        analytics: any AnalyticsProviding,
        notifications: any NotificationProviding
    ) {
        self.configuration = configuration
        self.sessions = sessions
        self.sources = sources
        self.folders = folders
        self.tags = tags
        self.favorites = favorites
        self.curatedNotes = curatedNotes
        self.outputPacks = outputPacks
        self.generatedOutputs = generatedOutputs
        self.mediaStorage = mediaStorage
        self.libraryMaintenance = libraryMaintenance
        self.processing = processing
        self.export = export
        self.quickSend = quickSend
        self.subscription = subscription
        self.authentication = authentication
        self.analytics = analytics
        self.notifications = notifications
    }

    public static var live: DependencyContainer {
        makeLocalJSON(configuration: .development)
    }

    public static var preview: DependencyContainer {
        let session = CaptureSession(title: "Property walkthrough", mode: .work, status: .completed)
        return make(configuration: .development, seed: [session])
    }

    public static var test: DependencyContainer {
        make(configuration: .development, processingStageDelayNanoseconds: 10_000_000)
    }

    public static func make(
        configuration: AppConfiguration,
        seed: [CaptureSession] = [],
        processingStageDelayNanoseconds: UInt64 = 450_000_000,
        processingShouldFail: Bool = false,
        quickSendShouldOpenInstagram: Bool = false
    ) -> DependencyContainer {
        let mediaStorage = InMemoryMediaFileStorage()
        return DependencyContainer(
            configuration: configuration,
            sessions: InMemoryCaptureSessionRepository(seed: seed),
            sources: InMemoryCaptureSourceRepository(),
            folders: InMemoryFolderRepository(),
            tags: InMemoryTagRepository(),
            favorites: InMemoryFavoriteRepository(),
            curatedNotes: InMemoryCuratedNoteRepository(),
            outputPacks: InMemoryOutputPackRepository(),
            generatedOutputs: InMemoryGeneratedOutputRepository(),
            mediaStorage: mediaStorage,
            libraryMaintenance: mediaStorage,
            processing: MockProcessingProvider(
                stageDelayNanoseconds: processingStageDelayNanoseconds,
                shouldFail: processingShouldFail
            ),
            export: MockExportProvider(),
            quickSend: MockQuickSendProvider(shouldOpenInstagram: quickSendShouldOpenInstagram),
            subscription: MockSubscriptionProvider(),
            authentication: MockAuthenticationProvider(),
            analytics: MockAnalyticsProvider(),
            notifications: MockNotificationProvider()
        )
    }

    public static func makeLocalJSON(configuration: AppConfiguration, rootDirectory: URL? = nil) -> DependencyContainer {
        let root = rootDirectory ?? FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("CURA")
        let store = JSONLocalLibraryStore(rootDirectory: root)
        return DependencyContainer(
            configuration: configuration,
            sessions: store,
            sources: store,
            folders: store,
            tags: InMemoryTagRepository(),
            favorites: store,
            curatedNotes: store,
            outputPacks: store,
            generatedOutputs: store,
            mediaStorage: store,
            libraryMaintenance: store,
            processing: MockProcessingProvider(),
            export: MockExportProvider(),
            quickSend: MockQuickSendProvider(),
            subscription: MockSubscriptionProvider(),
            authentication: MockAuthenticationProvider(),
            analytics: MockAnalyticsProvider(),
            notifications: MockNotificationProvider()
        )
    }
}
