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
45. Phase 2A.1 recording duration updates several times per second while recording.
46. Phase 2A.1 playback publishes current time, total duration, playing state, and completion reset.
47. Playback scrubbing uses local slider state and defers provider seek until drag end.
48. Audio sessions use friendly "Audio Recording" presentation instead of raw UUID filenames.
49. Processing stages are hidden until processing is initiated and use source-aware "Reading Audio" or "Reading Video" copy.
50. Folder creation refreshes choices immediately and can assign the new folder to an existing session.
51. Learn/Create/Work and Private/Smart helper text is present without implying Smart currently uploads anything.
52. Phase 2A.2 prevents new audio captures from initializing playback until a saved recording exists.
53. Missing or stale playback files now show an inline recovery message instead of a recording-level alert on new capture.
54. Audio recording education consent is acknowledged once per local installation and versioned so it can reappear only when the consent text materially changes.
55. New capture sessions default to Create mode while preserving any later user-selected mode.
56. Session Detail exposes the editable title at the top of the screen and removes the duplicate lower title control.
57. Smart/Private presentation is static for the current build and clearly marks Smart enhancements as unavailable until a later approved phase.

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
14. Phase 2A commit is pushed to `origin/main`.
15. Device Debug signing is configured for automatic iPhone signing without committing a personal Team ID.
16. `CuraCore.framework` remains embedded with `CodeSignOnCopy` and is signed in device builds.
17. `CuraCore.framework` uses an embedded-framework install name of `@rpath/CuraCore.framework/CuraCore`.
18. `CuraApp` uses embedded-framework runpaths for `@executable_path/Frameworks` and `@loader_path/Frameworks`.

No cloud upload, transcription, AI generation, Supabase, RevenueCat, authentication, or Phase 2B work has started.

Signing verification on 2026-07-20:

1. Root cause of the physical-install failure was unconditional `CODE_SIGNING_ALLOWED = NO` in the Xcode project build settings, which produced an unsigned `Cura.app`.
2. `Cura.xcodeproj/project.pbxproj` now uses automatic signing with `CODE_SIGN_IDENTITY = Apple Development`.
3. `CODE_SIGNING_ALLOWED` is now `YES` for `iphoneos` and `NO` for `iphonesimulator`, keeping CI simulator builds team-free.
4. No `DEVELOPMENT_TEAM` or `PROVISIONING_PROFILE_SPECIFIER` value is committed.
5. Connected device build for iPhone `00008150-001643EA0C3A401C` succeeded with the team supplied as a local command-line override.
6. `codesign --verify --deep --strict --verbose=4` passed for the built `Cura.app`.
7. `codesign --verify --strict --verbose=4` passed for embedded `CuraCore.framework`.
8. Simulator scheme tests passed again on iPhone 17 Pro, iOS 26.5, UDID `0001DB82-B759-4301-AB9C-F79DC34B9867`.

Runtime-linking verification on 2026-07-20:

1. Root cause of the physical-launch dyld failure was `CuraCore.framework` resolving `LD_DYLIB_INSTALL_NAME` to `/Library/Frameworks/CuraCore.framework/CuraCore`.
2. `otool -D` on the embedded framework now reports `@rpath/CuraCore.framework/CuraCore`.
3. `otool -L` on `Cura.app/Cura` now links `@rpath/CuraCore.framework/CuraCore`.
4. Clean device build from `/tmp/cura-device-deriveddata` succeeded for connected iPhone `00008150-001643EA0C3A401C`.
5. `Cura.app/Frameworks/CuraCore.framework/CuraCore` exists in the rebuilt app bundle.
6. `codesign` verification passed for both the rebuilt app and embedded framework.
7. `xcrun devicectl device install app` installed `com.visionbuilt.cura` successfully on the connected iPhone.
8. Direct `devicectl` launch probes no longer report the prior dyld framework-load error, but the tool did not return a normal launch-completion record in this session.
9. A focused physical-device UI-test attempt was blocked by the test runner identifier `com.visionbuilt.cura.uitests.xctrunner` not being found; this was not a Cura app dyld failure.

Target-reference verification on 2026-07-20:

1. `Cura.xcodeproj/project.pbxproj` was audited for every `CuraCore.framework`, `build/Debug-iphoneos`, `PBXFileReference`, `PBXBuildFile`, `PBXTargetDependency`, and `PBXContainerItemProxy` reference.
2. No committed literal `build/Debug-iphoneos` framework path remained, but the `CuraCore.framework` build-file, product-file, target-dependency, and proxy identifiers were refreshed so Xcode uses the current target product reference.
3. `CuraCore.framework` now has one built-products `PBXFileReference` with `sourceTree = BUILT_PRODUCTS_DIR`.
4. `CuraApp` has exactly one `CuraCore.framework` entry in Link Binary With Libraries and exactly one in Embed Frameworks.
5. The embed build file preserves `CodeSignOnCopy` and `RemoveHeadersOnCopy`.
6. `CuraApp` has an explicit target dependency on `CuraCore`.
7. A clean physical-device build from `/tmp/cura-device-deriveddata` succeeded for connected iPhone `00008150-001643EA0C3A401C`.
8. The build log shows `CuraCore.framework` copied from `/tmp/cura-device-deriveddata/Build/Products/Debug-iphoneos/CuraCore.framework` into `Cura.app/Frameworks`.
9. `otool -L` on the rebuilt `Cura.app/Cura` reports `@rpath/CuraCore.framework/CuraCore` and does not report `/Library/Frameworks/CuraCore.framework/CuraCore`.
10. `otool -D` on the embedded `Cura.app/Frameworks/CuraCore.framework/CuraCore` reports `@rpath/CuraCore.framework/CuraCore`.
11. `xcrun devicectl device install app` installed `com.visionbuilt.cura` successfully on the connected iPhone.
12. Physical-device launch is now blocked by iOS security trust for the development signing profile/certificate, reported as `RequestDenied` with "invalid code signature, inadequate entitlements or its profile has not been explicitly trusted by the user"; no dyld `CuraCore` load error was reported.
13. Host `codesign --verify` reports `CSSMERR_TP_NOT_TRUSTED`, while `codesign -dv` confirms embedded signatures and team identifiers are present on both `Cura.app` and `CuraCore.framework`.
14. Simulator scheme tests passed again on iPhone 17 Pro, iOS 26.5, UDID `0001DB82-B759-4301-AB9C-F79DC34B9867`, with 19 unit tests and 2 UI tests.

Phase 2A.1 verification on 2026-07-20:

1. Root cause of the frozen recording timer was that the view model only sampled `currentDuration()` on discrete actions such as pause, marker, stop, or interruption.
2. Root cause of the playback progress and scrubbing issues was that playback position only refreshed after pause/seek, while the slider pushed a provider seek on every drag update.
3. `AudioRecordingViewModel` now owns cancellable recording and playback timer tasks that poll every 0.2 seconds and stop on pause, stop, cancel, interruption, completion, reset, or failure.
4. `AVFoundationAudioRecordingProvider` and the mock recorder preserve accurate accumulated duration across pause/resume.
5. `AVFoundationAudioPlaybackProvider` and the mock playback provider expose playing state, current time, seeking, and completion behavior.
6. `AudioPlaybackView` displays current time / total duration, uses local scrubbing state, and defers expensive seeking until the drag ends.
7. Simulator build passed on iPhone 17 Pro, iOS 26.5, UDID `0001DB82-B759-4301-AB9C-F79DC34B9867`.
8. Native simulator scheme tests passed with 27 unit tests and 2 UI tests.
9. `swift test` passed with 27 tests.
10. `swift run CuraSmokeTests` passed.
11. `sh scripts/secret_scan.sh` passed.
12. Device Debug build passed for connected iPhone `00008150-001643EA0C3A401C` with the local development team supplied outside committed source.
13. `codesign --verify --deep --strict --verbose=2` passed for the device `Cura.app`.
14. `xcrun devicectl device install app` installed `com.visionbuilt.cura` successfully.
15. `xcrun devicectl device process launch --terminate-existing com.visionbuilt.cura` launched successfully.
16. Physical-device UI automation passed the Phase 2A mock audio flow, including visible recording duration advancing beyond `00:00`, playback progress advancing beyond `00:00`, and relaunch persistence.
17. Physical-device UI automation reported a non-fatal Apple diagnostics collection warning after test success.

Phase 2A.2 verification on 2026-07-20:

1. Root cause of the new-capture playback warning was stale playback/session state being reused when opening the recorder after a saved or missing playback URL had been loaded.
2. `ContentView` now resets the audio recorder for a new capture before showing it, and `AudioRecordingViewModel` clears stale recovery metadata when its referenced file no longer exists.
3. Playback is initialized only after a saved audio source exists; missing files produce inline "Recording playback cannot be loaded" state on the playback controls.
4. Audio consent acknowledgement is stored in the local JSON library snapshot as a version string and can be reset by automated tests.
5. New audio sessions are created with Create as the default mode.
6. Simulator scheme-level tests passed on iPhone 17 Pro, iOS 26.5, UDID `0001DB82-B759-4301-AB9C-F79DC34B9867`, with 32 unit tests and 2 UI tests.
7. `swift run CuraSmokeTests` passed.
8. `sh scripts/secret_scan.sh` passed.
9. Device Debug build passed for connected iPhone `00008150-001643EA0C3A401C` with the local development team supplied outside committed source.
10. `xcrun devicectl device install app` installed `com.visionbuilt.cura` successfully.
11. `xcrun devicectl device process launch --terminate-existing com.visionbuilt.cura` launched successfully.
