# CURA QA and Acceptance

## Foundation

1. Project compiles in Development and Staging configurations.
2. Unit and UI test targets run.
3. No server secrets exist in the app.
4. Dependency injection supports live, preview, and test implementations.
5. Documentation matches actual state.

## Capture

1. Recording starts visibly.
2. Pause and resume work.
3. Interruption recovery preserves the file.
4. Video, image, PDF, text, and link imports validate correctly.
5. Multi-source sessions preserve source order.
6. Unsupported content fails clearly.

## Processing

1. Every processing stage is visible.
2. Completed stages survive later failure.
3. Retry is idempotent.
4. Partial results remain available.
5. Temporary uploads are private.
6. Temporary cleanup is verifiable.
7. Transcript origin is accurate.
8. Audio and visual results can be separated.

## Curated Note

1. Smart Summary is useful.
2. Important quotes are exact.
3. Decisions are not confused with discussion.
4. Owners and due dates are not invented.
5. Evidence links resolve.
6. Inference is labeled.
7. User edits do not destroy the original source or transcript.
8. Schema and prompt versions are recorded.

## Output Packs

1. Learn, Create, and Work reuse the Curated Note.
2. Regeneration does not require media reprocessing.
3. Platform output fits configured limits.
4. Existing edits are not overwritten silently.
5. Every output remains a draft.
6. Quick Send never claims successful publication.

## Visual Brief

1. Text remains selectable.
2. Layout recommendation is explainable.
3. Overflow does not produce unreadable text.
4. PNG and PDF match the preview.
5. Source references are available.
6. Accessibility reading order is logical.

## Library

1. Sessions persist after relaunch.
2. Folders can be created, renamed, and deleted.
3. Deleting a folder does not delete sessions by default.
4. Favorites persist.
5. Search returns expected local results.
6. Deletion behavior is clear.

## Export

1. Markdown is readable.
2. JSON validates.
3. PDF is searchable where practical.
4. iCloud folder bookmarks recover.
5. Existing files are not overwritten silently.
6. Share Sheet fallback works.
7. Exported files remain usable without CURA.

## Privacy and Security

1. RLS blocks cross-user access.
2. Signed URLs expire.
3. User content is absent from logs and analytics.
4. Account deletion works.
5. Session deletion works.
6. Temporary deletion works.
7. Permission prompts are contextual.
8. Recording notice is shown.
9. App Store disclosures match behavior.
10. Provider data settings are verified.

## Commercial

1. RevenueCat sandbox purchase works.
2. Restore purchase works.
3. Server-side limits work.
4. Expiration does not lock existing local data.
5. Paywall copy is accurate.
6. Support and legal links work.

## First Vertical Slice

1. Import video from Files.
2. Create local Capture Session.
3. Display mock processing stages.
4. Display mock Curated Note.
5. Display mock Creator Pack.
6. Copy Instagram caption.
7. Copy and Open Instagram.
8. Fall back to Share Sheet.
9. Favorite session.
10. Move session to folder.
11. Relaunch and confirm persistence.
12. Unit and UI tests pass.
