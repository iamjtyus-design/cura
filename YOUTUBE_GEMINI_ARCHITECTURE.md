# YouTube and Public Video Architecture

## Product Goal

Allow a user to paste a supported public YouTube URL and receive a source-grounded Curated Note and Output Packs.

## Processing Strategy

1. Validate and canonicalize the URL.
2. Create a Capture Source.
3. Inspect public availability.
4. Use Gemini video understanding for supported public YouTube URLs.
5. Use authorized captions where available and appropriate.
6. Preserve the actual transcript origin.
7. Request timestamped visual and audiovisual observations.
8. Build source observations.
9. Create the Curated Note.
10. Generate outputs from the Curated Note.

## Transcript-Origin Rules

Allowed labels:

1. Official captions.
2. Authorized captions.
3. Speech-to-text from user-uploaded audio.
4. Gemini video reconstruction.
5. Manual transcript.

Gemini reconstruction must never be labeled verbatim.

## Failure Cases

Handle:

1. Private video.
2. Deleted video.
3. Age restriction.
4. Geographic restriction.
5. Unsupported duration.
6. Provider limit.
7. Rate limit.
8. Missing media.
9. Policy restriction.

Fallback:

> This video cannot be processed from the public link. Upload a file you have permission to use.

## Social Video Router

Use a platform adapter.

Possible acquisition methods:

1. Public metadata.
2. Official API.
3. Authorized user access.
4. Provider-supported public URL understanding.
5. User-upload fallback.

Do not make brittle scraping the core production strategy.

Do not bypass authentication or platform restrictions.
