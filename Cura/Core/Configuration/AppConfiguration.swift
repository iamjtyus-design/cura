import Foundation

public enum AppEnvironment: String, Codable, CaseIterable, Sendable {
    case development
    case staging
    case production
}

public struct AppConfiguration: Equatable, Sendable {
    public var environment: AppEnvironment
    public var supabaseURL: URL?
    public var supabaseAnonKey: String?
    public var revenueCatPublicAPIKey: String?
    public var sentryDSN: String?

    public init(
        environment: AppEnvironment,
        supabaseURL: URL? = nil,
        supabaseAnonKey: String? = nil,
        revenueCatPublicAPIKey: String? = nil,
        sentryDSN: String? = nil
    ) {
        self.environment = environment
        self.supabaseURL = supabaseURL
        self.supabaseAnonKey = supabaseAnonKey
        self.revenueCatPublicAPIKey = revenueCatPublicAPIKey
        self.sentryDSN = sentryDSN
    }

    public static let development = AppConfiguration(environment: .development)
    public static let staging = AppConfiguration(environment: .staging)
    public static let production = AppConfiguration(environment: .production)
}
