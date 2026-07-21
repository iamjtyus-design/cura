import SwiftUI

public enum PhaseOneProcessingStage: String, CaseIterable, Identifiable, Sendable {
    case preparing
    case readingVideo
    case buildingCuratedNote
    case creatingCreatorPack

    public var id: String { rawValue }

    public var title: String {
        title(sourceType: nil)
    }

    public func title(sourceType: CaptureSourceType?) -> String {
        switch self {
        case .preparing:
            return "Preparing"
        case .readingVideo:
            switch sourceType {
            case .liveAudio, .uploadedAudio:
                return "Reading Audio"
            default:
                return "Reading Video"
            }
        case .buildingCuratedNote:
            return "Building Curated Note"
        case .creatingCreatorPack:
            return "Creating Creator Pack"
        }
    }
}

public enum PhaseOneSurface {
    public static let secondary = Color.secondary.opacity(0.12)
}

public extension CaptureMode {
    var displayName: String {
        rawValue.capitalized
    }

    var guidance: String {
        switch self {
        case .learn:
            return "Notes, concepts, study materials."
        case .create:
            return "Content ideas and creator outputs."
        case .work:
            return "Summaries, tasks, reports, and professional outputs."
        }
    }
}

public extension CaptureSessionStatus {
    var displayName: String {
        switch self {
        case .partiallyCompleted:
            return "Partially Complete"
        default:
            return rawValue.capitalized
        }
    }
}

public extension ProcessingMode {
    var displayName: String {
        switch self {
        case .private:
            return "Private"
        case .smart:
            return "Smart"
        case .futureSync:
            return "Future Sync"
        }
    }

    var guidance: String {
        switch self {
        case .private:
            return "Keeps processing local whenever the selected capability supports it."
        case .smart:
            return "May later use temporary protected cloud processing for enhanced results."
        case .futureSync:
            return "Reserved for future synchronized workflows."
        }
    }
}
