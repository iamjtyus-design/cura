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
