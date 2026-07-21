# Decision Log

## D-001: Product name

**Decision:** CURA by VisionBuilt.  
**Meaning:** Capture. Understand. Refine. Activate.

## D-002: Core position

**Decision:** CURA is a capture and knowledge-activation product first.

## D-003: Primary modes

**Decision:** Learn, Create, and Work.

## D-004: Top-level object

**Decision:** Capture Session, which may contain multiple sources.

## D-005: Canonical result

**Decision:** Every completed session creates one Curated Note before Output Packs.

## D-006: Editing boundary

**Decision:** No professional video or image editing in V1. Basic text refinement and template-based Visual Brief editing are allowed.

## D-007: Publishing boundary

**Decision:** Quick Send may copy content and open another app. No automatic publishing or scheduling in V1.

## D-008: Website boundary

**Decision:** Initial website is marketing, waitlist, product education, privacy, support, and legal. Mission Control comes later.

## D-009: Privacy posture

**Decision:** Local originals by default, temporary cloud processing in Smart Mode, no permanent CURA cloud content storage by default.

## D-010: Technical platform

**Decision:** Native SwiftUI first. Web second. Android last.

## D-011: Visual Brief

**Decision:** Important text is rendered as real editable text through structured templates, not generated inside raster images.

## D-012: Reference strategy

**Decision:** Match valuable Notik capture and output capabilities, then exceed them through multimodal understanding, Apple integrations, Visual Briefs, user ownership, and Mission Control-ready structure.

## D-013: Swift package foundation for Phase 0

**Date:** 2026-07-20

**Decision:** Create a Swift package with `CuraCore`, `CuraApp`, formal test target files, and a smoke-test executable as the initial Phase 0 foundation.

**Reason:** The local environment has Swift Command Line Tools but does not have full Xcode selected, so a package foundation allows core models, dependency injection, mocks, design tokens, configuration, and smoke verification to compile now while preserving the native SwiftUI direction.

**Alternatives considered:**

1. Generate a full Xcode project immediately.
2. Wait for full Xcode before creating any foundation.
3. Build Phase 1 feature code without foundation verification.

**Consequences:**

1. The core foundation builds locally with `swift build`.
2. The native SwiftUI app shell exists but iOS simulator build/test must be rerun with full Xcode.
3. Formal unit/UI test targets are present, but local test execution is blocked by the Command Line Tools test-runtime issue.
4. No live AI, Supabase, RevenueCat, or paid service integration was added.

## D-014: Phase 0 providers remain mocked

**Date:** 2026-07-20

**Decision:** Back live, preview, and test dependency containers with local in-memory repositories and mock providers during Phase 0.

**Reason:** Phase 0 must establish boundaries without connecting live AI, Supabase, RevenueCat, or paid services.

**Alternatives considered:**

1. Add SDK dependencies now.
2. Stub only protocols without runnable mock behavior.

**Consequences:**

1. No server secrets are required or stored in the app.
2. The smoke test can verify processing and export boundaries without external services.
3. Production provider wiring remains explicitly deferred.

## D-015: Native Xcode project added

**Date:** 2026-07-20

**Decision:** Add `Cura.xcodeproj` with `CuraCore`, `CuraApp`, `CuraTests`, and `CuraUITests` targets.

**Reason:** Phase 0 requires a real native iOS Xcode project, not only a Swift package foundation.

**Alternatives considered:**

1. Keep Swift Package Manager as the only project definition.
2. Wait for XcodeGen or another generator.
3. Connect paid service SDKs while creating the project.

**Consequences:**

1. Native iOS app and test targets now build with Xcode.
2. Swift package verification remains available for fast local unit tests.
3. Live AI, Supabase, RevenueCat, and production persistence remain deferred.
4. Running native scheme tests still requires a compatible simulator runtime.

## D-016: CI target-build workaround before simulator runtime was stable

**Date:** 2026-07-20

**Decision:** Configure CI to run secret scanning, Swift package tests, smoke tests, and direct native Xcode target builds for the app, unit test bundle, and UI test bundle.

**Reason:** The local Xcode installation has iOS Simulator SDK 26.5, but the available simulator runtime is iOS 27.0, so scheme-level simulator test execution is blocked locally.

**Alternatives considered:**

1. Leave CI using a scheme/destination that cannot be verified locally.
2. Remove UI tests until a compatible simulator runtime exists.

**Consequences:**

1. CI still verifies compilation of the native app and test bundles.
2. Full simulator execution remains the next verification task.
3. Superseded by D-017 after the iOS 26.5 simulator runtime became available.

## D-017: Phase 0 scheme-level verification passed

**Date:** 2026-07-20

**Decision:** Treat Phase 0 foundation verification as complete after running the native `CuraApp` scheme tests on iPhone 17 Pro with iOS 26.5.

**Reason:** The installed simulator runtime now matches the Xcode iOS Simulator SDK, and Xcode successfully executed both unit and UI tests through the native scheme.

**Alternatives considered:**

1. Keep Phase 0 blocked because earlier simulator runtime mismatch existed.
2. Rely only on SwiftPM tests and target builds.

**Consequences:**

1. Phase 0 satisfies the build and test exit criteria.
2. Phase 1 remains blocked until explicit user approval.
3. CI can run the native scheme test command when a matching simulator is available.

## D-018: Phase 1 local library uses JSON persistence

**Date:** 2026-07-20

**Decision:** Use a JSON-backed local library store under Application Support for the first mock-driven vertical slice.

**Reason:** Phase 1 requires relaunch persistence for sessions, sources, folders, favorites, Curated Notes, Output Packs, and generated outputs, while production persistence and cloud services remain out of scope.

**Alternatives considered:**

1. Keep only in-memory repositories.
2. Introduce SwiftData or Core Data immediately.
3. Connect Supabase or another cloud database.

**Consequences:**

1. Phase 1 can prove the local-first flow and relaunch behavior without paid or live services.
2. Imported videos are preserved locally in app storage.
3. Production persistence remains a later migration decision.

## D-019: Phase 1 social activation boundary

**Date:** 2026-07-20

**Decision:** Copy and Instagram handoff require an explicit user tap; if Instagram cannot open, CURA shows the iOS Share Sheet.

**Reason:** The Constitution and Phase 1 scope prohibit automatic publishing and require user approval before anything leaves CURA.

**Alternatives considered:**

1. Automatically open Instagram after processing.
2. Automatically publish or schedule generated content.
3. Omit the Instagram handoff from Phase 1.

**Consequences:**

1. Clipboard writes happen only after explicit user action.
2. No content is published by CURA.
3. The activation path remains mock/local and user-controlled.

## D-020: Phase 1.1 feature boundaries

**Date:** 2026-07-20

**Decision:** Split the Phase 1 vertical slice into feature files under `Cura/Features` and keep `ContentView.swift` as the routing/composition entry point.

**Reason:** The Phase 1 implementation worked, but the view file had grown too large for maintainable Phase 2 work.

**Alternatives considered:**

1. Leave the vertical slice in `ContentView.swift`.
2. Move the entire app flow into a single coordinator.
3. Start Phase 2 before cleaning the Phase 1 structure.

**Consequences:**

1. User-visible behavior remains unchanged.
2. Phase 2 can build on focused Home, Session Setup, Session Detail, Processing, Library, Quick Send, and Phase One files.
3. The native Xcode project now explicitly includes the new feature files.

## D-021: Phase 1.1 dependency boundary

**Date:** 2026-07-20

**Decision:** Route Phase 1 persistence, media storage, mock processing, and Quick Send through `DependencyContainer` protocols.

**Reason:** `PhaseOneViewModel` should orchestrate the flow without constructing `JSONLocalLibraryStore` or owning clipboard/open-app behavior directly.

**Alternatives considered:**

1. Keep direct JSON store construction inside the view model.
2. Introduce production persistence before Phase 2.
3. Move Quick Send into SwiftUI views.

**Consequences:**

1. `JSONLocalLibraryStore` remains the local Phase 1 implementation behind repository and media-storage abstractions.
2. Mock processing timing and Creator Pack creation are owned by `ProcessingProviding`.
3. Clipboard and Instagram fallback behavior are owned by `QuickSendProviding`.
4. Live AI, Supabase, RevenueCat, authentication, paid services, audio recording, video editing, and automatic publishing remain unstarted.

## D-022: Phase 2A audio is local-only

**Date:** 2026-07-20

**Decision:** Implement reliable audio capture as a local-only feature using AVFoundation and local persistence.

**Reason:** Phase 2A explicitly excludes cloud upload, transcription, AI generation, Supabase, RevenueCat, authentication, and Phase 2B work.

**Consequences:**

1. Audio recordings are stored locally as M4A/AAC files through the media-storage abstraction.
2. Completed recordings create local Capture Sessions and live-audio Capture Sources.
3. No remote service, transcript, or generated output is created by the audio flow.

## D-023: Audio recovery metadata

**Date:** 2026-07-20

**Decision:** Persist active recording recovery metadata in the local JSON library snapshot.

**Reason:** Interrupted or incomplete recordings need recoverable context without introducing production persistence or sync.

**Consequences:**

1. Recovery metadata includes session ID, source ID, file URL, start date, accumulated duration, pause state, markers, last update, and interruption reason.
2. Relaunch can surface an interrupted recording when metadata exists.
3. Production persistence can later migrate this metadata behind the same repository contract.

## D-024: Device Debug signing without committed team ID

**Date:** 2026-07-20

**Decision:** Configure Xcode signing so physical `iphoneos` Debug builds can be automatically signed, while simulator builds remain unsigned for CI.

**Reason:** Physical installation failed with `0xe800801c` because `Cura.app` was built with code signing disabled.

**Consequences:**

1. `CODE_SIGNING_ALLOWED` is enabled only for `iphoneos` and disabled for `iphonesimulator`.
2. `CODE_SIGN_STYLE` is Automatic and `CODE_SIGN_IDENTITY` is Apple Development.
3. No personal `DEVELOPMENT_TEAM` is committed; local device builds can supply the team through Xcode selection or command-line override.
4. `CuraCore.framework` is signed in device builds and signed again on embed through `CodeSignOnCopy`.

## D-025: Embedded framework install name

**Date:** 2026-07-20

**Decision:** Configure `CuraCore.framework` with an embedded-framework install name and configure `CuraApp` with explicit embedded-framework runpaths.

**Reason:** Physical-device launch failed because `CuraCore.framework` advertised `/Library/Frameworks/CuraCore.framework/CuraCore`, but the framework is embedded inside `Cura.app/Frameworks`.

**Consequences:**

1. `CuraCore` now uses `INSTALL_PATH = @rpath`, `DYLIB_INSTALL_NAME_BASE = @rpath`, and `LD_DYLIB_INSTALL_NAME = @rpath/CuraCore.framework/CuraCore`.
2. `CuraApp` now includes `@executable_path/Frameworks` and `@loader_path/Frameworks` in `LD_RUNPATH_SEARCH_PATHS`.
3. The app continues to embed and sign `CuraCore.framework`.
4. Product behavior is unchanged.

## D-026: CuraCore target product reference refresh

**Date:** 2026-07-20

**Decision:** Refresh the `CuraCore.framework` product file reference, app link build file, app embed build file, test link build file, target dependencies, and container item proxies so all app references resolve through the current `CuraCore` target product in `BUILT_PRODUCTS_DIR`.

**Reason:** Xcode displayed the embedded framework with a build-products path, and the physical device still reported the old runtime behavior after Derived Data was deleted. The committed project did not contain a literal stale `build/Debug-iphoneos` framework path, so the safest non-product change was to rebuild the target-product graph with fresh references and preserve the target dependency.

**Consequences:**

1. `CuraApp` has exactly one `CuraCore.framework` in Link Binary With Libraries and one in Embed Frameworks.
2. The embed step preserves `CodeSignOnCopy`.
3. `CuraApp` explicitly depends on the `CuraCore` target.
4. `CuraCore.framework` remains the local framework product and is not converted to a package or copied from a path-based reference.
5. Product behavior is unchanged.

## D-027: Phase 2A.1 observable audio time

**Date:** 2026-07-20

**Decision:** Drive recording and playback time display from cancellable `AudioRecordingViewModel` timer tasks that poll injected audio providers every 0.2 seconds.

**Reason:** Physical-device testing showed that real recording and playback continued while the visible recording timer and playback progress stayed stale. The view model should publish observable state while providers remain responsible for AVFoundation details.

**Consequences:**

1. Recording duration updates several times per second during active recording.
2. Accumulated duration is preserved across pause/resume.
3. Playback position, total duration, playing state, seeking, and completion reset are testable through provider protocols.
4. Timers are stopped on pause, stop, cancel, interruption, failure, completion, and reset.
5. No cloud upload, transcription, AI generation, Supabase, RevenueCat, authentication, or Phase 2B work is introduced.

## D-028: Phase 2A.1 source-aware session presentation

**Date:** 2026-07-20

**Decision:** Keep saved audio sessions friendly and source-aware by labeling recordings as "Audio Recording", hiding processing stages until processing starts, and changing the read stage copy based on source type.

**Reason:** Physical-device testing showed audio sessions were exposing raw UUID filenames, unused mock processing stages, and video-specific processing copy even when the source was audio.

**Consequences:**

1. UUID filenames remain available only as secondary file metadata.
2. Audio processing copy says "Reading Audio"; video processing copy says "Reading Video".
3. Unprocessed saved audio sessions no longer show mock processing stages.
4. Folder creation refreshes choices immediately and can assign the created folder to an existing session.
5. Learn/Create/Work and Private/Smart helper text clarifies intent without implying current Smart-mode cloud upload.
