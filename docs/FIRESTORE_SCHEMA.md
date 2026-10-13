# Firestore Schema

Expands the README's rough shape into field-level detail. All collections live under a workspace except `users/` (global) and `invites/` (global, workspace-scoped by field).

## Conventions

- All documents carry `createdAt`, `updatedAt` (server timestamps, written by backend only — never trust client-sent timestamps).
- All IDs are Firestore auto-IDs unless noted.
- Soft delete via `deletedAt: Timestamp | null` on anything a user can "delete" but that other docs reference (references, scripts) — never hard-delete across subcollections.
- Enum fields are stored as short strings (e.g. `"hook_question"`), matching the Gemini `responseSchema` enums 1:1 so no translation layer is needed between AI output and Firestore.

## `users/{uid}`

| Field | Type | Notes |
|---|---|---|
| `email` | string | from Firebase Auth |
| `displayName` | string | |
| `photoUrl` | string? | |
| `workspaceIds` | array\<string\> | denormalized for fast "which workspaces am I in" on login |
| `defaultWorkspaceId` | string? | |

## `workspaces/{wid}`

| Field | Type | Notes |
|---|---|---|
| `name` | string | |
| `ownerUid` | string | |
| `memberUids` | array\<string\> | used in security rules for access checks |
| `members` | map\<uid, {role: "owner"\|"editor"\|"viewer", joinedAt}\> | role lives here, not just in `memberUids` |
| `plan` | string | future billing hook, unused in v1 |

### `workspaces/{wid}/clients/{cid}` — the Brand Bible

This is the single source of creative + legal truth for one client relationship. Everything downstream (the linter, the pillar heatmap, script defaults, even what a new script's format defaults to) reads from here — treat it as the one document worth over-designing, because every other feature is thin by comparison and this is what makes Foolscap feel like a real content-operations platform instead of a notes app with a video player attached.

It is organized into seven concerns. All of it lives on one document (not subcollections) — it's edited as a whole in one settings screen, read in full by the linter on every script save, and at this size (a few KB of text/config) one document read is cheaper and simpler than five.

**1. Identity** — who the brand is.

| Field | Type | Notes |
|---|---|---|
| `name` | string | client/brand name |
| `industry` | string? | e.g. `"automotive"` — lets future templates/defaults key off it |
| `logoUrl` | string? | Storage URL, shown as a watermark in Set Mode and on pitch pages |
| `brandColors` | array\<{name, hex}\> | not used for app theming — this is *their* palette, shown as a reference swatch so a creator never has to ask "what's the blue again" |
| `platforms` | array\<enum: `tiktok`\|`instagram`\|`youtube`\|`other`\> | which platforms this client is actually active on; seeds the default `sourcePlatform`/`format` picks on new references/scripts |

**2. Voice & tone** — how the brand sounds, with enough texture that "match the tone" means something concrete instead of a vibe.

| Field | Type | Notes |
|---|---|---|
| `voiceAdjectives` | array\<string\> | e.g. `["confident", "dry", "never corporate"]` — shown as pinned chips at the top of the Writing Room, not buried in a settings page nobody reopens |
| `toneNotes` | string | free text, human-authored, the original field — now the "paragraph" version sitting above the adjective "tags" |
| `voiceDoExamples` | array\<string\> | real lines that sound right, pulled from past approved scripts where possible |
| `voiceDontExamples` | array\<string\> | real lines that missed — just as useful as the do's, often more |
| `formality` | enum: `casual`\|`neutral`\|`formal` | one blunt dial instead of a paragraph nobody reads before writing hook #40 |

**3. Language rules** — the part the linter (Phase 4) actually executes against. No AI judgment anywhere in this section, by design.

| Field | Type | Notes |
|---|---|---|
| `bannedWords` | array\<string\> | plain-rule linter input, no AI — unchanged from v1 |
| `preferredTerms` | array\<{banned, preferred}\> | softer than an outright ban — linter flags `banned` and suggests `preferred` inline instead of just rejecting (e.g. `{banned: "cheap", preferred: "affordable"}`) |
| `requiredDisclaimers` | array\<{id, text, placement: enum(`caption`\|`on_screen`\|`voiceover`)}\> | `placement` added — a disclaimer that must be read aloud and one that must appear as a caption are different linter checks, and the old flat shape couldn't tell them apart |
| `approvedClaims` | array\<{id, text, expiresAt?}\> | the claims library: pre-cleared-by-legal statements a writer can safely use verbatim. Critical for regulated clients (auto, finance, health) — the linter can eventually flag an *unapproved* superlative/claim the same way it flags a banned word, without ever generating one |
| `competitorMentionPolicy` | enum: `never`\|`generic_only`\|`allowed` | legal-driven rule on whether a script may name a named competitor |
| `legalReviewRequired` | boolean | if true, Pitch (Phase 3) should surface this clearly to the approver — doesn't block anything in v1, just visible context |

**4. Audience** — who this is actually for, so "relatable pain" (a hook type the X-Ray already detects) means a specific person, not a guess.

| Field | Type | Notes |
|---|---|---|
| `personas` | array\<{id, label, ageRange?, painPoints: array\<string\>, primaryPlatform?}\> | kept intentionally light — this is a creative anchor for the writer, not a marketing-ops persona deck |

**5. Product / model specs** — restructured from one free-text blob into something a multi-SKU client (a dealership with ten trims, not one product) can actually use.

| Field | Type | Notes |
|---|---|---|
| `products` | array\<{id, name, keyFeatures: array\<string\>, priceNote?, availabilityNote?}\> | replaces the old flat `modelSpecs: string`. A script can reference `products[].id` later if that level of linkage is ever needed — not required for v1, the array alone is already more useful than one paragraph |
| `modelSpecs` | string? | kept as a free-text overflow field for anything that doesn't fit the structured list yet (legacy-compatible, optional) |

**6. Content pillars** — the taxonomy the heatmap (Phase 4.2) buckets scripts into, now with enough shape to answer "are we actually hitting our pillar mix" instead of just coloring a chart.

| Field | Type | Notes |
|---|---|---|
| `pillars` | array\<{id, label, color, description?, targetFrequency?: string}\> | `description` and `targetFrequency` (e.g. `"2x/week"`) added — the heatmap in Phase 4.2 can now show *actual vs target* cadence per pillar, not just a raw distribution |

**7. Competitors** — configuration only, not scraped data. This is just "who are we watching," which is harmless to store now and becomes the seed list Radar (Phase 5) consumes once that's legally cleared — building the list is not the scraping.

| Field | Type | Notes |
|---|---|---|
| `competitors` | array\<{id, name, handle?, platform?}\> | plain user-entered list |

**Meta / lifecycle**

| Field | Type | Notes |
|---|---|---|
| `brandBibleVersion` | number | incremented on every save. A script's linter result (Phase 4) should record which `brandBibleVersion` it was checked against, so "this script passed the linter" stays honestly scoped to the rules that existed at the time — the Brand Bible is a living document and old approvals shouldn't silently claim to satisfy rules written after the fact |
| `archivedAt` | Timestamp? | unchanged from v1 |

Deliberately **not** added here, to avoid turning one client's settings doc into an entire marketing-ops suite the rest of the app doesn't yet need: a content calendar/scheduling system and an analytics rollup. Both are reasonable "content platform" features in the abstract, but nothing in README's roadmap asks for them yet and `scripts.status` (`posted`) plus `retros/{rid}` already cover the actual need (knowing a script went out, and recording how it did). Logged in [ASSUMPTIONS_AND_DECISIONS.md](./ASSUMPTIONS_AND_DECISIONS.md) so this is a deliberate line, not an oversight.

### `workspaces/{wid}/references/{rid}`

| Field | Type | Notes |
|---|---|---|
| `sourceUrl` | string? | original TikTok/IG/YouTube link, kept for provenance only |
| `sourcePlatform` | enum | `tiktok` \| `instagram` \| `youtube` \| `other` |
| `storagePath` | string | Cloud Storage path to the owned video snapshot |
| `thumbnailUrl` | string? | generated on upload |
| `durationSec` | number | |
| `status` | enum | `uploading` \| `queued` \| `analyzing` \| `ready` \| `failed` — drives Firestore-listener UI state |
| `failureReason` | string? | set only when `status == "failed"` |
| `transcript` | array\<{startMs, endMs, text, speaker?}\> | from Gemini, read-only in UI |
| `onScreenText` | array\<{startMs, endMs, text}\> | |
| `caption` | string? | scraped/pasted caption text |
| `language` | enum | `en` \| `ur_roman` \| `ur` \| `mixed` |
| `analysis` | map | the X-Ray bundle — see schema below |
| `tags` | array\<string\> | user-authored |
| `folderIds` | array\<string\> | many-to-many, folders are just tag groups (see below) |
| `relatedPillarId` | string? | optional FK into `clients/{cid}.pillars` — lets a saved reference say "this is the kind of thing we mean by our 'relatable pain' pillar," so the Writing Room can later suggest references by pillar, not just by folder |
| `relatedCompetitorId` | string? | optional FK into `clients/{cid}.competitors` — if this reel belongs to a tracked competitor, tag it now; costs nothing today and is the exact join Format Arbitrage (Phase 5b) will want later |
| `deletedAt` | Timestamp? | |

`analysis` map (the Gemini `responseSchema` output, 1:1):

| Field | Type |
|---|---|
| `hookType` | enum: `question` \| `bold_claim` \| `pattern_interrupt` \| `relatable_pain` \| `visual_shock` \| `other` |
| `hookDurationMs` | number |
| `cutCount` | number |
| `cutsPerMinute` | number |
| `wordsPerMinute` | number |
| `pauses` | array\<{startMs, endMs}\> |
| `textAppearances` | array\<{startMs, label}\> |
| `outlierScore` | number | how far this reel outran the account's normal numbers, 0-100 |
| `analyzedAt` | Timestamp |
| `modelVersion` | string | which Gemini model/schema version produced this, for future re-analysis migrations |

### `workspaces/{wid}/folders/{fid}`

| Field | Type | Notes |
|---|---|---|
| `name` | string | |
| `color` | string? | |
| `referenceCount` | number | denormalized counter, maintained by backend on reference add/remove |

### `workspaces/{wid}/expressionClips/{eid}` — Expression Vault

| Field | Type | Notes |
|---|---|---|
| `referenceId` | string | parent reference |
| `storagePath` | string | clipped sub-video, best-quality source (not the screen recording) |
| `startMs` / `endMs` | number | trim points within the parent reference |
| `tag` | string | e.g. `"deadpan"` |
| `thumbnailUrl` | string? | |

### `workspaces/{wid}/scripts/{sid}`

| Field | Type | Notes |
|---|---|---|
| `title` | string | |
| `clientId` | string | FK to `clients/{cid}` |
| `format` | enum | `reel` \| `carousel` \| `static` \| `other` |
| `status` | enum | `draft` \| `in_review` \| `approved` \| `shot` \| `posted` \| `graveyard` |
| `linkedReferenceIds` | array\<string\> | pinned references |
| `targetDurationSec` | number? | compared live against the Writing Room timer |
| `currentVersionId` | string | FK, always points at latest `versions/{vid}` |
| `pillarId` | string? | FK into `clients/{cid}.pillars`, feeds the heatmap |

### `workspaces/{wid}/scripts/{sid}/versions/{vid}`

| Field | Type | Notes |
|---|---|---|
| `authorUid` | string | backend-stamped, never client-trusted — this is Human Ink's raw material |
| `rows` | array\<{id, hearText, seeText, direction?, pinnedReferenceId?, pinnedClipId?}\> | left column / right column model |
| `wordCount` | number | denormalized for the live timer |
| `estimatedDurationSec` | number | wordCount / user's configured speaking pace |
| `overlapFlags` | array\<{rowId, matchedReferenceId, similarity}\> | Overlap Alarm output, computed server-side |
| `createdAt` | Timestamp | immutable, this *is* the version history |

### `workspaces/{wid}/pitches/{pid}`

| Field | Type | Notes |
|---|---|---|
| `scriptId` | string | |
| `scriptVersionId` | string | pitch always pins a specific version, not "latest" |
| `referenceIds` | array\<string\> | |
| `shareToken` | string | random, URL-safe, used in the public link instead of `pid` |
| `status` | enum | `sent` \| `commented` \| `approved` \| `rejected` |
| `approvedAt` | Timestamp? | once set, immutable — "approved actually locks the version" |
| `approvedByName` | string? | client-side name, not a Firebase user (clients don't need accounts) |

### `workspaces/{wid}/pitches/{pid}/comments/{cid}`

| Field | Type | Notes |
|---|---|---|
| `rowId` | string? | which script row/line this is pinned to, null = general comment |
| `authorName` | string | |
| `authorRole` | enum | `creator` \| `client` |
| `text` | string | |
| `resolvedAt` | Timestamp? | |

### `workspaces/{wid}/takes/{tid}` — Set Mode take log

| Field | Type | Notes |
|---|---|---|
| `scriptId` | string | |
| `rowId` | string | which line this take covers |
| `takeNumber` | number | |
| `verdict` | enum | `good` \| `ok` \| `bad` |
| `note` | string? | |

### `workspaces/{wid}/retros/{rid}` — results loop

| Field | Type | Notes |
|---|---|---|
| `scriptId` | string | |
| `postedUrl` | string? | |
| `day1Metrics` / `week1Metrics` / `month1Metrics` | map\<string, number\>? | user-entered, platform-agnostic key/value (views, saves, etc.) |
| `notes` | string | human retro notes |

## Collections intentionally deferred

- `radar/*` — no schema yet. README flags Radar as legally-gated (licensed data only); do not design or build a scraper-shaped schema. Revisit after legal review, see [FEATURE_PLAN.md](./FEATURE_PLAN.md) Phase 5.
- `humanInkExports/*` — Human Ink export is derived entirely from `versions/{vid}.authorUid/createdAt` across a script's history; no separate write-path collection is needed until export becomes expensive enough to cache.

## Indexes (see `firestore.indexes.json`)

- `references`: composite on `(workspaceId implicit via path, folderIds ARRAY_CONTAINS, createdAt DESC)`.
- `references`: composite on `(status, createdAt DESC)` — for "show me what's still analyzing."
- `scripts`: composite on `(status, updatedAt DESC)`.
- `scripts`: composite on `(pillarId, updatedAt DESC)` — heatmap queries.

## Search (flagged risk)

Firestore has **no native full-text search**. README promises "everything is searchable by anything said or shown" (transcript + on-screen text + caption). This needs one of:

1. A search extension/service — **Typesense** or **Algolia** (Firebase has an official Algolia extension that syncs on write) indexing `transcript`, `onScreenText`, `caption`, `tags`.
2. A cheaper v1 fallback: tokenize transcript/caption into a `searchTerms: array<string>` field server-side on write, query with `array-contains-any` — works for keyword matching, not phrase relevance, but needs zero new infra.

Recommendation: ship the `searchTerms` fallback in Phase 1, swap in Typesense/Algolia only if keyword search proves too weak in practice. Logged in [ASSUMPTIONS_AND_DECISIONS.md](./ASSUMPTIONS_AND_DECISIONS.md).
