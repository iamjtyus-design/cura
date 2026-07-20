# Current State

Phase 0 foundation is implemented and remains limited to architecture, models, mocks, configuration, tests, CI, and documentation.

Current foundation:

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

Verification on 2026-07-20:

1. Xcode version: Xcode 26.6, build 17F113.
2. Available CoreSimulator runtime: iOS 27.0.
3. Installed iOS/iOS Simulator SDK: 26.5.
4. `xcodebuild -project Cura.xcodeproj -target CuraApp -sdk iphonesimulator build` passes.
5. `xcodebuild -project Cura.xcodeproj -target CuraTests -sdk iphonesimulator build` passes.
6. `xcodebuild -project Cura.xcodeproj -target CuraUITests -sdk iphonesimulator build` passes.
7. `swift test` passes with 4 tests.
8. `swift run CuraSmokeTests` passes.
9. `sh scripts/secret_scan.sh` passes.
10. `xcodebuild ... -scheme CuraApp -destination 'platform=iOS Simulator,name=iPhone 17 Pro' test` is blocked because Xcode has SDK 26.5 while the only available iOS simulator runtime is 27.0.

No Phase 1 work has started.
