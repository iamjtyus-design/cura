import SwiftUI

public struct SessionRow: View {
    @ObservedObject public var model: PhaseOneViewModel
    public let session: CaptureSession

    public init(model: PhaseOneViewModel, session: CaptureSession) {
        self.model = model
        self.session = session
    }

    public var body: some View {
        Button {
            model.selectedSession = session
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(session.title)
                        .font(.headline)
                    Text("\(session.mode.displayName) • \(session.status.displayName)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: session.isFavorite ? "star.fill" : "star")
                    .foregroundStyle(session.isFavorite ? Color.yellow : Color.secondary)
                    .accessibilityHidden(true)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .padding()
        .background(PhaseOneSurface.secondary)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .accessibilityLabel("\(session.title), \(session.status.displayName)")
    }
}
