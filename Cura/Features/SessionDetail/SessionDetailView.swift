import SwiftUI

public struct SessionDetailView: View {
    @ObservedObject public var model: PhaseOneViewModel
    public let session: CaptureSession

    public init(model: PhaseOneViewModel, session: CaptureSession) {
        self.model = model
        self.session = session
    }

    public var note: CuratedNote? { model.note(for: session.id) }
    public var caption: GeneratedOutput? { model.instagramCaption(for: session.id) }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(session.title)
                            .font(.title2.weight(.semibold))
                            .accessibilityIdentifier("sessionTitle")
                        Text("\(session.mode.displayName) • \(session.processingMode.displayName)")
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Button {
                        Task { await model.toggleFavorite(session) }
                    } label: {
                        Image(systemName: session.isFavorite ? "star.fill" : "star")
                            .imageScale(.large)
                    }
                    .accessibilityLabel(session.isFavorite ? "Remove Favorite" : "Add Favorite")
                    .accessibilityIdentifier("favoriteButton")
                }

                ProcessingStagesView(model: model)

                if let note {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Curated Note")
                            .font(.headline)
                        Text(note.smartSummary)
                        ForEach(note.keyIdeas, id: \.self) { idea in
                            Label(idea, systemImage: "checkmark.circle")
                                .font(.subheadline)
                        }
                    }
                    .padding()
                    .background(PhaseOneSurface.secondary)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .accessibilityIdentifier("curatedNote")
                }

                if let caption {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Instagram Caption")
                            .font(.headline)
                        Text(caption.content)
                            .font(.body)
                            .accessibilityIdentifier("instagramCaption")
                        HStack {
                            Button {
                                Task { await model.copy(caption.content) }
                            } label: {
                                Label("Copy", systemImage: "doc.on.doc")
                            }
                            .buttonStyle(.bordered)
                            .accessibilityIdentifier("copyCaptionButton")

                            Button {
                                Task { await model.copyAndOpenInstagram(caption.content) }
                            } label: {
                                Label("Copy and Open Instagram", systemImage: "square.and.arrow.up")
                            }
                            .buttonStyle(.borderedProminent)
                            .accessibilityIdentifier("copyOpenInstagramButton")
                        }
                    }
                    .padding()
                    .background(PhaseOneSurface.secondary)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .accessibilityIdentifier("creatorPack")
                }

                Button("Back to Sessions") {
                    model.selectedSession = nil
                }
                .accessibilityIdentifier("backToSessionsButton")
            }
            .padding()
        }
        .navigationTitle("Session")
    }
}
