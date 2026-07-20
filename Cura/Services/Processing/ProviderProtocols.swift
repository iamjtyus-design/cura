import Foundation

public struct ProcessingResult: Equatable, Sendable {
    public var job: ProcessingJob
    public var note: CuratedNote

    public init(job: ProcessingJob, note: CuratedNote) {
        self.job = job
        self.note = note
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

public struct AnalyticsEvent: Equatable, Sendable {
    public var name: String
    public var properties: [String: String]

    public init(name: String, properties: [String: String] = [:]) {
        self.name = name
        self.properties = properties
    }
}
