# Codex and Website Build Workflow

## Source of truth

GitHub is the shared project state.

The home Mac may be the primary development hub, but every device should use the same repository.

## Codex work

Use Codex for:

1. Native SwiftUI app.
2. Supabase schema and migrations.
3. Edge Functions and workers.
4. Provider adapters.
5. Tests and CI.
6. App Intents.
7. RevenueCat.
8. Documentation updates.
9. Website code when using a code-based site.

## Website builder work

Use Sites or a comparable builder for:

1. VisionBuilt marketing site.
2. CURA product explainer.
3. Waitlist.
4. Privacy and support pages.
5. Static product demonstrations.

Do not use the website builder as a substitute for the native iPhone app or the core processing backend.

## Working sequence

1. Add this package to the repository.
2. Run Phase 0.
3. Commit.
4. Run the mock vertical slice.
5. Commit.
6. Add real audio processing.
7. Commit.
8. Add multimodal video.
9. Commit.
10. Build the website after product wording is locked and the first flow exists.
11. Keep marketing claims synchronized with implemented features.
12. Build Mission Control later.

## Session handoff

Before changing devices:

1. Run tests.
2. Commit.
3. Push.
4. Update `docs/CURRENT_STATE.md`.
5. Update `docs/NEXT_ACTIONS.md`.

On the next device:

1. Pull.
2. Read the two status files.
3. Run the app and tests.
4. Continue from the documented next task.
