# CURA Privacy, Legal, Trust, and Liability Framework

## Document Status

**Product:** CURA by VisionBuilt  
**Version:** 1.0  
**Planning date:** July 2026  
**Primary source of truth:** `CURA_PRODUCT_CONSTITUTION.md`

This document is a product, engineering, and legal-planning framework.

It is not legal advice and should not be published unchanged as final legal language.

Before public launch, VisionBuilt should retain qualified counsel to review:

1. Privacy Policy.
2. Terms of Use.
3. Recording consent language.
4. Subscription disclosures.
5. Intellectual property terms.
6. AI vendor agreements.
7. State, federal, and international privacy obligations.
8. Insurance coverage.
9. Company structure.
10. App Store disclosures.

When this document conflicts with the Product Constitution, the Constitution wins unless a legal requirement requires revision.

---

## 1. Trust Position

CURA should be privacy-forward, not privacy-theatrical.

The product should make narrow, accurate promises that the architecture can prove.

Recommended trust position:

> Your original stays on your device by default. When Smart Mode is used, CURA temporarily processes the content to create your results, then deletes temporary source files according to the stated retention schedule. You control what you save, export, and share.

Do not claim:

1. Nothing ever leaves your device.
2. CURA never stores anything.
3. CURA is completely anonymous.
4. CURA is perfectly secure.
5. CURA is legally compliant everywhere.
6. CURA guarantees accurate transcription.
7. CURA guarantees lawful recording.
8. CURA never uses third-party processors.
9. CURA cannot be breached.
10. CURA eliminates liability.

Those statements would be inaccurate or impossible to guarantee.

---

## 2. Privacy Design Principles

CURA should follow these principles:

1. Collect the minimum data needed.
2. Request permissions only when needed.
3. Keep original source files local by default.
4. Make cloud processing visible.
5. Use temporary private storage.
6. Delete temporary media automatically.
7. Do not train models on user content by default.
8. Do not sell personal information.
9. Do not use user content for targeted advertising.
10. Do not use sensitive content in analytics.
11. Allow export.
12. Allow deletion.
13. Preserve user control.
14. Explain third-party processing.
15. Build security into the product.
16. Avoid dark patterns.
17. Keep subscription terms clear.
18. Limit employee access.
19. Document retention.
20. Test privacy claims against actual behavior.

---

## 3. Data Categories

CURA may process the following categories.

## 3.1 Account Data

Examples:

1. Apple account identifier.
2. Email relay address where provided.
3. Display name.
4. Account creation date.
5. Authentication tokens.
6. Subscription customer identifier.
7. Support contact information.

Purpose:

1. Authentication.
2. Subscription restoration.
3. Account support.
4. Account deletion.
5. Fraud prevention.

---

## 3.2 Capture Content

Examples:

1. Audio.
2. Video.
3. Photos.
4. Screenshots.
5. Text notes.
6. PDFs.
7. Imported web content.
8. YouTube links.
9. Social links.
10. Transcripts.
11. Visual observations.
12. Curated Notes.
13. Generated outputs.
14. Visual Briefs.

Capture Content may include personal, confidential, copyrighted, financial, spiritual, employment, educational, property, or other sensitive information.

CURA should not assume that Capture Content is non-sensitive.

---

## 3.3 Processing Metadata

Examples:

1. Session ID.
2. Source ID.
3. File type.
4. File size.
5. Duration.
6. Page count.
7. Processing stage.
8. Provider.
9. Model.
10. Token usage.
11. Error code.
12. Processing time.
13. Temporary object path.
14. Deletion status.

Purpose:

1. Process content.
2. Recover failures.
3. Meter usage.
4. Control cost.
5. Provide support.
6. Verify deletion.
7. Improve reliability.

---

## 3.4 Device and Technical Data

Examples:

1. App version.
2. Operating system version.
3. Device model class.
4. Crash data.
5. Performance data.
6. Network error.
7. Locale.
8. Time zone.
9. Anonymous installation identifier.

Do not collect unnecessary device fingerprinting data.

---

## 3.5 Usage Data

Examples:

1. Session created.
2. Output generated.
3. Export completed.
4. Quick Send used.
5. Shortcut used.
6. Paywall viewed.
7. Trial started.
8. Feature error.

Usage events should remain content-free.

---

## 3.6 Subscription Data

Examples:

1. Product ID.
2. Entitlement.
3. Renewal status.
4. Expiration date.
5. Purchase environment.
6. RevenueCat customer ID.

CURA should not directly receive or store full payment card details.

---

## 3.7 Support Data

Examples:

1. Support messages.
2. Screenshots users intentionally send.
3. Diagnostic reference.
4. Requested account action.
5. Contact information.

Support staff should not request full recordings unless necessary and explicitly authorized.

---

## 4. Data CURA Should Not Collect by Default

Do not collect by default:

1. Address book contacts.
2. Calendar contents.
3. Email inbox contents.
4. Precise location.
5. Health records.
6. Financial account credentials.
7. Full photo library.
8. Clipboard contents.
9. Advertising identifier.
10. Cross-app tracking data.
11. Sensitive inferred traits.
12. Face recognition templates.
13. Voice identity templates.
14. Private messages from unrelated apps.
15. Browser history.

If a future feature requires one of these categories, update:

1. Product Constitution.
2. Privacy Policy.
3. App Store privacy disclosures.
4. Permission flow.
5. Data map.
6. Threat model.
7. Retention policy.
8. User controls.

---

## 5. Processing Modes

## 5.1 Private Mode

Private Mode should:

1. Keep sources on device.
2. Use local extraction where supported.
3. Use local OCR where supported.
4. Avoid cloud upload.
5. Clearly limit unavailable AI functions.
6. Allow local recording, organization, editing, and export.

Private Mode should not claim equivalent output quality if cloud processing is not used.

---

## 5.2 Smart Mode

Smart Mode should:

1. Obtain clear user authorization.
2. Temporarily upload source content.
3. Encrypt data in transit.
4. Store temporary files privately.
5. Process through documented providers.
6. Return results to the device.
7. Delete temporary source files automatically.
8. Retain minimal metadata as needed for billing, support, fraud prevention, and legal obligations.
9. Make retention timing available.
10. Allow manual temporary-data deletion where practical.

Smart Mode is the recommended default only if onboarding clearly explains it.

---

## 5.3 Future Sync Mode

Future Sync Mode must be explicit opt-in.

It may:

1. Store sessions persistently.
2. Enable cross-device access.
3. Enable Mission Control.
4. Enable web access.
5. Enable semantic search.
6. Enable shared knowledge.

Before release, define:

1. Encryption.
2. Retention.
3. Deletion.
4. Conflict resolution.
5. Export.
6. Subscription expiration.
7. Provider access.
8. Backup aging.
9. Account recovery.
10. Data residency.

---

## 6. Temporary Processing Retention

Do not publish a precise retention claim until engineering verifies it.

Recommended policy target:

### Successfully processed source media

Delete promptly after:

1. Results are successfully delivered to the device.
2. Delivery is acknowledged.
3. A short recovery window expires.

### Failed processing media

Retain only long enough to:

1. Offer retry.
2. Diagnose technical failure.
3. Let the user recover.

Then delete automatically.

### Abandoned uploads

Delete through scheduled cleanup.

### Temporary derived files

Delete after:

1. Successful result retrieval.
2. Expiration.
3. User deletion request.

### Operational metadata

May be retained longer if necessary for:

1. Billing.
2. Fraud prevention.
3. Security.
4. Tax.
5. Legal compliance.
6. Service reliability.

The Privacy Policy should state categories and purposes rather than falsely promising that every technical record is immediately erased.

---

## 7. Suggested Retention Schedule

This is a proposed engineering target, not final legal policy.

| Data | Default target |
|---|---|
| Local original | Until user deletes it |
| Temporary successful source upload | Prompt deletion after confirmed processing |
| Failed source upload | Short retry window, then deletion |
| Abandoned partial upload | Automatic cleanup |
| Temporary output artifact | Until successful retrieval or expiration |
| Local Curated Note | Until user deletes it |
| Local generated outputs | Until user deletes them |
| Account data | Account lifetime plus required wind-down |
| Subscription records | As required for financial and dispute purposes |
| Usage ledger | Limited period necessary for billing and fraud |
| Security logs | Limited security-retention period |
| Support records | Limited support and dispute period |
| Deleted account data | Removed subject to legal, security, and backup limitations |

Every production table and storage bucket should have an assigned owner and retention rule.

---

## 8. Recording Consent

Recording laws vary by jurisdiction.

CURA should not determine whether a recording is legal.

The user is responsible for:

1. Informing participants.
2. Obtaining required consent.
3. Following workplace policy.
4. Following school or event policy.
5. Following platform rules.
6. Following local law.
7. Respecting confidential information.

### Required first-use notice

> Only record people when you have permission and when recording is lawful. Consent requirements vary by location. You are responsible for notifying participants and obtaining any required consent.

### Short recurring reminder

> Confirm that everyone who needs to know is aware of the recording.

### Product requirements

1. Visible recording screen.
2. System recording indicator.
3. No hidden recording.
4. No stealth mode.
5. No feature marketed as secret recording.
6. Recording state visible after returning to app.
7. Consent information available in Settings.
8. User acknowledgment logged locally or in minimal account metadata.
9. Do not automatically record calls.
10. Do not claim all-party consent has been obtained.

---

## 9. Video and Photography Consent

Capturing video or photos may raise additional:

1. Privacy.
2. Publicity.
3. Workplace.
4. School.
5. Venue.
6. Confidentiality.
7. Intellectual-property concerns.

Suggested in-app language:

> Make sure you have permission to capture and process people, private spaces, screens, documents, and copyrighted material.

CURA should not use face recognition or infer identity from appearance.

---

## 10. User Content Rights

Recommended Terms structure:

1. Users retain ownership of their content.
2. Users grant VisionBuilt a limited license to host, transmit, process, reproduce, and transform the content only as needed to provide CURA.
3. The license ends when no longer needed, subject to legal and backup limitations.
4. VisionBuilt does not claim ownership of user content.
5. Users represent that they have the necessary rights and permissions.
6. Users are responsible for content they record, upload, or share.
7. Generated outputs may require user review before publication.
8. Users are responsible for rights in exported or published outputs.

### Suggested draft language

> You retain ownership of content you submit to CURA. You grant VisionBuilt a limited, non-exclusive license to process that content solely to operate, secure, support, and improve the service as described in the Privacy Policy. You are responsible for ensuring that you have the rights and permissions needed to record, upload, process, export, and use the content.

Counsel should revise this language.

---

## 11. AI Vendor Requirements

Before using an AI vendor, confirm:

1. Whether prompts or files are used for training.
2. Default retention.
3. Enterprise or API data terms.
4. Subprocessor list.
5. Security documentation.
6. Data location.
7. Deletion capability.
8. Abuse-monitoring retention.
9. Contractual confidentiality.
10. Incident notification.
11. Model versioning.
12. Content restrictions.
13. Copyright terms.
14. Availability commitments.
15. Age restrictions.

Prefer commercial API terms that do not use customer API data to train general models by default.

Do not rely on consumer chat-product terms for production processing.

---

## 12. Vendor Data Processing Inventory

Maintain a vendor table:

| Vendor | Purpose | Data received | Retention | Training use | Location | Contract | Owner |
|---|---|---|---|---|---|---|---|
| Supabase | Auth, temporary storage, jobs | Account and temporary processing data | Defined policy | N/A | Verify | DPA | Engineering |
| Speech provider | Transcription | Audio and metadata | Verify | Verify | Verify | DPA | Engineering |
| Gemini API | Video understanding | Video, URLs, prompts | Verify | Verify | Verify | DPA | Engineering |
| RevenueCat | Subscription management | Account and purchase metadata | Vendor policy | N/A | Verify | DPA | Operations |
| Crash provider | Diagnostics | Scrubbed technical data | Limited | N/A | Verify | DPA | Engineering |
| Analytics provider | Product analytics | Content-free events | Limited | N/A | Verify | DPA | Product |

Complete actual values before launch.

---

## 13. No Training by Default

Recommended product policy:

1. VisionBuilt does not use user Capture Content to train general AI models by default.
2. Third-party API settings should be configured accordingly.
3. Product improvement based on content requires separate explicit opt-in.
4. Content-free analytics may still be used.
5. User feedback may be used without source content unless the user explicitly submits it.
6. Support access requires user authorization.

Suggested statement:

> CURA does not use your recordings, files, transcripts, or generated notes to train general AI models by default.

Verify every vendor before publishing this statement.

---

## 14. Sensitive Data

CURA may incidentally process sensitive information.

Examples:

1. Religious beliefs.
2. Health discussions.
3. Employment information.
4. Financial information.
5. Student information.
6. Children’s voices or images.
7. Property access details.
8. Confidential business information.
9. Legal discussions.
10. Biometric characteristics in media.

CURA should:

1. Avoid classifying sensitive traits unless explicitly required.
2. Avoid targeted advertising.
3. Avoid selling data.
4. Avoid creating face or voice identity profiles.
5. Apply strong access controls.
6. Keep retention short.
7. Warn users before processing highly sensitive content.
8. Avoid claiming HIPAA, FERPA, or other regulated compliance unless formally implemented and contracted.

---

## 15. Children and Age Limits

Recommended initial audience:

1. Adults.
2. Users at least 16, or another counsel-approved minimum.
3. Younger users only with a designed parental-consent process if introduced later.

Do not market directly to children under 13 without a COPPA-compliant product design.

If VisionBuilt has actual knowledge that it collects personal information from children under 13, additional obligations may apply.

Recommended Terms language:

> CURA is not intended for children under 13. If you are under the age required to consent to data processing in your location, use CURA only with authorization from a parent or legal guardian.

Counsel should define the final age threshold.

---

## 16. Education Use

Do not claim FERPA compliance by default.

For schools or institutional use, later requirements may include:

1. School contracts.
2. Student-data protections.
3. Parent rights.
4. Data deletion terms.
5. No advertising.
6. No training.
7. Access controls.
8. Audit requirements.
9. Data residency.
10. Institutional administration.

Individual student use should still follow the standard Privacy Policy.

---

## 17. Health Use

CURA may capture health-related discussions, but it should not be positioned as:

1. A medical device.
2. A diagnostic tool.
3. Clinical documentation software.
4. A HIPAA-compliant service.
5. Emergency support.

Suggested disclaimer:

> CURA is an organization and content tool. It is not medical advice, diagnosis, treatment, or emergency support.

Do not use health-related app-store positioning without a separate legal and regulatory review.

---

## 18. Legal and Financial Use

Suggested disclaimer:

> CURA may summarize legal, financial, tax, or compliance-related material, but generated outputs are not professional advice. Review the original source and consult a qualified professional before relying on important decisions.

CURA should:

1. Preserve source evidence.
2. Label uncertainty.
3. Avoid acting autonomously.
4. Avoid claims of professional accuracy.
5. Avoid legal deadline guarantees.
6. Avoid investment recommendations as a core feature.

---

## 19. AI Accuracy and Hallucination

The product must disclose that AI outputs can be wrong.

Suggested notice:

> AI-generated transcripts, summaries, visual observations, and recommendations may contain errors. Review important information against the original source.

Required product controls:

1. Preserve original source.
2. Preserve original transcript.
3. Link evidence.
4. Mark inference.
5. Show transcript origin.
6. Let users correct output.
7. Avoid fabricated quotes.
8. Avoid fabricated deadlines.
9. Avoid fabricated owners.
10. Allow reporting errors.

---

## 20. Transcript Labels

Use accurate labels:

1. Verbatim transcript.
2. Automatic transcript.
3. Official captions.
4. Translated transcript.
5. Model-generated reconstruction.
6. OCR-extracted text.
7. User-edited transcript.

Do not label Gemini video reconstruction as exact transcription.

---

## 21. Copyright and Platform Content

Users may submit copyrighted content.

Recommended Terms:

1. Users must have the right or permission to process content.
2. CURA is not a piracy or downloading tool.
3. CURA does not authorize copying protected content.
4. Platform restrictions still apply.
5. Outputs may be derivative works.
6. Users are responsible for publication rights.
7. VisionBuilt may disable access for credible infringement concerns.
8. Public-link processing does not transfer ownership.

Suggested notice:

> Only upload or process content that you own, that you have permission to use, or that you may lawfully process.

---

## 22. Social Media Links

CURA should:

1. Use official APIs where feasible.
2. Use publicly accessible content where legally and technically supported.
3. Request user upload when access is blocked.
4. Avoid bypassing authentication.
5. Avoid defeating technical restrictions.
6. Avoid calling itself a downloader.
7. Preserve source URL.
8. Disclose that platform availability can change.

Suggested FAQ:

> Some platforms restrict access to video or captions. When a link cannot be processed, CURA will ask you to upload a file you have permission to use.

---

## 23. User-Generated Outputs

Generated captions, articles, visuals, and plans are drafts.

Terms should state:

1. Users are responsible for review.
2. Users are responsible for publication.
3. CURA does not guarantee originality.
4. Similar outputs may be generated for others.
5. User content rights may affect output rights.
6. Platform rules apply.
7. Generated claims require verification.
8. Direct quotes should be checked.

Do not market outputs as guaranteed plagiarism-free or copyright-safe.

---

## 24. Content Moderation and Prohibited Uses

Prohibit use of CURA for:

1. Unlawful recording.
2. Stalking.
3. Harassment.
4. Non-consensual intimate content.
5. Sexual exploitation of minors.
6. Fraud.
7. Impersonation.
8. Malware.
9. Credential theft.
10. Copyright infringement.
11. Circumvention of platform protections.
12. Illegal surveillance.
13. Violent wrongdoing.
14. Discrimination.
15. Doxxing.
16. Unauthorized confidential-information extraction.
17. Creating deceptive evidence.
18. Misrepresenting edited or AI-generated content as authentic evidence.
19. Violating another person’s privacy rights.
20. Any use prohibited by AI providers or law.

Terms should allow suspension for material violations.

---

## 25. Content Access by VisionBuilt

Recommended internal policy:

1. Employees do not routinely access user content.
2. Access requires a legitimate operational reason.
3. Access is role-limited.
4. Access is logged.
5. Support access requires user authorization where practical.
6. Security investigations use the minimum content needed.
7. Production database access is restricted.
8. Temporary media access is restricted.
9. Contractors receive least privilege.
10. Access is removed promptly when no longer needed.

---

## 26. Security Controls

Minimum launch controls:

1. TLS.
2. Private storage buckets.
3. Signed URLs.
4. Row Level Security.
5. Server-side secrets.
6. Keychain.
7. File protection.
8. Role-based access.
9. Multi-factor authentication for administration.
10. Secret rotation.
11. Dependency scanning.
12. Logging scrubbing.
13. Rate limiting.
14. Idempotency.
15. Backups for essential account systems.
16. Incident response plan.
17. Vendor review.
18. Vulnerability patching.
19. Access review.
20. Deletion verification.

---

## 27. Security Promises

Use careful language.

Preferred:

> CURA uses technical and organizational safeguards designed to protect information.

Avoid:

1. Bank-level security.
2. Military-grade privacy.
3. Unhackable.
4. Completely secure.
5. Zero risk.
6. Anonymous by default, unless technically true.

---

## 28. Data Breach Response

Create an incident plan covering:

1. Detection.
2. Containment.
3. Evidence preservation.
4. Vendor coordination.
5. Scope assessment.
6. Legal analysis.
7. Regulatory notification.
8. User notification.
9. Key rotation.
10. Remediation.
11. Post-incident review.
12. Documentation.

Assign:

1. Incident owner.
2. Engineering lead.
3. Legal contact.
4. Communications contact.
5. Vendor contacts.

Do not wait until an incident to define this.

---

## 29. Privacy Requests

The product should support:

1. Access request.
2. Export request.
3. Correction request where applicable.
4. Deletion request.
5. Consent withdrawal.
6. Analytics opt-out where offered.
7. Account deletion.
8. Privacy contact.

The exact legal rights vary by location and company thresholds.

CURA should offer useful controls even before every legal threshold applies.

---

## 30. Account Deletion

Apple requires apps that support account creation to let users initiate account deletion from within the app.

CURA should provide:

1. In-app account deletion.
2. Explanation of what is deleted.
3. Export option before deletion.
4. Clear confirmation.
5. Deletion job status.
6. Revocation of authentication.
7. Removal of applicable backend records.
8. Temporary-object deletion.
9. Local-data option.
10. Explanation of limited legal or backup retention.

Do not require users to email support merely to initiate deletion.

---

## 31. Session Deletion

Users should be able to choose:

1. Delete original only.
2. Delete transcript only.
3. Delete outputs only.
4. Delete Visual Brief only.
5. Delete entire session.
6. Delete temporary cloud copy.
7. Keep exported files.
8. Remove exported files manually.

CURA cannot guarantee deletion of copies the user exported to another service.

---

## 32. App Store Privacy Disclosures

Apple requires developers to describe the app’s privacy practices, including relevant practices of integrated third-party SDKs.

Before every release:

1. Inventory SDKs.
2. Inventory data collected.
3. Identify whether data is linked to identity.
4. Identify tracking.
5. Identify purposes.
6. Review analytics.
7. Review crash reporting.
8. Review RevenueCat.
9. Review Supabase.
10. Review AI providers.
11. Review share extension.
12. Update App Store Connect.

Disclosures must match production behavior.

---

## 33. App Store Support and Privacy Links

Maintain public:

1. Privacy Policy URL.
2. Support URL.
3. Contact information.
4. Terms URL.
5. Account deletion information.
6. Subscription information.

Links must remain functional.

---

## 34. App Permissions

Request permissions contextually.

### Microphone

Purpose text should explain recording and transcription.

Suggested:

> CURA uses the microphone to record audio you choose to capture and turn it into notes and other outputs.

### Camera

Suggested:

> CURA uses the camera to capture videos and photos you choose to add to a session.

### Photos

Suggested:

> CURA accesses only the photos and videos you choose to import.

### Notifications

Suggested:

> CURA can notify you when processing is complete or needs your attention.

Do not request Contacts, Location, Calendar, or Reminders in V1.

---

## 35. Subscription Disclosures

The paywall must clearly state:

1. Price.
2. Billing period.
3. Trial length.
4. Renewal.
5. Cancellation method.
6. Processing limits.
7. Premium features.
8. Restore purchases.
9. Terms.
10. Privacy.

Avoid:

1. Hidden pricing.
2. Preselected expensive plan without clarity.
3. False urgency.
4. Difficult cancellation.
5. Misleading “free” claims.
6. Unlimited claims when limits exist.

---

## 36. Subscription Expiration

When a subscription expires:

1. Do not delete local user data.
2. Allow export.
3. Allow deletion.
4. Allow subscription restoration.
5. Limit new premium processing.
6. Explain feature changes.
7. Preserve previously generated outputs.
8. Do not hold user-owned content hostage.

---

## 37. Refunds and Billing Disputes

Terms should explain:

1. Purchases are handled through Apple where applicable.
2. Apple controls App Store refund processes.
3. VisionBuilt may provide support.
4. Usage-based abuse may be restricted.
5. Promotional pricing may expire.
6. Taxes may apply.

Counsel should review final consumer language.

---

## 38. Privacy Policy Required Sections

The final Privacy Policy should include:

1. Effective date.
2. Company identity.
3. Contact information.
4. Scope.
5. Information collected.
6. Sources of information.
7. Purposes.
8. Processing modes.
9. AI providers.
10. Sharing and subprocessors.
11. Retention.
12. Security.
13. User choices.
14. Data rights.
15. Account deletion.
16. Children.
17. International transfers.
18. U.S. state disclosures.
19. European disclosures if applicable.
20. Changes.
21. Contact.
22. Supplemental notices.

---

## 39. Draft Privacy Policy Outline

# Privacy Policy

## Who We Are

VisionBuilt operates CURA, a capture and knowledge activation application.

## Scope

This policy applies to CURA applications, websites, support, and related services.

## Information We Process

Describe:

1. Account data.
2. Capture Content.
3. Processing metadata.
4. Device and usage information.
5. Subscription data.
6. Support information.

## How We Use Information

Describe:

1. Provide service.
2. Process content.
3. Generate outputs.
4. Authenticate.
5. Manage subscriptions.
6. Secure service.
7. Provide support.
8. Measure content-free usage.
9. Comply with law.

## Processing Modes

Explain:

1. Private Mode.
2. Smart Mode.
3. Future Sync Mode.

## Temporary Processing

Explain:

1. Why upload is needed.
2. Providers.
3. Retention.
4. Deletion.
5. Recovery window.
6. Metadata retention.

## AI and Model Training

State the verified policy.

## Sharing

Describe service providers and legal disclosures.

## Retention

Describe category-based retention.

## User Choices

Describe:

1. Export.
2. Delete.
3. Processing mode.
4. Analytics.
5. Notifications.
6. Account deletion.

## Security

Describe safeguards without guarantees.

## Children

State age position.

## International Data

Describe transfers if applicable.

## Changes

Explain update notice.

## Contact

Provide privacy email and mailing address.

---

## 40. Terms of Use Required Sections

The final Terms should include:

1. Acceptance.
2. Eligibility.
3. Account.
4. Service description.
5. Recording responsibility.
6. User Content.
7. Limited content license.
8. AI-generated output.
9. Prohibited uses.
10. Intellectual property.
11. Third-party services.
12. Social and video links.
13. Subscriptions.
14. Trials.
15. Cancellation.
16. Service changes.
17. Suspension.
18. Disclaimers.
19. Limitation of liability.
20. Indemnity.
21. Dispute resolution.
22. Governing law.
23. Termination.
24. Data deletion.
25. Contact.
26. Apple-specific terms if required.

Counsel should draft final enforceable provisions.

---

## 41. Draft Terms Concepts

### Service Description

> CURA helps users capture, organize, analyze, transform, and export information. Features may vary by plan, platform, location, source type, and provider availability.

### Recording Responsibility

> You are responsible for complying with laws, policies, and consent requirements applicable to recordings, photographs, videos, and uploaded material.

### AI Output

> CURA uses automated systems that may produce inaccurate, incomplete, or inappropriate results. Review outputs before relying on, sending, publishing, or acting on them.

### No Professional Advice

> CURA does not provide legal, medical, financial, tax, safety, inspection, or other professional advice.

### No Automatic Publication

> Unless a future feature expressly states otherwise, CURA prepares content but does not publish it on your behalf.

### Availability

> Features that rely on third-party platforms or AI providers may change, become unavailable, or operate differently.

These are concepts, not final legal terms.

---

## 42. Warranty Disclaimer Strategy

Counsel should draft enforceable language.

Product copy should still avoid creating contrary promises.

Do not promise:

1. Perfect accuracy.
2. Uninterrupted service.
3. Permanent platform support.
4. Guaranteed deletion at an impossible technical instant.
5. Guaranteed compatibility.
6. Guaranteed legal compliance.
7. Guaranteed business outcome.
8. Guaranteed content performance.
9. Guaranteed safe reliance.
10. Guaranteed storage recovery.

---

## 43. Limitation of Liability Strategy

Potential categories for counsel:

1. Indirect damages.
2. Lost profits.
3. Lost data.
4. Business interruption.
5. User publication.
6. Recording disputes.
7. Third-party platform actions.
8. AI errors.
9. Unauthorized content.
10. Service outages.

The product should also reduce real risk through:

1. Local files.
2. Export.
3. Evidence.
4. Visible uncertainty.
5. No automatic publishing.
6. No hidden recording.
7. Deletion.
8. Backups chosen by user.
9. Limited access.
10. Security controls.

Terms alone are not a substitute for product controls.

---

## 44. Indemnity Strategy

Counsel may include user responsibility for claims arising from:

1. Unlawful recording.
2. Unauthorized upload.
3. Copyright violation.
4. Privacy violation.
5. Publication.
6. Misrepresentation.
7. Prohibited use.
8. Violation of third-party terms.

Avoid aggressive language that undermines customer trust.

---

## 45. Intellectual Property

VisionBuilt should protect:

1. CURA name.
2. CURA logo.
3. VisionBuilt name.
4. Product copy.
5. Interface.
6. Code.
7. Templates.
8. Visual Brief designs.
9. Prompt systems where protectable.
10. Documentation.

Before launch:

1. Conduct trademark search.
2. Review domain.
3. Review App Store names.
4. Document contractor IP assignment.
5. Confirm code license compatibility.
6. Confirm font licenses.
7. Confirm icon licenses.
8. Confirm stock asset licenses.
9. Maintain open-source notices.
10. Use work-for-hire and assignment agreements.

---

## 46. Name and Trademark

CURA is the approved working product name.

Before commercial release:

1. Search federal trademarks.
2. Search state registrations.
3. Search common-law use.
4. Search App Stores.
5. Search domains.
6. Search adjacent software categories.
7. Review international markets.
8. Obtain legal clearance.
9. File applications if appropriate.
10. Preserve alternative names until cleared.

Do not assume acronym meaning creates trademark availability.

---

## 47. Contractor and Developer Agreements

Anyone contributing should sign terms covering:

1. Confidentiality.
2. Intellectual-property assignment.
3. Work product.
4. Open-source approval.
5. Security duties.
6. Data access.
7. Return or deletion of data.
8. Subcontracting.
9. Warranty.
10. Ongoing cooperation.

Do not let code ownership remain ambiguous.

---

## 48. Insurance

Evaluate:

1. Cyber liability.
2. Technology errors and omissions.
3. General liability.
4. Media liability.
5. Directors and officers coverage later.
6. Employment practices coverage later.

Insurance should match:

1. Revenue.
2. Data volume.
3. Enterprise contracts.
4. Sensitive use cases.
5. Platform exposure.

---

## 49. Company Structure

Operate CURA through the appropriate VisionBuilt legal entity.

Recommended operational separation:

1. Business bank account.
2. Contracts in company name.
3. Vendor accounts in company name.
4. App Store account in company name where practical.
5. Insurance in company name.
6. Accurate bookkeeping.
7. Tax advice.
8. Signed IP assignments.
9. Separate personal and business expenses.
10. Corporate record maintenance.

An LLC reduces certain risks but does not protect against every personal act, guarantee, or failure.

---

## 50. Product Liability Controls

CURA should minimize risk through:

1. Clear scope.
2. No automatic posting.
3. No hidden recording.
4. Source evidence.
5. Uncertainty labels.
6. Draft labels.
7. User confirmation.
8. Limited permissions.
9. Temporary processing.
10. Deletion controls.
11. Export.
12. No professional-advice positioning.
13. No regulated compliance claims without proof.
14. Security testing.
15. Vendor contracts.
16. Incident response.
17. Documentation.
18. Insurance.
19. Legal review.
20. Accurate marketing.

---

## 51. Privacy User Interface Requirements

The app must provide:

1. Processing Mode selector.
2. Plain-language processing explanation.
3. Temporary upload indicator.
4. Deletion status.
5. Cloud sync status.
6. Export controls.
7. Account deletion.
8. Session deletion.
9. Vendor explanation.
10. Training statement.
11. Analytics preference.
12. Consent notice.
13. Privacy Policy link.
14. Terms link.
15. Support link.

---

## 52. Just-in-Time Notices

Use short notices when a decision matters.

### Before Smart Mode upload

> CURA will upload this source temporarily to generate your results. Temporary source files are deleted after processing under our retention policy.

Actions:

1. Continue.
2. Use Private Mode.
3. Learn More.

### Before first social-link import

> Process only content you own or have permission to use. Platform restrictions may limit what CURA can access.

### Before Quick Send

> CURA will copy this text and open the selected app. Nothing will be published automatically.

### Before deleting account

> This will delete your CURA account and applicable server data. Files already exported to other services will remain there.

---

## 53. Consent Records

Record only what is needed.

Possible records:

1. Terms version accepted.
2. Privacy version acknowledged.
3. Recording notice acknowledged.
4. Smart Mode authorization.
5. Sync Mode opt-in.
6. Optional research opt-in.

Avoid storing unnecessary legal telemetry.

---

## 54. Policy Versioning

Maintain:

1. Policy version.
2. Effective date.
3. Acceptance date where required.
4. Material-change notice.
5. Archive of prior versions.
6. Release mapping.
7. Translation version.

Do not overwrite old policy text without preserving a record.

---

## 55. International Considerations

Before serving users broadly, review:

1. European Economic Area.
2. United Kingdom.
3. Canada.
4. Australia.
5. Other target markets.

Potential requirements include:

1. Lawful basis.
2. Data-processing agreements.
3. International transfer mechanism.
4. Data-subject rights.
5. Representative requirements.
6. Privacy notices.
7. Consent rules.
8. Age thresholds.
9. Retention.
10. Processor contracts.

Do not claim global compliance based only on a U.S. Privacy Policy.

---

## 56. U.S. State Privacy Considerations

Several U.S. states grant consumers rights involving:

1. Access.
2. Deletion.
3. Correction.
4. Portability.
5. Opt-out of sale.
6. Opt-out of targeted advertising.
7. Opt-out of certain profiling.

Applicability depends on jurisdiction, thresholds, business model, and data practices.

Even before CURA reaches statutory thresholds, building:

1. Export.
2. Deletion.
3. Correction.
4. No sale.
5. No targeted ads.
6. Clear privacy controls.

will reduce future compliance work.

---

## 57. Sale and Targeted Advertising

Recommended policy:

1. Do not sell personal information.
2. Do not share Capture Content for cross-context behavioral advertising.
3. Do not use Capture Content for targeted advertising.
4. Avoid third-party advertising SDKs.
5. Avoid ad attribution that conflicts with privacy posture.
6. Reassess before introducing ads.

Suggested statement:

> VisionBuilt does not sell your Capture Content or use it for targeted advertising.

Verify legal definitions with counsel.

---

## 58. Tracking

Recommended V1:

1. No cross-app tracking.
2. No advertising identifier.
3. No third-party ad network.
4. Content-free product analytics.
5. First-party attribution where practical.

If tracking is introduced later:

1. Revisit AppTrackingTransparency.
2. Update App Store disclosures.
3. Update Privacy Policy.
4. Update consent.
5. Review brand impact.

---

## 59. Website Privacy

The marketing website should:

1. Use a minimal analytics setup.
2. Avoid unnecessary cookies.
3. Explain waitlist collection.
4. Use a consent mechanism where required.
5. Secure forms.
6. Avoid public exposure of submissions.
7. Document email provider.
8. Provide unsubscribe.
9. Link Privacy Policy.
10. Link Terms.

Waitlist form should collect only:

1. Email.
2. Optional name.
3. Optional use case.
4. Optional platform.
5. Consent to receive updates.

---

## 60. Email Marketing

Requirements:

1. Clear opt-in.
2. Sender identity.
3. Unsubscribe.
4. Mailing address where required.
5. No deceptive subject lines.
6. Separate operational and marketing messages.
7. Suppression list.
8. Vendor agreement.
9. Limited retention.
10. Accurate frequency expectations.

Do not add product users to marketing lists without proper basis and disclosure.

---

## 61. Support and Disputes

Provide:

1. Support email.
2. Privacy email.
3. Legal notice address.
4. Billing help.
5. Account deletion help.
6. Security reporting channel.

Internal support workflow should define:

1. Identity verification.
2. Data access limits.
3. Escalation.
4. Response targets.
5. Deletion requests.
6. Billing disputes.
7. Abuse reports.
8. Security reports.

---

## 62. Law-Enforcement Requests

Create a policy:

1. Require valid legal process.
2. Verify request.
3. Narrow response.
4. Preserve confidentiality.
5. Notify user when legally permitted.
6. Document disclosure.
7. Retain minimum required data.
8. Use counsel.

Do not create a public transparency claim before procedures exist.

---

## 63. Government and Enterprise Requests

Do not casually provide user content to:

1. Employers.
2. Schools.
3. Event organizers.
4. Property owners.
5. Business administrators.
6. Family members.

Require:

1. User direction.
2. Valid account authorization.
3. Contractual authority.
4. Legal process where appropriate.

---

## 64. Content Removal

Because V1 is primarily private, public-content removal is limited.

If public sharing or hosted links are added later, create:

1. Abuse reporting.
2. Copyright complaints.
3. Privacy complaints.
4. Non-consensual media reporting.
5. Takedown process.
6. Appeals.
7. Repeat-infringer policy where appropriate.

---

## 65. Biometric and Identity Boundaries

CURA should not:

1. Identify unknown people from faces.
2. Build face templates.
3. Build voiceprints.
4. Infer identity from appearance.
5. Infer race, health, religion, or sexuality from media.
6. Sell biometric information.
7. Claim speaker identity without source support.

Speaker labels may use:

1. Speaker 1.
2. Speaker 2.
3. User-supplied name.
4. Source-supported name.

---

## 66. Property Use Boundaries

CURA may organize property observations.

It should not claim:

1. Licensed inspection.
2. Code compliance.
3. Structural safety.
4. Habitability certification.
5. Environmental clearance.
6. Cost guarantee.
7. Legal notice compliance.

Suggested disclaimer:

> CURA organizes observations from the material you provide. It does not replace a licensed inspection, contractor assessment, legal review, or safety evaluation.

---

## 67. Spiritual and Religious Use Boundaries

CURA may summarize sermons and teachings.

It should:

1. Preserve speaker context.
2. Avoid fabricating scripture.
3. Avoid claiming theological authority.
4. Separate source teaching from AI suggestion.
5. Allow personal reflection.
6. Avoid manipulating spiritual vulnerability.

---

## 68. Journalism and Interview Use

CURA should:

1. Preserve exact quotes.
2. Label paraphrases.
3. Link timestamps.
4. Avoid inventing attribution.
5. Preserve original media.
6. Make edits visible.
7. Encourage verification before publication.

Suggested notice:

> Verify quotes, names, dates, and claims against the original source before publication.

---

## 69. Publicity and Likeness

Users publishing images, clips, or quotes may need:

1. Consent.
2. Release.
3. Publicity rights.
4. Venue permission.
5. Music rights.
6. Trademark clearance.

CURA should not imply that capture permission automatically grants publication rights.

---

## 70. Music and Background Audio

Uploaded video may contain music.

CURA may transcribe or analyze the source, but users are responsible for:

1. Rights to reuse music.
2. Platform music rules.
3. Public performance.
4. Distribution.
5. Monetization.

Do not provide music-download functionality.

---

## 71. AI-Generated Visuals

If future versions generate images:

1. Label generated content where appropriate.
2. Avoid imitating protected artists on request where restricted.
3. Do not render critical text through image generation.
4. Maintain provenance metadata where practical.
5. Review publicity and trademark concerns.
6. Avoid deceptive documentary use.

V1 Visual Briefs should use structured templates.

---

## 72. Accessibility and Legal Risk

Accessibility is both a product and risk-management priority.

Implement:

1. Dynamic Type.
2. VoiceOver.
3. Contrast.
4. Keyboard access where relevant.
5. Non-color cues.
6. Accessible documents where practical.
7. Captions.
8. Clear errors.
9. Large touch targets.
10. Reduced Motion.

Do not claim formal certification unless tested.

---

## 73. Frequently Asked Questions

## What is CURA?

CURA is a mobile capture and knowledge activation app. It turns audio, video, photos, documents, and links into organized notes, content, visual briefs, and next actions.

## What does CURA stand for?

Capture. Understand. Refine. Activate.

## Does CURA secretly record people?

No. CURA does not offer hidden recording. The recording interface remains visible, and users are responsible for obtaining required permission.

## Is recording always legal?

No. Recording laws and policies vary. Users are responsible for following applicable law and obtaining required consent.

## Does CURA store my recordings?

Your original stays on your device by default. Smart Mode may temporarily upload content for processing. Temporary source files are deleted according to the stated retention policy.

## Does CURA train AI on my content?

CURA’s intended policy is no training on your recordings, files, transcripts, or notes by default. This statement must be verified against every production provider before publication.

## Can I use CURA without cloud processing?

Private Mode is intended to keep processing local where supported, but some advanced AI features may be unavailable.

## Can I delete everything?

You can delete sessions, sources, outputs, and your account. Files you exported to other services must be deleted from those services separately.

## Can I export my information?

Yes. CURA is designed to export notes and outputs to user-controlled destinations such as Files and iCloud Drive.

## Does CURA publish to social media?

Not in V1. CURA can copy content, open another app, or use the iOS Share Sheet. You decide what gets published.

## Does CURA edit videos?

CURA may identify clips, timestamps, hooks, captions, and workflow steps. It is not a professional video editor.

## Does CURA understand visuals?

Yes. Full Video processing may analyze visible text, slides, interfaces, scenes, and demonstrated actions in addition to audio.

## Are transcripts perfect?

No. Automatic transcription can contain errors. Review important names, quotes, numbers, dates, and decisions.

## Is CURA medical, legal, or financial advice?

No. CURA organizes and transforms information. It does not replace a qualified professional.

## Can I process YouTube videos?

CURA may analyze supported public YouTube links. Availability depends on access, provider support, and the video’s restrictions.

## Can I process Instagram or TikTok links?

Some public links may be supported. Platform restrictions can prevent access. CURA may ask you to upload a file you have permission to use.

## Who owns generated outputs?

Users retain rights in their source content. Rights in generated outputs may depend on source rights, applicable law, and third-party terms. Users should review before publication.

## Can CURA guarantee my content will perform well?

No. CURA prepares useful drafts, but it cannot guarantee engagement, revenue, reach, or business results.

## Is cloud sync available?

Persistent cross-device sync is planned as an explicit opt-in feature connected to Mission Control. It is not the default storage model.

## What happens if I cancel Pro?

You keep access to local sessions and previously generated outputs. Premium processing and generation may become limited.

---

## 74. Legal Launch Checklist

Before TestFlight external beta:

1. Company entity active.
2. Business bank account.
3. Contractor IP assignments.
4. Trademark preliminary search.
5. Domain ownership.
6. Privacy Policy draft.
7. Terms draft.
8. Recording notice.
9. Vendor inventory.
10. Vendor data terms reviewed.
11. Temporary retention verified.
12. Account deletion tested.
13. Session deletion tested.
14. App Store privacy inventory.
15. Subscription disclosures.
16. Support email.
17. Privacy email.
18. Security contact.
19. Incident-response plan.
20. Insurance quote.

Before public App Store launch:

1. Counsel review complete.
2. Final Privacy Policy published.
3. Final Terms published.
4. App Store disclosures completed.
5. Account deletion available in app.
6. Support and privacy links functional.
7. Retention automation audited.
8. AI training policy verified.
9. Security test completed.
10. RLS test completed.
11. Vendor contracts stored.
12. Data map current.
13. Child-directed marketing excluded.
14. Recording language approved.
15. Copyright process defined.
16. Refund language approved.
17. Accessibility review completed.
18. Incident contacts confirmed.
19. Insurance active where appropriate.
20. Release claims verified.

---

## 75. Privacy Engineering Checklist

For every new feature:

1. What data is collected?
2. Why is it needed?
3. Can it remain local?
4. Does it need temporary upload?
5. Which vendor receives it?
6. How long is it retained?
7. How is it deleted?
8. Is it logged?
9. Is it used in analytics?
10. Is it linked to identity?
11. Can the user export it?
12. Can the user delete it?
13. Does App Store disclosure change?
14. Does the Privacy Policy change?
15. Is new consent required?
16. Does the threat model change?
17. Does a child-safety issue arise?
18. Does regulated data arise?
19. Does marketing copy remain accurate?
20. Has counsel review become necessary?

---

## 76. Marketing Claim Review

Before publishing a claim, verify:

### “Private”

1. What leaves the device?
2. How long is it retained?
3. Who receives it?
4. What logs remain?

### “Secure”

1. What safeguards exist?
2. Are they tested?
3. Are vendors included?

### “Deleted”

1. Which object?
2. From which system?
3. How quickly?
4. What backups remain?

### “Accurate”

1. Which output?
2. What benchmark?
3. Under what conditions?

### “Instant”

1. What latency?
2. Which source length?
3. Which network?

### “Any link”

1. Which platforms?
2. What restrictions?
3. What fallback?

Avoid absolute marketing language.

---

## 77. Internal Privacy Roles

Assign:

1. Privacy owner.
2. Security owner.
3. Vendor owner.
4. Data deletion owner.
5. App Store disclosure owner.
6. Incident-response owner.
7. Support escalation owner.
8. Legal contact.
9. Subscription compliance owner.
10. Documentation owner.

Early-stage companies still need named responsibility.

---

## 78. Policy Source References

Review current official guidance during implementation and before release.

### Apple

App Review Guidelines  
https://developer.apple.com/app-store/review/guidelines/

App Privacy Details  
https://developer.apple.com/app-store/app-privacy-details/

Manage App Privacy  
https://developer.apple.com/help/app-store-connect/manage-app-information/manage-app-privacy/

Offering Account Deletion in Your App  
https://developer.apple.com/support/offering-account-deletion-in-your-app/

Apple Human Interface Guidelines: Privacy  
https://developer.apple.com/design/human-interface-guidelines/privacy

### United States Federal Trade Commission

Privacy and Security Guidance  
https://www.ftc.gov/business-guidance/privacy-security

Marketing Your Mobile App  
https://www.ftc.gov/business-guidance/resources/marketing-your-mobile-app-get-it-right-start

Data Security Guidance  
https://www.ftc.gov/business-guidance/privacy-security/data-security

COPPA Frequently Asked Questions  
https://www.ftc.gov/business-guidance/resources/complying-coppa-frequently-asked-questions

### California Privacy Protection Agency

Official CPPA site  
https://cppa.ca.gov/

Applicability and obligations require legal analysis.

---

## 79. Final Trust Standard

CURA should earn trust by doing less with user data, explaining more clearly, and giving users meaningful control.

The legal strategy should not be:

> Put everything in the Terms.

The strategy should be:

1. Narrow the product.
2. Minimize the data.
3. Obtain consent.
4. Keep recording visible.
5. Preserve evidence.
6. Label AI uncertainty.
7. Avoid automatic publishing.
8. Delete temporary files.
9. Let users export.
10. Let users delete.
11. Verify vendor behavior.
12. Protect access.
13. Insure real risk.
14. Use accurate marketing.
15. Have counsel review the final product.

CURA cannot eliminate legal risk.

It can materially reduce risk by making privacy, consent, user control, and honest communication part of the product architecture.
