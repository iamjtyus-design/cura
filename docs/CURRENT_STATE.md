# Current State

Phase 2A reliable local audio capture is implemented on top of the approved Phase 1.1 architecture cleanup.

Current foundation and Phase 1 slice:

1. Git repository initialized.
2. Native iOS Xcode project at `Cura.xcodeproj`.
3. Swift package foundation retained for fast core verification.
4. `CuraCore` framework target for shared domain code.
5. `CuraApp` native SwiftUI app target.
6. `CuraTests` unit test target.
7. `CuraUITests` UI test target.
8. Architecture folder structure from `ARCHITECTURE.md`.
9. Core domain models for Capture Sessions, sources, jobs, Curated Notes, generated outputs, Output Packs, Visual Briefs, folders, tags, and favorites.
10. Protocol-based dependency container with live, preview, and test containers currently backed by mocks.
11. In-memory local persistence abstractions.
12. Mock processing, export, subscription, authentication, analytics, and notification providers.
13. Design tokens from `DESIGN_SYSTEM.md`.
14. Development, staging, and production environment configuration.
15. CI workflow for secret scan, Swift tests, smoke tests, and native Xcode target builds.
16. Local secret scanning script.
17. Capture-first home screen with empty state.
18. Video import from Files for real user files, plus a deterministic UI-test video path.
19. Imported videos copied into app-local Application Support media folders.
20. Local Capture Session setup for title, mode, folder, and processing mode.
21. Local folders.
22. Mock processing stages: Preparing, Reading Video, Building Curated Note, Creating Creator Pack.
23. Persisted mock Curated Note and Creator Pack with Instagram Caption output.
24. Explicit Copy and Copy and Open Instagram actions.
25. Share Sheet fallback when Instagram cannot open.
26. Favorites.
27. JSON-backed local library persistence for sessions, sources, folders, favorites, Curated Notes, Output Packs, and generated outputs.
28. Unit coverage for JSON persistence.
29. UI coverage for the primary import, process, favorite, copy, and relaunch-persistence flow.
30. Phase 1 views split into focused feature files under `Cura/Features`.
31. `ContentView.swift` reduced to composition and routing.
32. `PhaseOneViewModel` now uses injected repositories and services from `DependencyContainer`.
33. JSON persistence remains the local implementation behind repository and media-storage abstractions.
34. Quick Send is behind `QuickSendProviding`.
35. Phase 1 mock timing and Creator Pack creation are behind `ProcessingProviding`.
36. Local audio recording flow with first-use consent notice.
37. AVFoundation-backed production audio recording and playback providers.
38. Mock audio recording and playback providers for preview, test, and UI-test flows.
39. Dedicated audio recording state machine.
40. Recovery metadata persistence for interrupted or incomplete recordings.
41. Local M4A/AAC audio storage through the media-storage abstraction.
42. Audio playback controls for play, pause, seek, duration, and current position.
43. Recording/session deletion paths.
44. Microphone usage description configured in the native iOS app.

Verification on 2026-07-20:

1. Xcode version: Xcode 26.6, build 17F113.
2. Simulator used: iPhone 17 Pro, iOS 26.5, UDID `0001DB82-B759-4301-AB9C-F79DC34B9867`.
3. Installed iOS/iOS Simulator SDK: 26.5.
4. `xcodebuild -project Cura.xcodeproj -target CuraApp -sdk iphonesimulator build` passes.
5. `xcodebuild -project Cura.xcodeproj -target CuraTests -sdk iphonesimulator build` passes.
6. `xcodebuild -project Cura.xcodeproj -target CuraUITests -sdk iphonesimulator build` passes.
7. `swift test` passes with 19 tests.
8. `swift run CuraSmokeTests` passes.
9. `sh scripts/secret_scan.sh` passes.
10. `xcodebuild -project Cura.xcodeproj -scheme CuraApp -destination 'id=0001DB82-B759-4301-AB9C-F79DC34B9867' test` passes.
11. Native scheme-level tests executed 19 unit tests and 2 UI tests with 0 failures.
12. Phase 0 commit is pushed to `origin/main`.
13. Phase 1 commit is pushed to `origin/main`.
14. Phase 2A changes are ready for final verification, commit, and push.

No cloud upload, transcription, AI generation, Supabase, RevenueCat, authentication, or Phase 2B work has started.
