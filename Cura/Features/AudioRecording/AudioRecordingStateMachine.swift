import Foundation

public enum AudioRecordingState: String, Codable, Equatable, Sendable {
    case idle
    case requestingPermission
    case ready
    case recording
    case paused
    case stopping
    case completed
    case interrupted
    case failed
}

public enum AudioRecordingPermissionStatus: String, Equatable, Sendable {
    case undetermined
    case granted
    case denied
    case restricted
}

public enum AudioRecordingInterruptionReason: String, Codable, Equatable, Sendable {
    case incomingAudioInterruption
    case routeChange
    case headphonesDisconnected
    case appBackgrounded
    case insufficientStorage
    case saveFailure
    case userCancellation
    case unknown
}

public struct AudioMarker: Identifiable, Codable, Equatable, Sendable {
    public var id: UUID
    public var time: TimeInterval
    public var createdAt: Date

    public init(id: UUID = UUID(), time: TimeInterval, createdAt: Date = Date()) {
        self.id = id
        self.time = time
        self.createdAt = createdAt
    }
}

public struct AudioRecordingRecoveryMetadata: Codable, Equatable, Sendable {
    public var sessionID: UUID
    public var sourceID: UUID
    public var fileURL: URL
    public var recordingStartDate: Date
    public var accumulatedDuration: TimeInterval
    public var pauseState: AudioRecordingState
    public var markers: [AudioMarker]
    public var lastSuccessfulStateUpdate: Date
    public var interruptionReason: AudioRecordingInterruptionReason?

    public init(
        sessionID: UUID,
        sourceID: UUID,
        fileURL: URL,
        recordingStartDate: Date = Date(),
        accumulatedDuration: TimeInterval = 0,
        pauseState: AudioRecordingState = .idle,
        markers: [AudioMarker] = [],
        lastSuccessfulStateUpdate: Date = Date(),
        interruptionReason: AudioRecordingInterruptionReason? = nil
    ) {
        self.sessionID = sessionID
        self.sourceID = sourceID
        self.fileURL = fileURL
        self.recordingStartDate = recordingStartDate
        self.accumulatedDuration = accumulatedDuration
        self.pauseState = pauseState
        self.markers = markers
        self.lastSuccessfulStateUpdate = lastSuccessfulStateUpdate
        self.interruptionReason = interruptionReason
    }
}

public struct AudioRecordingStateMachine: Sendable {
    public private(set) var state: AudioRecordingState

    public init(initialState: AudioRecordingState = .idle) {
        self.state = initialState
    }

    public mutating func transition(to nextState: AudioRecordingState) -> Bool {
        guard canTransition(from: state, to: nextState) else { return false }
        state = nextState
        return true
    }

    public func canTransition(from current: AudioRecordingState, to next: AudioRecordingState) -> Bool {
        switch (current, next) {
        case (.idle, .requestingPermission), (.idle, .ready), (.idle, .interrupted), (.idle, .failed):
            return true
        case (.requestingPermission, .ready), (.requestingPermission, .failed):
            return true
        case (.ready, .recording), (.ready, .idle), (.ready, .failed):
            return true
        case (.recording, .paused), (.recording, .stopping), (.recording, .interrupted), (.recording, .failed):
            return true
        case (.paused, .recording), (.paused, .stopping), (.paused, .interrupted), (.paused, .failed):
            return true
        case (.stopping, .completed), (.stopping, .failed):
            return true
        case (.interrupted, .ready), (.interrupted, .recording), (.interrupted, .stopping), (.interrupted, .failed):
            return true
        case (.completed, .idle):
            return true
        default:
            return false
        }
    }
}
