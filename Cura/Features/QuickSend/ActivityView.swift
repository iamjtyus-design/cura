import SwiftUI

public struct ShareItem: Identifiable {
    public let id = UUID()
    public let text: String

    public init(text: String) {
        self.text = text
    }
}

#if canImport(UIKit)
import UIKit

public struct ActivityView: UIViewControllerRepresentable {
    public let items: [Any]

    public init(items: [Any]) {
        self.items = items
    }

    public func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    public func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
#endif
