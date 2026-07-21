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

public enum CuratedNoteGenerationStatus: String, Codable, CaseIterable, Sendable {
    case notStarted
    case preparing
    case transcribing
    case buildingCuratedNote
    case completed
    case failed
    case cancelled
}

public enum ActionEvidenceState: String, Codable, CaseIterable, Sendable {
    case explicit
    case stronglySupported
    case uncertain
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

public struct TranscriptSegment: Identifiable, Codable, Equatable, Sendable {
    public var id: UUID
    public var startTime: TimeInterval?
    public var endTime: TimeInterval?
    public var text: String
    public var confidence: Double?

    public init(
        id: UUID = UUID(),
        startTime: TimeInterval? = nil,
        endTime: TimeInterval? = nil,
        text: String,
        confidence: Double? = nil
    ) {
        self.id = id
        self.startTime = startTime
        self.endTime = endTime
        self.text = text
        self.confidence = confidence
    }
}

public struct CuratedActionItem: Identifiable, Codable, Equatable, Sendable {
    public var id: UUID
    public var title: String
    public var supportingExcerpt: String?
    public var timestamp: TimeInterval?
    public var isCompleted: Bool
    public var evidenceState: ActionEvidenceState

    public init(
        id: UUID = UUID(),
        title: String,
        supportingExcerpt: String? = nil,
        timestamp: TimeInterval? = nil,
        isCompleted: Bool = false,
        evidenceState: ActionEvidenceState = .explicit
    ) {
        self.id = id
        self.title = title
        self.supportingExcerpt = supportingExcerpt
        self.timestamp = timestamp
        self.isCompleted = isCompleted
        self.evidenceState = evidenceState
    }
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
    public var captureSessionID: UUID { sessionID }
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
    public var updatedAt: Date
    public var sourceType: CaptureSourceType?
    public var transcript: String
    public var transcriptSegments: [TranscriptSegment]
    public var suggestedTitle: String?
    public var confirmedTitle: String?
    public var summary: String
    public var keyPoints: [String]
    public var structuredActionItems: [CuratedActionItem]
    public var userNotes: String
    public var generationStatus: CuratedNoteGenerationStatus
    public var generationError: String?

    enum CodingKeys: String, CodingKey {
        case id
        case sessionID
        case captureSessionID
        case schemaVersion
        case promptVersion
        case title
        case smartSummary
        case detailedSummary
        case keyIdeas
        case quotes
        case decisions
        case actionItems
        case dates
        case people
        case organizations
        case projects
        case risks
        case questions
        case visualObservations
        case tags
        case uncertainties
        case confidence
        case evidenceReferences
        case createdAt
        case updatedAt
        case sourceType
        case transcript
        case transcriptSegments
        case suggestedTitle
        case confirmedTitle
        case summary
        case keyPoints
        case structuredActionItems
        case userNotes
        case generationStatus
        case generationError
    }

    public init(
        id: UUID = UUID(),
        sessionID: UUID,
        schemaVersion: String = "2.1",
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
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        sourceType: CaptureSourceType? = nil,
        transcript: String = "",
        transcriptSegments: [TranscriptSegment] = [],
        suggestedTitle: String? = nil,
        confirmedTitle: String? = nil,
        summary: String? = nil,
        keyPoints: [String]? = nil,
        structuredActionItems: [CuratedActionItem] = [],
        userNotes: String = "",
        generationStatus: CuratedNoteGenerationStatus = .completed,
        generationError: String? = nil
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
        self.updatedAt = updatedAt
        self.sourceType = sourceType
        self.transcript = transcript
        self.transcriptSegments = transcriptSegments
        self.suggestedTitle = suggestedTitle
        self.confirmedTitle = confirmedTitle
        self.summary = summary ?? smartSummary
        self.keyPoints = keyPoints ?? keyIdeas
        self.structuredActionItems = structuredActionItems
        self.userNotes = userNotes
        self.generationStatus = generationStatus
        self.generationError = generationError
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        sessionID = try container.decodeIfPresent(UUID.self, forKey: .sessionID)
            ?? container.decode(UUID.self, forKey: .captureSessionID)
        schemaVersion = try container.decodeIfPresent(String.self, forKey: .schemaVersion) ?? "1.0"
        promptVersion = try container.decodeIfPresent(String.self, forKey: .promptVersion) ?? "1.0"
        title = try container.decodeIfPresent(String.self, forKey: .title) ?? "Curated Note"
        smartSummary = try container.decodeIfPresent(String.self, forKey: .smartSummary)
            ?? container.decodeIfPresent(String.self, forKey: .summary)
            ?? ""
        detailedSummary = try container.decodeIfPresent(String.self, forKey: .detailedSummary) ?? ""
        keyIdeas = try container.decodeIfPresent([String].self, forKey: .keyIdeas)
            ?? container.decodeIfPresent([String].self, forKey: .keyPoints)
            ?? []
        quotes = try container.decodeIfPresent([String].self, forKey: .quotes) ?? []
        decisions = try container.decodeIfPresent([String].self, forKey: .decisions) ?? []
        actionItems = try container.decodeIfPresent([String].self, forKey: .actionItems) ?? []
        dates = try container.decodeIfPresent([String].self, forKey: .dates) ?? []
        people = try container.decodeIfPresent([String].self, forKey: .people) ?? []
        organizations = try container.decodeIfPresent([String].self, forKey: .organizations) ?? []
        projects = try container.decodeIfPresent([String].self, forKey: .projects) ?? []
        risks = try container.decodeIfPresent([String].self, forKey: .risks) ?? []
        questions = try container.decodeIfPresent([String].self, forKey: .questions) ?? []
        visualObservations = try container.decodeIfPresent([String].self, forKey: .visualObservations) ?? []
        tags = try container.decodeIfPresent([String].self, forKey: .tags) ?? []
        uncertainties = try container.decodeIfPresent([String].self, forKey: .uncertainties) ?? []
        confidence = try container.decodeIfPresent(Double.self, forKey: .confidence) ?? 0
        evidenceReferences = try container.decodeIfPresent([EvidenceReference].self, forKey: .evidenceReferences) ?? []
        createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt) ?? Date()
        updatedAt = try container.decodeIfPresent(Date.self, forKey: .updatedAt) ?? createdAt
        sourceType = try container.decodeIfPresent(CaptureSourceType.self, forKey: .sourceType)
        transcript = try container.decodeIfPresent(String.self, forKey: .transcript) ?? ""
        transcriptSegments = try container.decodeIfPresent([TranscriptSegment].self, forKey: .transcriptSegments) ?? []
        suggestedTitle = try container.decodeIfPresent(String.self, forKey: .suggestedTitle)
        confirmedTitle = try container.decodeIfPresent(String.self, forKey: .confirmedTitle)
        summary = try container.decodeIfPresent(String.self, forKey: .summary) ?? smartSummary
        keyPoints = try container.decodeIfPresent([String].self, forKey: .keyPoints) ?? keyIdeas
        structuredActionItems = try container.decodeIfPresent([CuratedActionItem].self, forKey: .structuredActionItems) ?? []
        userNotes = try container.decodeIfPresent(String.self, forKey: .userNotes) ?? ""
        generationStatus = try container.decodeIfPresent(CuratedNoteGenerationStatus.self, forKey: .generationStatus) ?? .completed
        generationError = try container.decodeIfPresent(String.self, forKey: .generationError)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(sessionID, forKey: .sessionID)
        try container.encode(schemaVersion, forKey: .schemaVersion)
        try container.encode(promptVersion, forKey: .promptVersion)
        try container.encode(title, forKey: .title)
        try container.encode(smartSummary, forKey: .smartSummary)
        try container.encode(detailedSummary, forKey: .detailedSummary)
        try container.encode(keyIdeas, forKey: .keyIdeas)
        try container.encode(quotes, forKey: .quotes)
        try container.encode(decisions, forKey: .decisions)
        try container.encode(actionItems, forKey: .actionItems)
        try container.encode(dates, forKey: .dates)
        try container.encode(people, forKey: .people)
        try container.encode(organizations, forKey: .organizations)
        try container.encode(projects, forKey: .projects)
        try container.encode(risks, forKey: .risks)
        try container.encode(questions, forKey: .questions)
        try container.encode(visualObservations, forKey: .visualObservations)
        try container.encode(tags, forKey: .tags)
        try container.encode(uncertainties, forKey: .uncertainties)
        try container.encode(confidence, forKey: .confidence)
        try container.encode(evidenceReferences, forKey: .evidenceReferences)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(updatedAt, forKey: .updatedAt)
        try container.encodeIfPresent(sourceType, forKey: .sourceType)
        try container.encode(transcript, forKey: .transcript)
        try container.encode(transcriptSegments, forKey: .transcriptSegments)
        try container.encodeIfPresent(suggestedTitle, forKey: .suggestedTitle)
        try container.encodeIfPresent(confirmedTitle, forKey: .confirmedTitle)
        try container.encode(summary, forKey: .summary)
        try container.encode(keyPoints, forKey: .keyPoints)
        try container.encode(structuredActionItems, forKey: .structuredActionItems)
        try container.encode(userNotes, forKey: .userNotes)
        try container.encode(generationStatus, forKey: .generationStatus)
        try container.encodeIfPresent(generationError, forKey: .generationError)
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
