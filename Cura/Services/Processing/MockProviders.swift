import Foundation

public struct MockProcessingProvider: ProcessingProviding {
    public init() {}

    public func process(session: CaptureSession, sources: [CaptureSource]) async throws -> ProcessingResult {
        let job = ProcessingJob(sessionID: session.id, stage: .completed, attempts: 1)
        let note = CuratedNote(
            sessionID: session.id,
            title: session.title,
            smartSummary: "Mock processing completed for Phase 0 foundation.",
            detailedSummary: "This placeholder note proves the processing provider boundary without connecting live AI.",
            keyIdeas: ["Capture Session", "Curated Note", "Provider abstraction"],
            confidence: 1.0
        )
        return ProcessingResult(job: job, note: note)
    }
}

public struct MockExportProvider: ExportProviding {
    public init() {}

    public func render(output: GeneratedOutput, format: ExportFormat) async throws -> Data {
        Data(output.content.utf8)
    }
}

public struct MockSubscriptionProvider: SubscriptionProviding {
    public var entitlement: String?

    public init(entitlement: String? = "preview") {
        self.entitlement = entitlement
    }

    public func currentEntitlement() async throws -> String? {
        entitlement
    }
}

public struct MockAuthenticationProvider: AuthenticationProviding {
    public var userID: UUID?

    public init(userID: UUID? = UUID()) {
        self.userID = userID
    }

    public func currentUserID() async throws -> UUID? {
        userID
    }
}

public actor MockAnalyticsProvider: AnalyticsProviding {
    public private(set) var events: [AnalyticsEvent] = []

    public init() {}

    public func track(_ event: AnalyticsEvent) async {
        events.append(event)
    }
}

public struct MockNotificationProvider: NotificationProviding {
    public init() {}

    public func requestAuthorization() async throws -> Bool {
        true
    }

    public func scheduleProcessingComplete(sessionID: UUID, title: String) async throws {}
}
