# CURA Visual Brief Specification

## Document Status

**Product:** CURA by VisionBuilt  
**Version:** 1.0  
**Primary source of truth:** `CURA_PRODUCT_CONSTITUTION.md`

This document defines CURA’s Visual Brief system.

A Visual Brief is a structured, editable, source-grounded visual summary generated from a Curated Note.

It is a signature CURA output.

When this document conflicts with the Product Constitution, the Constitution wins.

---

## 1. Product Purpose

Visual Brief helps users understand and share information faster.

It converts a Capture Session into a clear visual artifact such as:

1. One-page summary.
2. Timeline.
3. Process map.
4. Concept map.
5. Comparison.
6. Quote layout.
7. Key-statistics layout.
8. Carousel plan.
9. Presentation outline.
10. Workflow reconstruction.

Visual Brief should make information easier to scan, remember, present, and reuse.

It should not become a full graphic-design application.

---

## 2. Core Product Principle

Critical text must remain real text.

CURA must not rely on image-generation models to render:

1. Headlines.
2. Quotes.
3. Statistics.
4. Instructions.
5. Timeline labels.
6. Process steps.
7. Names.
8. Dates.
9. Source references.
10. Action items.

Generated images may support a design later, but they should not control factual text.

The rendering system should use structured content, reusable templates, and real layout components.

---

## 3. Visual Brief Promise

A user should be able to:

1. Generate a visual summary from any eligible Curated Note.
2. Let CURA recommend the best layout.
3. Choose another layout.
4. Review the content before export.
5. Edit text.
6. Remove sections.
7. Reorder supported sections.
8. Change visual density.
9. Apply an approved theme.
10. Export as PNG or PDF.
11. Share through iOS.
12. Save to Files or a Second Brain folder.
13. Preserve source references.
14. Regenerate without reprocessing original media.

---

## 4. Supported Source Types

Visual Brief should work with:

1. Audio recordings.
2. Video recordings.
3. YouTube videos.
4. Social videos.
5. Interviews.
6. Meetings.
7. Lectures.
8. Sermons.
9. Property walkthroughs.
10. Site visits.
11. PDFs.
12. Web pages.
13. Photos.
14. Screenshots.
15. Typed notes.
16. Multi-source Capture Sessions.

The quality of a Visual Brief depends on the quality of the Curated Note.

---

## 5. Visual Brief Object

Every Visual Brief should include:

```text
id
session_id
curated_note_id
output_pack_id_optional
layout_type
title
subtitle
status
theme_key
density
page_format
orientation
language
sections
source_references
render_version
schema_version
prompt_version
model_metadata
created_at
updated_at
export_history
```

### Status values

```text
draft
generating
ready
edited
rendering
exported
failed
archived
deleted
```

---

## 6. Visual Brief Section Object

Each section should include:

```text
id
section_type
headline
body
items
order
priority
evidence_references
style_variant
is_editable
is_visible
```

### Section types

```text
summary
key_point
quote
statistic
timeline_event
process_step
concept
comparison_item
action_item
decision
risk
question
source
visual_observation
callout
```

---

## 7. Base Content Schema

A Visual Brief generation request should support:

```text
title
subtitle
summary
key_points
quotes
statistics
timeline
process_steps
concepts
comparisons
decisions
actions
risks
questions
visual_observations
sources
theme
layout_preference
density
page_format
orientation
language
```

Not every layout uses every field.

---

## 8. Layout Recommendation Engine

CURA should recommend a layout based on the Curated Note.

### Recommendation signals

Use:

1. Chronological density.
2. Number of process steps.
3. Number of comparable items.
4. Number of key concepts.
5. Number of quotes.
6. Number of statistics.
7. Number of decisions.
8. Number of actions.
9. Visual observations.
10. User mode.
11. Output Pack.
12. Source type.
13. User-selected purpose.

### Example rules

#### Recommend Timeline when:

1. Chronology matters.
2. Several time-coded events exist.
3. The source is historical, procedural, or event-based.

#### Recommend Process Map when:

1. A workflow or method is demonstrated.
2. The source includes ordered actions.
3. The user chooses Work Mode.

#### Recommend Concept Map when:

1. Several connected ideas exist.
2. The source is educational.
3. The user chooses Learn Mode.

#### Recommend Comparison when:

1. Two or more approaches, products, ideas, or positions are discussed.
2. The Curated Note contains structured differences.

#### Recommend Quote Layout when:

1. The source contains strong attributable quotes.
2. The user chooses Create Mode.
3. The intended destination is social media or presentation.

#### Recommend One-Page Summary when:

1. No specialized layout clearly dominates.
2. The user wants a concise overview.
3. The source contains mixed information.

The system should explain its recommendation briefly.

Example:

> Timeline fits this session because the main ideas unfold in sequence.

---

## 9. Required V1 Layouts

The sellable beta should include:

1. One-Page Summary.
2. Timeline.
3. Process Map.
4. Concept Map.
5. Comparison.
6. Quote Layout.
7. Key Statistics.
8. Carousel Plan.

Presentation Outline may be a fast-follow.

---

## 10. One-Page Summary

### Purpose

Provide a compact overview of a Capture Session.

### Recommended sections

1. Title.
2. Smart Summary.
3. Three to seven Key Points.
4. Important Quote.
5. Decisions or Actions.
6. Risks or Questions.
7. Source note.

### Ideal uses

1. Meeting.
2. Interview.
3. Lecture.
4. Sermon.
5. Event.
6. YouTube video.
7. Article.
8. General session.

### Rules

1. Keep to one page where practical.
2. Prioritize information.
3. Avoid overfilling.
4. Show no more than one primary quote by default.
5. Show only the most important actions.
6. Allow expanded multi-page version.

---

## 11. Timeline

### Purpose

Show the sequence of events, ideas, or changes.

### Required event fields

```text
time_or_order
title
description
source_reference
importance
```

### Ideal uses

1. Event recap.
2. Historical lecture.
3. Project discussion.
4. Interview story.
5. Video chapter summary.
6. Workflow progression.
7. Property walkthrough.
8. Incident review.

### Rules

1. Preserve chronology.
2. Do not invent times.
3. Use order labels when exact time is unavailable.
4. Support vertical and horizontal layouts.
5. Avoid overcrowding.
6. Link events to source timestamps or pages.

---

## 12. Process Map

### Purpose

Show how a process works.

### Required step fields

```text
step_number
title
description
input
output
decision_point_optional
source_reference
confidence
```

### Ideal uses

1. Apple Shortcut workflow.
2. Operational process.
3. Property procedure.
4. Tutorial.
5. Demonstration.
6. SOP.
7. Content workflow.
8. Sales process.

### Rules

1. Separate observed steps from inferred steps.
2. Mark unknown transitions.
3. Preserve sequence.
4. Support decision branches.
5. Keep V1 to simple flows.
6. Do not become a full diagramming editor.

---

## 13. Concept Map

### Purpose

Show relationships between ideas.

### Required fields

```text
central_concept
nodes
relationships
source_references
```

Each node:

```text
id
label
description
category
priority
```

Each relationship:

```text
from_node
to_node
relationship_label
confidence
```

### Ideal uses

1. Lecture.
2. Sermon.
3. Research topic.
4. Book notes.
5. Podcast.
6. Strategy conversation.
7. Complex interview.

### Rules

1. Keep node count limited.
2. Avoid meaningless relationship labels.
3. Preserve source meaning.
4. Use hierarchy when appropriate.
5. Support zoom in future.
6. Export a readable static version in V1.

---

## 14. Comparison

### Purpose

Compare two or more items.

### Required fields

```text
items
criteria
summary
recommendation_optional
source_references
```

### Ideal uses

1. Product comparison.
2. Strategy options.
3. Two viewpoints.
4. Before and after.
5. Pros and cons.
6. Competing approaches.
7. Property options.
8. Platform comparison.

### Rules

1. Use only supported criteria.
2. Avoid inventing missing values.
3. Mark unknown fields.
4. Distinguish source conclusion from CURA suggestion.
5. Allow neutral comparison without recommendation.

---

## 15. Quote Layout

### Purpose

Create a visually strong quote-based artifact.

### Required fields

```text
quote
speaker
context
source_reference
supporting_point_optional
```

### Ideal uses

1. Interview.
2. Sermon.
3. Event.
4. Podcast.
5. Social content.
6. Presentation.
7. Newsletter.

### Rules

1. Direct quotes remain exact.
2. Paraphrases are labeled.
3. Speaker must be supported.
4. Context should not distort meaning.
5. Avoid quote overdesign.
6. Support square and portrait social sizes.

---

## 16. Key Statistics Layout

### Purpose

Present important numeric information.

### Required fields

```text
value
label
context
source_reference
confidence
```

### Ideal uses

1. Research.
2. Business review.
3. Event metrics.
4. Property observations.
5. Market discussion.
6. Educational content.
7. Survey or report.

### Rules

1. No fabricated numbers.
2. Preserve units.
3. Preserve denominators.
4. Include context.
5. Mark estimates.
6. Avoid using statistics when the source is weak.

---

## 17. Carousel Plan

### Purpose

Create a visual content plan for Instagram, LinkedIn, or other slide-based posts.

### Required structure

```text
carousel_title
platform
slide_count
slides
caption
call_to_action
visual_direction
```

Each slide:

```text
number
headline
body
visual_suggestion
source_reference
```

### Rules

1. One main idea per slide.
2. Keep copy readable.
3. Preserve narrative sequence.
4. Use real editable text.
5. Export as individual images and PDF.
6. CURA does not become a full Canva replacement.
7. Provide copy-ready export for Canva.

---

## 18. Presentation Outline

### Purpose

Create a slide-by-slide presentation plan.

### Fast-follow structure

```text
presentation_title
audience
objective
slides
speaker_notes
source_references
```

Each slide:

```text
number
title
main_point
supporting_points
visual_suggestion
source_reference
```

V1 may generate the outline without fully rendering presentation files.

---

## 19. Visual Themes

Initial themes should be limited.

Recommended V1 themes:

1. CURA Light.
2. CURA Dark.
3. Executive.
4. Learning.
5. Creator.
6. Minimal.

Each theme defines:

1. Background.
2. Text.
3. Accent.
4. Border.
5. Typography.
6. Spacing.
7. Icon treatment.
8. Chart treatment.
9. Quote treatment.
10. Source treatment.

Themes should not change factual structure.

---

## 20. Design Tokens

Visual Brief should use shared tokens.

### Typography

1. Display.
2. Title.
3. Section Heading.
4. Body.
5. Caption.
6. Data Value.
7. Source Label.

### Spacing

1. Extra Small.
2. Small.
3. Medium.
4. Large.
5. Extra Large.

### Radius

1. Small.
2. Medium.
3. Large.

### Borders

1. Subtle.
2. Standard.
3. Emphasis.

### Shadows

Use sparingly.

---

## 21. Visual Density

Supported density options:

1. Compact.
2. Balanced.
3. Spacious.

### Compact

For:

1. Reports.
2. Internal work.
3. Dense study material.
4. Multi-section exports.

### Balanced

Default.

### Spacious

For:

1. Social content.
2. Presentations.
3. Quote layouts.
4. Simple executive summaries.

Density should adjust typography and spacing, not remove critical facts silently.

---

## 22. Page Formats

Support:

1. Phone portrait.
2. Square social.
3. Portrait social.
4. Landscape presentation.
5. Letter.
6. A4.
7. Custom later.

Recommended sizes:

1. 1080 × 1080.
2. 1080 × 1350.
3. 1920 × 1080.
4. US Letter.
5. A4.

Export should preserve high-resolution text.

---

## 23. Orientation

Support:

1. Portrait.
2. Landscape.
3. Square.

Auto recommendation may use:

1. Layout type.
2. Destination.
3. Content length.
4. User preference.

---

## 24. Editing Boundaries

V1 editing should support:

1. Edit title.
2. Edit subtitle.
3. Edit section text.
4. Hide section.
5. Reorder supported sections.
6. Choose theme.
7. Choose density.
8. Choose format.
9. Choose orientation.
10. Regenerate one section.
11. Reset to generated version.

V1 should not support:

1. Freeform object placement.
2. Arbitrary font upload.
3. Complex layers.
4. Vector editing.
5. Photo masking.
6. Advanced animation.
7. Video editing.
8. Full collaborative design.
9. Plugin ecosystem.
10. Full brand-kit designer.

---

## 25. Evidence Display

Visual Brief should support evidence without clutter.

Display options:

1. Source markers.
2. Footnote numbers.
3. Timestamp chips.
4. Page references.
5. Source list.
6. Evidence drawer in app.

For exported social layouts, source markers may be optional.

For work and learning outputs, evidence should be enabled by default.

---

## 26. Inference Display

If content is inferred:

1. Show an Inferred label in editing mode.
2. Allow user review.
3. Hide technical confidence in final social export unless requested.
4. Preserve inference metadata in JSON and PDF notes.
5. Never style inference as certain fact.

---

## 27. Image Use

Visual Brief may include:

1. User-provided photos.
2. Key frames from video.
3. Screenshots.
4. Document previews.
5. Icons.
6. Simple charts.
7. Abstract background elements.

Rules:

1. Preserve user ownership.
2. Do not use copyrighted external images without permission.
3. Do not silently upload images to another provider.
4. Clearly label generated illustrations if added later.
5. Avoid AI-generated text inside images.
6. Avoid replacing evidence with decorative imagery.

---

## 28. Key Frame Selection

For video sources, CURA may recommend frames.

Required frame fields:

```text
source_id
timestamp
reason
visual_description
quality_score
contains_text
contains_person
contains_interface
```

Rules:

1. Select clear frames.
2. Avoid near-duplicates.
3. Preserve timestamp.
4. Avoid unflattering or private frames where possible.
5. Allow user removal.
6. Do not identify unknown people by name without source evidence.

---

## 29. Chart Support

V1 charts should be simple and data-grounded.

Supported chart types:

1. Bar.
2. Line.
3. Donut.
4. Progress.
5. Comparison table.
6. Ranked list.

Rules:

1. Use only source-supported data.
2. Preserve units.
3. Avoid misleading scales.
4. Show source.
5. Allow table fallback.
6. Do not invent missing data.

---

## 30. Accessibility

Visual Brief must support:

1. Sufficient contrast.
2. Dynamic preview text where practical.
3. VoiceOver descriptions.
4. Logical reading order.
5. Text alternatives for images.
6. Non-color distinction.
7. Large text mode.
8. Reduced motion.
9. PDF text selection.
10. Accessible export where technically supported.

---

## 31. Rendering Architecture

Recommended rendering flow:

```text
Curated Note
→ Visual Brief schema
→ Layout recommendation
→ Template component tree
→ User edits
→ Preview render
→ Export render
```

The schema should remain independent of SwiftUI.

This allows future rendering in:

1. iOS.
2. Web.
3. Mission Control.
4. Server-side export.
5. Future desktop tools.

---

## 32. Renderer Requirements

The renderer should:

1. Accept structured JSON.
2. Validate required fields.
3. Apply theme tokens.
4. Handle overflow.
5. Split pages when needed.
6. Preserve reading order.
7. Render high-resolution output.
8. Support deterministic results.
9. Record render version.
10. Produce export metadata.

---

## 33. Overflow Rules

When content exceeds layout:

1. Reduce optional sections first.
2. Suggest Expanded Version.
3. Split into pages.
4. Do not shrink text below accessibility threshold.
5. Do not silently truncate critical text.
6. Show a warning before export.
7. Preserve full text in metadata or appendix where relevant.

---

## 34. Auto-Summarization for Layout

Visual Brief may create a visual-specific condensed summary.

Rules:

1. Use Curated Note as source.
2. Preserve original meaning.
3. Avoid removing critical qualifiers.
4. Link condensed text to full section.
5. Let user expand.
6. Mark when condensed.

---

## 35. Visual Brief Generation Modes

### Auto

CURA selects layout and sections.

### Guided

User chooses:

1. Purpose.
2. Layout.
3. Audience.
4. Destination.
5. Density.

### Custom

User chooses:

1. Sections.
2. Order.
3. Theme.
4. Format.
5. Orientation.
6. Evidence style.

V1 should prioritize Auto and Guided.

---

## 36. Purpose Options

The user may select:

1. Understand.
2. Present.
3. Share.
4. Study.
5. Report.
6. Publish.
7. Save.

The purpose influences layout and density.

---

## 37. Destination Options

1. Instagram.
2. LinkedIn.
3. X.
4. Presentation.
5. Email.
6. Files.
7. Second Brain.
8. Print.
9. General.

Destination affects size and source display.

---

## 38. Visual Brief by Mode

### Learn

Prioritize:

1. Concepts.
2. Definitions.
3. Relationships.
4. Timeline.
5. Review prompts.
6. Sources.

### Create

Prioritize:

1. Hooks.
2. Quotes.
3. Key ideas.
4. Carousel.
5. Strong visual hierarchy.
6. Shareable formats.

### Work

Prioritize:

1. Summary.
2. Decisions.
3. Actions.
4. Timeline.
5. Process.
6. Risks.
7. Sources.

---

## 39. Visual Brief by Pack

### Creator Pack

Default:

1. Carousel Plan.
2. Quote Layout.
3. One-Page Summary.

### Interview Pack

Default:

1. Quote Layout.
2. One-Page Summary.
3. Timeline.

### Event Pack

Default:

1. Timeline.
2. One-Page Summary.
3. Key Statistics.

### Learning Pack

Default:

1. Concept Map.
2. One-Page Summary.
3. Timeline.

### Business Pack

Default:

1. One-Page Summary.
2. Process Map.
3. Timeline.

### Property Walk Pack

Default:

1. One-Page Summary.
2. Timeline.
3. Issue Map or categorized list.

---

## 40. Export Formats

Required V1:

1. PNG.
2. PDF.
3. Share Sheet.
4. Save to Files.
5. Save to iCloud Drive.
6. Save to session.

Fast follow:

1. SVG.
2. PowerPoint.
3. Keynote.
4. Figma-ready structure.
5. Web link.

Do not promise unsupported formats at launch.

---

## 41. PNG Export

Requirements:

1. High resolution.
2. Correct dimensions.
3. Embedded color profile where appropriate.
4. No clipped text.
5. Accurate preview.
6. Metadata where appropriate.
7. Individual images for carousel slides.

---

## 42. PDF Export

Requirements:

1. Selectable text.
2. Multiple pages.
3. Embedded fonts supported by system.
4. Source references.
5. Accessible reading order where practical.
6. Accurate page size.
7. Searchable content.
8. No rasterization of all text unless unavoidable.

---

## 43. Carousel Export

For Carousel Plan:

1. Export each slide as PNG.
2. Export combined PDF.
3. Export slide copy as text.
4. Export Canva-ready copy.
5. Preserve slide order.
6. Include caption separately.
7. Include source references optionally.

CURA does not directly create or publish the Instagram carousel in V1.

---

## 44. Share Sheet

Share Sheet should support:

1. PNG.
2. PDF.
3. Text summary.
4. Carousel images.
5. Source link where appropriate.

The app should not assume the destination completed the action.

---

## 45. Visual Brief Versioning

Each revision should record:

```text
version
parent_version_id
layout_type
theme_key
user_edits
generation_settings
created_at
```

User should be able to:

1. View current.
2. Restore generated.
3. Duplicate.
4. Regenerate.
5. Compare prior version later.

---

## 46. Regeneration

Users may regenerate:

1. Entire Visual Brief.
2. Layout only.
3. One section.
4. Summary.
5. Quote selection.
6. Key points.
7. Timeline.
8. Visual suggestions.
9. Theme recommendation.

Regeneration should not overwrite edits without confirmation.

---

## 47. Error Handling

### Unsupported layout

> This session does not contain enough structured information for that layout. Try One-Page Summary.

### Overflow

> This content needs more space. Use Expanded Version or remove a section.

### Missing evidence

> One section could not be linked to a source. Review before exporting.

### Render failure

> Your Visual Brief content is safe. Retry the export.

### Image issue

> One image could not be included. Export without it or choose another image.

---

## 48. Quality Evaluation

Evaluate Visual Briefs on:

1. Accuracy.
2. Readability.
3. Information hierarchy.
4. Source fidelity.
5. Layout fit.
6. Export quality.
7. Accessibility.
8. Usefulness.
9. Edit effort.
10. Visual consistency.

---

## 49. First Visual Brief Vertical Slice

The first implementation should:

1. Use a mock Curated Note.
2. Generate One-Page Summary schema.
3. Render with SwiftUI.
4. Allow title editing.
5. Allow hiding one section.
6. Switch between Light and Dark.
7. Preview portrait format.
8. Export PNG.
9. Export PDF.
10. Share through Share Sheet.
11. Persist the Visual Brief locally.
12. Include tests for overflow and export.

Do not begin with freeform design tools.

---

## 50. V1 Acceptance Criteria

A user can:

1. Open a completed Capture Session.
2. Tap Create Visual Brief.
3. Accept Auto layout.
4. Select another layout.
5. Edit text.
6. Hide a section.
7. Change theme.
8. Change density.
9. Preview.
10. Export PNG.
11. Export PDF.
12. Share.
13. Save to Files.
14. Reopen the Visual Brief.
15. See source references.
16. Regenerate without reprocessing media.

---

## 51. Future Expansion

Future possibilities:

1. Mission Control visual boards.
2. Collaborative editing.
3. Brand kits.
4. Custom templates.
5. Presentation generation.
6. SVG export.
7. Web publishing.
8. Interactive visual briefs.
9. Embedded audio and video.
10. Animated timelines.
11. Team template libraries.
12. Figma integration.
13. Canva integration.
14. Direct social design handoff.
15. Data-driven dashboard views.

These should not delay the V1 system.

---

## 52. Final Visual Brief Definition

Visual Brief is CURA’s visual understanding layer.

It turns a Curated Note into a structured, editable, source-grounded visual artifact.

It helps users understand faster, communicate more clearly, and move information into the next stage.

It should feel polished without becoming complicated.

It should make the value of the capture visible.
