# Feature Plan — Build Order, Feasibility, Requirements

Sequenced per README's "The plan, loosely," with one prerequisite phase (0) added because nothing else can be built without auth and a workspace to hang data on. Each feature lists: what it is, frontend pieces, backend pieces, Firestore touched, external APIs/packages, feasibility notes and risks, and definition of done. Build phases in order — later phases assume earlier ones exist.

---

## Phase 0 — Foundations (Auth + Workspace + Brand Bible shell)

Not in README's roadmap list but required before anything else: every collection in the schema is workspace-scoped.

### 0.1 Authentication

- **Frontend:** `features/auth/` — email/password + Google sign-in screens, `AuthController` (ChangeNotifier) wrapping `firebase_auth`, route guard in `core/routing` that redirects unauthenticated users to `/sign-in`.
- **Backend:** `middleware/auth.middleware.js` verifies the Firebase ID token on every protected route (`firebase-admin` `verifyIdToken`), attaches `req.uid`.
- **Firestore:** `users/{uid}` created lazily on first authenticated request (no auth-trigger compute available on a plain Node server — the backend has no event-trigger mechanism, only HTTP routes, so this happens inside `auth.middleware.js` or a first-request check, not a trigger).
- **External APIs:** Firebase Authentication (email/password, Google provider).
- **Feasibility:** Solid, zero risk — this is Firebase's best-supported surface.
- **DoD:** sign up, sign in, sign out, token refresh, route guard all work on mobile + web.

### 0.2 Workspace creation & membership

- **Frontend:** `features/workspaces/` — create workspace flow, member invite (by email), workspace switcher.
- **Backend:** `routes/workspaces.routes.js`, `controllers/workspaces.controller.js`, `services/workspaces.service.js`, `repositories/workspaces.repository.js`. Invite flow needs a `invites/{token}` doc + email delivery (see risk below).
- **Firestore:** `workspaces/{wid}`, `users/{uid}.workspaceIds` updated transactionally on join.
- **External APIs:** none required for v1 if invites are a shareable link the invitee opens while already signed in; add an email provider (e.g. Firebase Extensions "Trigger Email" + SendGrid/Mailgun) only if async email invites are required.
- **Feasibility:** Straightforward. Risk is scope creep on invite UX — keep v1 to "generate link, anyone signed-in with the link joins as editor."
- **DoD:** create workspace, invite link join flow, role stored and enforced in security rules.

### 0.3 Brand Bible data model (UI deferred to Phase 4)

- **Frontend:** `features/workspaces/` CRUD form for the full `clients/{cid}` shape — see [FIRESTORE_SCHEMA.md](./FIRESTORE_SCHEMA.md) for the seven-section structure (identity, voice & tone, language rules, audience, products, pillars, competitors). Build it as a multi-section settings screen (tabs or a long scroll with anchored section headers), not seven separate forms — it's edited as one document. No linter logic yet — just data entry.
- **Backend:** `routes/clients.routes.js` + validators enforcing the full shape (already scaffolded in `backend/src/validators/clients.validators.js`).
- **Firestore:** `workspaces/{wid}/clients/{cid}`. `brandBibleVersion` auto-increments server-side on every save (repository layer already does this) — the frontend never sets it.
- **Feasibility:** Still CRUD, just CRUD over a richer shape. The only non-trivial UI decision is information density — this is the single densest screen in the app, so lean on progressive disclosure (collapsed sections by default) rather than cramming all seven sections onto one scroll.
- **DoD:** create/edit a full Brand Bible across all seven sections; no linting applied yet; `brandBibleVersion` visibly increments on save (even just shown in a corner, for sanity-checking the plumbing).

---

## Phase 1 — The Library (capture, snapshots, transcripts, X-Ray, folders, search)

The core technical risk of the whole product lives here. Read README "The honest bits" before starting.

### 1.1 Capture intake (record-and-share, v1)

- **Frontend:** OS-level share sheet target — Flutter package `receive_sharing_intent` (Android/iOS) registers Foolscap as a share target for video files/links. `features/library/presentation` shows an "Add to workspace" sheet after a video is shared in. Upload via `firebase_storage` with resumable upload + progress UI (loading state per playbook section 4).
- **Backend:** the upload itself needs nothing (client uploads directly to Storage under a path backend security rules validate); once the upload finishes, the client calls `POST /v1/workspaces/:wid/references` to register it, which creates the `references/{rid}` doc with `status: "queued"`. (No Cloud Functions Storage trigger — the backend is a plain Node server, so this is a client-initiated call, not an event trigger. See [ASSUMPTIONS_AND_DECISIONS.md](./ASSUMPTIONS_AND_DECISIONS.md).)
- **Firestore/Storage:** `references/{rid}`, Storage path `workspaces/{wid}/references/{rid}/source.mp4`.
- **External APIs/packages:** `receive_sharing_intent`, `firebase_storage`.
- **Feasibility:** README calls this "v1, zero custom magic" — correct. Main engineering cost is robust resumable upload UX (retries, Wi-Fi drop, background upload) not the share-intent plumbing.
- **Risk:** iOS share extensions have strict memory limits for large video files; test with real multi-minute screen recordings early, not synthetic small files.
- **DoD:** share a screen-recorded reel from the OS share sheet into Foolscap, see it land in the Library with an uploading → ready status progression.

### 1.2 One-tap in-app record (deferred, flagged high-risk)

- **Frontend:** custom platform channel work — Android `MediaProjection` API, iOS `ReplayKit` + a **Broadcast Extension** target (a separate iOS app extension, not pure Dart/Flutter) to record other apps' screens.
- **Feasibility:** **High native-engineering risk.** No mature, actively maintained Flutter plugin does this well for recording *other* apps on iOS. This is not a "add a package" feature — it is custom native module work on both platforms, plus App Store review scrutiny on Broadcast Extensions. Treat as its own mini-project, not a Library sub-task.
- **Recommendation:** build and ship 1.1 fully first; only pick this up with a dedicated native-engineering pass, likely after Phase 3.

### 1.3 Ingestion pipeline: transcript, on-screen text, X-Ray

- **Backend:** `services/geminiAnalysis.service.js` — the single call site. Uploads the Storage file reference to Gemini via the **Files API** (files up to 2GB; use inline base64 only for very short clips) and calls `generateContent` with a strict `responseSchema` matching `references/{rid}.analysis` and transcript/onScreenText shapes 1:1 (see [FIRESTORE_SCHEMA.md](./FIRESTORE_SCHEMA.md)).
- **Flow:** client registers the upload (`status: "queued"`, see 1.1) → a small `/internal/process-analysis-queue` endpoint, hit periodically by the backend host's cron/scheduler feature (**not** Cloud Tasks — there isn't one, see [ASSUMPTIONS_AND_DECISIONS.md](./ASSUMPTIONS_AND_DECISIONS.md)), picks up a batch of queued references → sets `status: "analyzing"` → Gemini call → writes `analysis`/`transcript`/`onScreenText` → sets `status: "ready"` (or `"failed"` + `failureReason`). See [TECHNICAL_DEEP_DIVE.md](./TECHNICAL_DEEP_DIVE.md) section 3 for the full trace.
- **Frontend:** `features/library/data` listens to the `references/{rid}` doc via a Firestore snapshot stream and reflects `status` directly in the UI (loading/analyzing/ready/failed), per playbook's mandatory loading/empty/error/success states.
- **External APIs:** Gemini API (Files API + `generateContent` with `responseSchema`). Gemini samples ~1 frame/sec — confirms a screen recording is sufficient quality for X-Ray (README).
- **Feasibility:** README calls the video-understanding part "solved" — trust that, but the **orchestration** (queue, retry on failure, idempotent re-analysis) is real engineering, budget for it — more so than it would be on Cloud Tasks, since retry-with-backoff has to be built by hand here (a `retryCount` field and a requeue check in the queue query, see [TECHNICAL_DEEP_DIVE.md](./TECHNICAL_DEEP_DIVE.md) section 3) rather than coming for free from the platform.
- **Risk — Roman Urdu / English code-switching:** no standard spelling, mid-sentence language switching. Test against real saved clips before promising transcript accuracy in product copy; consider storing `language: "mixed"` explicitly so the UI can caveat accuracy rather than imply perfection.
- **DoD:** a reference goes from `queued` to `ready` with a populated transcript, on-screen text, and full X-Ray `analysis` bundle, end to end, on a real device-recorded clip.

### 1.4 Folders, tags, search

- **Frontend:** `features/library/presentation` — folder CRUD, tag chips, search bar.
- **Backend:** `routes/references.routes.js` for tag/folder mutation (folder membership is many-to-many, keep `referenceCount` consistent via a transaction in `services/references.service.js`).
- **Search:** ship the `searchTerms: array<string>` tokenized-field fallback described in [FIRESTORE_SCHEMA.md](./FIRESTORE_SCHEMA.md) (`array-contains-any` query) for v1. Do not integrate Algolia/Typesense until keyword search is proven insufficient — it's new infra and a new monthly bill.
- **Feasibility:** Folder/tag CRUD is trivial. Search quality is the real open question — treat the fallback as intentionally temporary, not a mistake to fix immediately.
- **DoD:** filter by folder/tag; search returns relevant results on transcript/caption keyword overlap.

---

## Phase 2 — The Room (Writing Room, timers, Hook Bench, Overlap Alarm, Expression Vault)

### 2.1 Writing Room core (two-column editor)

- **Frontend:** `features/writing_room/presentation` — two-column (hear/see) row-based editor, `WritingRoomController` holding the in-progress `versions/{vid}.rows` draft, autosave debounce to backend on row change. Pinned reference panel beside the draft (playbook: controllers own async state, never fetch in `build()`).
- **Backend:** `routes/scripts.routes.js` — create script, save version (append-only — every save creates a new `versions/{vid}`, never mutates a past version, this *is* the Human Ink audit trail).
- **Firestore:** `scripts/{sid}`, `scripts/{sid}/versions/{vid}`.
- **Feasibility:** Standard rich structured-editor work, no exotic APIs. Main design decision: autosave cadence and conflict handling if two people edit the same script (v1: last-write-wins is acceptable given single-writer-at-a-time usage pattern implied by README).
- **DoD:** write a script in the two-column format, see autosave create new versions, see word count live.

### 2.2 Live speaking-pace timer

- **Frontend:** pure client-side computation — `wordCount / userSpeakingPaceWpm * 60` recalculated on every keystroke/row change, displayed against `scripts/{sid}.targetDurationSec`. Speaking pace is a per-user setting (`features/settings/`), stored via `shared_preferences` (non-sensitive).
- **Feasibility:** Zero external dependency, pure logic. Lowest-risk feature in the whole plan.
- **DoD:** timer updates live while typing and visibly flags over/under target duration.

### 2.3 Hook Bench

- **Frontend:** `features/writing_room/presentation` — a scratch-pad UI listing N hook variants for row 1, pick-one-to-promote interaction. This is just structured local/draft state, no new backend shape beyond possibly storing bench drafts in the version doc or a lightweight `scripts/{sid}.hookBench: array<string>` scratch field that is not part of version history (it's drafting, not an authored line yet).
- **Feasibility:** Pure frontend feature.
- **DoD:** write multiple hooks, promote one into row 1 of the script.

### 2.4 Overlap Alarm

- **Backend:** `services/overlap.service.js` — on version save, compare each row's `hearText` against the transcripts of the script's `linkedReferenceIds` using a similarity measure (start with a cheap approach: normalized n-gram/Jaccard overlap or a string-similarity library; this does **not** need an LLM call — it's explicitly a "plain rule," matching the product's no-AI-in-writing stance). Write results into `versions/{vid}.overlapFlags`.
- **Frontend:** render a subtle inline warning on flagged rows, pulling `overlapFlags` from the latest version.
- **Feasibility:** Medium — tuning the similarity threshold to avoid false positives ("same topic" vs "same words") needs iteration against real scripts. No external API required; keep it server-side so the threshold/algorithm can change without an app release.
- **DoD:** typing a near-verbatim line from a pinned reference's transcript triggers a visible flag within the autosave cycle.

### 2.5 Expression Vault

- **Frontend:** `features/expression_vault/` — in-app video trim UI (start/end markers) over a reference's best-quality source, tag input, pin-to-row picker inside the Writing Room.
- **Backend:** clipping a sub-video from the source needs either (a) client-side trim via a Flutter video-editing package (limited, codec-dependent) or (b) server-side `ffmpeg` run as a background job on the backend's own Node host. A long or heavy encode may exceed the host's request-timeout the same way Gemini analysis can (see Phase 1.3) — if so, reuse the same register-then-process-via-cron pattern rather than trying to encode inline in the HTTP request.
- **Firestore:** `expressionClips/{eid}`.
- **Feasibility:** Medium-high risk on the media-processing side. Recommend starting with client-side trim-and-re-upload (simplest, works for short clips) and only move to server-side ffmpeg if quality/perf demands it.
- **DoD:** clip a 2-5 second moment from a reference, tag it, pin it to a script row, see it rendered inline in the Writing Room.

---

## Phase 3 — The Pitch (shareable links, comments, approvals)

### 3.1 Shareable pitch link

- **Backend:** `routes/pitches.routes.js` — creates `pitches/{pid}` with a random `shareToken`; a **public** (unauthenticated) JSON endpoint `GET /v1/pitches/by-token/:token` returns the pinned script version + references, enforced read-only and scoped to exactly that pitch (never a general public Firestore read — go through the backend so there is a single, auditable chokepoint for what's exposed).
- **Backend, mobile-only consequence:** Foolscap ships as a mobile app only (Android/iOS, no Flutter Web/desktop — see [ASSUMPTIONS_AND_DECISIONS.md](./ASSUMPTIONS_AND_DECISIONS.md)), so the client/brand opening a pitch link **cannot** be assumed to have the app installed. The public pitch view is therefore a small **server-rendered HTML page** served directly by the backend (`GET /pitch/:token`, plain template, no build step, no app required) — not a Flutter screen of any kind. The JSON endpoint above is what that HTML page's own script calls to fetch data; it is not consumed by the Flutter app.
- **Frontend (Flutter):** the creator-side pitch flow only — compose a pitch (pick script version + references + shot list), see its status/comments/revision counter. The Flutter app never renders the public pitch page.
- **Feasibility:** Standard, but the security posture matters: the public endpoint/page must only ever expose the one pitch it's scoped to, never a workspace-wide query. Covered in [SECURITY_PRACTICES.md](./SECURITY_PRACTICES.md). The server-rendered page also means zero Flutter Web build/hosting to maintain — simpler than the original plan, not a compromise.
- **DoD:** open a pitch link in a private browser tab on a phone with no app installed and see the script, references, and shot list; creator sees the same pitch's comments/approval status inside the Flutter app.

### 3.2 Timestamped comments + revision counter

- **Backend:** `pitches/{pid}/comments/{cid}` CRUD via the same public-token-scoped endpoint (rate-limited — this is an unauthenticated write surface, see [SECURITY_PRACTICES.md](./SECURITY_PRACTICES.md)).
- **Frontend:** comment pinned to a script row, revision counter increments on each new `versions/{vid}` tied to that pitch.
- **Feasibility:** Standard CRUD; the only non-obvious part is the revision counter needs to track "how many script versions since this pitch was sent," which just means storing `scriptVersionIdAtSend` on the pitch and diffing version `createdAt` ordering.
- **DoD:** client comments on a specific line without an account; creator sees comments mapped to exact rows.

### 3.3 Approval lock

- **Backend:** `approvedAt` set once, backend rejects any further mutation to that pitch's `scriptVersionId` reference after approval (immutability enforced server-side, not just hidden in the UI).
- **Feasibility:** Simple state-machine rule.
- **DoD:** approving a pitch is irreversible through normal app flow and visibly locks the version.

---

## Phase 4 — The Guardrails (Brand Bible linter, pillar heatmap)

### 4.1 Brand Bible linter

- **Backend:** `services/linter.service.js` — pure rule evaluation run against a script version's full text on save. Explicitly **no AI judgment** (README) — every check below is regex/string/set matching, nothing fuzzier:
  - `bannedWords` → substring/word-boundary match, hard flag.
  - `preferredTerms` → same match as a banned word, but the flag carries a one-click "swap to `preferred`" suggestion instead of just a rejection.
  - `requiredDisclaimers` → presence check, now scoped by `placement` (`caption`/`on_screen`/`voiceover`) so a disclaimer meant for voiceover doesn't false-pass just because the word appears in an on-screen-text row.
  - `approvedClaims`/`competitorMentionPolicy` → v1 scope note: flagging an *unapproved* claim or a competitor mention needs a defined claim-detection rule (e.g. superlative + product-noun patterns), which is a second iteration on this service, not day one. Ship banned-word/preferred-term/disclaimer checks first; add claims/competitor checks once those are proven useful.
  - Every linter result records the `brandBibleVersion` it was checked against (see [FIRESTORE_SCHEMA.md](./FIRESTORE_SCHEMA.md)) so a script's "passed the linter" status stays honestly scoped in time.
- **Frontend:** inline warnings in the Writing Room, same visual language as the Overlap Alarm; `preferredTerms` flags render with an inline swap action, other flags render as plain warnings.
- **Feasibility:** Low risk, deterministic logic for the v1 scope (banned words, preferred terms, disclaimers). Claims/competitor-mention checking is medium risk on rule design, not on infrastructure.
- **DoD:** a banned word, an unswapped preferred term, or a missing disclaimer surfaces as a flag before the script reaches a pitch, and the flag records the Brand Bible version it was checked against.

### 4.2 Pillar heatmap

- **Frontend:** `features/guardrails/presentation` — aggregate view (chart/grid) of scripts by `pillarId` over time, using the composite index on `(pillarId, updatedAt)`.
- **Backend:** likely a read-only aggregation endpoint (`routes/analytics.routes.js`) if the aggregation is too heavy for client-side Firestore queries at scale; start client-side.
- **Feasibility:** Standard reporting feature once pillars exist on scripts (Phase 2 already stamps `pillarId`).
- **DoD:** see pillar distribution across a workspace's scripts over a selectable time range.

---

## Phase 5 — The Radar (licensed data, outlier alerts, comment mining) — legally gated

- **Do not build a scraper.** README is explicit: platforms ban automated access in their ToS; this must run on licensed data or official partner/API routes, with legal advice **before** any engineering starts.
- **Feasibility:** Unknown until a data source is contracted. No schema, no endpoints, no frontend work should start here until that's resolved — this phase is a placeholder, not a backlog of buildable tickets.
- **Action item:** when a licensed data source exists, revisit this section and expand it before writing code.

## Phase 5b — Format Arbitrage Board

- Same legal gating as Radar if it relies on cross-niche scraped data; if instead it's powered by the same licensed source as Radar, it's a derived view (`services/formatArbitrage.service.js` grouping outlier references by format across niches) — define after Radar's data source is settled.

---

## Phase 6 — The Set (Teleprompter, take log, results loop, Human Ink)

### 6.1 Set Mode (teleprompter)

- **Frontend:** `features/set_mode/presentation` — large-type, high-contrast, auto-scroll-at-speaking-pace view; must work **offline** (cache the active script's latest version locally — `shared_preferences` for a single doc is fine, or a tiny local store if caching multiple scripts for an offline shoot day), mirror-flip toggle for teleprompter rigs.
- **Feasibility:** Mostly UI/UX polish + offline caching discipline (playbook section 11: cache stable data, invalidate on logout). No new backend surface beyond reading the script.
- **DoD:** open a script in Set Mode with Wi-Fi off and it still renders and scrolls correctly.

### 6.2 Take log

- **Backend:** `routes/takes.routes.js`, simple CRUD.
- **Firestore:** `takes/{tid}`.
- **Feasibility:** Trivial.
- **DoD:** mark takes good/ok/bad against specific script lines during a shoot.

### 6.3 Results loop (retro)

- **Frontend/Backend:** `retros/{rid}` CRUD, user-entered metrics (no platform API integration assumed in v1 — README doesn't specify auto-pulling Instagram/TikTok analytics, and that would need those platforms' official APIs/business accounts, which is a separate feasibility question to raise if auto-pull is wanted later).
- **Feasibility:** Simple as manual entry; flag as open question if automatic metric pulling becomes a requirement — note it here rather than assume it.
- **DoD:** log day1/week1/month1 metrics and notes against a posted script.

### 6.4 Script Graveyard

- **Frontend:** a filtered view of `scripts` where `status == "graveyard"`, plus a "resurrect" action that just flips status back to `"draft"`.
- **Feasibility:** Trivial, no new schema.
- **DoD:** move a script to the graveyard and resurrect it later with history intact.

### 6.5 Human Ink

- **Backend:** `services/humanInk.service.js` — reads a script's full `versions` subcollection ordered by `createdAt`, assembles the authorship timeline, renders a PDF (`pdfkit` on the backend, keeps this off the Flutter app's dependency list and makes the export shareable via a signed Storage URL rather than generated on-device).
- **Frontend:** "Export authorship proof" button → calls backend → gets a download link.
- **Feasibility:** Low risk — it's a report generator over data the app already captures by design (every version is already attributed per the AI firewall rule in [ARCHITECTURE.md](./ARCHITECTURE.md)).
- **DoD:** export a one-pager PDF showing a script's authorship timeline.

---

## Cross-cutting items that ride along with every phase

- Responsive mobile/tablet/desktop pass per playbook section 6 (don't defer to "final polish").
- Loading/empty/error/success states for every network-driven screen (playbook section 4, 15, 21).
- Security rules updated in the same PR as any new collection (never ship a collection without rules).
- API contract entry added to [API_CONTRACTS.md](./API_CONTRACTS.md) for every new endpoint before the frontend consumes it.
