import Foundation

public enum CuraColorToken: String, CaseIterable, Sendable {
    case ink = "#10151D"
    case deep = "#172334"
    case canvas = "#F7F5F0"
    case white = "#FFFFFF"
    case signal = "#316BFF"
    case signalDark = "#1E4FCC"
    case gold = "#B98A46"
    case softGold = "#E7D4AE"
    case success = "#1F8A5B"
    case warning = "#B7791F"
    case danger = "#C94A4A"
    case muted = "#667085"
    case border = "#D9DEE7"
}

public enum CuraSpacing: Double, CaseIterable, Sendable {
    case xxs = 4
    case xs = 8
    case sm = 12
    case md = 16
    case lg = 20
    case xl = 24
    case xxl = 32
    case xxxl = 40
    case huge = 48
}

public enum CuraRadius: Double, Sendable {
    case small = 6
    case medium = 8
    case large = 16
}

public enum CuraStatusToken: String, CaseIterable, Sendable {
    case draft
    case capturing
    case uploading
    case processing
    case partial
    case complete
    case warning
    case failed
    case `private`
    case cloud
}
