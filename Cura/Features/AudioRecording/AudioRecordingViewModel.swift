import Foundation
import SwiftUI

@MainActor
public final class AudioRecordingViewModel: ObservableObject {
    public static let audioConsentVersion = "audio-recording-consent-v1"

    @Published public private(set) var state: AudioRecordingState = .idle
    @Published public private(set) var markers: [AudioMarker] = []
    @Published public private(set) var duration: TimeInterval = 0
    @Published public private(set) var playbackDuration: TimeInterval = 0
    @Published public private(set) var playbackPosition: TimeInterval = 0
    @Published public private(set) var isPlaybackPlaying = false
    @Published public private(set) var recoveredMetadata: AudioRecordingRecoveryMetadata?
    @Published public private(set) var savedSession: CaptureSession?
    @Published public private(set) var savedSource: CaptureSource?
    @Published public private(set) var playbackUnavailableMessage = ""
    @Published public var showConsentNotice = false
    @Published public var errorMessage = ""

    private var machine = AudioRecordingStateMachine()
    private let container: DependencyContainer
    private var activeSessionID: UUID?
    private var activeSourceID: UUID?
    private var activeFileURL: URL?
    private var recordingStartDate: Date?
    private var recordingTimerTask: Task<Void, Never>?
    private var playbackTimerTask: Task<Void, Never>?

    public var showingError: Binding<Bool> {
        Binding(
            get: { !self.errorMessage.isEmpty },
            set: { if !$0 { self.errorMessage = "" } }
        )
    }

    public init(container: DependencyContainer) {
        self.container = container
    }

    public func load() async {
        do {
            recoveredMetadata = try await container.audioRecovery.fetch()
            if let recoveredMetadata {
                guard FileManager.default.fileExists(atPath: recoveredMetadata.fileURL.path) else {
                    try await container.audioRecovery.clear()
                    self.recoveredMetadata = nil
                    resetCaptureState()
                    return
                }
                activeSessionID = recoveredMetadata.sessionID
                activeSourceID = recoveredMetadata.sourceID
                activeFileURL = recoveredMetadata.fileURL
                recordingStartDate = recoveredMetadata.recordingStartDate
                markers = recoveredMetadata.markers
                duration = recoveredMetadata.accumulatedDuration
                transition(to: .interrupted)
            }
        } catch {
            errorMessage = "Recording recovery data could not be loaded."
        }
    }

    public func recordTapped() async {
        clearPlaybackState()
        errorMessage = ""
        do {
            if try await container.audioConsent.acknowledgedAudioConsentVersion() == Self.audioConsentVersion {
                await prepareForRecordingPermission()
            } else {
                showConsentNotice = true
            }
        } catch {
            showConsentNotice = true
        }
    }

    public func acceptConsentAndPrepare() async {
        showConsentNotice = false
        try? await container.audioConsent.acknowledgeAudioConsent(version: Self.audioConsentVersion)
        await prepareForRecordingPermission()
    }

    public func resetAudioConsentForTesting() async {
        try? await container.audioConsent.resetAudioConsentAcknowledgement()
    }

    public func prepareForNewCapture() {
        errorMessage = ""
        showConsentNotice = false
        resetCaptureState()
        clearPlaybackState()
    }

    private func prepareForRecordingPermission() async {
        transition(to: .requestingPermission)
        let status = await container.audioRecorder.requestPermission()
        switch status {
        case .granted:
            transition(to: .ready)
        case .denied:
            transition(to: .failed)
            errorMessage = "Microphone permission was denied. You can enable it in Settings."
        case .restricted:
            transition(to: .failed)
            errorMessage = "Microphone access is restricted on this device."
        case .undetermined:
            transition(to: .failed)
            errorMessage = "Microphone permission is still undecided."
        }
    }

    public func startRecording() async {
        do {
            let sessionID = activeSessionID ?? UUID()
            let sourceID = activeSourceID ?? UUID()
            let url = try await container.mediaStorage.audioRecordingURL(sessionID: sessionID, sourceID: sourceID)
            activeSessionID = sessionID
            activeSourceID = sourceID
            activeFileURL = url
            recordingStartDate = recordingStartDate ?? Date()
            try await container.audioRecorder.startRecording(to: url, configuration: AudioRecordingConfiguration())
            transition(to: .recording)
            startRecordingTimer()
            await persistRecovery(reason: nil)
        } catch CocoaError.fileWriteOutOfSpace {
            stopRecordingTimer()
            transition(to: .failed)
            errorMessage = "There is not enough storage to start recording."
        } catch {
            stopRecordingTimer()
            transition(to: .failed)
            errorMessage = "Recording could not start."
        }
    }

    public func pauseRecording() async {
        guard state == .recording else { return }
        do {
            try await container.audioRecorder.pauseRecording()
            duration = await container.audioRecorder.currentDuration()
            stopRecordingTimer()
            transition(to: .paused)
            await persistRecovery(reason: nil)
        } catch {
            stopRecordingTimer()
            transition(to: .failed)
            errorMessage = "Recording could not pause."
        }
    }

    public func resumeRecording() async {
        guard state == .paused || state == .interrupted else { return }
        do {
            try await container.audioRecorder.resumeRecording()
            transition(to: .recording)
            startRecordingTimer()
            await persistRecovery(reason: nil)
        } catch {
            stopRecordingTimer()
            transition(to: .failed)
            errorMessage = "Recording could not resume."
        }
    }

    public func addMarker() async {
        let current = await container.audioRecorder.currentDuration()
        markers.append(AudioMarker(time: current))
        duration = current
        await persistRecovery(reason: nil)
    }

    public func stopAndSave() async {
        guard let sessionID = activeSessionID, let sourceID = activeSourceID, let fileURL = activeFileURL else { return }
        stopRecordingTimer()
        transition(to: .stopping)
        do {
            let finalDuration = try await container.audioRecorder.stopRecording()
            let title = "Audio Recording"
            let session = CaptureSession(id: sessionID, title: title, mode: .create, status: .ready)
            let source = CaptureSource(
                id: sourceID,
                sessionID: sessionID,
                sourceType: .liveAudio,
                localIdentifier: fileURL.path,
                originalFilename: fileURL.lastPathComponent,
                mimeType: "audio/mp4",
                duration: finalDuration,
                sourceURL: fileURL,
                transcriptOrigin: .unavailable
            )
            try await container.sessions.save(session)
            try await container.sources.save(source)
            try await container.audioRecovery.clear()
            duration = finalDuration
            savedSession = session
            savedSource = source
            transition(to: .completed)
        } catch {
            stopRecordingTimer()
            transition(to: .failed)
            await persistRecovery(reason: .saveFailure)
            errorMessage = "Recording could not be saved."
        }
    }

    public func cancelRecording() async {
        do {
            try await container.audioRecorder.cancelRecording()
            if let activeFileURL {
                try await container.mediaStorage.deleteMedia(at: activeFileURL)
            }
            try await container.audioRecovery.clear()
            stopRecordingTimer()
            resetLocalState()
        } catch {
            stopRecordingTimer()
            transition(to: .failed)
            errorMessage = "Recording cancellation failed."
        }
    }

    public func handleInterruption(_ reason: AudioRecordingInterruptionReason) async {
        guard state == .recording || state == .paused else { return }
        duration = await container.audioRecorder.currentDuration()
        stopRecordingTimer()
        transition(to: .interrupted)
        await persistRecovery(reason: reason)
    }

    public func recoverInterruptedRecording() async {
        guard recoveredMetadata != nil else { return }
        transition(to: .ready)
    }

    public func loadPlayback(url: URL) async {
        guard FileManager.default.fileExists(atPath: url.path) else {
            clearPlaybackState()
            playbackUnavailableMessage = "Recording file is no longer available on this device."
            return
        }

        do {
            playbackUnavailableMessage = ""
            playbackDuration = try await container.audioPlayback.load(url: url)
            playbackPosition = await container.audioPlayback.currentTime()
            isPlaybackPlaying = false
        } catch {
            clearPlaybackState()
            playbackUnavailableMessage = "Recording playback is unavailable for this file."
        }
    }

    public func play() async {
        do {
            try await container.audioPlayback.play()
            isPlaybackPlaying = await container.audioPlayback.isPlaying()
            startPlaybackTimer()
        } catch {
            isPlaybackPlaying = false
            errorMessage = "Recording playback could not start."
        }
    }

    public func pausePlayback() async {
        await container.audioPlayback.pause()
        playbackPosition = await container.audioPlayback.currentTime()
        isPlaybackPlaying = false
        stopPlaybackTimer()
    }

    public func seek(to time: TimeInterval) async {
        await container.audioPlayback.seek(to: time)
        playbackPosition = await container.audioPlayback.currentTime()
    }

    public func handlePlaybackInterruption() async {
        await pausePlayback()
    }

    private func persistRecovery(reason: AudioRecordingInterruptionReason?) async {
        guard let sessionID = activeSessionID,
              let sourceID = activeSourceID,
              let activeFileURL,
              let recordingStartDate else { return }
        let metadata = AudioRecordingRecoveryMetadata(
            sessionID: sessionID,
            sourceID: sourceID,
            fileURL: activeFileURL,
            recordingStartDate: recordingStartDate,
            accumulatedDuration: duration,
            pauseState: state,
            markers: markers,
            lastSuccessfulStateUpdate: Date(),
            interruptionReason: reason
        )
        try? await container.audioRecovery.save(metadata)
        recoveredMetadata = metadata
    }

    private func transition(to nextState: AudioRecordingState) {
        if machine.transition(to: nextState) {
            state = machine.state
        } else {
            machine = AudioRecordingStateMachine(initialState: nextState)
            state = nextState
        }
    }

    private func resetLocalState() {
        stopRecordingTimer()
        stopPlaybackTimer()
        resetCaptureState()
        clearPlaybackState()
    }

    private func resetCaptureState() {
        activeSessionID = nil
        activeSourceID = nil
        activeFileURL = nil
        recordingStartDate = nil
        markers = []
        duration = 0
        recoveredMetadata = nil
        savedSession = nil
        savedSource = nil
        machine = AudioRecordingStateMachine()
        state = .idle
    }

    private func clearPlaybackState() {
        stopPlaybackTimer()
        playbackDuration = 0
        playbackPosition = 0
        isPlaybackPlaying = false
        playbackUnavailableMessage = ""
    }

    private func startRecordingTimer() {
        stopRecordingTimer()
        recordingTimerTask = Task { [weak self] in
            while !Task.isCancelled {
                guard let self else { return }
                self.duration = await self.container.audioRecorder.currentDuration()
                try? await Task.sleep(nanoseconds: 200_000_000)
            }
        }
    }

    private func stopRecordingTimer() {
        recordingTimerTask?.cancel()
        recordingTimerTask = nil
    }

    private func startPlaybackTimer() {
        stopPlaybackTimer()
        playbackTimerTask = Task { [weak self] in
            while !Task.isCancelled {
                guard let self else { return }
                let position = await self.container.audioPlayback.currentTime()
                let playing = await self.container.audioPlayback.isPlaying()
                self.playbackPosition = position
                self.isPlaybackPlaying = playing
                if !playing {
                    if self.playbackDuration > 0, position >= self.playbackDuration - 0.05 {
                        await self.container.audioPlayback.seek(to: 0)
                        self.playbackPosition = 0
                    }
                    self.stopPlaybackTimer()
                    return
                }
                try? await Task.sleep(nanoseconds: 200_000_000)
            }
        }
    }

    private func stopPlaybackTimer() {
        playbackTimerTask?.cancel()
        playbackTimerTask = nil
    }
}
