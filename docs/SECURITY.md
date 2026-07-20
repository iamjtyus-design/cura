# CURA Security Baseline

## Principles

1. Least privilege.
2. Data minimization.
3. Private storage.
4. Short retention.
5. Server-side secrets.
6. User-scoped access.
7. Auditable deletion.
8. Content-free observability.
9. Secure defaults.
10. Honest claims.

## Client

1. Store auth tokens in Keychain.
2. Use iOS file protection.
3. Keep media outside application logs.
4. Validate imported file types and sizes.
5. Use security-scoped bookmarks narrowly.
6. Never bundle AI or service-role secrets.
7. Protect background recording state.
8. Avoid clipboard access without a tap.
9. Clear sensitive temporary files.
10. Use dependency pinning and review.

## Backend

1. Enable RLS on every user table.
2. Keep storage buckets private.
3. Use signed URLs with short expiry.
4. Verify auth and ownership in every function.
5. Verify RevenueCat webhook signatures.
6. Use idempotency keys.
7. Rate-limit uploads and AI jobs.
8. Limit duration, size, and concurrency.
9. Scrub provider errors.
10. Rotate secrets.
11. Use separate development, staging, and production projects.
12. Monitor deletion failures.

## Logging

Allowed:

1. Request ID.
2. Hashed user ID.
3. Session ID.
4. Job ID.
5. Stage.
6. Provider.
7. Model.
8. Usage units.
9. Latency.
10. Normalized error.

Forbidden:

1. Transcript text.
2. User notes.
3. Private URLs.
4. Signed URLs.
5. Auth tokens.
6. Media contents.
7. Clipboard contents.
8. Extracted personal details.

## Required tests

1. Cross-user database access.
2. Cross-user object access.
3. Expired signed URL.
4. Token revocation.
5. Account deletion.
6. Temporary cleanup.
7. Webhook replay.
8. Duplicate processing.
9. Oversized upload.
10. Malicious filename.
11. Unsupported MIME type.
12. Log scrubbing.

## Incident readiness

Define:

1. Incident owner.
2. Engineering lead.
3. Legal contact.
4. Vendor contacts.
5. Containment plan.
6. Notification analysis.
7. Key rotation.
8. Post-incident review.
