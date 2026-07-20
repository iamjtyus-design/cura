import SwiftUI

public struct AudioPlaybackView: View {
    @ObservedObject public var recordingModel: AudioRecordingViewModel
    public let source: CaptureSource

    public init(recordingModel: AudioRecordingViewModel, source: CaptureSource) {
        self.recordingModel = recordingModel
        self.source = source
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recording")
                .font(.headline)
            Text(source.originalFilename ?? "Local audio")
                .font(.subheadline)
            Text("Duration \(formatDuration(source.duration ?? recordingModel.playbackDuration))")
                .foregroundStyle(.secondary)
            Slider(
                value: Binding(
                    get: { recordingModel.playbackPosition },
                    set: { newValue in Task { await recordingModel.seek(to: newValue) } }
                ),
                in: 0...max(recordingModel.playbackDuration, source.duration ?? 1)
            )
            .accessibilityLabel("Audio position")
            HStack {
                Button("Play") {
                    Task { await recordingModel.play() }
                }
                .buttonStyle(.borderedProminent)
                .accessibilityLabel("Play Recording")

                Button("Pause") {
                    Task { await recordingModel.pausePlayback() }
                }
                .buttonStyle(.bordered)
                .accessibilityLabel("Pause Recording Playback")
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
    }
}
