# CURA VisionBuilt Codex Build Package v4

This repository package defines the product, brand, architecture, privacy model, website, schemas, and implementation sequence for **CURA by VisionBuilt**.

## Product

CURA is a native, mobile-first, multimodal capture and knowledge-activation product.

It accepts audio, video, photos, screenshots, text, PDFs, web pages, public YouTube links, supported social links, and multi-source Capture Sessions.

It creates one canonical Curated Note and then produces useful outputs through:

1. Learn
2. Create
3. Work

CURA is a capture tool first. It is not a professional editing suite, social scheduler, or Mission Control dashboard.

## Package map

### Source of truth

- `CURA_PRODUCT_CONSTITUTION.md`
- `CURA_CODEX_MASTER_BUILD_PROMPT.md`
- `PRODUCT.md`
- `BRAND.md`
- `APP_FLOW.md`
- `OUTPUT_PACKS.md`
- `VISUAL_BRIEF.md`
- `ARCHITECTURE.md`
- `PRIVACY_LEGAL.md`
- `WEBSITE.md`
- `ROADMAP.md`

### Build instructions

- `START_HERE.md`
- `AGENTS.md`
- `CODEX_AND_SITES_BUILD_WORKFLOW.md`
- `docs/CURRENT_STATE.md`
- `docs/NEXT_ACTIONS.md`
- `docs/IMPLEMENTATION_STATUS.md`
- `docs/DECISIONS.md`

### Technical starters

- `database/DATABASE.sql`
- `database/MISSION_CONTROL_SCHEMA_ADDITIONS.sql`
- `schemas/CURATED_NOTE_SCHEMA.json`
- `schemas/OUTPUT_PACK_SCHEMA.json`
- `schemas/VISUAL_BRIEF_SCHEMA.json`
- `config/.env.example`
- `config/project.json`

### Product systems

- `DESIGN_SYSTEM.md`
- `APP_INTENTS.md`
- `AI_PROMPTS.md`
- `REFERENCE_APP_PARITY.md`
- `YOUTUBE_GEMINI_ARCHITECTURE.md`
- `MARKDOWN_EXPORT_TEMPLATE.md`

### Quality and release

- `docs/QA_ACCEPTANCE.md`
- `docs/SECURITY.md`
- `docs/AI_EVALUATION.md`
- `docs/RELEASE_CHECKLIST.md`

## Recommended execution order

1. Repository foundation
2. Mock vertical slice
3. Real audio capture and transcription
4. Multimodal video understanding
5. Curated Note and Output Packs
6. Visual Brief
7. Imports, exports, Quick Send, and App Intents
8. Privacy, billing, reliability, and TestFlight
9. VisionBuilt and CURA website
10. Mission Control only after real product usage validates the dashboard

## Important boundary

Do not try to build all features at once.

The 10/10 standard means focused execution, strong reliability, clear design, evidence-grounded intelligence, and honest privacy. It does not mean uncontrolled scope.
