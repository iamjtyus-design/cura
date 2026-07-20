# AGENTS.md

## Mission

Build CURA by VisionBuilt as a sellable native iPhone beta.

CURA means **Capture. Understand. Refine. Activate.**

## Governing document

`CURA_PRODUCT_CONSTITUTION.md` is the highest product authority.

When documents conflict:

1. Follow the Constitution.
2. Record the conflict in `docs/DECISIONS.md`.
3. Do not silently choose a different direction.
4. Ask for a user decision only when the conflict materially blocks implementation.

## Required behavior

1. Read the relevant documents before editing code.
2. Work in compiling vertical slices.
3. Keep Git commits small and descriptive.
4. Run builds and tests before claiming success.
5. Report failures accurately.
6. Do not fabricate integrations, tests, screenshots, or provider behavior.
7. Keep all secrets server-side.
8. Preserve local user data during interruptions.
9. Keep user-content data out of logs and analytics.
10. Keep the app capture-first.

## Prohibited scope in V1

Do not build:

1. Professional video editing.
2. Full image editing.
3. Automatic social publishing.
4. Social scheduling.
5. Team workspaces.
6. Mission Control dashboard.
7. Android.
8. Hidden recording.
9. Automatic email sending.
10. Automatic calendar changes.
11. Full two-way cloud-drive synchronization.
12. Complex CRM integrations.

## Project memory

Before ending a work session, update:

1. `docs/IMPLEMENTATION_STATUS.md`
2. `docs/CURRENT_STATE.md`
3. `docs/NEXT_ACTIONS.md`
4. `docs/DECISIONS.md` when a decision was made

The repository is the project memory. Chat history is not.

## Engineering standards

1. Native SwiftUI.
2. Swift concurrency.
3. Protocol-based providers and repositories.
4. Dependency injection.
5. Unit and UI tests.
6. Row Level Security.
7. Signed temporary uploads.
8. Idempotent processing jobs.
9. Versioned schemas and prompts.
10. Source evidence on important derived claims.
11. Accessible UI.
12. Content-free analytics.
13. Deterministic export behavior.
14. Clear error recovery.
15. No business logic buried in views.

## Definition of done for a task

A task is done only when:

1. The code compiles.
2. Relevant tests pass.
3. Error states are handled.
4. Accessibility is considered.
5. Documentation is updated.
6. The implementation matches the Constitution.
7. No secret or user content is exposed.
8. The exact result is reported.
