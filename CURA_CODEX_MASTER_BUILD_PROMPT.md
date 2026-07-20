# CURA Codex Master Build Prompt

## Role

You are the principal product engineer, iOS architect, backend engineer, AI systems engineer, and implementation lead for **CURA by VisionBuilt**.

CURA means:

**Capture. Understand. Refine. Activate.**

Primary promise:

**Capture once. Create everything you need next.**

Your job is to build a sellable, privacy-forward, native iPhone beta that serves as the capture gateway into the future VisionBuilt ecosystem and Mission Control platform.

---

## Required Source of Truth

Before writing code, read these documents in full:

1. `CURA_PRODUCT_CONSTITUTION.md`
2. `PRODUCT.md`
3. `BRAND.md`
4. `APP_FLOW.md`
5. `OUTPUT_PACKS.md`
6. `VISUAL_BRIEF.md`
7. `ARCHITECTURE.md`
8. `PRIVACY_LEGAL.md`
9. `WEBSITE.md`
10. `ROADMAP.md`

If these files do not yet exist, create placeholders and record them in `docs/IMPLEMENTATION_STATUS.md`.

When any file conflicts with `CURA_PRODUCT_CONSTITUTION.md`, the Constitution wins unless the user explicitly revises it.

Do not make silent product decisions that contradict the Constitution.

---

## Product Definition

CURA is a mobile-first, multimodal capture and knowledge activation platform.

It accepts:

1. Live audio recordings.
2. Uploaded audio.
3. Uploaded video.
4. Photos.
5. Screenshots.
6. Typed notes.
7. PDFs.
8. Web pages.
9. Public YouTube links.
10. Supported public social links.
11. Files imported through the iOS share sheet.
12. Content added later to an existing Capture Session.

It understands:

1. Spoken audio.
2. Visible text.
3. Screens and interfaces.
4. Slides and diagrams.
5. Objects and environments.
6. Visual workflows.
7. Relationships between audio and visuals.
8. Whether audio and visuals are unrelated.
9. Important people, organizations, dates, ideas, tasks, decisions, and risks.

It creates:

1. One canonical Curated Note.
2. Learn Mode outputs.
3. Create Mode outputs.
4. Work Mode outputs.
5. Visual Briefs.
6. Output Packs.
7. Quick Send actions.
8. User-owned exports.
9. Structured Mission Control-ready data.

CURA is not:

1. A professional video editor.
2. A full image editor.
3. A social scheduling platform.
4. A direct publishing platform in V1.
5. A full web dashboard in V1.
6. A meeting bot.
7. A hidden recorder.
8. A generic research notebook.
9. A replacement for Mission Control.

---

## Product Principles

1. Capture must be fast.
2. Understanding must be grounded in source evidence.
3. The Curated Note must be the canonical processed object.
4. Outputs must be useful, editable, and exportable.
5. User ownership must be clear.
6. Privacy must be honest and technically enforced.
7. Shortcuts must be a first-class interface.
8. The app must remain focused on capture and activation.
9. The user should feel practical momentum, not AI hype.
10. Reliability is more important than the number of features.

---

## V1 Product Modes

### Learn

For:

1. Church.
2. School.
3. Lectures.
4. Conferences.
5. Sermons.
6. Podcasts.
7. Training.
8. Research.
9. Educational videos.

Outputs include:

1. Structured notes.
2. Key concepts.
3. Study guide.
4. Quiz.
5. Flashcards.
6. Glossary.
7. Reflection questions.
8. Concept map.
9. Visual Brief.
10. Review plan.

### Create

For:

1. Interviews.
2. Social content.
3. Creator workflows.
4. Events.
5. Articles.
6. Newsletters.
7. Faceless accounts.
8. Creator research.
9. Video repurposing.

Outputs include:

1. Captions.
2. Hooks.
3. Quote posts.
4. Instagram carousel copy.
5. LinkedIn post.
6. X thread.
7. Threads post.
8. Facebook post.
9. Short-form video clip suggestions.
10. Article outline.
11. Newsletter draft.
12. Blog draft.
13. Visual Brief.
14. Content series ideas.
15. Calls to action.

### Work

For:

1. Meetings.
2. Property walks.
3. Site visits.
4. Inspections.
5. Consulting.
6. Sales calls.
7. Project conversations.
8. Operational notes.

Outputs include:

1. Executive summary.
2. Decisions.
3. Action items.
4. Owners.
5. Deadlines.
6. Follow-up email draft.
7. Project plan.
8. SOP.
9. Workflow reconstruction.
10. Property or site report.
11. Risks.
12. Questions.
13. CRM notes.
14. Team handoff.
15. Second Brain export.

---

## Brand Voice

CURA is a calm strategist that creates practical momentum.

The voice must feel:

1. Clear.
2. Steady.
3. Capable.
4. Empowering.
5. Reassuring.
6. Intelligent.
7. Practical.
8. Modern.
9. Human.
10. Never exaggerated.

Avoid:

1. Generic AI hype.
2. Childish language.
3. Mascot-like chatter.
4. Empty motivational slogans.
5. Overly technical wording.
6. Aggressive urgency.
7. Claims that are not supported by product behavior.

Example microcopy:

1. Ready when you are.
2. Capture it while it is fresh.
3. Turn this into momentum.
4. Your note is ready.
5. Here is what matters.
6. Choose what you want to create next.
7. Copied. Open Instagram when ready.
8. Saved to your Second Brain folder.
9. Audio and visuals appear to cover different topics.
10. Nothing is published without your approval.

---

## Required Technology Direction

### iPhone app

Use:

1. Native SwiftUI.
2. Swift 6.
3. Swift concurrency.
4. Observation.
5. AVFoundation.
6. Vision framework.
7. App Intents.
8. FileDocument and document picker APIs.
9. Share extensions where practical.
10. Background audio support.
11. Local persistence suitable for recoverable drafts.
12. Keychain for sensitive local values.
13. Security-scoped bookmarks for user-selected folders.

### Backend

Use Supabase for:

1. Authentication.
2. Temporary processing coordination.
3. Job state.
4. Subscription state.
5. Future opt-in sync.
6. Edge Functions.
7. Private temporary storage.
8. Row Level Security.
9. Usage ledger.
10. Future vector search.

### AI and media processing

Use provider abstractions.

Required interfaces:

```swift
protocol SpeechToTextProviding
protocol VideoUnderstandingProviding
protocol DocumentUnderstandingProviding
protocol IntelligenceGenerating
protocol TranslationProviding
protocol ExportRendering
protocol CaptureRepository
protocol SubscriptionProviding
protocol AnalyticsProviding
```

Server-side equivalents should also exist.

Do not hardwire business logic to one AI vendor.

### Recommended routing

1. Live and uploaded audio: dedicated speech-to-text provider.
2. Uploaded video: speech-to-text plus multimodal visual understanding.
3. Public YouTube URLs: Gemini video understanding.
4. Images and screenshots: Apple Vision OCR plus multimodal model when needed.
5. PDFs: text extraction plus OCR fallback.
6. Social links: official APIs, supported provider access, or user-provided media. Do not build brittle scraping as the production strategy.
7. Structured outputs: evaluated model router with schema validation and fallback.

### Billing

Use RevenueCat.

Entitlements must be enforced server-side where processing cost is involved.

### Website

The V1 website is:

1. Marketing.
2. Product explanation.
3. Waitlist.
4. Pricing.
5. Privacy.
6. Terms.
7. Support.
8. FAQ.

It is not the Mission Control dashboard.

---

## Privacy Architecture

CURA must be privacy-forward and accurate.

### Default behavior

1. Keep originals local unless processing requires temporary upload.
2. Use temporary encrypted server processing.
3. Delete temporary processing files after completion under a documented schedule.
4. Do not permanently store content on CURA servers by default.
5. Do not train models on user content by default.
6. Make future persistent cloud sync explicit opt-in.
7. Allow user-owned export to Files and cloud drive locations.
8. Avoid transcript or media contents in logs.

### Modes

#### Private Mode

1. Local processing where possible.
2. Reduced AI functionality.
3. No permanent CURA server storage.

#### Smart Mode

1. Temporary encrypted upload.
2. Cloud AI processing.
3. Results returned to the device.
4. Temporary media deleted automatically.
5. No permanent content storage by default.

#### Future Sync Mode

1. Explicit opt-in.
2. Persistent cloud storage.
3. Cross-device access.
4. Mission Control integration.
5. User-controlled retention and deletion.

Do not claim “nothing leaves the device” when cloud AI is used.

Do not claim “we never store anything” if temporary processing storage exists.

---

## Core Domain Model

The top-level object is `CaptureSession`.

A `CaptureSession` can contain many `CaptureSource` records.

Required high-level models:

```text
User
CaptureSession
CaptureSource
ProcessingJob
Transcript
TranscriptSegment
VisualObservation
CuratedNote
GeneratedOutput
OutputPack
VisualBrief
Folder
Favorite
Tag
ExportEvent
UsageEvent
Entitlement
EvidenceReference
Idea
Decision
ActionItem
Person
Organization
Project
Risk
KnowledgeTopic
EntityLink
```

### CaptureSession

Required fields:

```text
id
user_id
title
mode
status
created_at
updated_at
folder_id
is_favorite
processing_mode
output_language
template_key
```

### CaptureSource

Required fields:

```text
id
session_id
source_type
local_identifier
temporary_storage_path
original_filename
mime_type
duration
page_count
source_url
transcript_origin
created_at
deleted_at
```

### CuratedNote

Required fields:

```text
id
session_id
schema_version
prompt_version
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
questions
visual_observations
tags
uncertainties
confidence
created_at
```

### EvidenceReference

Every important derived statement should support:

```text
source_id
start_time
end_time
frame_time
page_number
text_range
evidence_text
confidence
```

---

## Processing State Machine

Use an explicit state machine.

Recommended states:

```text
draft
capturing
ready
preparing
uploading
uploaded
queued
extracting_audio
transcribing
extracting_frames
reading_visual_text
understanding_visuals
understanding_documents
merging_sources
building_curated_note
generating_outputs
rendering_visual_brief
saving
completed
partially_completed
failed
cancelled
deleting
deleted
```

Requirements:

1. Every transition is visible to the user.
2. Every stage records attempts and errors.
3. Completed stages remain available after later failure.
4. Retry does not duplicate charges.
5. Processing must be idempotent.
6. The app must recover from interruption.
7. The user can cancel where technically possible.

---

## The Curated Note Contract

Every processed session must create one Curated Note before output packs are generated.

The Curated Note must:

1. Preserve source evidence.
2. Separate explicit information from inference.
3. Label uncertainty.
4. Distinguish audio and visual findings.
5. Identify unrelated source tracks.
6. Preserve the original transcript.
7. Support user edits without destroying source data.
8. Use a versioned schema.
9. Record model and prompt versions.
10. Feed every output pack.

Do not generate final social content directly from raw media when the Curated Note exists.

---

## Output Packs

Required packs:

1. Creator Pack.
2. Interview Pack.
3. Event Pack.
4. Learning Pack.
5. Business Pack.
6. Custom Pack.

Every generated output should record:

```text
id
session_id
curated_note_id
output_type
mode
pack_key
language
content
evidence_references
prompt_version
model
created_at
```

Generated content is always a draft until the user approves or exports it.

---

## Visual Brief

Visual Brief is a signature output.

V1 must be template-based.

Required characteristics:

1. Real selectable text.
2. Editable sections.
3. Source evidence.
4. Consistent design tokens.
5. PNG export.
6. PDF export.
7. Share sheet support.
8. No critical text rendered by an image generator.
9. Multiple layouts chosen from structured data.
10. Accessibility support.

Initial layouts:

1. One-page summary.
2. Timeline.
3. Process map.
4. Concept map.
5. Comparison.
6. Quote layout.
7. Key statistics.
8. Carousel plan.

---

## Quick Send

Quick Send is a lightweight export workflow.

Required examples:

1. Copy caption and open Instagram.
2. Copy post and open LinkedIn.
3. Copy thread and open X.
4. Copy text and open Threads.
5. Copy design copy and open Canva.
6. Copy caption and open TikTok.
7. Copy email and open Mail.
8. Save note to Files.
9. Export to selected Second Brain folder.

Rules:

1. Clipboard write only after explicit user action.
2. Confirm copy success.
3. Never publish automatically in V1.
4. Never claim another app received the content.
5. Fall back gracefully if an app is not installed.
6. Use universal links or supported URL schemes only.
7. Always provide Share Sheet as a fallback.

---

## Apple Shortcuts

Required App Intents:

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

Rules:

1. Recording opens visible app UI.
2. No hidden recording.
3. Return structured results.
4. Do not silently send messages.
5. Do not silently publish content.
6. Do not silently create calendar items.
7. Do not silently alter reminders.
8. Authentication is required for cloud processing.
9. Incomplete results return a clear status.
10. App Entities must resolve across relaunches.

---

## V1 Scope

### Must build

1. Sign in with Apple.
2. Local library.
3. Folders.
4. Favorites.
5. Search.
6. Audio recording.
7. Audio upload.
8. Video upload.
9. Photo upload.
10. Screenshot upload.
11. Text note.
12. PDF import.
13. YouTube link import.
14. Supported social link intake.
15. Multimodal understanding.
16. Curated Note.
17. Learn Mode.
18. Create Mode.
19. Work Mode.
20. Output Packs.
21. Visual Brief.
22. Quick Send.
23. Files and iCloud export.
24. Markdown export.
25. Plain text export.
26. JSON export.
27. PDF export.
28. Apple Shortcuts.
29. RevenueCat subscription.
30. Account deletion.
31. Temporary processing deletion.
32. Marketing website and waitlist.

### Do not build in V1

1. Full video editor.
2. Full image editor.
3. Automatic social publishing.
4. Social scheduling.
5. Team workspaces.
6. Mission Control dashboard.
7. Android.
8. Meeting bots.
9. Hidden recording.
10. Automatic email sending.
11. Automatic calendar writes.
12. Two-way Drive or Dropbox sync.
13. Advanced collaborative documents.
14. Full desktop editing suite.
15. Complex CRM integrations.

---

## Repository Structure

Create:

```text
Cura/
  App/
  Core/
    Configuration/
    Models/
    Networking/
    Persistence/
    Security/
    Utilities/
  DesignSystem/
  Features/
    Authentication/
    Home/
    Capture/
    Sessions/
    SessionDetail/
    Imports/
    Processing/
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
    Paywall/
  Services/
    Audio/
    Video/
    OCR/
    Upload/
    Processing/
    Supabase/
    AI/
    Export/
    Purchases/
    Analytics/
  AppIntents/
  ShareExtension/
  Resources/
  Tests/
  UITests/

supabase/
  migrations/
  seed/
  functions/
    create-session/
    create-upload/
    complete-upload/
    dispatch-processing/
    transcribe-source/
    understand-video/
    understand-document/
    merge-session/
    build-curated-note/
    generate-output-pack/
    render-visual-brief/
    revenuecat-webhook/
    delete-temporary-files/
    delete-account/

website/
  app/
  components/
  content/
  public/

docs/
  IMPLEMENTATION_STATUS.md
  DECISIONS.md
  CURRENT_STATE.md
  NEXT_ACTIONS.md
  SECURITY.md
  AI_EVALUATION.md
  RELEASE_CHECKLIST.md
```

---

## Engineering Rules

1. Build in compiling vertical slices.
2. Keep secrets out of the client.
3. Use dependency injection.
4. Use protocols around providers.
5. Write tests for business rules.
6. Use Row Level Security on user data.
7. Use signed temporary URLs.
8. Use idempotency keys.
9. Meter AI usage server-side.
10. Handle cancellation and retry.
11. Preserve local draft state.
12. Avoid blocking the main thread.
13. Use content-free analytics.
14. Never log transcript text.
15. Never log private media URLs.
16. Add accessibility from the beginning.
17. Keep the future web dashboard compatible with backend contracts.
18. Do not bury critical business logic inside SwiftUI views.
19. Do not place core processing logic only inside App Intents.
20. Do not create fake integrations.

---

## AI Quality Rules

1. Use only supplied sources and user context.
2. Do not invent facts.
3. Do not invent quotes.
4. Do not invent owners or deadlines.
5. Label inferred information.
6. Attach evidence when possible.
7. Report uncertainty.
8. Preserve proper nouns carefully.
9. Validate every structured output.
10. Retry invalid output with a repair prompt.
11. Preserve transcript origin.
12. Distinguish exact transcript from model reconstruction.
13. Evaluate audio and visual results separately.
14. Detect unrelated tracks.
15. Store schema version and prompt version.
16. Maintain a regression evaluation set.

---

## Required Documentation Behavior

Maintain:

### `docs/IMPLEMENTATION_STATUS.md`

Track:

1. Completed.
2. In progress.
3. Blocked.
4. Deferred.
5. Required user configuration.
6. Known risks.

### `docs/DECISIONS.md`

For every meaningful decision, record:

1. Date.
2. Decision.
3. Reason.
4. Alternatives considered.
5. Consequences.

### `docs/CURRENT_STATE.md`

Keep a concise summary so a new Codex session can continue without relying on conversation history.

### `docs/NEXT_ACTIONS.md`

Keep the next five implementation tasks only.

Do not use chat history as the project source of truth.

---

## Build Phases

### Phase 0: Product and repository foundation

1. Read all documents.
2. Audit contradictions.
3. Create repository structure.
4. Create Xcode project.
5. Add package dependencies.
6. Add configuration.
7. Add design tokens.
8. Add domain models.
9. Add dependency container.
10. Add test targets.
11. Add CI.
12. Create status documents.

Exit criteria:

1. Project compiles.
2. Tests run.
3. No secrets are committed.
4. Constitution is referenced in README.
5. Domain models compile.

### Phase 1: First vertical slice

Build:

1. Local session creation.
2. Video file import.
3. Mock processing pipeline.
4. Mock Curated Note.
5. Mock Creator Pack.
6. Copy output.
7. Copy and open app.
8. Local session library.
9. Basic folder.
10. Basic favorite.

Exit criteria:

1. User imports a video.
2. Processing states display.
3. Curated Note appears.
4. Creator Pack appears.
5. User copies a caption.
6. User opens a supported destination app.
7. Session persists locally.
8. Tests pass.

This phase should work without live paid AI providers.

### Phase 2: Real audio and transcription

1. Audio recorder.
2. Pause and resume.
3. Background recording.
4. Interruption handling.
5. Local playback.
6. Temporary upload.
7. Real speech-to-text.
8. Transcript persistence.
9. Source evidence.
10. Automatic temporary cleanup.

Exit criteria:

1. A real recording becomes a transcript and Curated Note.
2. Audio remains recoverable after interruptions.
3. Temporary files are deleted as specified.

### Phase 3: Multimodal video

1. Extract audio.
2. Extract key frames.
3. OCR visible text.
4. Gemini video understanding.
5. Merge audio and visual observations.
6. Detect unrelated tracks.
7. Generate combined Curated Note.
8. Generate visual-only output.

Exit criteria:

1. A screen recording with unrelated audio produces separate audio and visual tracks.
2. Evidence links resolve to valid timestamps.

### Phase 4: Learn, Create, and Work

1. Mode selector.
2. Output Packs.
3. Custom Packs.
4. Brand Voice Profile.
5. Creator Pack.
6. Learning Pack.
7. Business Pack.
8. Interview Pack.
9. Event Pack.

Exit criteria:

1. One Curated Note can generate all three mode outputs without reprocessing original media.

### Phase 5: Visual Brief

1. Structured visual schema.
2. Layout selection.
3. Editable text blocks.
4. PNG export.
5. PDF export.
6. Share sheet.
7. Accessibility.

Exit criteria:

1. Visual Brief contains accurate selectable text.
2. Exported visual matches the visible preview.

### Phase 6: Imports and links

1. Photos.
2. Screenshots.
3. PDFs.
4. Web pages.
5. YouTube URLs.
6. Supported social URLs.
7. Share extension.
8. Add to existing session.

Exit criteria:

1. Unsupported sources fail clearly.
2. YouTube processing distinguishes analysis from exact captions.
3. Social platforms do not depend on brittle scraping.

### Phase 7: Shortcuts and exports

1. App Intents.
2. Markdown.
3. Plain text.
4. JSON.
5. PDF.
6. Files.
7. iCloud folder.
8. Quick Send.
9. Share Sheet.

Exit criteria:

1. At least ten physical-device Shortcut workflows pass.
2. Exports remain usable outside CURA.

### Phase 8: Commercial beta

1. RevenueCat.
2. Usage ledger.
3. Plan limits.
4. Paywall.
5. Restore purchases.
6. Account deletion.
7. Privacy controls.
8. Analytics.
9. Crash reporting.
10. TestFlight preparation.

Exit criteria:

1. Sandbox purchase works.
2. Server-side limits work.
3. Account deletion removes applicable cloud records and temporary objects.
4. Privacy disclosures match actual behavior.

### Phase 9: Website

1. VisionBuilt parent page.
2. CURA product page.
3. Learn, Create, and Work explanation.
4. Capture Session demo.
5. Visual Brief demo.
6. Waitlist.
7. Pricing.
8. FAQ.
9. Privacy.
10. Terms.
11. Support.

Exit criteria:

1. Website is publishable.
2. Claims match implemented beta behavior.
3. Waitlist works.
4. Mobile layout is polished.

---

## First Task

Do not immediately build every feature.

First:

1. Read all project documents.
2. Produce a concise implementation audit.
3. Identify contradictions, missing values, and external accounts required.
4. Create the repository structure.
5. Create the Xcode app and test targets.
6. Create shared models.
7. Create configuration.
8. Create dependency injection.
9. Create the design system.
10. Create `docs/IMPLEMENTATION_STATUS.md`.
11. Create `docs/DECISIONS.md`.
12. Create `docs/CURRENT_STATE.md`.
13. Create `docs/NEXT_ACTIONS.md`.
14. Add CI.
15. Compile and run tests.
16. Stop.

Then report:

1. Files created.
2. Commands run.
3. Tests run.
4. Build result.
5. Required user configuration.
6. Risks.
7. Exact next task.

Do not begin Phase 1 until the foundation compiles.

---

## First Vertical Slice Prompt

After Phase 0 succeeds, implement this exact vertical slice:

> A user imports a video from Files, CURA creates a local Capture Session, displays mock processing stages, creates a mock Curated Note and Creator Pack, allows the user to copy an Instagram caption, and provides a Copy and Open Instagram action. The session can be favorited and placed in a folder. No live AI API is required for this slice.

Requirements:

1. Native SwiftUI.
2. Accessible.
3. Local persistence.
4. Real file import.
5. Mock provider interfaces.
6. Clear processing states.
7. Curated Note model.
8. Creator Pack model.
9. Clipboard action after explicit tap.
10. Open app action with fallback to Share Sheet.
11. Unit tests.
12. UI test for primary flow.

Stop after this slice compiles and tests pass.

---

## Definition of Done

CURA is not done because screens exist.

The sellable beta is done when a real user can:

1. Capture or import information.
2. Understand what happened.
3. Receive a reliable Curated Note.
4. Generate useful Learn, Create, or Work outputs.
5. Generate a Visual Brief.
6. Export to their own storage.
7. Use Quick Send.
8. Use Apple Shortcuts.
9. Understand the privacy model.
10. Delete their information.
11. Pay for recurring value.
12. Trust the app enough to use it again.

The product must feel focused, useful, private, and premium.

It must turn moments into momentum.
