# Start Here

## CURA by VisionBuilt

**CURA means:** Capture. Understand. Refine. Activate.  
**Primary promise:** Capture once. Create everything you need next.

This package is the source material for the CURA iPhone application, temporary-processing backend, and VisionBuilt marketing website.

## Before Codex writes code

Codex must read these files in order:

1. `AGENTS.md`
2. `CURA_PRODUCT_CONSTITUTION.md`
3. `CURA_CODEX_MASTER_BUILD_PROMPT.md`
4. `PRODUCT.md`
5. `ARCHITECTURE.md`
6. `APP_FLOW.md`
7. `BRAND.md`
8. `OUTPUT_PACKS.md`
9. `VISUAL_BRIEF.md`
10. `PRIVACY_LEGAL.md`
11. `ROADMAP.md`
12. `docs/CURRENT_STATE.md`
13. `docs/NEXT_ACTIONS.md`

## First Codex instruction

Paste this into Codex after placing the package in a new Git repository:

> Read `AGENTS.md`, `CURA_PRODUCT_CONSTITUTION.md`, and `CURA_CODEX_MASTER_BUILD_PROMPT.md` completely. Then review the remaining root product documents. Execute Phase 0 only. Create the repository and native iOS project foundation, shared domain models, dependency injection, test targets, configuration, CI, and project-status documents. Do not begin the first feature slice until the foundation compiles and tests pass. Report every file created, command run, build result, test result, missing account, risk, and exact next action.

## After Phase 0

Use the first vertical slice already defined in the Master Build Prompt:

> Import a real video from Files, create a local Capture Session, display mock processing stages, create a mock Curated Note and Creator Pack, copy an Instagram caption, and provide Copy and Open Instagram with Share Sheet fallback. Persist folders and favorites locally.

Do not add live AI before that slice compiles and passes tests.

## Working rules

1. GitHub is the source of truth.
2. Commit after each compiling vertical slice.
3. Never store API secrets in the iOS app.
4. Never let a Codex conversation become the only project memory.
5. Update `docs/CURRENT_STATE.md` and `docs/NEXT_ACTIONS.md` before ending every build session.
6. The Product Constitution wins when documents disagree.
