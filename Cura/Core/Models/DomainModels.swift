import Foundation

public enum CaptureMode: String, Codable, CaseIterable, Sendable {
    case learn
    case create
    case work
}

public enum CaptureSessionStatus: String, Codable, CaseIterable, Sendable {
    case draft
    case capturing
    case ready
    case processing
    case partiallyCompleted
    case completed
    case failed
    case cancelled
    case deleted
}

public enum ProcessingMode: String, Codable, CaseIterable, Sendable {
    case `private`
    case smart
    case futureSync
}

public enum CaptureSourceType: String, Codable, CaseIterable, Sendable {
    case liveAudio
    case uploadedAudio
    case uploadedVideo
    case photo
    case screenshot
    case typedNote
    case pdf
    case webPage
    case youtubeLink
    case socialLink
    case sharedFile
}

public enum TranscriptOrigin: String, Codable, CaseIterable, Sendable {
    case speechToText
    case officialCaptions
    case modelReconstruction
    case ocr
    case manualEntry
    case importedText
    case unavailable
}

public enum ProcessingStage: String, Codable, CaseIterable, Sendable {
    case draft
    case preparing
    case uploading
    case queued
    case extractingAudio
    case transcribing
    case extractingFrames
    case readingVisualText
    case understandingVisuals
    case understandingDocuments
    case mergingSources
    case buildingCuratedNote
    case generatingOutputs
    case renderingVisualBrief
    case saving
    case completed
    case failed
    case cancelled
}

public enum OutputType: String, Codable, CaseIterable, Sendable {
    case smartSummary
    case creatorPack
    case learningPack
    case businessPack
    case custom
}

public enum VisualBriefLayout: String, Codable, CaseIterable, Sendable {
    case onePageSummary
    case timeline
    case processMap
    case conceptMap
    case comparison
    case quoteLayout
    case keyStatistics
    case carouselPlan
}

public struct EvidenceReference: Identifiable, Codable, Equatable, Sendable {
    public var id: UUID
    public var sourceID: UUID
    public var startTime: TimeInterval?
    public var endTime: TimeInterval?
    public var frameTime: TimeInterval?
    public var pageNumber: Int?
    public var textRange: String?
    public var evidenceText: String?
    public var confidence: Double?

    public init(
        id: UUID = UUID(),
        sourceID: UUID,
        startTime: TimeInterval? = nil,
        endTime: TimeInterval? = nil,
        frameTime: TimeInterval? = nil,
        pageNumber: Int? = nil,
        textRange: String? = nil,
        evidenceText: String? = nil,
        confidence: Double? = nil
    ) {
        self.id = id
        self.sourceID = sourceID
        self.startTime = startTime
        self.endTime = endTime
        self.frameTime = frameTime
        self.pageNumber = pageNumber
        self.textRange = textRange
        self.evidenceText = evidenceText
        self.confidence = confidence
    }
}

public struct CaptureSession: Identifiable, Codable, Equatable, Sendable {
    public var id: UUID
    public var userID: UUID?
    public var title: String
    public var mode: CaptureMode
    public var status: CaptureSessionStatus
    public var createdAt: Date
    public var updatedAt: Date
    public var folderID: UUID?
    public var isFavorite: Bool
    public var processingMode: ProcessingMode
    public var outputLanguage: String
    public var templateKey: String?

    public init(
        id: UUID = UUID(),
        userID: UUID? = nil,
        title: String,
        mode: CaptureMode,
        status: CaptureSessionStatus = .draft,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        folderID: UUID? = nil,
        isFavorite: Bool = false,
        processingMode: ProcessingMode = .smart,
        outputLanguage: String = "en",
        templateKey: String? = nil
    ) {
        self.id = id
        self.userID = userID
        self.title = title
        self.mode = mode
        self.status = status
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.folderID = folderID
        self.isFavorite = isFavorite
        self.processingMode = processingMode
        self.outputLanguage = outputLanguage
        self.templateKey = templateKey
    }
}

public struct CaptureSource: Identifiable, Codable, Equatable, Sendable {
    public var id: UUID
    public var sessionID: UUID
    public var sourceType: CaptureSourceType
    public var localIdentifier: String?
    public var temporaryStoragePath: String?
    public var originalFilename: String?
    public var mimeType: String?
    public var duration: TimeInterval?
    public var pageCount: Int?
    public var sourceURL: URL?
    public var transcriptOrigin: TranscriptOrigin
    public var createdAt: Date
    public var deletedAt: Date?

    public init(
        id: UUID = UUID(),
        sessionID: UUID,
        sourceType: CaptureSourceType,
        localIdentifier: String? = nil,
        temporaryStoragePath: String? = nil,
        originalFilename: String? = nil,
        mimeType: String? = nil,
        duration: TimeInterval? = nil,
        pageCount: Int? = nil,
        sourceURL: URL? = nil,
        transcriptOrigin: TranscriptOrigin = .unavailable,
        createdAt: Date = Date(),
        deletedAt: Date? = nil
    ) {
        self.id = id
        self.sessionID = sessionID
        self.sourceType = sourceType
        self.localIdentifier = localIdentifier
        self.temporaryStoragePath = temporaryStoragePath
        self.originalFilename = originalFilename
        self.mimeType = mimeType
        self.duration = duration
        self.pageCount = pageCount
        self.sourceURL = sourceURL
        self.transcriptOrigin = transcriptOrigin
        self.createdAt = createdAt
        self.deletedAt = deletedAt
    }
}

public struct ProcessingJob: Identifiable, Codable, Equatable, Sendable {
    public var id: UUID
    public var sessionID: UUID
    public var stage: ProcessingStage
    public var attempts: Int
    public var errorMessage: String?
    public var idempotencyKey: String
    public var createdAt: Date
    public var updatedAt: Date

    public init(
        id: UUID = UUID(),
        sessionID: UUID,
        stage: ProcessingStage,
        attempts: Int = 0,
        errorMessage: String? = nil,
        idempotencyKey: String = UUID().uuidString,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.sessionID = sessionID
        self.stage = stage
        self.attempts = attempts
        self.errorMessage = errorMessage
        self.idempotencyKey = idempotencyKey
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

public struct CuratedNote: Identifiable, Codable, Equatable, Sendable {
    public var id: UUID
    public var sessionID: UUID
    public var schemaVersion: String
    public var promptVersion: String
    public var title: String
    public var smartSummary: String
    public var detailedSummary: String
    public var keyIdeas: [String]
    public var quotes: [String]
    public var decisions: [String]
    public var actionItems: [String]
    public var dates: [String]
    public var people: [String]
    public var organizations: [String]
    public var projects: [String]
    public var risks: [String]
    public var questions: [String]
    public var visualObservations: [String]
    public var tags: [String]
    public var uncertainties: [String]
    public var confidence: Double
    public var evidenceReferences: [EvidenceReference]
    public var createdAt: Date

    public init(
        id: UUID = UUID(),
        sessionID: UUID,
        schemaVersion: String = "1.0",
        promptVersion: String = "1.0",
        title: String,
        smartSummary: String,
        detailedSummary: String = "",
        keyIdeas: [String] = [],
        quotes: [String] = [],
        decisions: [String] = [],
        actionItems: [String] = [],
        dates: [String] = [],
        people: [String] = [],
        organizations: [String] = [],
        projects: [String] = [],
        risks: [String] = [],
        questions: [String] = [],
        visualObservations: [String] = [],
        tags: [String] = [],
        uncertainties: [String] = [],
        confidence: Double = 0,
        evidenceReferences: [EvidenceReference] = [],
        createdAt: Date = Date()
    ) {
        self.id = id
        self.sessionID = sessionID
        self.schemaVersion = schemaVersion
        self.promptVersion = promptVersion
        self.title = title
        self.smartSummary = smartSummary
        self.detailedSummary = detailedSummary
        self.keyIdeas = keyIdeas
        self.quotes = quotes
        self.decisions = decisions
        self.actionItems = actionItems
        self.dates = dates
        self.people = people
        self.organizations = organizations
        self.projects = projects
        self.risks = risks
        self.questions = questions
        self.visualObservations = visualObservations
        self.tags = tags
        self.uncertainties = uncertainties
        self.confidence = confidence
        self.evidenceReferences = evidenceReferences
        self.createdAt = createdAt
    }
}

public struct GeneratedOutput: Identifiable, Codable, Equatable, Sendable {
    public var id: UUID
    public var sessionID: UUID
    public var curatedNoteID: UUID
    public var outputType: OutputType
    public var mode: CaptureMode
    public var packKey: String
    public var language: String
    public var content: String
    public var evidenceReferences: [EvidenceReference]
    public var promptVersion: String
    public var model: String
    public var createdAt: Date

    public init(
        id: UUID = UUID(),
        sessionID: UUID,
        curatedNoteID: UUID,
        outputType: OutputType,
        mode: CaptureMode,
        packKey: String,
        language: String = "en",
        content: String,
        evidenceReferences: [EvidenceReference] = [],
        promptVersion: String = "1.0",
        model: String = "mock",
        createdAt: Date = Date()
    ) {
        self.id = id
        self.sessionID = sessionID
        self.curatedNoteID = curatedNoteID
        self.outputType = outputType
        self.mode = mode
        self.packKey = packKey
        self.language = language
        self.content = content
        self.evidenceReferences = evidenceReferences
        self.promptVersion = promptVersion
        self.model = model
        self.createdAt = createdAt
    }
}

public struct OutputPack: Identifiable, Codable, Equatable, Sendable {
    public var id: UUID
    public var sessionID: UUID
    public var curatedNoteID: UUID
    public var packKey: String
    public var mode: CaptureMode
    public var outputs: [GeneratedOutput]
    public var createdAt: Date

    public init(
        id: UUID = UUID(),
        sessionID: UUID,
        curatedNoteID: UUID,
        packKey: String,
        mode: CaptureMode,
        outputs: [GeneratedOutput] = [],
        createdAt: Date = Date()
    ) {
        self.id = id
        self.sessionID = sessionID
        self.curatedNoteID = curatedNoteID
        self.packKey = packKey
        self.mode = mode
        self.outputs = outputs
        self.createdAt = createdAt
    }
}

public struct VisualBrief: Identifiable, Codable, Equatable, Sendable {
    public var id: UUID
    public var sessionID: UUID
    public var curatedNoteID: UUID
    public var layout: VisualBriefLayout
    public var title: String
    public var sections: [String]
    public var evidenceReferences: [EvidenceReference]
    public var createdAt: Date

    public init(
        id: UUID = UUID(),
        sessionID: UUID,
        curatedNoteID: UUID,
        layout: VisualBriefLayout,
        title: String,
        sections: [String] = [],
        evidenceReferences: [EvidenceReference] = [],
        createdAt: Date = Date()
    ) {
        self.id = id
        self.sessionID = sessionID
        self.curatedNoteID = curatedNoteID
        self.layout = layout
        self.title = title
        self.sections = sections
        self.evidenceReferences = evidenceReferences
        self.createdAt = createdAt
    }
}

public struct Folder: Identifiable, Codable, Equatable, Sendable {
    public var id: UUID
    public var name: String
    public var createdAt: Date

    public init(id: UUID = UUID(), name: String, createdAt: Date = Date()) {
        self.id = id
        self.name = name
        self.createdAt = createdAt
    }
}

public struct Tag: Identifiable, Codable, Equatable, Sendable {
    public var id: UUID
    public var name: String

    public init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
    }
}

public struct Favorite: Identifiable, Codable, Equatable, Sendable {
    public var id: UUID
    public var sessionID: UUID
    public var createdAt: Date

    public init(id: UUID = UUID(), sessionID: UUID, createdAt: Date = Date()) {
        self.id = id
        self.sessionID = sessionID
        self.createdAt = createdAt
    }
}
