# CURA App Flow and Experience Specification

## Document Status

**Product:** CURA by VisionBuilt  
**Version:** 1.0  
**Platform:** iPhone  
**Primary source of truth:** `CURA_PRODUCT_CONSTITUTION.md`

This document defines how users move through CURA.

It covers:

1. Information architecture.
2. Screen hierarchy.
3. Navigation.
4. Capture flows.
5. Processing flows.
6. Curated Note behavior.
7. Learn, Create, and Work outputs.
8. Visual Brief.
9. Library organization.
10. Quick Send.
11. Export.
12. Privacy.
13. Subscription.
14. Error handling.

When this document conflicts with the Product Constitution, the Constitution wins.

---

## 1. Experience Goal

CURA should feel fast, clear, and focused.

The user should always understand:

1. What they are capturing.
2. What CURA is doing.
3. What CURA created.
4. What they can do next.
5. Where their information is stored.
6. Whether anything was uploaded.
7. Whether anything was deleted.
8. Whether anything was shared or published.

The app should reduce decisions during capture and provide more control after processing.

---

## 2. Core Experience Loop

The primary loop is:

```text
Capture
→ Process
→ Curated Note
→ Choose Learn, Create, or Work
→ Generate outputs
→ Copy, save, share, or open another app
```

The user should not have to understand AI providers, technical schemas, or backend architecture.

---

## 3. Primary Navigation

Recommended tab bar:

1. Home
2. Sessions
3. Capture
4. Create
5. Profile

The Capture action should be visually prominent.

### Tab purposes

#### Home

Start quickly and continue recent work.

#### Sessions

Browse and organize the capture library.

#### Capture

Begin a new source or Capture Session.

#### Create

Generate and manage outputs from existing sessions.

#### Profile

Manage settings, privacy, exports, subscription, and account.

---

## 4. App Launch States

## 4.1 First Launch

Flow:

1. Welcome.
2. Product promise.
3. Learn, Create, and Work introduction.
4. Privacy explanation.
5. Recording consent notice.
6. Sign in or continue locally where supported.
7. Land on Home.

Do not request microphone, camera, Photos, or notifications until the user initiates a relevant action.

---

## 4.2 Returning Authenticated User

Flow:

1. Restore session.
2. Load local library.
3. Check interrupted recordings or uploads.
4. Show Home.
5. Surface any important processing completion.

---

## 4.3 Returning Local-Only User

Flow:

1. Load local library.
2. Show limited cloud capability status.
3. Do not interrupt with sign-in unless the user selects a cloud feature.

---

## 4.4 Interrupted Processing Recovery

If a task was interrupted:

1. Show the session.
2. Explain the last successful stage.
3. Offer Resume.
4. Offer Keep Partial Results.
5. Offer Delete Temporary Data.
6. Never restart costly processing without confirmation.

---

## 5. Onboarding Flow

## Screen 1: Welcome

Headline:

**Capture once. Create everything you need next.**

Supporting text:

Record, upload, or paste what matters. CURA turns it into notes, content, visuals, and action.

Primary action:

**Continue**

---

## Screen 2: Three Modes

Show:

### Learn

For lectures, church, conferences, podcasts, and study.

### Create

For interviews, events, social content, and ideas.

### Work

For meetings, walkthroughs, projects, and operations.

Primary action:

**Continue**

---

## Screen 3: Privacy

Explain:

1. Originals stay on the device by default.
2. Smart Mode may temporarily upload content for processing.
3. Temporary processing files are deleted automatically.
4. Persistent cloud sync is not enabled by default.
5. Users can export and delete their data.

Primary action:

**Review Processing Options**

Secondary action:

**Continue**

---

## Screen 4: Recording Consent

Display:

> Only record people when you have permission and when recording is lawful. Consent requirements vary by location. You are responsible for notifying participants and obtaining any required consent.

Required acknowledgment:

**I understand**

---

## Screen 5: Account

Options:

1. Sign in with Apple.
2. Continue locally, if supported.
3. Review why sign-in is useful.

Sign-in benefits:

1. Subscription restoration.
2. Processing access.
3. Future sync eligibility.
4. Account deletion.

---

## Screen 6: Ready

Message:

**Ready when you are.**

Actions:

1. Start a Capture.
2. Import Something.
3. Explore Demo Session.

---

## 6. Home Screen

The Home screen should prioritize action over browsing.

### Header

1. VisionBuilt or CURA wordmark.
2. Profile or settings button.
3. Optional processing status indicator.

### Primary actions

1. Record Audio.
2. Import Video.
3. Paste Link.
4. Build Session.

### Secondary actions

1. Take Photo.
2. Import File.
3. Type Note.
4. Scan Document, when supported.

### Recent Sessions

Show:

1. Thumbnail or source icon.
2. Title.
3. Mode.
4. Status.
5. Date.
6. Favorite state.
7. Folder.
8. Quick access to latest output.

### Processing Queue

Only show when active.

Include:

1. Session title.
2. Current stage.
3. Progress.
4. Cancel option where supported.
5. Open session.

### Suggested Next Step

Examples:

1. Generate a Creator Pack.
2. Export to your Second Brain folder.
3. Review three open actions.
4. Finish setting your default output language.
5. Add a source to your recent session.

Avoid generic engagement prompts.

---

## 7. Capture Entry Sheet

Tapping Capture opens a full-screen action sheet or dedicated page.

Options:

1. Record Audio.
2. Record Video.
3. Take Photo.
4. Import Media.
5. Import Document.
6. Paste Link.
7. Type Note.
8. Build Multi-Source Session.
9. Add to Existing Session.

Each option should include a short explanation.

---

## 8. New Capture Session Flow

### Step 1: Choose Start Type

The user chooses:

1. Audio.
2. Video.
3. Photo.
4. File.
5. Link.
6. Text.
7. Multi-source.

### Step 2: Capture or Select Source

Use the correct system picker or recording interface.

### Step 3: Session Setup

Fields:

1. Session title.
2. Mode: Learn, Create, or Work.
3. Output language.
4. Processing mode.
5. Optional context.
6. Optional folder.
7. Optional default Output Pack.

Use smart defaults.

### Step 4: Review Sources

Show:

1. Source list.
2. Duration or page count.
3. File type.
4. Remove option.
5. Add another source.
6. Reorder when useful.

### Step 5: Process

Primary action:

**Create Curated Note**

Secondary actions:

1. Save Draft.
2. Add Another Source.
3. Change Processing Mode.

---

## 9. Audio Recording Flow

## 9.1 Pre-Recording

Show:

1. Title field.
2. Input source.
3. Mode.
4. Consent reminder.
5. Recording quality setting.
6. Processing mode.
7. Start button.

Do not overcrowd the screen.

---

## 9.2 Active Recording

Show:

1. Persistent recording indicator.
2. Elapsed time.
3. Audio level or waveform.
4. Pause.
5. Add Marker.
6. Stop.
7. Lock-screen-safe status.
8. Current session title.

Optional:

1. Add quick text note.
2. Add photo marker.
3. Add session label.

The app should never hide the recording state.

---

## 9.3 Paused

Show:

1. Paused status.
2. Resume.
3. Stop.
4. Add note.
5. Review markers.

---

## 9.4 Recording Complete

Show:

1. Playback.
2. Duration.
3. Rename.
4. Trim only if extremely basic and reliable.
5. Add another source.
6. Select mode.
7. Add context.
8. Process.
9. Save as draft.
10. Delete.

CURA should not expand into detailed audio editing.

---

## 10. Video Capture and Import Flow

## 10.1 Record Video

Use native camera capture where appropriate.

After recording:

1. Preview.
2. Retake.
3. Keep.
4. Add context.
5. Add related photos.
6. Add typed note.
7. Select mode.
8. Process.

---

## 10.2 Import Video

Sources:

1. Photos.
2. Files.
3. Share extension.

After selection:

1. Show thumbnail.
2. Show duration.
3. Show file size.
4. Allow preview.
5. Add to session.
6. Add more sources.
7. Select processing depth.

Processing depth:

1. Audio Only.
2. Full Video.
3. Visual Only.
4. Smart Auto.

Default:

**Smart Auto**

---

## 10.3 Video Analysis Explanation

Before first full-video processing, explain:

> CURA can analyze spoken audio, visible text, screens, slides, and visual actions.

If processing cost differs, show the difference clearly.

---

## 11. Photo and Screenshot Flow

The user can:

1. Take a photo.
2. Select one or many photos.
3. Add them to a new or existing session.
4. Add captions.
5. Reorder sources.
6. Choose Learn, Create, or Work.
7. Process.

Suggested detected types:

1. Slide.
2. Document.
3. Whiteboard.
4. Interface.
5. Property.
6. Event.
7. Chart.
8. General image.

The user should be able to correct the detected type.

---

## 12. Link Import Flow

## 12.1 Paste Link

The app:

1. Validates URL.
2. Detects platform.
3. Shows a preview.
4. Explains available processing.
5. Requests upload if the source cannot be accessed.
6. Lets the user add context.
7. Creates or adds to a session.

---

## 12.2 YouTube

Show:

1. Thumbnail.
2. Title.
3. Channel.
4. Duration where available.
5. Public-access status.
6. Analysis method.
7. Transcript origin notice.

Suggested message:

> CURA can analyze supported public YouTube videos. The result may use official captions, audio transcription, or video understanding depending on availability.

---

## 12.3 Social Media Link

Show:

1. Platform.
2. Accessible text.
3. Media preview where supported.
4. Processing limitation.
5. Upload alternative.

Suggested blocked-state message:

> This platform does not allow CURA to access the full video from the link. Upload the video instead.

---

## 13. PDF and Document Flow

The user:

1. Selects a PDF.
2. Sees filename and page count.
3. Selects mode.
4. Adds context.
5. Processes.
6. Receives page-linked evidence.

If OCR is needed:

1. Show that scanned pages were detected.
2. Explain that processing may take longer.
3. Continue without requiring extra technical decisions.

---

## 14. Typed Note Flow

The user can:

1. Enter title.
2. Type or paste text.
3. Select mode.
4. Add to an existing session.
5. Process.
6. Generate outputs.

Quick Note should be available through App Intents and the Share Sheet.

---

## 15. Multi-Source Session Flow

### Build Session

The user can add:

1. Recording.
2. Video.
3. Photos.
4. Screenshots.
5. Text.
6. PDF.
7. Web link.
8. YouTube link.
9. Social link.

### Review

Show a chronological or user-defined source list.

Each source card shows:

1. Source type.
2. Name.
3. Duration or page count.
4. Date added.
5. Processing status.
6. Remove.
7. Preview.

### Process

CURA processes:

1. Each source independently.
2. Shared entities.
3. Conflicts.
4. Repeated information.
5. Time relationships.
6. Combined session context.

### Smart Grouping

Future or fast-follow:

Suggest related camera-roll content captured near the recording time.

Require confirmation before adding.

---

## 16. Processing Experience

Processing should feel informative, not technical.

### Stage sequence

1. Preparing sources.
2. Uploading securely.
3. Transcribing audio.
4. Reading visuals.
5. Understanding documents.
6. Combining what matters.
7. Building Curated Note.
8. Generating outputs.
9. Rendering Visual Brief.
10. Saving results.

### Progress behavior

1. Show current stage.
2. Show completed stages.
3. Show partial results as soon as useful.
4. Allow leaving the screen.
5. Send completion notification when enabled.
6. Preserve progress across relaunch.
7. Show retry for failed stages.
8. Do not restart completed stages unnecessarily.

---

## 17. Partial Completion

If transcript succeeds but Visual Brief fails:

1. Mark session Partially Complete.
2. Show available Curated Note.
3. Show failed output.
4. Offer Retry Visual Brief.
5. Do not hide completed work.

If one source fails:

1. Show which source failed.
2. Continue with successful sources.
3. Let the user retry or remove the failed source.

---

## 18. Curated Note Screen

The Curated Note is the primary result.

### Header

1. Session title.
2. Mode.
3. Date.
4. Folder.
5. Favorite.
6. Source count.
7. Processing origin.
8. Export action.

### Sections

1. Smart Summary.
2. What Matters.
3. Key Ideas.
4. Quotes.
5. Decisions.
6. Action Items.
7. Dates.
8. People and Organizations.
9. Projects.
10. Risks.
11. Open Questions.
12. Visual Observations.
13. Transcript.
14. Sources.
15. Evidence.

### Interaction

The user can:

1. Expand sections.
2. Edit derived content.
3. Copy a section.
4. Jump to source evidence.
5. Generate another output.
6. Change mode.
7. Add source.
8. Export.
9. Delete.
10. Ask CURA.

---

## 19. Evidence Interaction

Tapping evidence should:

1. Open the source.
2. Jump to timestamp, frame, page, or text location.
3. Highlight the related evidence.
4. Show confidence.
5. Show whether the item was explicit or inferred.

If evidence cannot be opened, show the reference details plainly.

---

## 20. Mode Selection

Mode may be selected:

1. Before processing.
2. After Curated Note generation.
3. Per output pack.

The Curated Note should remain mode-neutral enough to generate all three modes later.

Changing modes should not require retranscribing or reanalyzing original media unless necessary.

---

## 21. Learn Mode Flow

### Entry

From:

1. Session Detail.
2. Curated Note.
3. Create tab.
4. Home suggestion.

### Output selection

1. Learning Pack.
2. Study Guide.
3. Quiz.
4. Flashcards.
5. Reflection Questions.
6. Glossary.
7. Concept Map.
8. Visual Brief.
9. Custom Pack.

### Review

The user can:

1. Edit text.
2. Adjust difficulty.
3. Regenerate a section.
4. Copy.
5. Export.
6. Save to session.
7. Quick Send where relevant.

---

## 22. Create Mode Flow

### Entry

From:

1. Session Detail.
2. Curated Note.
3. Create tab.
4. Home suggestion.

### Select destination or purpose

Options:

1. Instagram.
2. LinkedIn.
3. X.
4. Threads.
5. Facebook.
6. TikTok.
7. YouTube.
8. Blog.
9. Newsletter.
10. General Content Pack.

### Select output

Examples:

1. Caption.
2. Carousel.
3. Quote Post.
4. Thread.
5. Hooks.
6. Clip Suggestions.
7. Article.
8. Newsletter.
9. Visual Brief.
10. Creator Pack.

### Customize

Optional:

1. Audience.
2. Tone.
3. Length.
4. Call to action.
5. Brand Voice Profile.
6. Number of options.

### Review

The user can:

1. Edit.
2. Regenerate.
3. Copy.
4. Quick Send.
5. Export.
6. Save as output.

Do not build a full visual or video editor.

---

## 23. Work Mode Flow

### Entry

From:

1. Session Detail.
2. Curated Note.
3. Create tab.
4. Home suggestion.

### Select output

1. Business Pack.
2. Meeting Notes.
3. Follow-Up Email.
4. Project Plan.
5. SOP.
6. Property Walk Report.
7. Site Visit Report.
8. CRM Notes.
9. Team Handoff.
10. Visual Brief.

### Review

The user can:

1. Edit.
2. Assign owner locally.
3. Add due date.
4. Mark action done.
5. Copy.
6. Export.
7. Save to Second Brain.
8. Open Mail with copied draft.

No automatic sending in V1.

---

## 24. Output Pack Screen

Each Output Pack should show:

1. Pack name.
2. Source session.
3. Generated date.
4. Output list.
5. Completion state.
6. Regenerate.
7. Export all.
8. Quick Send where relevant.
9. Save as custom pack.
10. Delete pack.

Each output card should support:

1. Preview.
2. Edit.
3. Copy.
4. Export.
5. Evidence.
6. Regenerate.

---

## 25. Visual Brief Flow

### Step 1: Choose layout

1. Auto.
2. One-Page Summary.
3. Timeline.
4. Process Map.
5. Concept Map.
6. Comparison.
7. Quote Layout.
8. Key Statistics.
9. Carousel Plan.

### Step 2: Review data

The user can:

1. Remove sections.
2. Reorder sections.
3. Edit text.
4. Change title.
5. Choose density.
6. Choose page size.
7. Select theme.

### Step 3: Preview

Show:

1. Real selectable text.
2. Source references.
3. Layout preview.
4. Accessibility preview where useful.

### Step 4: Export

1. PNG.
2. PDF.
3. Share Sheet.
4. Save to Files.
5. Save to session.

No complex design canvas in V1.

---

## 26. Create Tab

The Create tab is the output workspace.

Show:

1. Recent sessions ready for outputs.
2. Recommended packs.
3. Saved custom packs.
4. Recent Visual Briefs.
5. Draft outputs.
6. Brand Voice Profile.
7. Quick Send history.

The Create tab should not become a full content calendar in V1.

---

## 27. Sessions Tab

### Default view

Show:

1. All Sessions.
2. Folders.
3. Favorites.
4. Processing.
5. Recent.
6. Learn.
7. Create.
8. Work.

### Session card

Show:

1. Title.
2. Thumbnail or icon.
3. Mode.
4. Source types.
5. Date.
6. Status.
7. Folder.
8. Favorite.
9. Latest output.

### Actions

1. Open.
2. Favorite.
3. Move.
4. Rename.
5. Export.
6. Add Source.
7. Generate Output.
8. Delete.

---

## 28. Folder Flow

### Create Folder

Fields:

1. Name.
2. Optional icon.
3. Optional color.
4. Optional default mode.
5. Optional default Output Pack.

### Folder Detail

Show:

1. Folder title.
2. Session count.
3. Sort.
4. Filter.
5. Add session.
6. Rename.
7. Delete folder.

Deleting a folder should not delete sessions unless the user explicitly chooses that action.

---

## 29. Favorites Flow

The user can favorite:

1. Capture Sessions.
2. Outputs.
3. Visual Briefs.
4. Custom Packs.

Favorites should be accessible from:

1. Home.
2. Sessions.
3. Create.

---

## 30. Search Flow

Search entry points:

1. Sessions tab.
2. Home.
3. App Intent.
4. Future global search.

Search fields:

1. Title.
2. Transcript.
3. Summary.
4. Tag.
5. Person.
6. Organization.
7. Project.
8. Quote.
9. Action.
10. URL.

Filters:

1. Mode.
2. Date.
3. Source type.
4. Folder.
5. Favorite.
6. Status.

V1 may use local indexed text search.

---

## 31. Quick Send Flow

### Step 1: Choose output

The user selects a generated output.

### Step 2: Choose action

Examples:

1. Copy.
2. Copy and Open Instagram.
3. Copy and Open LinkedIn.
4. Copy and Open X.
5. Copy and Open Threads.
6. Copy and Open TikTok.
7. Copy and Open Facebook.
8. Copy and Open Canva.
9. Copy and Open Mail.
10. Share.

### Step 3: Confirm

Message:

**Copied. Open Instagram when ready.**

### Fallback

If the app is unavailable:

1. Show Share Sheet.
2. Offer Copy Only.
3. Explain that nothing was posted.

---

## 32. Export Flow

### Step 1: Choose content

1. Curated Note.
2. Transcript.
3. Output Pack.
4. Visual Brief.
5. Entire Session.

### Step 2: Choose format

1. Markdown.
2. Plain Text.
3. JSON.
4. PDF.
5. PNG.
6. DOCX when supported.

### Step 3: Choose options

1. Include transcript.
2. Include evidence.
3. Include source list.
4. Include YAML front matter.
5. Filename pattern.
6. Destination.

### Step 4: Save

Destinations:

1. Files.
2. iCloud Drive.
3. Share Sheet.
4. Selected Second Brain folder.

### Step 5: Confirm

Message:

**Saved to your Second Brain folder.**

---

## 33. Second Brain Setup Flow

### Initial Setup

1. Explain user-owned export.
2. Choose folder.
3. Request folder access.
4. Save security-scoped bookmark.
5. Choose default format.
6. Choose filename pattern.
7. Choose automatic or manual export.

### Automatic Export

For V1, automatic export should mean:

1. Export after explicit user opt-in.
2. Export after successful session completion.
3. Use chosen format.
4. Show confirmation.
5. Allow disabling.

Do not implement full two-way sync.

---

## 34. Profile Tab

Sections:

1. Account.
2. Subscription.
3. Processing Mode.
4. Privacy.
5. Export Destinations.
6. Brand Voice Profile.
7. Default Output Packs.
8. Language.
9. Recording Settings.
10. Notifications.
11. Shortcuts.
12. Help.
13. Legal.
14. Delete Account.

---

## 35. Privacy Settings

Show:

1. Current processing mode.
2. Temporary retention period.
3. Cloud sync status.
4. Analytics preference.
5. Model training statement.
6. Vendor processing details.
7. Delete temporary data.
8. Export account data.
9. Delete account.

Use plain language.

---

## 36. Subscription Flow

### Paywall entry points

1. Processing limit reached.
2. Premium output selected.
3. Visual Brief limit reached.
4. Custom Pack selected.
5. Advanced Shortcuts selected.
6. Settings.

### Paywall content

1. Current plan.
2. Monthly and annual price.
3. Processing limits.
4. Premium outputs.
5. Translation.
6. Visual Brief access.
7. Custom Packs.
8. Restore Purchases.
9. Terms.
10. Privacy.

Do not block access to existing local user data when a subscription expires.

---

## 37. Account Deletion Flow

### Step 1

Explain what will be deleted.

### Step 2

Offer export.

### Step 3

Require confirmation.

### Step 4

Delete:

1. Account.
2. Applicable backend records.
3. Temporary files.
4. Subscription association where appropriate.
5. Local data if selected.

### Step 5

Show completion.

Never make account deletion unnecessarily difficult.

---

## 38. Error Handling

Every error should include:

1. What failed.
2. What completed.
3. Whether data is safe.
4. What the user can do.
5. Whether retry may incur processing cost.
6. Support option when necessary.

Examples:

### Unsupported link

> This link cannot be processed directly. Upload the video instead.

### Interrupted upload

> Upload paused. Your session is saved and can resume.

### Transcription failed

> The file uploaded successfully, but the audio could not be transcribed. Retry transcription or keep the original.

### Visual processing failed

> Audio processing completed. Visual analysis can be retried separately.

### Export failed

> The file could not be saved to that folder. Choose another location or restore folder access.

---

## 39. Empty States

### No Sessions

> Capture something worth keeping.

Actions:

1. Start Recording.
2. Import Video.
3. Paste Link.

### No Favorites

> Favorite the sessions and outputs you return to most.

### No Folder Content

> Move a session here or start a new capture.

### No Outputs

> Your Curated Note is ready. Choose Learn, Create, or Work.

### No Search Results

> Nothing matched that search. Try a title, person, topic, or source.

---

## 40. Accessibility Flow Requirements

1. VoiceOver labels for every capture control.
2. Recording status announced.
3. Processing stages announced without excessive repetition.
4. Dynamic Type.
5. Large tap targets.
6. Non-color status cues.
7. Accessible source evidence.
8. Visual Brief text remains readable.
9. Reduce Motion support.
10. Haptics do not carry meaning alone.

---

## 41. First Vertical Slice Flow

The first implemented slice should be:

1. Launch app.
2. Open Capture.
3. Import video from Files.
4. Create local Capture Session.
5. Choose Create Mode.
6. Show mock processing states.
7. Create mock Curated Note.
8. Create mock Creator Pack.
9. Open Instagram caption output.
10. Tap Copy.
11. Tap Copy and Open Instagram.
12. Fall back to Share Sheet if needed.
13. Favorite session.
14. Place session in folder.
15. Close and relaunch.
16. Confirm persistence.

No live AI is required for this first slice.

---

## 42. V1 Screen Inventory

Required screens:

1. Launch.
2. Onboarding.
3. Sign In.
4. Home.
5. Capture Entry.
6. Audio Recorder.
7. Video Capture.
8. Media Import.
9. Photo Import.
10. Document Import.
11. Link Import.
12. Text Note.
13. Build Session.
14. Session Setup.
15. Source Review.
16. Processing.
17. Session Detail.
18. Curated Note.
19. Learn Mode.
20. Create Mode.
21. Work Mode.
22. Output Pack.
23. Output Detail.
24. Visual Brief Layout.
25. Visual Brief Preview.
26. Sessions.
27. Folder List.
28. Folder Detail.
29. Favorites.
30. Search.
31. Quick Send.
32. Export.
33. Second Brain Setup.
34. Profile.
35. Privacy.
36. Subscription.
37. Shortcuts.
38. Help and FAQ.
39. Legal.
40. Delete Account.

---

## 43. Product Flow Rules

1. Capture remains the shortest path.
2. The Curated Note is the central result.
3. Output generation happens after understanding.
4. User edits never overwrite original source data.
5. Nothing is published without approval.
6. Nothing is copied without a user action.
7. No processing state is hidden.
8. No permanent cloud storage is assumed.
9. Partial results remain available.
10. Users can always export or delete.
11. Learn, Create, and Work remain simple.
12. Advanced options stay secondary.
13. Errors preserve user confidence.
14. Screens should avoid unnecessary density.
15. Mission Control features do not enter the V1 mobile flow.

---

## 44. Final Experience Definition

CURA should feel like this:

The user captures something important.

CURA explains what it is doing.

CURA returns one clear Curated Note.

The user chooses what they want next.

CURA prepares the output.

The user moves it where it belongs.

Nothing important feels lost, hidden, or out of control.
