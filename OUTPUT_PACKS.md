# CURA Output Packs Specification

## Document Status

**Product:** CURA by VisionBuilt  
**Version:** 1.0  
**Primary source of truth:** `CURA_PRODUCT_CONSTITUTION.md`

This document defines how CURA transforms a Curated Note into usable outputs.

It covers:

1. Output Pack structure.
2. Required packs.
3. Output types.
4. Platform-specific outputs.
5. Learn, Create, and Work rules.
6. Evidence requirements.
7. Customization.
8. Regeneration.
9. Export.
10. Quality standards.

When this document conflicts with the Product Constitution, the Constitution wins.

---

## 1. Product Principle

CURA should not ask users to build every output one item at a time.

Output Packs should make common outcomes available quickly.

A user captures once, receives one Curated Note, and then creates one or more reusable packs.

Each pack is a grouped set of outputs designed around a real goal.

Examples:

1. Turn an interview into social content.
2. Turn a lecture into study materials.
3. Turn a meeting into action.
4. Turn an event into a recap.
5. Turn a walkthrough into a report.
6. Turn a video into a Visual Brief.

---

## 2. Output Pack Object

Every Output Pack should include:

```text
id
session_id
curated_note_id
pack_key
pack_name
mode
status
output_language
brand_voice_profile_id
generation_settings
created_at
updated_at
generated_outputs
evidence_policy
prompt_version
schema_version
model_metadata
```

### Status values

```text
draft
queued
generating
partially_complete
complete
failed
archived
deleted
```

---

## 3. Generated Output Object

Every generated output should include:

```text
id
output_pack_id
session_id
curated_note_id
output_type
title
content
structured_content
platform
audience
tone
language
length
status
evidence_references
inference_labels
prompt_version
schema_version
model
created_at
updated_at
```

### Output status values

```text
draft
generated
edited
approved
exported
failed
archived
deleted
```

Generated content remains a draft until the user approves or exports it.

---

## 4. Output Pack Rules

1. Every pack uses the Curated Note as its source.
2. Every factual claim should trace back to source evidence.
3. Every direct quote must link to evidence.
4. Inferred details must be labeled.
5. User edits must not modify the Curated Note unless explicitly chosen.
6. Regenerating one output should not regenerate the entire pack.
7. Users may remove outputs from a pack.
8. Users may add outputs to an existing pack.
9. Users may save a modified pack as a Custom Pack.
10. Pack generation should preserve style settings.
11. Pack generation should preserve language settings.
12. Failed outputs should not hide successful outputs.
13. Every pack should support export-all.
14. Every output should support copy and share.
15. Platform-specific outputs should follow current limits through configurable rules.

---

## 5. Required Packs

The sellable beta should include:

1. Creator Pack.
2. Interview Pack.
3. Event Pack.
4. Learning Pack.
5. Business Pack.
6. Property Walk Pack.
7. Sermon or Teaching Pack.
8. Video Insight Pack.
9. Custom Pack.

The first five are mandatory for the earliest beta.

---

## 6. Creator Pack

### Purpose

Turn one capture into a ready-to-use content package.

### Ideal sources

1. Interview.
2. Podcast.
3. Voice note.
4. Event.
5. Social video.
6. YouTube video.
7. Teaching.
8. Product demonstration.
9. Personal story.
10. Research session.

### Default outputs

1. Smart Summary.
2. Five Hooks.
3. Instagram Caption.
4. LinkedIn Post.
5. X Thread.
6. Threads Post.
7. Facebook Post.
8. Carousel Outline.
9. Carousel Slide Copy.
10. Quote Options.
11. Short-Form Clip Suggestions.
12. Article Outline.
13. Newsletter Draft.
14. Content Series Ideas.
15. Calls to Action.
16. Visual Brief.

### Optional outputs

1. TikTok Caption.
2. Reel Caption.
3. YouTube Title Options.
4. YouTube Description.
5. YouTube Chapters.
6. Faceless Content Prompts.
7. Short-Form Scripts.
8. Blog Draft.
9. Podcast Description.
10. Show Notes.

---

## 7. Interview Pack

### Purpose

Turn an interview into organized knowledge and publish-ready assets.

### Default outputs

1. Interview Summary.
2. Guest Profile.
3. Key Themes.
4. Best Quotes.
5. Follow-Up Questions.
6. Social Recap.
7. LinkedIn Post.
8. Instagram Caption.
9. X Thread.
10. Clip Suggestions.
11. Article Outline.
12. Newsletter Draft.
13. Visual Brief.
14. Follow-Up Email Draft.

### Interview Summary fields

```text
guest
interviewer
purpose
main_topics
key_takeaways
notable_moments
open_questions
next_steps
```

### Guest Profile fields

```text
name
role
organization
expertise
background
notable_claims
links
uncertainties
```

Do not invent biography details.

---

## 8. Event Pack

### Purpose

Turn an event, conference, panel, service, or gathering into recap content and useful records.

### Default outputs

1. Event Summary.
2. Speaker Takeaways.
3. Session Highlights.
4. Best Quotes.
5. Photo Captions.
6. LinkedIn Recap.
7. Instagram Caption.
8. X Thread.
9. Daily Recap.
10. Follow-Up Actions.
11. Content Calendar Ideas.
12. Visual Brief.
13. Attendee Follow-Up Draft.
14. Event Article Outline.

### Event-specific fields

```text
event_name
location
date
speakers
sessions
themes
announcements
quotes
follow_ups
content_opportunities
```

---

## 9. Learning Pack

### Purpose

Turn a lecture, sermon, class, podcast, article, or educational video into structured learning materials.

### Default outputs

1. Structured Notes.
2. Key Concepts.
3. Definitions.
4. Study Guide.
5. Quiz.
6. Flashcards.
7. Glossary.
8. Reflection Questions.
9. Concept Map.
10. Visual Brief.
11. Review Plan.
12. Source References.

### Optional outputs

1. Essay Questions.
2. Discussion Guide.
3. Memory Review.
4. Reading Plan.
5. Practice Problems.
6. Summary by Difficulty.
7. Child-Friendly Explanation.
8. Advanced Explanation.
9. Sermon Application Notes.
10. Scripture List.

Scripture references must come only from the source.

---

## 10. Business Pack

### Purpose

Turn a meeting, call, consulting session, or operational conversation into organized action.

### Default outputs

1. Executive Summary.
2. Decisions.
3. Action Items.
4. Owners.
5. Due Dates.
6. Risks.
7. Open Questions.
8. Follow-Up Email.
9. Action Plan.
10. Project Plan.
11. Team Handoff.
12. Second Brain Export.
13. Visual Brief.

### Optional outputs

1. CRM Notes.
2. Proposal Outline.
3. Client Recap.
4. Meeting Agenda.
5. SOP.
6. Status Update.
7. Stakeholder Brief.
8. Decision Log.
9. Risk Register.
10. Next Meeting Preparation.

---

## 11. Property Walk Pack

### Purpose

Turn a property, site, or inspection walkthrough into an organized operational report.

### Ideal sources

1. Walkthrough video.
2. Audio observations.
3. Photos.
4. Screenshots.
5. Typed notes.
6. Documents.
7. Property listing or work-order link.

### Default outputs

1. Property Summary.
2. Observed Conditions.
3. Maintenance Issues.
4. Safety Concerns.
5. Recommended Actions.
6. Priority Ranking.
7. Photo Log.
8. Vendor Brief.
9. Owner Update.
10. Work Order Drafts.
11. Follow-Up Checklist.
12. Visual Brief.

### Property issue fields

```text
location
issue
severity
evidence
recommended_action
suggested_owner
suggested_timing
confidence
```

CURA must avoid representing itself as a licensed inspector.

---

## 12. Sermon or Teaching Pack

### Purpose

Turn a sermon, church service, teaching, or devotional into useful notes and reflection material.

### Default outputs

1. Teaching Summary.
2. Main Message.
3. Key Points.
4. Scriptures Explicitly Mentioned.
5. Reflection Questions.
6. Application Ideas.
7. Study Guide.
8. Flashcards.
9. Social Quote Options.
10. Discussion Guide.
11. Visual Brief.
12. Personal Action Notes.

### Rules

1. Do not invent scripture references.
2. Do not rewrite interpretation as fact.
3. Preserve speaker framing.
4. Separate source statements from user reflections.
5. Mark uncertain references.
6. Avoid presenting theological conclusions as universally settled.

---

## 13. Video Insight Pack

### Purpose

Turn an uploaded or linked video into a combined audio and visual intelligence package.

### Default outputs

1. Audio Summary.
2. Visual Summary.
3. Combined Summary.
4. Visible Text.
5. Demonstrated Steps.
6. Timeline.
7. Key Frames.
8. Clip Suggestions.
9. Workflow Reconstruction.
10. Unrelated Track Notice.
11. Visual Brief.
12. Content Opportunities.

### Required relationship fields

```text
audio_topic
visual_topic
relationship_type
relationship_confidence
combined_interpretation
```

### Relationship types

```text
aligned
partially_aligned
unrelated
uncertain
```

---

## 14. Custom Pack

### Purpose

Allow users to save a repeatable output configuration.

### Required capabilities

1. Name pack.
2. Select mode.
3. Select outputs.
4. Select default language.
5. Select brand voice.
6. Select audience.
7. Select platform.
8. Select length.
9. Select Visual Brief layout.
10. Select evidence visibility.
11. Save.
12. Edit.
13. Duplicate.
14. Delete.
15. Set as default.

### Custom Pack example

```text
Pack Name: Sunday Teaching Content
Mode: Create
Outputs:
  Teaching Summary
  Five Quote Posts
  Instagram Caption
  Facebook Post
  Short Reel Hooks
  Discussion Questions
  Visual Brief
Tone: Encouraging and grounded
Audience: Church members and local community
```

---

## 15. Smart Summary

### Purpose

Provide the fastest useful understanding of the source.

### Required structure

```text
what_this_is
why_it_matters
main_points
important_context
next_step
uncertainties
```

### Rules

1. Keep concise.
2. Avoid generic filler.
3. Preserve user context.
4. Surface important contradiction.
5. Mention unrelated tracks where relevant.
6. Label uncertainty.
7. Do not overstate.

---

## 16. Detailed Summary

### Purpose

Provide a fuller organized explanation.

### Suggested structure

```text
overview
topic_sections
important_examples
decisions
actions
open_questions
visual_findings
conclusion
```

### Rules

1. Organize by topic.
2. Preserve chronology when important.
3. Use headings.
4. Avoid repeating transcript.
5. Include visuals when relevant.
6. Preserve evidence.

---

## 17. Hooks

### Purpose

Create opening lines for social, video, article, or email use.

### Hook categories

1. Curiosity.
2. Contrarian.
3. Practical.
4. Emotional.
5. Question.
6. Result.
7. Story.
8. Warning.
9. Statistic.
10. Insight.

### Hook output fields

```text
hook
category
best_platform
best_audience
source_basis
```

### Rules

1. No fabricated statistic.
2. No fabricated quote.
3. Avoid clickbait that misrepresents source.
4. Keep hooks distinct.
5. Support short and expanded versions.

---

## 18. Instagram Caption

### Required fields

```text
opening_hook
body
call_to_action
hashtags_optional
alternate_short_version
```

### Rules

1. Lead with a strong first line.
2. Use readable spacing.
3. Avoid hashtag stuffing.
4. Preserve user brand voice.
5. Support concise and expanded versions.
6. Do not imply media attachments that do not exist.

---

## 19. Instagram Carousel

### Required structure

```text
carousel_title
slide_count
slides
caption
call_to_action
visual_direction
```

Each slide should include:

```text
slide_number
headline
body
source_reference
visual_suggestion
```

### Rules

1. One main idea per slide.
2. Keep copy readable.
3. Avoid overly dense text.
4. Preserve logical sequence.
5. Include a clear closing slide.
6. Export copy cleanly for Canva.

---

## 20. LinkedIn Post

### Required fields

```text
hook
body
insight
practical_takeaway
call_to_action
alternate_version
```

### Styles

1. Founder insight.
2. Professional lesson.
3. Event recap.
4. Interview takeaway.
5. Operational lesson.
6. Industry observation.
7. Personal reflection.

### Rules

1. Avoid fake vulnerability.
2. Avoid manufactured authority.
3. Preserve professional tone.
4. Keep factual claims grounded.
5. Support first-person or neutral voice.

---

## 21. X Post and Thread

### X Post fields

```text
post
alternate_post
source_basis
```

### X Thread fields

```text
thread_hook
posts
closing_post
call_to_action
```

Each thread item should include:

```text
order
text
source_reference
```

### Rules

1. Respect configurable character limits.
2. Keep each post understandable.
3. Avoid splitting sentences awkwardly.
4. Preserve source truth.
5. Allow numbered and unnumbered threads.

---

## 22. Threads Post

### Fields

```text
opening
body
closing
alternate_short_version
```

### Rules

1. Conversational.
2. Clear.
3. Not overly formal.
4. Avoid platform stereotypes.
5. Preserve user voice.

---

## 23. Facebook Post

### Fields

```text
opening
body
context
call_to_action
alternate_version
```

### Rules

1. Support personal and page style.
2. Allow longer context.
3. Avoid aggressive engagement bait.
4. Preserve facts.

---

## 24. TikTok and Reel Hooks

### Required fields

```text
spoken_hook
on_screen_text
first_three_seconds
suggested_visual
source_reference
```

### Rules

1. Hook must match source.
2. Keep spoken line natural.
3. Avoid deceptive claims.
4. Do not create unsupported urgency.
5. Provide several angles.

---

## 25. Short-Form Video Script

### Structure

```text
duration_target
hook
setup
main_points
close
call_to_action
on_screen_text
b_roll_suggestions
```

### Rules

1. Designed for user recording or external editor.
2. Do not imply CURA edits the video.
3. Preserve source meaning.
4. Keep timing realistic.
5. Allow 15, 30, 60, and 90-second formats.

---

## 26. Clip Suggestions

### Required fields

```text
clip_title
start_time
end_time
duration
hook
reason
platform_fit
caption
visual_context
speaker
confidence
```

### Rules

1. Timestamps must be valid.
2. Clip should stand alone where possible.
3. Avoid selecting misleading fragments.
4. Include visual context.
5. Label low-confidence boundaries.
6. Do not cut a sentence into a misleading claim.

---

## 27. Quote Options

### Required fields

```text
quote_text
speaker
start_time
end_time
quote_type
context
confidence
```

### Quote types

1. Insight.
2. Practical.
3. Emotional.
4. Contrarian.
5. Inspirational.
6. Educational.
7. Humorous.
8. Warning.

### Rules

1. Direct quotes must remain exact.
2. Paraphrases must be labeled.
3. Speaker attribution must be supported.
4. Preserve context.
5. Avoid quote laundering.

---

## 28. Faceless Content Prompts

### Purpose

Help users create content without appearing on camera.

### Output fields

```text
content_angle
voiceover_script
on_screen_text
visual_sequence
stock_footage_suggestions
caption
call_to_action
```

### Rules

1. Use source-derived ideas.
2. Do not promise automatic video creation.
3. Keep production requirements simple.
4. Support image slideshow, screen text, and voiceover formats.
5. Clearly distinguish generated suggestion from finished media.

---

## 29. YouTube Title Options

### Required fields

```text
title
angle
audience
source_basis
```

### Rules

1. No misleading title.
2. No unsupported claims.
3. Offer search-oriented and curiosity-oriented options.
4. Preserve key topic.
5. Keep configurable length.

---

## 30. YouTube Description

### Required structure

```text
summary
key_points
chapters_optional
links_placeholder
call_to_action
disclaimer_optional
```

### Rules

1. Do not invent links.
2. Do not invent sponsors.
3. Do not create chapters without valid timestamps.
4. Preserve names carefully.

---

## 31. YouTube Chapters

### Required fields

```text
start_time
title
description_optional
```

### Rules

1. First chapter begins at 00:00.
2. Times increase correctly.
3. Titles are concise.
4. Chapters reflect real topic changes.
5. Avoid too many tiny chapters.

---

## 32. Article Outline

### Required structure

```text
working_title
audience
thesis
introduction
sections
examples
conclusion
call_to_action
source_notes
```

### Rules

1. Use source material.
2. Identify gaps needing research.
3. Do not invent citations.
4. Separate source claims from suggested expansion.
5. Support blog, article, and editorial formats.

---

## 33. Newsletter Draft

### Required structure

```text
subject_lines
preview_text
opening
body_sections
takeaway
call_to_action
closing
```

### Rules

1. Preserve user voice.
2. Keep clear sectioning.
3. Avoid generic newsletter filler.
4. Offer concise and expanded versions.
5. Label any unsupported suggested additions.

---

## 34. Blog Draft

### Required structure

```text
title
subtitle
introduction
sections
conclusion
call_to_action
seo_notes_optional
```

### Rules

1. Source-grounded.
2. Clear organization.
3. Avoid keyword stuffing.
4. Identify factual gaps.
5. Preserve user tone.

---

## 35. Content Series Ideas

### Required fields

```text
series_name
series_purpose
episodes_or_posts
audience
cadence_suggestion
source_basis
```

### Rules

1. Build from repeated source themes.
2. Avoid generic ideas.
3. Keep each installment distinct.
4. Support content batching.

---

## 36. Calls to Action

### Categories

1. Comment.
2. Save.
3. Share.
4. Follow.
5. Subscribe.
6. Join.
7. Download.
8. Reflect.
9. Try.
10. Contact.

### Rules

1. Match the content goal.
2. Avoid manipulative wording.
3. Offer low-pressure options.
4. Support user brand voice.
5. Do not invent links or offers.

---

## 37. Structured Notes

### Required structure

```text
title
overview
sections
key_points
examples
questions
source_references
```

### Rules

1. Organize clearly.
2. Avoid transcript dumping.
3. Preserve terminology.
4. Mark uncertain terms.
5. Link to sources.

---

## 38. Key Concepts

### Required fields

```text
concept
definition
why_it_matters
example
source_reference
```

### Rules

1. Ground definitions.
2. Avoid expanding beyond source without labeling.
3. Preserve domain terms.
4. Support difficulty level.

---

## 39. Study Guide

### Required structure

```text
learning_objectives
core_topics
important_details
review_questions
practice
summary
source_references
```

### Rules

1. Reflect source.
2. Support beginner, standard, and advanced versions.
3. Include uncertainty where needed.
4. Avoid invented curriculum.

---

## 40. Quiz

### Supported question types

1. Multiple choice.
2. True or false.
3. Short answer.
4. Fill in the blank.
5. Scenario.
6. Matching.

### Question fields

```text
question
question_type
choices
correct_answer
explanation
difficulty
source_reference
```

### Rules

1. Correct answer must be source-supported.
2. Explanation should teach.
3. Avoid ambiguity.
4. Difficulty should be meaningful.
5. Support configurable question count.
6. Do not use unsupported trick questions.

---

## 41. Flashcards

### Fields

```text
front
back
category
difficulty
source_reference
```

### Rules

1. One idea per card.
2. Short and memorable.
3. Preserve context where necessary.
4. Support export later.
5. Avoid duplicate cards.

---

## 42. Glossary

### Fields

```text
term
definition
example
source_reference
```

### Rules

1. Use only relevant terms.
2. Preserve source meaning.
3. Mark inferred definitions.
4. Sort alphabetically or by topic.

---

## 43. Reflection Questions

### Categories

1. Understanding.
2. Application.
3. Personal reflection.
4. Group discussion.
5. Critical thinking.
6. Spiritual reflection.
7. Professional reflection.

### Rules

1. Match source and mode.
2. Avoid intrusive assumptions.
3. Do not frame one interpretation as mandatory.
4. Support individual and group versions.

---

## 44. Review Plan

### Fields

```text
goal
duration
steps
schedule_suggestion
materials
completion_check
```

### Rules

1. Keep realistic.
2. Use source volume.
3. Offer brief and extended plans.
4. Avoid calendar writes in V1.
5. Allow copy to calendar or reminders through user-controlled workflows later.

---

## 45. Executive Summary

### Required structure

```text
purpose
current_state
important_outcomes
decisions
risks
next_steps
```

### Rules

1. Short.
2. Operational.
3. Avoid generic language.
4. Highlight unresolved issues.
5. Preserve evidence.

---

## 46. Decisions

### Fields

```text
decision
decision_status
owner_optional
date_optional
explicit
evidence
impact
```

### Decision statuses

```text
proposed
made
reversed
deferred
uncertain
```

### Rules

1. Do not confuse discussion with decision.
2. Mark inferred decisions.
3. Preserve reversal.
4. Link to source.

---

## 47. Action Items

### Fields

```text
action
owner
due_date
priority
status
explicit
evidence
dependencies
```

### Rules

1. Do not invent owners.
2. Do not invent due dates.
3. Label suggestions.
4. Support user editing.
5. Preserve source evidence.
6. Avoid splitting one action into meaningless fragments.

---

## 48. Follow-Up Email

### Required structure

```text
subject
greeting
context
summary
decisions
actions
questions
closing
```

### Rules

1. Draft only.
2. Do not send automatically.
3. Preserve names.
4. Keep tone professional.
5. Mark uncertain commitments.
6. Support Copy and Open Mail.

---

## 49. Action Plan

### Fields

```text
objective
steps
owner_optional
timing
dependencies
risks
success_measure
```

### Rules

1. Sequence logically.
2. Distinguish source commitments from CURA suggestions.
3. Keep practical.
4. Avoid false precision.
5. Support concise and detailed versions.

---

## 50. Project Plan

### Required structure

```text
objective
scope
deliverables
milestones
owners
dependencies
risks
first_actions
success_criteria
```

### Rules

1. Use source evidence.
2. Mark suggested fields.
3. Avoid invented budgets or dates.
4. Support export.

---

## 51. SOP

### Required structure

```text
title
purpose
scope
prerequisites
steps
decision_points
exceptions
quality_checks
source_references
```

### Rules

1. Separate observed workflow from suggested improvement.
2. Preserve sequence.
3. Identify missing information.
4. Avoid representing incomplete workflow as final.

---

## 52. Workflow Reconstruction

### Required structure

```text
workflow_name
trigger
inputs
steps
apps_or_tools
conditions
outputs
failure_points
unknowns
```

### Rules

1. Use visual evidence.
2. Preserve visible app names.
3. Mark unreadable steps.
4. Distinguish observed actions from inferred logic.
5. Support Apple Shortcuts use cases.

---

## 53. Property or Site Report

### Required structure

```text
property_or_site
visit_purpose
areas_reviewed
observations
issues
priorities
recommended_actions
photo_log
follow_up
limitations
```

### Rules

1. Do not represent CURA as a licensed inspector.
2. Preserve visual evidence.
3. Mark limited visibility.
4. Avoid safety assurances.
5. Separate observation from recommendation.

---

## 54. CRM Notes

### Required fields

```text
contact
organization
conversation_summary
needs
pain_points
opportunities
commitments
follow_up
risks
```

### Rules

1. Draft only.
2. Do not auto-sync in V1.
3. Preserve uncertainty.
4. Avoid inferred sensitive traits.

---

## 55. Team Handoff

### Required structure

```text
context
current_state
completed
open_items
owners
deadlines
risks
questions
recommended_next_step
```

### Rules

1. Operational.
2. Clear ownership.
3. Highlight uncertainty.
4. Avoid unnecessary background.

---

## 56. Visual Brief Output Data

Every Visual Brief should be generated from structured fields.

Required base structure:

```text
title
subtitle
layout_type
sections
key_points
quotes
statistics
timeline
process_steps
comparisons
sources
theme
```

Each section:

```text
section_id
section_type
headline
body
evidence_references
order
```

Visual Brief details are governed by `VISUAL_BRIEF.md`.

---

## 57. Evidence Policy

### Strict Evidence

Use for:

1. Direct quotes.
2. Decisions.
3. Action items.
4. Dates.
5. Statistics.
6. Workflow steps.
7. Property issues.
8. Legal or compliance-sensitive claims.

### Standard Evidence

Use for:

1. Summaries.
2. Key ideas.
3. Themes.
4. Learning outputs.
5. Content drafts.

### Creative Transformation

Use for:

1. Hooks.
2. Social captions.
3. Content ideas.
4. Calls to action.
5. Brand-voice adaptations.

Creative Transformation still cannot invent facts or quotes.

---

## 58. Inference Labels

Supported labels:

```text
explicit
strong_inference
suggestion
uncertain
not_supported
```

The UI should expose labels when relevant.

Suggested display:

1. Explicit.
2. Inferred.
3. CURA Suggestion.
4. Needs Review.

Avoid exposing technical confidence values everywhere.

---

## 59. Regeneration

Users should be able to regenerate:

1. Entire output.
2. One section.
3. One variation.
4. Shorter version.
5. Longer version.
6. Different tone.
7. Different audience.
8. Different platform.
9. Different language.
10. More options.

Rules:

1. Preserve prior versions.
2. Do not overwrite user edits without confirmation.
3. Record generation settings.
4. Allow comparison.
5. Meter usage accurately.
6. Reuse Curated Note without reprocessing media.

---

## 60. Editing

V1 editing should support:

1. Plain text editing.
2. Section reordering.
3. Removing output sections.
4. Changing title.
5. Changing tone settings.
6. Approving output.
7. Resetting to generated version.

V1 should not include:

1. Full document collaboration.
2. Advanced rich text layout.
3. Professional design canvas.
4. Video timeline editing.
5. Image compositing.

---

## 61. Output Versioning

Each output should keep:

```text
version
parent_version_id
generation_settings
user_edits
created_at
created_by
```

V1 may show only Current and Previous.

The data model should support later history.

---

## 62. Export-All

Every pack should support Export All.

Options:

1. One Markdown file.
2. One PDF.
3. One JSON bundle.
4. Separate text files.
5. ZIP archive.
6. Visual Brief assets.
7. Include transcript.
8. Exclude transcript.
9. Include evidence.
10. Include source list.

---

## 63. Quick Send Mapping

Recommended mappings:

| Output | Primary destination |
|---|---|
| Instagram Caption | Instagram |
| Carousel Copy | Canva |
| LinkedIn Post | LinkedIn |
| X Thread | X |
| Threads Post | Threads |
| Facebook Post | Facebook |
| TikTok Caption | TikTok |
| Follow-Up Email | Mail |
| Article Draft | Notes or writing app |
| Visual Brief | Share Sheet |
| Second Brain Export | Files or iCloud Drive |

Always provide Share Sheet fallback.

---

## 64. Platform Rules Configuration

Platform limits and behavior may change.

Do not hardcode them deeply into business logic.

Use configurable rules:

```text
platform
output_type
max_length
recommended_length
supports_hashtags
supports_threads
supports_media
supports_deep_link
updated_at
```

Codex should create defaults but isolate them for future updates.

---

## 65. Language and Translation

Every pack should support:

1. Source language.
2. Output language.
3. Translated transcript.
4. Translated output.
5. Proper-name preservation.
6. User terminology.
7. Language-specific platform style.

Rules:

1. Preserve original source.
2. Do not overwrite original transcript.
3. Mark machine translation.
4. Preserve names and brands.
5. Support regeneration in another language without reprocessing media.

---

## 66. Brand Voice Profile Application

Apply profile to:

1. Social posts.
2. Articles.
3. Newsletters.
4. Email drafts.
5. Calls to action.
6. Short-form scripts.

Do not apply style in a way that alters:

1. Quotes.
2. Facts.
3. Decisions.
4. Action items.
5. Dates.
6. Evidence.

---

## 67. User Feedback

Users should be able to rate:

1. Accurate.
2. Useful.
3. Needs Work.

Optional issue types:

1. Missed point.
2. Incorrect fact.
3. Wrong quote.
4. Weak style.
5. Poor visual analysis.
6. Bad timestamp.
7. Wrong output format.

Feedback should not contain source content in analytics without explicit consent.

---

## 68. Quality Evaluation

Each output type should be evaluated against:

1. Factual accuracy.
2. Evidence fidelity.
3. Usefulness.
4. Clarity.
5. Platform fit.
6. Tone fit.
7. Concision.
8. Completeness.
9. Edit distance to usable output.
10. User rating.

---

## 69. Minimum Beta Output Set

The first usable beta must support:

### Learn

1. Smart Summary.
2. Structured Notes.
3. Quiz.
4. Flashcards.
5. Visual Brief.

### Create

1. Hooks.
2. Instagram Caption.
3. LinkedIn Post.
4. X Thread.
5. Carousel Copy.
6. Quote Options.
7. Clip Suggestions.
8. Visual Brief.

### Work

1. Executive Summary.
2. Decisions.
3. Action Items.
4. Follow-Up Email.
5. Action Plan.
6. Property or Site Report.
7. Visual Brief.

---

## 70. Final Output Standard

An output is successful when:

1. It is grounded.
2. It is immediately understandable.
3. It reduces user work.
4. It matches the chosen mode.
5. It fits its intended destination.
6. It is easy to copy or export.
7. It preserves user control.
8. It does not overstate certainty.
9. It feels consistent with CURA.
10. It helps turn the capture into momentum.
