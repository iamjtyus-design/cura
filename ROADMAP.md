# CURA Product and Engineering Roadmap

## Roadmap Principle

Build one reliable vertical slice at a time.

Do not begin later phases while foundational architecture, tests, or privacy behavior remain unstable.

---

## Phase 0: Repository and Foundation

### Build

1. Git repository.
2. Native SwiftUI project.
3. Unit and UI test targets.
4. Shared domain models.
5. Dependency container.
6. Design tokens.
7. Local persistence abstraction.
8. Provider protocols.
9. Environment configuration.
10. CI.
11. Project memory documents.

### Exit criteria

1. App compiles.
2. Tests run.
3. No secrets are committed.
4. Source-of-truth documents are referenced.
5. Mock dependencies work in previews and tests.

---

## Phase 1: First Vertical Slice

### User outcome

Import a video and receive a mock Creator Pack.

### Build

1. Video import from Files.
2. Local Capture Session.
3. Session setup.
4. Mock processing states.
5. Mock Curated Note.
6. Mock Creator Pack.
7. Copy caption.
8. Copy and Open Instagram.
9. Share Sheet fallback.
10. Folder.
11. Favorite.
12. Relaunch persistence.

### Exit criteria

1. Full flow works on simulator.
2. Primary flow has UI test.
3. Local data survives relaunch.
4. Clipboard requires explicit tap.
5. No live paid AI is required.

---

## Phase 2: Real Audio Capture

### User outcome

Record audio and receive a real transcript and Curated Note.

### Build

1. AVFoundation recorder.
2. Pause and resume.
3. Background recording.
4. Interruption recovery.
5. Local playback.
6. Signed temporary upload.
7. Speech-to-text provider.
8. Curated Note generation.
9. Local result persistence.
10. Temporary-file cleanup.
11. Usage metering.
12. Entitlement check.

### Exit criteria

1. Interrupted recording is recoverable.
2. Real transcript has timestamps.
3. Source media is deleted from temporary storage under the documented process.
4. User can export the result.

---

## Phase 3: Multimodal Video

### User outcome

CURA understands what was said and what was shown.

### Build

1. Audio extraction.
2. Key-frame extraction.
3. Vision OCR.
4. Gemini video understanding.
5. Audio-visual merge.
6. Source relationships.
7. Unrelated-track detection.
8. Visual observations.
9. Evidence timeline.
10. Video Insight Pack.

### Exit criteria

1. Screen recording with unrelated audio is separated correctly.
2. Visual workflow steps link to timestamps.
3. Audio-only and visual-only output options work.
4. Provider failures preserve partial results.

---

## Phase 4: Curated Note and Modes

### User outcome

One capture can produce Learn, Create, and Work outputs.

### Build

1. Final Curated Note schema.
2. Evidence references.
3. Inference labels.
4. Learn Mode.
5. Create Mode.
6. Work Mode.
7. Creator Pack.
8. Interview Pack.
9. Event Pack.
10. Learning Pack.
11. Business Pack.
12. Custom Pack.

### Exit criteria

1. Modes reuse the Curated Note.
2. Media is not reprocessed unnecessarily.
3. Quotes, decisions, dates, owners, and deadlines remain evidence-grounded.
4. Outputs remain drafts.

---

## Phase 5: Visual Brief

### User outcome

Create a polished visual summary without using a full design editor.

### Build

1. Visual Brief schema.
2. Layout recommendation.
3. One-Page Summary.
4. Timeline.
5. Process Map.
6. Concept Map.
7. Comparison.
8. Quote Layout.
9. Carousel Plan.
10. Theme and density.
11. PNG export.
12. PDF export.

### Exit criteria

1. Critical text remains selectable.
2. Preview and export match.
3. Overflow is handled without unreadable text.
4. Source evidence is available.

---

## Phase 6: Universal Imports

### Build

1. Photos and screenshots.
2. PDFs.
3. Typed notes.
4. Web pages.
5. Public YouTube links.
6. Supported public social links.
7. Share extension.
8. Add to existing session.
9. Multi-source merging.

### Exit criteria

1. Unsupported links fail clearly.
2. YouTube transcript origin is accurate.
3. Social access uses supported methods or user-upload fallback.
4. Multi-source sessions detect repetition, conflict, and unrelated content.

---

## Phase 7: Export, Quick Send, and Shortcuts

### Build

1. Markdown.
2. Plain text.
3. JSON.
4. PDF.
5. Files.
6. iCloud folder.
7. Second Brain export.
8. Quick Send.
9. App Intents.
10. Share Sheet.
11. Search.

### Exit criteria

1. Exports remain useful outside CURA.
2. Folder bookmarks recover cleanly.
3. Nothing publishes automatically.
4. At least ten physical-device Shortcut workflows pass.

---

## Phase 8: Commercial Beta

### Build

1. Sign in with Apple.
2. RevenueCat.
3. Usage ledger.
4. Plan limits.
5. Paywall.
6. Restore purchase.
7. Account deletion.
8. Session deletion.
9. Privacy controls.
10. Crash reporting.
11. Content-free analytics.
12. Support workflow.
13. TestFlight release.

### Exit criteria

1. Sandbox purchases work.
2. Server-side limits work.
3. Privacy disclosures match production behavior.
4. Account deletion works.
5. Temporary deletion is verified.
6. Launch gates pass.

---

## Phase 9: Website

### Build

1. VisionBuilt home.
2. CURA product page.
3. Product transformation demo.
4. Learn, Create, and Work.
5. Visual Brief.
6. Use cases.
7. Waitlist.
8. Pricing.
9. FAQ.
10. Privacy and Terms.
11. Support.

### Exit criteria

1. Site is accessible and mobile-first.
2. Waitlist works securely.
3. Claims match implemented product status.
4. No dashboard or fake integrations appear.

---

## Phase 10: Product Validation

### Measure

1. Time to first useful result.
2. Sessions per user.
3. Output generation rate.
4. Export rate.
5. Quick Send rate.
6. Return rate.
7. Multisource rate.
8. Usefulness rating.
9. Processing cost.
10. Reliability.

### Decide

1. Which mode drives retention?
2. Which inputs matter most?
3. Which output packs convert?
4. Which Visual Brief layouts are used?
5. Which Mission Control views are justified?

---

## Phase 11: Mission Control

Begin only after real usage validates it.

Potential first capabilities:

1. Project view.
2. Action view.
3. Idea view.
4. Person and organization view.
5. Risk view.
6. Content opportunity view.
7. Cross-session search.
8. Opt-in sync.

Mission Control must not delay the capture-first beta.
