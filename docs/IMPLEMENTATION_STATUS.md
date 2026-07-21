# Implementation Status

## Current Phase

Phase 2A reliable local audio capture is implemented and verified locally. Phase 2B has not started.

## Completed

1. Product Constitution.
2. Product Requirements.
3. Brand strategy.
4. App flow.
5. Output Pack specification.
6. Visual Brief specification.
7. Technical architecture.
8. Privacy and legal framework.
9. Website specification.
10. Roadmap.
11. Starter database and JSON schemas.
12. Codex repository instructions.
13. Git repository initialized.
14. Native Xcode project.
15. Swift package foundation.
16. Native SwiftUI app shell.
17. Architecture folder structure.
18. Core domain models.
19. Dependency container.
20. Live, preview, and test container entry points backed by mocks.
21. In-memory local persistence abstractions.
22. Mock processing, export, subscription, authentication, analytics, and notification providers.
23. Design tokens.
24. Environment configuration.
25. CI workflow.
26. Secret scanning script.
27. Phase 0 smoke-test executable.
28. Unit tests.
29. UI test target.
30. Native scheme-level test verification.
31. Push to `origin/main`.
32. Video import from Files into a local Capture Session.
33. Local preservation of imported videos under Application Support media folders.
34. Session setup for title, mode, folder, and processing mode.
35. Local folder creation.
36. Mock processing stage display.
37. Mock Curated Note generation and persistence.
38. Mock Creator Pack generation and persistence.
39. Instagram Caption output display.
40. Explicit Copy action.
41. Explicit Copy and Open Instagram action with Share Sheet fallback.
42. Favorites.
43. JSON-backed local library persistence for Phase 1 entities.
44. UI test coverage for the primary Phase 1 flow and relaunch persistence.
45. Phase 1 feature views split out of `ContentView.swift`.
46. Repository contracts extended for Phase 1 persisted entities and media storage.
47. `PhaseOneViewModel` refactored to use injected dependencies.
48. Quick Send behavior moved behind `QuickSendProviding`.
49. Phase 1 mock processing output creation moved behind `ProcessingProviding`.
50. Focused Phase 1.1 view-model unit tests.
51. Local audio-recording flow with consent, permission handling, visible recording controls, pause/resume, markers, stop/save, playback, metadata editing, deletion, and relaunch persistence.
52. `AudioRecordingProviding` and `AudioPlaybackProviding` protocols.
53. AVFoundation production recording and playback providers.
54. Preview/test/mock audio providers.
55. Audio recording state machine.
56. Audio recovery metadata persistence.
57. Microphone usage description in app build settings.
58. Audio unit tests and mock audio UI test.
59. Phase 2A.1 observable recording timer backed by cancellable view-model polling and provider accumulated duration.
60. Phase 2A.1 playback progress, current/total duration display, smooth deferred seeking, and completion reset.
61. Source-aware processing labels and hidden processing stages for unprocessed saved audio sessions.
62. Friendly audio recording presentation that keeps UUID filenames as secondary metadata only.
63. Immediate folder refresh and assignment for newly created folders in setup and detail flows.
64. Helper copy for Learn, Create, Work, Private, and Smart modes without adding cloud behavior.

## Verification

1. Xcode 26.6 build 17F113 is active at `/Applications/Xcode.app/Contents/Developer`.
2. `xcodebuild -project Cura.xcodeproj -target CuraApp -sdk iphonesimulator build` passes.
3. `xcodebuild -project Cura.xcodeproj -target CuraTests -sdk iphonesimulator build` passes.
4. `xcodebuild -project Cura.xcodeproj -target CuraUITests -sdk iphonesimulator build` passes.
5. `swift test` passes 27 tests.
6. `swift run CuraSmokeTests` passes.
7. `sh scripts/secret_scan.sh` passes.
8. `xcodebuild -project Cura.xcodeproj -scheme CuraApp -destination 'id=0001DB82-B759-4301-AB9C-F79DC34B9867' test` passes.
9. Native scheme-level verification executed 27 unit tests and 2 UI tests with 0 failures.
10. Device Debug build for connected iPhone `00008150-001643EA0C3A401C` passes when the local development team is supplied outside committed source.
11. `Cura.app` and embedded `CuraCore.framework` pass `codesign` verification.
12. `otool -D` verifies embedded `CuraCore.framework` uses `@rpath/CuraCore.framework/CuraCore`.
13. `otool -L` verifies `Cura.app/Cura` links `CuraCore` through `@rpath`.
14. Clean device build and device install pass for connected iPhone `00008150-001643EA0C3A401C`.
15. `CuraCore.framework` project references were refreshed to a single `BUILT_PRODUCTS_DIR` file reference used by the app link phase, app embed phase, core product reference, and test link phase.
16. `CuraApp` explicitly depends on the `CuraCore` target.
17. Clean device build logs show `CuraCore.framework` is embedded from the current device build products directory.
18. Current device `otool -L` output for `Cura.app/Cura` contains `@rpath/CuraCore.framework/CuraCore` and not `/Library/Frameworks/CuraCore.framework/CuraCore`.
19. Current device `otool -D` output for embedded `CuraCore.framework/CuraCore` is `@rpath/CuraCore.framework/CuraCore`.
20. `xcrun devicectl device install app` succeeds for `com.visionbuilt.cura`.
21. Simulator scheme-level verification still passes with 27 unit tests and 2 UI tests.
22. Phase 2A.1 device Debug build passed for connected iPhone `00008150-001643EA0C3A401C`.
23. `codesign --verify --deep --strict --verbose=2` passed for the Phase 2A.1 device `Cura.app`.
24. Device install and launch passed for `com.visionbuilt.cura`.
25. Physical-device UI automation passed the Phase 2A mock audio flow, including recording duration advancement, playback progress advancement, and relaunch persistence.

## Blocked

1. Apple Developer account details for committed release/distribution signing.
2. Supabase project.
3. RevenueCat project.
4. Production AI provider accounts.
5. Final domain and support email.
6. Trademark clearance.
7. Legal review.
8. Final pricing after cost tests.

## Deferred

1. Mission Control.
2. Persistent cloud sync.
3. Android.
4. Apple Watch.
5. Direct social publishing.
6. Social scheduling.
7. Professional editing.
8. Team workspaces.
9. Live AI.
10. Supabase integration.
11. RevenueCat integration.
12. Production persistence.
13. Live transcription.
14. Cloud upload.
15. AI generation.
16. Phase 2B.
14. Video editing.
15. Automatic publishing.

## Next Milestone

Phase 2A.1 satisfies its physical-device audio reliability checks. The exact next recommended action is to approve Phase 2B scope before starting any transcription, cloud upload, AI generation, Supabase, authentication, RevenueCat, or other remote-service work.
