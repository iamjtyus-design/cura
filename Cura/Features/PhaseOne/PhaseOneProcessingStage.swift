import SwiftUI

public enum PhaseOneProcessingStage: String, CaseIterable, Identifiable, Sendable {
    case preparing
    case readingVideo
    case buildingCuratedNote
    case creatingCreatorPack

    public var id: String { rawValue }

    public var title: String {
        switch self {
        case .preparing:
            return "Preparing"
        case .readingVideo:
            return "Reading Video"
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
}
