import Foundation
import CuraCore

public final class AppCoordinator {
    public let container: DependencyContainer

    public init(container: DependencyContainer) {
        self.container = container
    }
}
