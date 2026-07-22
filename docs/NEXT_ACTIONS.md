# Next Actions

1. Manually retest audible playback for a freshly recorded session on the physical iPhone speaker and headphones; automated tests verify playback state/progress but cannot listen to audio output.
2. Retest that the same fresh recording plays before leaving Session Detail, after returning Home and reopening it, and after an ordinary force-close/relaunch.
3. Confirm older missing-file sessions still show the localized missing-file message while preserving transcript and Curated Note data.
4. Approve Phase 2B.2 before replacing the deterministic demo transcription provider with any production transcription path.
5. Decide whether production transcription should use Apple Speech/on-device capability where available, a protected server-side provider, or a hybrid architecture.
6. Define the privacy copy and capability gating for Smart versus Private before any cloud-assisted processing is introduced.
7. Keep live AI generation, Supabase, RevenueCat, authentication, paid services, cloud upload, social publishing, full Output Packs, and Visual Brief generation deferred until their planned phases.
8. Decide when release/distribution signing should be configured.
9. Decide whether physical-device UI automation should remain part of every local verification pass or be reserved for device-specific regressions.
10. Keep project-memory documents updated at the end of every build session.
