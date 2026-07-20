import Foundation

public struct ProcessingResult: Equatable, Sendable {
    public var job: ProcessingJob
    public var note: CuratedNote

    public init(job: ProcessingJob, note: CuratedNote) {
        self.job = job
        self.note = note
    }
}

public struct CreatorPackProcessingResult: Equatable, Sendable {
    public var job: ProcessingJob
    public var note: CuratedNote
    public var pack: OutputPack
    public var outputs: [GeneratedOutput]

    public init(job: ProcessingJob, note: CuratedNote, pack: OutputPack, outputs: [GeneratedOutput]) {
        self.job = job
        self.note = note
        self.pack = pack
        self.outputs = outputs
    }
}

public enum ExportFormat: String, CaseIterable, Sendable {
    case markdown
    case plainText
    case json
    case pdf
}

public protocol ProcessingProviding: Sendable {
    func process(session: CaptureSession, sources: [CaptureSource]) async throws -> ProcessingResult
    @MainActor
    func processCreatorPack(
        session: CaptureSession,
        sources: [CaptureSource],
        progress: (PhaseOneProcessingStage) async -> Void
    ) async throws -> CreatorPackProcessingResult
}

public protocol ExportProviding: Sendable {
    func render(output: GeneratedOutput, format: ExportFormat) async throws -> Data
}

public protocol SubscriptionProviding: Sendable {
    func currentEntitlement() async throws -> String?
}

public protocol AuthenticationProviding: Sendable {
    func currentUserID() async throws -> UUID?
}

public protocol AnalyticsProviding: Sendable {
    func track(_ event: AnalyticsEvent) async
}

public protocol NotificationProviding: Sendable {
    func requestAuthorization() async throws -> Bool
    func scheduleProcessingComplete(sessionID: UUID, title: String) async throws
}

public struct QuickSendResult: Equatable, Sendable {
    public var didCopy: Bool
    public var didOpenTargetApp: Bool
    public var shouldPresentShareSheet: Bool

    public init(didCopy: Bool, didOpenTargetApp: Bool, shouldPresentShareSheet: Bool) {
        self.didCopy = didCopy
        self.didOpenTargetApp = didOpenTargetApp
        self.shouldPresentShareSheet = shouldPresentShareSheet
    }
}

public protocol QuickSendProviding: AnyObject {
    @MainActor
    func copy(_ text: String) async
    @MainActor
    func copyAndOpenInstagram(_ text: String) async -> QuickSendResult
}

public struct AnalyticsEvent: Equatable, Sendable {
    public var name: String
    public var properties: [String: String]

    public init(name: String, properties: [String: String] = [:]) {
        self.name = name
        self.properties = properties
    }
}
