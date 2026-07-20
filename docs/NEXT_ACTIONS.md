# Next Actions

1. Install an iOS 26.5 simulator runtime or an Xcode/iOS SDK combination compatible with the installed iOS 27.0 runtime.
2. Rerun `xcodebuild -project Cura.xcodeproj -scheme CuraApp -destination 'platform=iOS Simulator,name=iPhone 17 Pro' test`.
3. Add a GitHub remote and push the Phase 0 commit if a remote is not already configured.
4. Confirm signing bundle identifiers and Apple Developer team values without committing secrets.
5. After approval and simulator test verification, begin the Phase 1 video-import mock vertical slice only.
