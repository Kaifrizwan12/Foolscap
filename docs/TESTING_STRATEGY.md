# Testing Strategy

Priority order per [FLUTTER_FULL_STACK_PLAYBOOK.md](../FLUTTER_FULL_STACK_PLAYBOOK.md) section 16, mapped onto Foolscap's actual risk areas.

## Priority 1 — Auth + workspace membership

- Backend: `auth.middleware.js` rejects missing/invalid/expired tokens; service-layer role checks reject non-members.
- Frontend: `AuthController` state transitions (signed out -> signing in -> signed in -> error).

## Priority 2 — The analysis pipeline (highest real risk in the product)

- Backend: `geminiAnalysis.service.js` tested with a **mocked Gemini client** returning both valid and malformed JSON — the zod re-validation step (section 3 of the deep dive) must reject malformed output, not silently write partial data.
- Integration: simulate the full `register-upload -> queue -> analyze -> ready` path (client-registered upload via a plain endpoint, then a manually-invoked hit of `/internal/process-analysis-queue` standing in for the host's cron) against the Firestore/Storage emulator; assert `status` transitions happen in the right order and `failed` is reachable and carries `failureReason`.
- Do this against **real recorded clips** early, per README's own caution on Roman Urdu/English transcript quality — a passing mocked test does not mean the real transcript is usable.

## Priority 3 — Script versioning and Overlap Alarm

- Backend: version save is append-only (a new `versions/{vid}` is created, never an existing one mutated) — test this invariant directly, it's load-bearing for Human Ink.
- Backend: `overlap.service.js` similarity thresholding — test against known near-duplicate and known-different text pairs to catch false positives before they erode trust in the feature.

## Priority 4 — Pitch public surface

- The one unauthenticated read/write surface in the app — test that `GET /pitches/by-token/:token` never returns data belonging to a different pitch, and that rate limiting actually triggers under burst requests.

## Priority 5 — Navigation flows

- `go_router` redirect logic (signed-out -> `/sign-in`, no-workspace -> `/workspaces/select`) — easy to silently break when routes are added later; cover with a widget test per playbook section 16/21.

## Frontend

- Models: JSON parsing round-trips, including tolerance for missing optional fields (playbook section 10).
- Controllers: tested independent of widgets, with a fake/mocked repository.
- Widget tests: one per critical flow (sign-in, create script, send pitch) — not exhaustive golden tests until UI is stable (playbook section 16).

## Backend

- Validators: reject malformed payloads for every route.
- Controllers: tested with mocked services.
- Repositories: tested against the Firestore emulator, not a live project.
