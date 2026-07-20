# CURA Technical Architecture

## Document Status

**Product:** CURA by VisionBuilt  
**Version:** 1.0  
**Primary platform:** iPhone  
**Primary source of truth:** `CURA_PRODUCT_CONSTITUTION.md`

This document defines how CURA should be built.

It covers:

1. Native iOS architecture.
2. Capture and media processing.
3. Local-first storage.
4. Temporary cloud processing.
5. AI provider routing.
6. Supabase.
7. Authentication.
8. Subscriptions.
9. Apple Shortcuts.
10. Security.
11. Privacy.
12. Mission Control readiness.
13. Reliability.
14. Observability.
15. Testing.
16. Deployment.

When this document conflicts with the Product Constitution, the Constitution wins.

---

## 1. Architecture Goals

The system must:

1. Make capture fast.
2. Preserve user data during interruptions.
3. Keep originals local by default.
4. Use temporary cloud processing when needed.
5. Delete temporary source media automatically.
6. Support audio, video, images, documents, and links.
7. Understand both audio and visual content.
8. Produce one canonical Curated Note.
9. Generate reusable output packs.
10. Support Apple Shortcuts.
11. Support user-owned exports.
12. Enforce subscription limits server-side.
13. Avoid vendor lock-in.
14. Prepare for Mission Control.
15. Remain understandable to future engineers and Codex sessions.

---

## 2. High-Level System

```text
iPhone App
  |
  |-- Local Capture and Library
  |-- AVFoundation Recording
  |-- Video and Image Import
  |-- Vision OCR
  |-- App Intents
  |-- Files and iCloud Export
  |-- Local Persistence
  |
  +--> Supabase Auth
  |
  +--> Temporary Processing API
          |
          |-- Signed Temporary Upload
          |-- Processing Jobs
          |-- Speech-to-Text Provider
          |-- Gemini Video Understanding
          |-- Document Understanding
          |-- Structured Intelligence Generation
          |-- Visual Brief Schema Generation
          |-- Temporary Storage Cleanup
          |
          +--> Results Returned to Device
```

Future:

```text
CURA iPhone
  |
  +--> Optional Sync Layer
          |
          +--> Mission Control Web Dashboard
```

---

## 3. Core Architectural Decision

CURA should use a hybrid local-first architecture.

### Local responsibilities

1. Record audio and video.
2. Maintain local session library.
3. Store originals by default.
4. Recover interrupted drafts.
5. Store Curated Notes and outputs.
6. Render standard Visual Briefs.
7. Export to Files and iCloud.
8. Handle App Intents.
9. Perform lightweight OCR where practical.
10. Manage user-selected folders.

### Cloud responsibilities

1. Authentication.
2. Subscription state.
3. Temporary media processing.
4. Long-running job coordination.
5. Speech-to-text.
6. Video understanding.
7. Document understanding.
8. Structured AI generation.
9. Usage metering.
10. Temporary deletion.
11. Future opt-in sync.

### Architectural principle

The app should still open, display local sessions, and export local data when backend services are unavailable.

Cloud failure must not make the user’s local library inaccessible.

---

## 4. iOS Technology Stack

Use:

1. Swift 6.
2. SwiftUI.
3. Swift Concurrency.
4. Observation framework.
5. AVFoundation.
6. Vision.
7. PhotosUI.
8. Uniform Type Identifiers.
9. App Intents.
10. BackgroundTasks where appropriate.
11. URLSession.
12. FileDocument.
13. UIDocumentPicker.
14. UserNotifications.
15. Keychain.
16. Security-scoped bookmarks.
17. RevenueCat iOS SDK.
18. Supabase Swift SDK.

Avoid introducing a cross-platform UI framework for V1.

Native iOS is a strategic advantage because CURA depends heavily on:

1. Apple Shortcuts.
2. Recording.
3. Files.
4. Photos.
5. Background audio.
6. Share extensions.
7. Apple Watch later.
8. Native performance.
9. Native privacy indicators.
10. App Store quality.

---

## 5. Recommended iOS Application Structure

```text
Cura/
  App/
    CuraApp.swift
    AppCoordinator.swift
    DependencyContainer.swift
    AppEnvironment.swift

  Core/
    Configuration/
    Models/
    Networking/
    Persistence/
    Security/
    Logging/
    Utilities/
    Extensions/

  DesignSystem/
    Tokens/
    Components/
    Typography/
    Icons/
    Motion/
    Accessibility/

  Features/
    Authentication/
    Onboarding/
    Home/
    Capture/
    AudioRecorder/
    VideoCapture/
    MediaImport/
    LinkImport/
    DocumentImport/
    SessionSetup/
    Processing/
    Sessions/
    SessionDetail/
    CuratedNote/
    Learn/
    Create/
    Work/
    OutputPacks/
    VisualBrief/
    Library/
    Folders/
    Favorites/
    Search/
    Export/
    QuickSend/
    Settings/
    Privacy/
    Subscription/
    Help/

  Services/
    Audio/
    Video/
    OCR/
    Media/
    Upload/
    Processing/
    Supabase/
    AI/
    Export/
    FileAccess/
    Purchases/
    Analytics/
    Notifications/

  AppIntents/
  ShareExtension/
  Resources/
  Tests/
  UITests/
```

Feature modules should own screens and presentation logic.

Services should own reusable capabilities.

Core should contain shared domain rules and infrastructure.

---

## 6. Architectural Pattern

Use a pragmatic layered architecture.

Recommended layers:

1. Presentation.
2. Domain.
3. Data.
4. Infrastructure.

### Presentation

1. SwiftUI views.
2. View models or observable feature models.
3. Navigation.
4. User interaction.
5. Accessibility.

### Domain

1. Capture Session rules.
2. Processing state machine.
3. Curated Note rules.
4. Output Pack rules.
5. Subscription eligibility.
6. Export policies.
7. Privacy-mode behavior.

### Data

1. Local repositories.
2. Remote repositories.
3. Mapping.
4. Caching.
5. Persistence.

### Infrastructure

1. AVFoundation.
2. Supabase.
3. AI providers.
4. RevenueCat.
5. Files.
6. Keychain.
7. Analytics.
8. Logging.

Do not put backend calls directly inside SwiftUI views.

Do not put domain rules only inside App Intents.

---

## 7. Dependency Injection

Use protocol-driven dependency injection.

Example service contracts:

```swift
protocol CaptureSessionRepository
protocol CaptureSourceRepository
protocol CuratedNoteRepository
protocol OutputPackRepository
protocol FolderRepository
protocol SearchRepository
protocol RecordingService
protocol VideoProcessingService
protocol OCRService
protocol UploadService
protocol ProcessingService
protocol ExportService
protocol QuickSendService
protocol SubscriptionService
protocol AuthenticationService
protocol AnalyticsService
protocol NotificationService
```

The app should provide:

1. Live dependencies.
2. Preview dependencies.
3. Test dependencies.
4. Mock processing dependencies.

This allows the first vertical slice to work without live AI.

---

## 8. Domain Models

Required iOS domain models:

```text
User
CaptureSession
CaptureSource
ProcessingJob
ProcessingStage
Transcript
TranscriptSegment
VisualObservation
DocumentObservation
CuratedNote
EvidenceReference
GeneratedOutput
OutputPack
VisualBrief
VisualBriefSection
Folder
Tag
Favorite
ExportDestination
ExportEvent
ProcessingMode
SubscriptionEntitlement
UsageSnapshot
BrandVoiceProfile
```

Mission Control-ready models:

```text
Idea
Decision
ActionItem
Commitment
Person
Organization
Project
Risk
KnowledgeTopic
ContentOpportunity
EntityLink
```

Not every Mission Control-ready model must have full UI in V1.

The data structure should preserve them.

---

## 9. Capture Session Data Model

Suggested local structure:

```swift
struct CaptureSession: Identifiable, Codable, Sendable {
    let id: UUID
    var title: String
    var mode: SessionMode
    var status: SessionStatus
    var processingMode: ProcessingMode
    var outputLanguage: String
    var folderID: UUID?
    var isFavorite: Bool
    var tags: [String]
    var sourceIDs: [UUID]
    var curatedNoteID: UUID?
    var createdAt: Date
    var updatedAt: Date
}
```

### Session modes

```text
learn
create
work
unselected
```

### Session statuses

```text
draft
capturing
ready
processing
partially_complete
complete
failed
cancelled
deleting
deleted
```

---

## 10. Capture Source Data Model

Suggested fields:

```text
id
session_id
source_type
local_url
temporary_remote_path
original_filename
mime_type
file_size
duration
page_count
source_url
transcript_origin
created_at
processing_status
deletion_status
```

### Source types

```text
audio_recording
audio_file
video_recording
video_file
photo
screenshot
pdf
web_page
youtube_url
social_url
text_note
```

### Transcript origin

```text
speech_to_text
official_caption
gemini_reconstruction
ocr
manual
imported_text
none
```

---

## 11. Local Persistence

Recommended approach:

1. SwiftData or SQLite-backed repository.
2. File-system storage for media and exported artifacts.
3. Keychain for credentials and sensitive tokens.
4. Application Support directory for user data.
5. Caches directory only for regenerable data.
6. Temporary directory only for short-lived processing artifacts.

### Local persistence requirements

1. Atomic writes.
2. Migration strategy.
3. Recovery from partial writes.
4. File protection.
5. Stable identifiers.
6. Background-safe access.
7. Exportable formats.
8. Testable repositories.
9. No silent destructive migration.
10. Clear storage cleanup.

### SwiftData decision

SwiftData is acceptable for app metadata if:

1. Migration tests are implemented.
2. Media remains outside the database.
3. Repository protocols isolate persistence.
4. Export does not depend on SwiftData internals.

SQLite may be used directly if stronger control is needed.

---

## 12. Local File Structure

Recommended structure:

```text
Application Support/
  Sessions/
    {session_id}/
      session.json
      Sources/
        {source_id}/
          original.m4a
          original.mp4
          image.jpg
          document.pdf
          source.json
      Derived/
        transcript.json
        curated-note.json
        outputs/
        visual-briefs/
      Exports/
```

Do not expose internal storage paths as stable public contracts.

---

## 13. File Protection

Apply appropriate iOS file protection.

Recommended:

1. User originals: complete file protection when device is locked where practical.
2. Temporary upload files: strongest usable protection.
3. Cached thumbnails: protected unless operational needs differ.
4. Exported Files: governed by destination storage.

Document any background-recording exception that requires access while locked.

---

## 14. Audio Recording Architecture

Use AVFoundation.

Required capabilities:

1. Microphone permission.
2. Start.
3. Pause.
4. Resume.
5. Stop.
6. Background audio.
7. Audio interruption handling.
8. Route change handling.
9. Input source changes.
10. Local draft recovery.
11. Audio level data.
12. Marker timestamps.

Recommended format:

1. M4A.
2. AAC.
3. Configurable quality.
4. Practical sample rate.
5. Mono by default unless stereo is valuable.

Do not promise cellular call recording.

---

## 15. Recording Recovery

Persist:

1. Session ID.
2. Source ID.
3. Recording start time.
4. Current file URL.
5. Duration.
6. Pause state.
7. Markers.
8. Last successful file write.
9. Interruption reason.

On relaunch:

1. Detect incomplete recording.
2. Validate file.
3. Offer recovery.
4. Avoid deleting recoverable audio automatically.

---

## 16. Video Processing Architecture

For uploaded video:

```text
Video File
  |
  |-- Extract Audio
  |-- Extract Metadata
  |-- Generate Key Frames
  |-- OCR Frames
  |-- Send Supported Video to Multimodal Provider
  |-- Merge Audio and Visual Results
```

### On-device preprocessing

Use AVFoundation for:

1. Duration.
2. Track inspection.
3. Thumbnail generation.
4. Audio extraction.
5. Key-frame sampling.
6. Orientation normalization.

Use Vision for:

1. OCR.
2. Text bounding boxes.
3. Confidence.
4. Language hints.

### Server processing

Use multimodal provider for:

1. Visual context.
2. Demonstrated actions.
3. Scene understanding.
4. Interface understanding.
5. Relationship between audio and visuals.
6. Timestamped video analysis.

---

## 17. Key-Frame Strategy

Do not upload every frame individually by default.

Use:

1. Scene-change sampling.
2. Fixed interval sampling.
3. Text-change detection.
4. User markers.
5. Audio emphasis.
6. Screen-recording awareness.
7. Provider-native video input where supported.

Store:

```text
frame_id
source_id
timestamp
local_thumbnail_url
ocr_text
ocr_confidence
visual_summary
selection_reason
```

---

## 18. OCR Strategy

Use Apple Vision locally where practical.

OCR output:

```text
recognized_text
confidence
bounding_box
language
frame_timestamp
page_number
source_id
```

Use server OCR or multimodal fallback when:

1. Local OCR quality is poor.
2. Complex documents need layout understanding.
3. Handwriting is present.
4. Multi-column layout is difficult.
5. Additional semantic interpretation is required.

---

## 19. Document Processing

### PDFs

Pipeline:

1. Inspect file.
2. Extract embedded text.
3. Detect scanned pages.
4. OCR scanned pages.
5. Preserve page references.
6. Chunk text.
7. Generate document observations.
8. Add to session merge.

### Web pages

Pipeline:

1. Validate URL.
2. Fetch allowed public content.
3. Extract title and body.
4. Preserve canonical URL.
5. Remove navigation clutter.
6. Store source metadata.
7. Process into Curated Note.

Respect access restrictions.

---

## 20. YouTube Architecture

Primary approach:

1. Accept supported public YouTube URL.
2. Canonicalize video ID.
3. Create Capture Source.
4. Send public URL to Gemini video-understanding provider.
5. Request timestamped analysis.
6. Use authorized captions when available.
7. Preserve transcript origin.
8. Generate Curated Note.

### Important rule

A Gemini-generated transcript-like reconstruction must not be labeled as exact verbatim transcription.

### Failure cases

Handle:

1. Private.
2. Deleted.
3. Age-restricted.
4. Geo-blocked.
5. Unsupported length.
6. Provider failure.
7. Missing media.
8. Rate limits.

Offer upload alternative.

---

## 21. Social Link Architecture

Use a platform adapter.

```typescript
interface SocialSourceAdapter {
  canHandle(url: URL): boolean
  inspect(url: URL): Promise<SourcePreview>
  acquireContent(url: URL, authorization?: Token): Promise<AcquiredSource>
}
```

Possible acquisition modes:

1. Public text extraction.
2. Public metadata.
3. Official API.
4. Authorized user access.
5. Provider-supported public video understanding.
6. User-upload fallback.

Do not depend on brittle scraping.

Do not bypass access controls.

---

## 22. AI Provider Abstraction

Backend interfaces:

```typescript
interface SpeechToTextProvider
interface VideoUnderstandingProvider
interface DocumentUnderstandingProvider
interface StructuredGenerationProvider
interface TranslationProvider
interface EmbeddingProvider
```

Each provider response should normalize into CURA contracts.

Provider selection should be configuration-driven.

---

## 23. AI Routing

Recommended routing:

### Audio

Primary:

1. Dedicated speech-to-text provider.
2. Timestamped transcript.
3. Speaker detection where available.
4. Language detection.

### Video

Primary:

1. Dedicated speech-to-text for audio.
2. Gemini for visual and audiovisual understanding.
3. Local OCR.
4. Merge layer.

### YouTube

Primary:

1. Gemini public YouTube URL analysis.

Fallback:

1. Alternate Gemini model.
2. Authorized captions.
3. User upload.
4. Unsupported notice.

### Documents

Primary:

1. Native text extraction.
2. OCR.
3. Structured generation model.

### Curated Note

Use:

1. Structured-output capable model.
2. Strict JSON schema.
3. Repair pass for validation failure.
4. Evidence-aware prompt.

### Output Packs

Use:

1. Curated Note as source.
2. Mode-specific prompts.
3. Brand Voice Profile.
4. Platform constraints.
5. Evidence policy.

---

## 24. Canonical Processing Pipeline

```text
Create Session
→ Add Sources
→ Validate
→ Prepare
→ Temporary Upload
→ Source-Level Processing
→ Source Observations
→ Merge Sources
→ Build Curated Note
→ Generate Output Pack
→ Render Visual Brief
→ Return Results
→ Save Locally
→ Delete Temporary Media
```

Every stage must be individually retryable.

---

## 25. Processing Jobs

Suggested backend model:

```text
id
user_id
session_id
source_id_optional
job_type
stage
status
attempt
max_attempts
idempotency_key
provider
model
request_id
usage
error_code
error_message
started_at
completed_at
created_at
```

### Status values

```text
queued
running
succeeded
failed
cancelled
expired
```

---

## 26. Idempotency

Every costly operation must use an idempotency key.

Examples:

1. Upload completion.
2. Transcription.
3. Video analysis.
4. Curated Note generation.
5. Output generation.
6. Visual Brief generation.
7. RevenueCat webhook.
8. Account deletion.

Idempotency should prevent:

1. Duplicate charges.
2. Duplicate outputs.
3. Duplicate usage records.
4. Duplicate deletion jobs.

---

## 27. Temporary Storage

Use private Supabase Storage buckets.

Suggested buckets:

```text
temporary-source
temporary-derived
temporary-exports
```

Path convention:

```text
{user_id}/{session_id}/{source_id}/original/{filename}
{user_id}/{session_id}/{source_id}/derived/{artifact}
```

Requirements:

1. Private.
2. Signed URLs.
3. Short expiration.
4. Server-only listing.
5. User-scoped access.
6. Automatic cleanup.
7. Cleanup monitoring.
8. Deletion retries.
9. No public bucket for user media.
10. No permanent storage by default.

---

## 28. Temporary Retention

Retention should be configurable.

Recommended initial targets:

1. Successful processing source media: delete as soon as practical after result confirmation.
2. Failed jobs: retain briefly for user retry, then delete.
3. Abandoned uploads: delete through scheduled cleanup.
4. Derived temporary artifacts: delete after successful device retrieval or expiration.

Do not hardcode marketing claims until technical deletion is verified.

---

## 29. Result Delivery

The backend returns:

1. Transcript.
2. Transcript segments.
3. Visual observations.
4. Document observations.
5. Curated Note.
6. Output Packs.
7. Visual Brief schema.
8. Processing metadata.
9. Deletion status.

The iOS app should:

1. Persist results locally.
2. Confirm receipt.
3. Trigger cleanup acknowledgment where designed.
4. Show partial results.
5. Recover if the app closes.

---

## 30. Supabase Responsibilities

Use Supabase for:

1. Auth.
2. User profile.
3. Entitlement state.
4. Job coordination.
5. Temporary storage.
6. Edge Functions.
7. Usage ledger.
8. Webhook handling.
9. Scheduled cleanup.
10. Future opt-in sync.
11. Future vector search.
12. Audit metadata.

Avoid storing user content permanently in V1 unless the user opts into a defined sync feature.

---

## 31. Supabase Database Tables

Suggested V1 server tables:

```text
profiles
processing_sessions
processing_sources
processing_jobs
temporary_objects
usage_ledger
user_entitlements
subscription_events
deletion_jobs
provider_events
support_events
```

Future sync tables:

```text
capture_sessions
capture_sources
transcripts
curated_notes
generated_outputs
visual_briefs
folders
tags
ideas
decisions
action_items
people
organizations
projects
risks
knowledge_topics
entity_links
```

The V1 server schema should avoid pretending temporary processing data is the permanent product database.

---

## 32. Row Level Security

Enable RLS on every user-linked table.

Policies must ensure:

1. Users can read only their rows.
2. Users can create only their rows.
3. Sensitive job writes occur through trusted functions.
4. Entitlement updates occur through trusted webhooks.
5. Service-role access remains server-side.
6. Temporary object paths are user-scoped.
7. Account deletion can reach all owned rows.

Write automated RLS tests.

---

## 33. Authentication

Use Sign in with Apple through Supabase Auth.

Requirements:

1. Nonce flow.
2. Secure token handling.
3. Session restoration.
4. Refresh.
5. Sign out.
6. Account deletion.
7. Keychain storage.
8. Revocation handling.
9. Anonymous or local-only mode decision.
10. Clear error handling.

Do not expose service-role keys in the app.

---

## 34. Local-Only Mode

If supported:

1. Local library works.
2. Local capture works.
3. Local export works.
4. Cloud AI is unavailable until user authorizes.
5. Subscription restoration may require sign-in.
6. Limitations are explained clearly.

Do not force account creation before the user understands product value unless backend cost or security makes it necessary.

---

## 35. RevenueCat

Use RevenueCat for:

1. StoreKit integration.
2. Offerings.
3. Purchases.
4. Restore purchases.
5. Entitlements.
6. Subscription status.
7. Webhooks.

Server must verify entitlement for costly processing.

RevenueCat client state alone must not authorize unlimited backend usage.

---

## 36. Usage Metering

Meter:

1. Audio seconds.
2. Video seconds.
3. YouTube minutes.
4. OCR pages.
5. Document pages.
6. LLM input tokens.
7. LLM output tokens.
8. Visual Brief renders.
9. Output Pack generations.
10. Regenerations.

Usage ledger fields:

```text
user_id
session_id
source_id
event_type
quantity
unit
provider
model
estimated_cost
idempotency_key
created_at
```

---

## 37. Cost Controls

Required:

1. Per-plan duration limits.
2. Per-file size limits.
3. Monthly usage limits.
4. Concurrency limits.
5. Duplicate-processing prevention.
6. Reuse transcript for regeneration.
7. Reuse Curated Note for outputs.
8. Smaller model for simple tasks.
9. Premium model only when justified.
10. Automatic abandoned-upload cleanup.
11. Rate limiting.
12. Circuit breakers.

---

## 38. Processing Queue

For the beta, use a durable queue.

Options:

1. Supabase-backed queue pattern.
2. External managed queue.
3. Dedicated worker service.

Do not rely on one short-lived Edge Function to process long video end to end.

Recommended architecture:

```text
Dispatcher Edge Function
→ Durable Job Queue
→ Worker
→ Stage Update
→ Next Job
```

Short operations may remain in Edge Functions.

Long video work should use a worker environment that supports expected runtime.

---

## 39. Backend Function Structure

```text
supabase/functions/
  create-processing-session/
  create-upload/
  complete-upload/
  dispatch-processing/
  transcribe-source/
  understand-video/
  understand-document/
  merge-session/
  build-curated-note/
  generate-output-pack/
  generate-visual-brief/
  acknowledge-results/
  delete-temporary-files/
  revenuecat-webhook/
  delete-account/
```

Each function should:

1. Validate auth.
2. Validate ownership.
3. Validate entitlement.
4. Validate input.
5. Use request IDs.
6. Avoid sensitive logs.
7. Return normalized errors.
8. Be idempotent where needed.

---

## 40. Curated Note Schema

The Curated Note should use strict versioned JSON.

Required fields:

```text
schema_version
title
smart_summary
detailed_summary
key_ideas
quotes
decisions
action_items
dates
people
organizations
projects
risks
open_questions
visual_observations
tags
confidence
uncertainties
evidence_references
source_relationships
```

Validate before storage or device return.

Use repair prompt once.

If repair fails:

1. Preserve transcript.
2. Return partial output.
3. Show failure clearly.
4. Avoid endless retries.

---

## 41. Source Relationship Model

For multi-source sessions:

```text
source_a
source_b
relationship_type
confidence
explanation
```

Relationship types:

```text
same_event
supports
duplicates
contradicts
unrelated
uncertain
```

This is important for:

1. Audio and visual mismatch.
2. Multiple files from one event.
3. Supporting documents.
4. Conflicting notes.
5. Repeated sources.

---

## 42. Evidence Model

Evidence reference:

```text
id
source_id
transcript_segment_id_optional
start_ms_optional
end_ms_optional
frame_timestamp_ms_optional
page_number_optional
text_range_optional
evidence_text
confidence
```

Important outputs should reference evidence IDs rather than duplicating source metadata.

---

## 43. Visual Brief Architecture

Recommended layers:

1. Visual Brief schema generation.
2. Layout recommendation.
3. SwiftUI renderer.
4. Export renderer.
5. Future web renderer.

The schema should not depend on SwiftUI types.

Use shared JSON contracts.

For V1:

1. Render on device.
2. Export PNG.
3. Export PDF.
4. Persist schema and user edits locally.

Server rendering may be added later.

---

## 44. Export Architecture

Use an `ExportService`.

Supported exporters:

```swift
protocol MarkdownExporter
protocol PlainTextExporter
protocol JSONExporter
protocol PDFExporter
protocol PNGExporter
protocol DOCXExporter
```

Export data should derive from domain models.

Do not scrape visible SwiftUI text to create exports.

---

## 45. Security-Scoped Folder Access

For user-selected folders:

1. Use system document picker.
2. Save security-scoped bookmark.
3. Resolve on use.
4. Detect stale bookmark.
5. Ask for reauthorization.
6. Stop access after operation.
7. Avoid broad file access.
8. Never overwrite silently.

---

## 46. iCloud Drive

Use Files APIs rather than private iCloud database assumptions for user-owned export.

V1:

1. User chooses an iCloud Drive folder.
2. CURA exports files.
3. CURA may auto-export after explicit opt-in.
4. CURA does not implement full two-way synchronization.

---

## 47. Google Drive and Dropbox

Fast-follow approach:

1. Use Files provider integration first.
2. Let users select Drive or Dropbox folders through Files where available.
3. Add direct APIs only if product need justifies complexity.

Do not build custom two-way sync in V1.

---

## 48. Quick Send Architecture

Use a `QuickSendService`.

Capabilities:

1. Copy to clipboard after explicit tap.
2. Open supported app.
3. Use supported URL scheme or universal link.
4. Fall back to Share Sheet.
5. Record content-free event.
6. Never claim posting succeeded.

Destination definitions should be configuration-driven.

---

## 49. Share Extension

The share extension should support:

1. URL.
2. Text.
3. Image.
4. Video.
5. Audio.
6. PDF.

Flow:

1. Receive item.
2. Show recent sessions.
3. Create new session or add to existing.
4. Save shared item locally.
5. Defer processing if needed.
6. Open main app when required.

Keep extension logic minimal.

---

## 50. App Intents Architecture

Create App Entities for:

1. Capture Session.
2. Folder.
3. Output Pack.
4. Generated Output.

App Intents should call shared domain services.

Do not duplicate core logic.

Required intents:

1. Record with CURA.
2. Process File with CURA.
3. Analyze Text with CURA.
4. Add Source to Recent Session.
5. Get Latest Curated Note.
6. Generate Output Pack.
7. Get Open Action Items.
8. Export to Second Brain.
9. Find Capture Sessions.
10. Ask CURA About a Session.

---

## 51. Background Behavior

Supported:

1. Background audio recording.
2. Upload continuation where iOS allows.
3. Processing status refresh.
4. Completion notification.
5. Recovery after app termination.

Use:

1. Background URLSession for uploads.
2. Background audio mode for recording.
3. BackgroundTasks for cleanup and refresh where appropriate.
4. Local notifications.

Do not promise uninterrupted background execution beyond platform limits.

---

## 52. Notifications

Use local or push notifications for:

1. Processing complete.
2. Processing failed.
3. User action required.
4. Subscription issue.
5. Export issue.

Avoid notification spam.

---

## 53. Privacy Modes in Architecture

### Private Mode

1. No upload without explicit user action.
2. Local OCR.
3. Local extraction.
4. Local library.
5. Limited AI.
6. Clear feature limitations.

### Smart Mode

1. Temporary upload.
2. Cloud processing.
3. Local result persistence.
4. Automatic temporary deletion.
5. No permanent content storage by default.

### Future Sync Mode

1. Explicit opt-in.
2. Persistent backend content.
3. Cross-device sync.
4. Mission Control.
5. Retention controls.

Processing mode should be recorded per session.

---

## 54. Data Minimization

Collect only:

1. Account identifiers.
2. Subscription state.
3. Usage.
4. Processing metadata.
5. Error metadata.
6. Optional support information.
7. Temporary content needed for processing.

Avoid collecting:

1. Contacts.
2. Calendar.
3. Location.
4. Email contents.
5. Full device photo library.
6. Clipboard contents.
7. Sensitive inferred traits.

---

## 55. Logging

Allowed:

1. Request ID.
2. Hashed user ID.
3. Session ID.
4. Job ID.
5. Stage.
6. Duration.
7. Provider.
8. Model.
9. Token or minute usage.
10. Normalized error code.

Never log:

1. Transcript text.
2. User notes.
3. Private source URLs.
4. Signed URLs.
5. Auth tokens.
6. Media contents.
7. Extracted personal information.
8. Clipboard contents.

---

## 56. Analytics

Use privacy-conscious analytics.

Track events such as:

1. Session created.
2. Source added.
3. Processing started.
4. Processing completed.
5. Output generated.
6. Visual Brief generated.
7. Quick Send used.
8. Export completed.
9. Shortcut used.
10. Trial started.

Event properties should remain content-free.

---

## 57. Crash Reporting

Use Sentry or equivalent.

Requirements:

1. Scrub PII.
2. Scrub URLs.
3. Scrub text fields.
4. Avoid attaching user media.
5. Review breadcrumbs.
6. Allow opt-out where appropriate.
7. Document SDK data collection.

---

## 58. Error Model

Normalize errors:

```text
code
title
message
retryable
stage
provider
support_reference
```

Categories:

1. Authentication.
2. Permission.
3. File.
4. Upload.
5. Provider.
6. Validation.
7. Subscription.
8. Export.
9. Deletion.
10. Network.
11. Unsupported source.
12. Internal.

UI should never expose raw provider errors.

---

## 59. Retry Strategy

Use:

1. Exponential backoff.
2. Jitter.
3. Maximum attempts.
4. Retryable classification.
5. Idempotency.
6. User-triggered retry.
7. Stage-specific retry.

Do not retry:

1. Unsupported input.
2. Permission denial.
3. Plan limit.
4. Invalid ownership.
5. Permanent provider rejection.

---

## 60. Offline Behavior

Offline support:

1. Record.
2. Import.
3. Build session.
4. Browse local library.
5. Edit local outputs.
6. Export local data.
7. Queue processing for later.
8. Show offline status.

Do not silently attempt repeated uploads.

---

## 61. Search Architecture

V1:

1. Local text index.
2. Title.
3. Transcript.
4. Summary.
5. Tags.
6. People.
7. Projects.
8. Actions.

Future:

1. Local embeddings.
2. Opt-in cloud semantic search.
3. Cross-session Mission Control search.

Keep search abstraction separate from persistence.

---

## 62. Mission Control Readiness

CURA should create normalized entities:

1. Ideas.
2. Decisions.
3. Actions.
4. Commitments.
5. People.
6. Organizations.
7. Projects.
8. Risks.
9. Knowledge Topics.
10. Content Opportunities.

Each entity should preserve:

1. Source session.
2. Source evidence.
3. Confidence.
4. Created date.
5. Relationship.

---

## 63. Entity Link Model

```text
id
source_entity_type
source_entity_id
target_entity_type
target_entity_id
relationship
confidence
evidence_reference_id
created_at
```

Examples:

1. Session mentions Person.
2. Action belongs to Project.
3. Decision affects Project.
4. Person owns Action.
5. Idea supports Content Opportunity.
6. Risk blocks Project.

---

## 64. Future Sync Contract

The future Mission Control sync should:

1. Reuse stable UUIDs.
2. Preserve local edit timestamps.
3. Use conflict metadata.
4. Support user-controlled sync.
5. Encrypt transport.
6. Preserve deletion intent.
7. Avoid silent duplication.
8. Support local-first behavior.

Do not implement full sync before local models are stable.

---

## 65. API Contracts

Use versioned API routes.

Example:

```text
/v1/processing-sessions
/v1/uploads
/v1/jobs
/v1/curated-notes
/v1/output-packs
/v1/visual-briefs
/v1/usage
/v1/account
```

Responses should include:

1. Request ID.
2. Schema version.
3. Status.
4. Normalized data.
5. Error object.
6. Server time where needed.

---

## 66. Configuration

Use environment-based configuration.

iOS:

1. Development.
2. Staging.
3. Production.

Backend:

1. Development.
2. Staging.
3. Production.

Use `.xcconfig` for non-secret app configuration.

Use server secrets for:

1. AI keys.
2. Supabase service role.
3. RevenueCat webhook secret.
4. Observability secrets.
5. Provider credentials.

---

## 67. Suggested Environment Variables

```text
APP_ENV
SUPABASE_URL
SUPABASE_ANON_KEY
SUPABASE_SERVICE_ROLE_KEY
OPENAI_API_KEY
GOOGLE_GEMINI_API_KEY
TRANSCRIPTION_PROVIDER
TRANSCRIPTION_MODEL
VIDEO_MODEL
INTELLIGENCE_MODEL
EMBEDDING_MODEL
REVENUECAT_WEBHOOK_SECRET
SENTRY_DSN
ANALYTICS_KEY
TEMP_SOURCE_RETENTION_HOURS
FAILED_SOURCE_RETENTION_HOURS
MAX_FREE_DURATION_SECONDS
MAX_PRO_DURATION_SECONDS
SCHEMA_VERSION
PROMPT_VERSION
```

Never ship server secrets in the client.

---

## 68. Testing Strategy

### Unit tests

1. Domain rules.
2. State transitions.
3. Usage limits.
4. Export formatting.
5. File naming.
6. Evidence mapping.
7. Folder deletion behavior.
8. Quick Send fallback.
9. Visual Brief overflow.
10. Privacy-mode rules.

### Integration tests

1. Supabase Auth.
2. Signed upload.
3. Processing job.
4. Provider adapter.
5. Temporary deletion.
6. RevenueCat webhook.
7. Account deletion.
8. Export folder access.
9. App Intents.
10. Share extension.

### UI tests

1. First vertical slice.
2. Audio recording.
3. Video import.
4. Session creation.
5. Processing.
6. Curated Note.
7. Output Pack.
8. Quick Send.
9. Folder.
10. Favorite.
11. Export.
12. Account deletion.

---

## 69. AI Evaluation

Maintain a regression dataset across:

1. Interviews.
2. Meetings.
3. Sermons.
4. Lectures.
5. Property walks.
6. Screen recordings.
7. YouTube videos.
8. Social videos.
9. Documents.
10. Multilingual content.
11. Unrelated audio and visuals.
12. Weak audio.
13. Multiple speakers.
14. Long-form video.
15. Visually important silent content.

Score:

1. Transcript usefulness.
2. Factual accuracy.
3. Quote fidelity.
4. Timestamp accuracy.
5. Visual understanding.
6. Action extraction.
7. Curated Note quality.
8. Output quality.
9. Cost.
10. Latency.

---

## 70. Security Testing

Required:

1. RLS tests.
2. Signed URL expiration.
3. Cross-user file access.
4. Token leakage.
5. Service-role exposure.
6. Webhook signature.
7. Rate limiting.
8. Account deletion.
9. Temporary storage cleanup.
10. Log scrubbing.
11. Share extension data handling.
12. Clipboard behavior.

---

## 71. Performance Targets

Target:

1. Recording start under one second.
2. Local session creation under one second.
3. Smooth transcript scrolling.
4. Non-blocking media hashing.
5. Non-blocking export.
6. Responsive Visual Brief preview.
7. Immediate processing status.
8. Recoverable upload.
9. Fast local search.
10. Stable background recording.

Actual targets should be measured on supported devices.

---

## 72. CI/CD

CI should:

1. Build app.
2. Run unit tests.
3. Run linting where adopted.
4. Check formatting.
5. Scan for committed secrets.
6. Validate migrations.
7. Run backend tests.
8. Build Edge Functions.
9. Validate JSON schemas.
10. Produce test report.

Deployment environments:

1. Development.
2. Staging.
3. Production.

Do not deploy directly from unreviewed local changes.

---

## 73. Git and Repository Discipline

Use GitHub as the source of truth.

Required files:

1. README.md.
2. CURA_PRODUCT_CONSTITUTION.md.
3. PRODUCT.md.
4. BRAND.md.
5. APP_FLOW.md.
6. OUTPUT_PACKS.md.
7. VISUAL_BRIEF.md.
8. ARCHITECTURE.md.
9. PRIVACY_LEGAL.md.
10. WEBSITE.md.
11. ROADMAP.md.
12. docs/CURRENT_STATE.md.
13. docs/NEXT_ACTIONS.md.
14. docs/DECISIONS.md.
15. AGENTS.md.

Codex conversations are not the project memory.

Repository documentation is the project memory.

---

## 74. Development Device Strategy

Primary home MacBook:

1. Main repository.
2. Codex hub.
3. Long-running development.
4. Simulator and testing.
5. Remote access where supported.

Second MacBook:

1. Clone same GitHub repository.
2. Pull before work.
3. Push before switching.
4. Avoid uncommitted device-specific divergence.

iPad and iPhone:

1. Review.
2. Remote steering where supported.
3. TestFlight testing.
4. Capture product feedback.
5. Validate mobile experience.

---

## 75. First Vertical Slice Architecture

The first slice should use:

1. Local-only session repository.
2. Real video import.
3. Mock processing provider.
4. Mock Curated Note.
5. Mock Creator Pack.
6. Clipboard.
7. Open-app attempt.
8. Share Sheet fallback.
9. Folder repository.
10. Favorite state.
11. Local persistence.
12. Unit and UI tests.

No live AI dependency.

This proves:

1. App structure.
2. Domain model.
3. Navigation.
4. Session persistence.
5. Output rendering.
6. Quick Send.
7. Testability.

---

## 76. Second Vertical Slice Architecture

Add:

1. Audio recorder.
2. Local audio source.
3. Signed temporary upload.
4. Real speech-to-text.
5. Real Curated Note generation.
6. Local result persistence.
7. Temporary cleanup.
8. Usage metering.
9. Entitlement check.
10. Error recovery.

---

## 77. Third Vertical Slice Architecture

Add multimodal video:

1. Audio extraction.
2. Key frames.
3. OCR.
4. Gemini video understanding.
5. Audio-visual merge.
6. Unrelated-track detection.
7. Visual observations.
8. Video Insight Pack.
9. Evidence timeline.
10. Visual Brief input.

---

## 78. Architecture Decision Records

Create ADRs for:

1. SwiftData versus SQLite.
2. Durable queue selection.
3. Speech-to-text provider.
4. Gemini model selection.
5. Local versus server Visual Brief rendering.
6. Anonymous mode.
7. Temporary retention.
8. Direct social link support.
9. Web framework.
10. Future sync.

Each ADR should include:

1. Context.
2. Decision.
3. Alternatives.
4. Consequences.
5. Review date.

---

## 79. Risks

Primary risks:

1. Scope expansion.
2. Social platform restrictions.
3. Long video cost.
4. Temporary deletion reliability.
5. Background recording complexity.
6. AI accuracy.
7. App Store privacy disclosures.
8. Multimodal latency.
9. Cross-device expectations.
10. Overcomplicated output selection.
11. Visual Brief overflow.
12. Subscription margin.

Mitigation must be documented.

---

## 80. Architecture Boundaries

Do not:

1. Add full video editing.
2. Add direct publishing before core reliability.
3. Build Mission Control in the mobile beta.
4. Create permanent cloud storage by accident.
5. Embed AI keys.
6. Depend on one provider.
7. Build unofficial scraping as a core feature.
8. Store transcripts in logs.
9. Use chat history as product memory.
10. Hide processing stages.
11. Let App Intents bypass privacy rules.
12. Let user content become analytics.

---

## 81. Definition of Technical Success

The architecture succeeds when:

1. A user can capture while offline.
2. The app preserves local data.
3. Cloud processing is temporary and clear.
4. Audio and video are understood.
5. Results are structured.
6. Outputs are reusable.
7. Exports are user-owned.
8. Shortcuts work.
9. Privacy claims match implementation.
10. Costs are measurable.
11. Providers can be replaced.
12. Mission Control can reuse the data model.
13. Codex can continue from repository documentation.
14. The app remains focused and reliable.

---

## 82. Final Architecture Principle

CURA should be powerful without becoming dependent.

The user should not depend on permanent CURA storage to keep their information.

The product should not depend on one AI model.

The engineering team should not depend on one Codex conversation.

Mission Control should not require rebuilding the capture layer.

Every layer should preserve optionality, ownership, and momentum.
