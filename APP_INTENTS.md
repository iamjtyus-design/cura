# CURA App Intents and Apple Shortcuts

## Product Role

Shortcuts are a core differentiator.

App Intents must use shared domain services and must not duplicate business logic.

## Required App Entities

1. Capture Session.
2. Folder.
3. Output Pack.
4. Generated Output.
5. Action Item.

## Required Intents

### Record with CURA

Opens visible recording UI.

Inputs:

1. Session title.
2. Mode.
3. Folder.
4. Processing mode.

Never starts hidden recording.

### Process File with CURA

Inputs:

1. File.
2. Mode.
3. Output Pack.
4. Output language.
5. Context.

Returns:

1. Session.
2. Status.
3. Curated Note when available.

### Analyze Text with CURA

Inputs:

1. Text.
2. Mode.
3. Output Pack.
4. Context.

### Add Source to Recent Session

Inputs:

1. Source.
2. Session.

Returns updated session.

### Get Latest Curated Note

Filters:

1. Mode.
2. Folder.
3. Date.
4. Status.

Returns structured note fields.

### Generate Output Pack

Inputs:

1. Session.
2. Pack.
3. Language.
4. Brand Voice Profile.

### Get Open Action Items

Filters:

1. Session.
2. Folder.
3. Priority.
4. Due-date range.

Returns structured action objects suitable for user-controlled follow-up automation.

### Export to Second Brain

Inputs:

1. Session.
2. Format.
3. Include transcript.
4. Include evidence.

Returns exported file and destination result.

### Find Capture Sessions

Filters:

1. Text.
2. Mode.
3. Folder.
4. Favorite.
5. Date.

### Ask CURA About a Session

Inputs:

1. Session.
2. Question.

Returns answer with source references where possible.

## Safety Rules

1. No hidden recording.
2. No silent publishing.
3. No silent email sending.
4. No silent calendar changes.
5. No silent reminder creation.
6. No silent deletion.
7. Cloud operations require authentication.
8. Processing status must be explicit.
9. Consequential actions remain user-controlled.
10. Clipboard writes require user action.

## Shortcut Output Contract

Return structured values such as:

```text
session_id
title
status
mode
smart_summary
key_ideas
decisions
action_items
people
organizations
projects
risks
open_questions
source_references
markdown_file
json_file
pdf_file
```

## Testing

Test on physical devices:

1. App closed.
2. App backgrounded.
3. Authentication expired.
4. Offline.
5. Large file.
6. Processing incomplete.
7. Folder bookmark stale.
8. Destination app missing.
9. Subscription limit reached.
10. User cancels.
