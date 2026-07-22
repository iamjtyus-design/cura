import Foundation
#if os(iOS) && canImport(AVFoundation)
import AVFoundation
#endif

#if os(iOS) && canImport(AVFoundation) && DEBUG
fileprivate func debugAudioLog(_ event: String, url: URL? = nil, duration: TimeInterval? = nil, position: TimeInterval? = nil) {
    let session = AVAudioSession.sharedInstance()
    let route = session.currentRoute.outputs.map { "\($0.portType.rawValue):\($0.portName)" }.joined(separator: ", ")
    let exists = url.map { FileManager.default.fileExists(atPath: $0.path) } ?? false
    let fileSize = url.flatMap { try? FileManager.default.attributesOfItem(atPath: $0.path)[.size] as? NSNumber }?.intValue
    let path = url?.path ?? "nil"
    let sizeText = fileSize.map(String.init) ?? "nil"
    let durationText = duration.map { String($0) } ?? "nil"
    let positionText = position.map { String($0) } ?? "nil"
    print("[CURA Audio DEBUG] \(event) url=\(path) exists=\(exists) size=\(sizeText) duration=\(durationText) position=\(positionText) route=\(route)")
}
#endif

public struct AudioRecordingConfiguration: Equatable, Sendable {
    public var sampleRate: Double
    public var channelCount: Int
    public var bitRate: Int

    public init(sampleRate: Double = 44_100, channelCount: Int = 1, bitRate: Int = 128_000) {
        self.sampleRate = sampleRate
        self.channelCount = channelCount
        self.bitRate = bitRate
    }
}

public protocol AudioRecordingProviding: Sendable {
    func permissionStatus() async -> AudioRecordingPermissionStatus
    func requestPermission() async -> AudioRecordingPermissionStatus
    func startRecording(to url: URL, configuration: AudioRecordingConfiguration) async throws
    func pauseRecording() async throws
    func resumeRecording() async throws
    func stopRecording() async throws -> TimeInterval
    func cancelRecording() async throws
    func currentDuration() async -> TimeInterval
}

public protocol AudioPlaybackProviding: Sendable {
    func load(url: URL) async throws -> TimeInterval
    func play() async throws
    func pause() async
    func seek(to time: TimeInterval) async
    func currentTime() async -> TimeInterval
    func isPlaying() async -> Bool
}

#if os(iOS) && canImport(AVFoundation)
public enum AudioFileValidationError: Error, Equatable {
    case recorderDidNotStart
    case finalizedFileMissing
    case finalizedFileEmpty
    case finalizedFileHasNoDuration
    case playbackDidNotStart
}

public actor AVFoundationAudioRecordingProvider: AudioRecordingProviding {
    private var recorder: AVAudioRecorder?
    private var accumulatedDuration: TimeInterval = 0

    public init() {}

    public func permissionStatus() async -> AudioRecordingPermissionStatus {
        switch AVAudioApplication.shared.recordPermission {
        case .granted:
            return .granted
        case .denied:
            return .denied
        case .undetermined:
            return .undetermined
        @unknown default:
            return .restricted
        }
    }

    public func requestPermission() async -> AudioRecordingPermissionStatus {
        await withCheckedContinuation { continuation in
            AVAudioApplication.requestRecordPermission { granted in
                continuation.resume(returning: granted ? .granted : .denied)
            }
        }
    }

    public func startRecording(to url: URL, configuration: AudioRecordingConfiguration) async throws {
        try FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true)
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetoothHFP, .allowBluetoothA2DP])
        try session.setActive(true)

        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: configuration.sampleRate,
            AVNumberOfChannelsKey: configuration.channelCount,
            AVEncoderBitRateKey: configuration.bitRate
        ]
        let recorder = try AVAudioRecorder(url: url, settings: settings)
        recorder.isMeteringEnabled = true
        guard recorder.record() else {
            throw AudioFileValidationError.recorderDidNotStart
        }
        self.recorder = recorder
        accumulatedDuration = 0
#if DEBUG
        debugAudioLog("recording started", url: url)
#endif
    }

    public func pauseRecording() async throws {
        accumulatedDuration = await currentDuration()
        recorder?.pause()
    }

    public func resumeRecording() async throws {
        guard recorder?.record() == true else {
            throw AudioFileValidationError.recorderDidNotStart
        }
    }

    public func stopRecording() async throws -> TimeInterval {
        let duration = await currentDuration()
        recorder?.stop()
        let url = recorder?.url
        recorder = nil
        accumulatedDuration = duration
        try AVAudioSession.sharedInstance().setActive(false, options: [.notifyOthersOnDeactivation])
#if DEBUG
        if let url {
            debugAudioLog("recording stopped", url: url)
        }
#endif
        return duration
    }

    public func cancelRecording() async throws {
        recorder?.stop()
        if let url = recorder?.url, FileManager.default.fileExists(atPath: url.path) {
            try FileManager.default.removeItem(at: url)
        }
        recorder = nil
        accumulatedDuration = 0
    }

    public func currentDuration() async -> TimeInterval {
        if let recorder {
            return recorder.currentTime
        }
        return accumulatedDuration
    }
}

public actor AVFoundationAudioPlaybackProvider: AudioPlaybackProviding {
    private var player: AVAudioPlayer?

    public init() {}

    public func load(url: URL) async throws -> TimeInterval {
        let attributes = try FileManager.default.attributesOfItem(atPath: url.path)
        let fileSize = attributes[.size] as? NSNumber
        guard (fileSize?.intValue ?? 0) > 0 else {
            throw AudioFileValidationError.finalizedFileEmpty
        }

        let player = try AVAudioPlayer(contentsOf: url)
        player.prepareToPlay()
        guard player.duration > 0 else {
            throw AudioFileValidationError.finalizedFileHasNoDuration
        }
        self.player = player
#if DEBUG
        debugAudioLog("player loaded", url: url, duration: player.duration)
#endif
        return player.duration
    }

    public func play() async throws {
        guard let player else {
            throw CocoaError(.fileReadNoSuchFile)
        }
        if player.currentTime >= player.duration {
            player.currentTime = 0
        }
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetoothHFP, .allowBluetoothA2DP])
        try session.setActive(true)
        try? session.overrideOutputAudioPort(.speaker)
#if DEBUG
        debugAudioLog("play requested", duration: player.duration, position: player.currentTime)
#endif
        guard player.play() else {
            throw AudioFileValidationError.playbackDidNotStart
        }
    }

    public func pause() async {
        player?.pause()
    }

    public func seek(to time: TimeInterval) async {
        player?.currentTime = time
    }

    public func currentTime() async -> TimeInterval {
        player?.currentTime ?? 0
    }

    public func isPlaying() async -> Bool {
        player?.isPlaying ?? false
    }
}
#endif

public actor MockAudioRecordingProvider: AudioRecordingProviding {
    public var permission: AudioRecordingPermissionStatus
    public var shouldFailStart: Bool
    private var state: AudioRecordingState = .idle
    private var duration: TimeInterval = 0
    private var outputURL: URL?
    private var startedAt: Date?

    public init(permission: AudioRecordingPermissionStatus = .granted, shouldFailStart: Bool = false) {
        self.permission = permission
        self.shouldFailStart = shouldFailStart
    }

    public func permissionStatus() async -> AudioRecordingPermissionStatus {
        permission
    }

    public func requestPermission() async -> AudioRecordingPermissionStatus {
        permission
    }

    public func startRecording(to url: URL, configuration: AudioRecordingConfiguration) async throws {
        if shouldFailStart {
            throw CocoaError(.fileWriteOutOfSpace)
        }
        outputURL = url
        try FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true)
        try Data("mock m4a audio".utf8).write(to: url)
        state = .recording
        duration = 0
        startedAt = Date()
    }

    public func pauseRecording() async throws {
        duration = await currentDuration()
        state = .paused
        startedAt = nil
    }

    public func resumeRecording() async throws {
        state = .recording
        startedAt = Date()
    }

    public func stopRecording() async throws -> TimeInterval {
        state = .completed
        duration = max(await currentDuration(), 0.2)
        startedAt = nil
        return duration
    }

    public func cancelRecording() async throws {
        state = .idle
        duration = 0
        startedAt = nil
        if let outputURL, FileManager.default.fileExists(atPath: outputURL.path) {
            try FileManager.default.removeItem(at: outputURL)
        }
    }

    public func currentDuration() async -> TimeInterval {
        if let startedAt {
            return duration + Date().timeIntervalSince(startedAt)
        }
        return duration
    }
}

public actor MockAudioPlaybackProvider: AudioPlaybackProviding {
    private var duration: TimeInterval
    private var position: TimeInterval = 0
    private var startedAt: Date?
    private var isPlaybackActive = false

    public init(duration: TimeInterval = 3) {
        self.duration = duration
    }

    public func load(url: URL) async throws -> TimeInterval {
        position = 0
        startedAt = nil
        isPlaybackActive = false
        return duration
    }

    public func play() async throws {
        guard position < duration else {
            position = 0
            return
        }
        startedAt = Date()
        isPlaybackActive = true
    }

    public func pause() async {
        position = await currentTime()
        startedAt = nil
        isPlaybackActive = false
    }

    public func seek(to time: TimeInterval) async {
        position = min(max(time, 0), duration)
        if isPlaybackActive {
            startedAt = Date()
        }
    }

    public func currentTime() async -> TimeInterval {
        guard isPlaybackActive, let startedAt else {
            return position
        }
        let current = min(position + Date().timeIntervalSince(startedAt), duration)
        if current >= duration {
            position = duration
            self.startedAt = nil
            isPlaybackActive = false
        }
        return current
    }

    public func isPlaying() async -> Bool {
        _ = await currentTime()
        return isPlaybackActive
    }
}
