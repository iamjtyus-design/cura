import SwiftUI
#if os(iOS) && canImport(AVFoundation)
import AVFoundation
#endif

public struct AudioRecordingView: View {
    @Environment(\.scenePhase) private var scenePhase
    @ObservedObject public var model: AudioRecordingViewModel
    public var onSave: (CaptureSession) -> Void
    public var onCancel: () -> Void

    public init(
        model: AudioRecordingViewModel,
        onSave: @escaping (CaptureSession) -> Void,
        onCancel: @escaping () -> Void
    ) {
        self.model = model
        self.onSave = onSave
        self.onCancel = onCancel
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Record Audio")
                    .font(.title2.weight(.semibold))

                Label(model.state.displayName, systemImage: model.state == .recording ? "record.circle.fill" : "waveform")
                    .font(.headline)
                    .accessibilityLabel("Recording status \(model.state.displayName)")

                Text(formatDuration(model.duration))
                    .font(.system(.title, design: .monospaced))
                    .accessibilityLabel("Recording duration \(formatDuration(model.duration))")
                    .accessibilityIdentifier("recordingDuration")

                if let recovered = model.recoveredMetadata, model.state == .interrupted {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Interrupted recording found")
                            .font(.headline)
                        Text("CURA saved recovery details for this local recording.")
                            .foregroundStyle(.secondary)
                        Button("Recover Recording") {
                            Task { await model.recoverInterruptedRecording() }
                        }
                        .buttonStyle(.borderedProminent)
                        .accessibilityLabel("Recover Recording")
                        Text("Last update \(recovered.lastSuccessfulStateUpdate.formatted(date: .abbreviated, time: .shortened))")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .background(PhaseOneSurface.secondary)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }

                VStack(spacing: 12) {
                    if model.state == .idle {
                        Button {
                            Task { await model.recordTapped() }
                        } label: {
                            Label("Record Audio", systemImage: "mic.circle")
                                .frame(maxWidth: .infinity, minHeight: 44)
                        }
                        .buttonStyle(.borderedProminent)
                        .accessibilityLabel("Record Audio")
                    }

                    if model.state == .ready {
                        Button {
                            Task { await model.startRecording() }
                        } label: {
                            Label("Start Recording", systemImage: "record.circle")
                                .frame(maxWidth: .infinity, minHeight: 44)
                        }
                        .buttonStyle(.borderedProminent)
                        .accessibilityLabel("Start Recording")
                    }

                    if model.state == .recording {
                        Button("Pause Recording") {
                            Task { await model.pauseRecording() }
                        }
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .buttonStyle(.bordered)
                        .accessibilityLabel("Pause Recording")
                    }

                    if model.state == .paused {
                        Button("Resume Recording") {
                            Task { await model.resumeRecording() }
                        }
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .buttonStyle(.borderedProminent)
                        .accessibilityLabel("Resume Recording")
                    }

                    if model.state == .recording || model.state == .paused {
                        Button("Add Marker") {
                            Task { await model.addMarker() }
                        }
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .buttonStyle(.bordered)
                        .accessibilityLabel("Add Timestamp Marker")

                        Button("Stop and Save") {
                            Task { await model.stopAndSave() }
                        }
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .buttonStyle(.borderedProminent)
                        .accessibilityLabel("Stop and Save")
                    }

                    Button("Cancel") {
                        Task {
                            await model.cancelRecording()
                            onCancel()
                        }
                    }
                    .frame(maxWidth: .infinity, minHeight: 44)
                    .buttonStyle(.bordered)
                    .accessibilityLabel("Cancel Recording")
                }

                if !model.markers.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Markers")
                            .font(.headline)
                        ForEach(model.markers) { marker in
                            Text(formatDuration(marker.time))
                        }
                    }
                }
            }
            .padding()
        }
        .task {
            await model.load()
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .background {
                Task { await model.handleInterruption(.appBackgrounded) }
            }
        }
#if os(iOS) && canImport(AVFoundation)
        .onReceive(NotificationCenter.default.publisher(for: AVAudioSession.interruptionNotification)) { _ in
            Task { await model.handleInterruption(.incomingAudioInterruption) }
        }
        .onReceive(NotificationCenter.default.publisher(for: AVAudioSession.routeChangeNotification)) { notification in
            let reasonValue = notification.userInfo?[AVAudioSessionRouteChangeReasonKey] as? UInt
            let reason = AVAudioSession.RouteChangeReason(rawValue: reasonValue ?? 0)
            Task {
                await model.handleInterruption(reason == .oldDeviceUnavailable ? .headphonesDisconnected : .routeChange)
            }
        }
#endif
        .onChange(of: model.savedSession) { _, session in
            if let session {
                onSave(session)
            }
        }
        .confirmationDialog(
            "CURA records only when you tap Start Recording. Keep recording visible and stop when you are done.",
            isPresented: $model.showConsentNotice,
            titleVisibility: .visible
        ) {
            Button("Continue") {
                Task { await model.acceptConsentAndPrepare() }
            }
            Button("Cancel", role: .cancel) {}
        }
        .alert("Audio needs attention", isPresented: model.showingError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(model.errorMessage)
        }
    }
}

public extension AudioRecordingState {
    var displayName: String {
        switch self {
        case .idle:
            return "Idle"
        case .requestingPermission:
            return "Requesting Permission"
        case .ready:
            return "Ready"
        case .recording:
            return "Recording"
        case .paused:
            return "Paused"
        case .stopping:
            return "Stopping"
        case .completed:
            return "Completed"
        case .interrupted:
            return "Interrupted"
        case .failed:
            return "Failed"
        }
    }
}

public func formatDuration(_ duration: TimeInterval) -> String {
    let total = Int(duration.rounded())
    return String(format: "%02d:%02d", total / 60, total % 60)
}
