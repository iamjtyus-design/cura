import Foundation

public struct DependencyContainer: Sendable {
    public var configuration: AppConfiguration
    public var sessions: any CaptureSessionRepository
    public var sources: any CaptureSourceRepository
    public var folders: any FolderRepository
    public var tags: any TagRepository
    public var favorites: any FavoriteRepository
    public var processing: any ProcessingProviding
    public var export: any ExportProviding
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
        processing: any ProcessingProviding,
        export: any ExportProviding,
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
        self.processing = processing
        self.export = export
        self.subscription = subscription
        self.authentication = authentication
        self.analytics = analytics
        self.notifications = notifications
    }

    public static var live: DependencyContainer {
        make(configuration: .development)
    }

    public static var preview: DependencyContainer {
        let session = CaptureSession(title: "Property walkthrough", mode: .work, status: .completed)
        return make(configuration: .development, seed: [session])
    }

    public static var test: DependencyContainer {
        make(configuration: .development)
    }

    public static func make(configuration: AppConfiguration, seed: [CaptureSession] = []) -> DependencyContainer {
        DependencyContainer(
            configuration: configuration,
            sessions: InMemoryCaptureSessionRepository(seed: seed),
            sources: InMemoryCaptureSourceRepository(),
            folders: InMemoryFolderRepository(),
            tags: InMemoryTagRepository(),
            favorites: InMemoryFavoriteRepository(),
            processing: MockProcessingProvider(),
            export: MockExportProvider(),
            subscription: MockSubscriptionProvider(),
            authentication: MockAuthenticationProvider(),
            analytics: MockAnalyticsProvider(),
            notifications: MockNotificationProvider()
        )
    }
}
