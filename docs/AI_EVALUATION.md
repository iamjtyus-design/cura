# CURA AI Evaluation Plan

## Evaluation Set

Maintain representative examples for:

1. Clean single-speaker audio.
2. Noisy audio.
3. Multiple speakers.
4. Interview.
5. Meeting.
6. Sermon.
7. Lecture.
8. Property walkthrough.
9. Screen recording.
10. Public YouTube video.
11. PDF.
12. Web page.
13. Multi-source event.
14. Unrelated audio and visuals.
15. Multilingual material.
16. Long-form video.
17. Silent visually important video.
18. Conflicting sources.

## Score Areas

1. Transcript usefulness.
2. Proper-noun accuracy.
3. Quote fidelity.
4. Timestamp accuracy.
5. Visual understanding.
6. OCR quality.
7. Audio-visual relationship classification.
8. Smart Summary usefulness.
9. Decision accuracy.
10. Action-item accuracy.
11. Evidence accuracy.
12. Output Pack usefulness.
13. Visual Brief usefulness.
14. Latency.
15. Cost.

## Critical failure checks

1. Fabricated quote.
2. Fabricated owner.
3. Fabricated due date.
4. False scripture reference.
5. False property safety claim.
6. Wrong speaker attribution.
7. Reconstruction mislabeled verbatim.
8. Unrelated tracks merged as one topic.
9. Unsupported statistic.
10. Evidence link pointing to the wrong source.

## Release gate

Before public launch:

1. At least fifty varied evaluation items.
2. All critical failures reviewed.
3. Known limitations documented.
4. Provider and prompt versions recorded.
5. Regression suite runs after prompt or model changes.
6. Product copy matches measured behavior.
