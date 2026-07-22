import SwiftUI

public struct AudioPlaybackView: View {
    @ObservedObject public var recordingModel: AudioRecordingViewModel
    public let source: CaptureSource
    public var removeMissingSource: (() -> Void)?
    @State private var displayedPosition: TimeInterval = 0
    @State private var isScrubbing = false

    public init(recordingModel: AudioRecordingViewModel, source: CaptureSource, removeMissingSource: (() -> Void)? = nil) {
        self.recordingModel = recordingModel
        self.source = source
        self.removeMissingSource = removeMissingSource
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Original Audio")
                .font(.headline)
            Text("\(source.createdAt.formatted(date: .abbreviated, time: .shortened)) • \(formatDuration(totalDuration))")
                .font(.caption)
                .foregroundStyle(.secondary)
            Text("\(formatDuration(displayedPlaybackPosition)) / \(formatDuration(totalDuration))")
                .font(.system(.body, design: .monospaced))
                .foregroundStyle(.secondary)
            if !recordingModel.playbackUnavailableMessage.isEmpty {
                Text(recordingModel.playbackUnavailableMessage)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .accessibilityIdentifier("playbackUnavailableMessage")
                if let removeMissingSource {
                    Button("Remove Missing Recording Reference", role: .destructive) {
                        removeMissingSource()
                    }
                    .buttonStyle(.bordered)
                    .accessibilityIdentifier("removeMissingRecordingReferenceButton")
                }
            }
            Slider(
                value: Binding(
                    get: { displayedPlaybackPosition },
                    set: { displayedPosition = $0 }
                ),
                in: 0...max(totalDuration, 1),
                onEditingChanged: { editing in
                    isScrubbing = editing
                    if !editing {
                        Task { await recordingModel.seek(to: displayedPosition) }
                    }
                }
            )
            .accessibilityLabel("Audio position")
            .accessibilityValue("\(formatDuration(displayedPlaybackPosition)) of \(formatDuration(totalDuration))")
            .accessibilityIdentifier("playbackProgress")
            .disabled(!recordingModel.playbackUnavailableMessage.isEmpty)
            HStack {
                Button {
                    Task {
                        if recordingModel.isPlaybackPlaying {
                            await recordingModel.pausePlayback()
                        } else {
                            await recordingModel.play(url: source.sourceURL)
                        }
                    }
                } label: {
                    Label(recordingModel.isPlaybackPlaying ? "Pause" : "Play", systemImage: recordingModel.isPlaybackPlaying ? "pause.fill" : "play.fill")
                }
                .buttonStyle(.borderedProminent)
                .accessibilityLabel(recordingModel.isPlaybackPlaying ? "Pause Recording Playback" : "Play Recording")
                .disabled(!recordingModel.playbackUnavailableMessage.isEmpty)
            }
        }
        .padding()
        .background(PhaseOneSurface.secondary)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .task {
            if let url = source.sourceURL {
                await recordingModel.loadPlayback(url: url)
            }
        }
        .onChange(of: recordingModel.playbackPosition) { _, position in
            if !isScrubbing {
                displayedPosition = position
            }
        }
        .onChange(of: recordingModel.playbackDuration) { _, _ in
            if !isScrubbing {
                displayedPosition = recordingModel.playbackPosition
            }
        }
    }

    private var totalDuration: TimeInterval {
        max(recordingModel.playbackDuration, source.duration ?? 0)
    }

    private var displayedPlaybackPosition: TimeInterval {
        isScrubbing ? displayedPosition : recordingModel.playbackPosition
    }
}
