# Security Practices

## Secrets

- Gemini API key: set as an env var in the backend host's own secret manager (Render/Railway/Vercel/etc.), read only in `backend/src/config/gemini.js`. Never in `.env` committed to git, never in the Flutter app.
- Firebase service account: the backend runs on a plain Node host with no ambient GCP identity, so `FIREBASE_SERVICE_ACCOUNT_BASE64` (the service account JSON, base64-encoded) must also live in the host's secret manager — see `backend/src/config/firebaseAdmin.js` and [ENVIRONMENTS.md](./ENVIRONMENTS.md). This is a materially bigger secret to protect than a single API key; treat it with the same care.
- `/internal/*` endpoints (the analysis-queue processor, see [TECHNICAL_DEEP_DIVE.md](./TECHNICAL_DEEP_DIVE.md) section 3) are protected by a shared-secret header, not Firebase auth — that secret also lives only in the host's secret manager and in whatever scheduler is configured to call it.
- `.env.example` at `backend/.env.example` lists every variable name with a placeholder value, never a real one.
- Service account JSON files are never committed — `.gitignore` covers `*serviceAccountKey*.json`, `*firebase-adminsdk*.json`.

## Auth

- Every non-public route requires a verified Firebase ID token (`middleware/auth.middleware.js`).
- The two public routes (`GET /pitches/by-token/:token`, `POST /pitches/by-token/:token/comments`) are rate-limited (`express-rate-limit`) and scoped to exactly one pitch — never a general query endpoint.
- Role checks (owner/editor/viewer) happen server-side in the service layer, never trusted from a client-sent role field.

## Validation

- Every route validates `body`/`params`/`query` with a zod schema before the controller runs (`middleware/validate.middleware.js`). Reject first, process never.
- Server-stamped fields (`authorUid`, `createdAt`, `status`, `analysis`) are never accepted from client input even if present in the request body — explicitly strip/ignore them server-side, don't just "trust the schema omits them."

## Firestore security rules

- Rules mirror the write-ownership table in [TECHNICAL_DEEP_DIVE.md](./TECHNICAL_DEEP_DIVE.md) section 4: machine-authored fields have no client-write rule at all.
- Every rule checks workspace membership via `request.auth.uid in get(/databases/$(database)/documents/workspaces/$(wid)).data.memberUids` (or a cached custom claim if membership checks become a cost/latency issue — not needed at current scale).
- Add the rule in the **same PR** that adds the collection. No collection ships without a rule.

## Storage rules

- Upload paths are scoped to `workspaces/{wid}/references/{rid}/...` and writable only by authenticated members of that workspace.
- Max file size enforced both in Storage rules and as a Flutter-side pre-upload check (fail fast, don't waste the user's upload bandwidth).

## Logging

- Structured JSON logs (`backend/src/utils/logger.js`), always includes request ID, route, status, timing.
- Never log: tokens, Gemini API key, raw video bytes, full transcript text at `info` level (transcript content is user-sensitive brand material — log existence/length, not content).

## Rate limiting

- Auth-adjacent and public-write endpoints (`by-token/:token/comments`, invite accept) are rate-limited per IP.
- Consider per-workspace rate limiting on the Gemini analysis queue later if abuse/cost becomes a concern — not needed for v1 scale.

## The AI firewall, restated as a checklist

- [ ] Gemini SDK import exists in exactly one backend file.
- [ ] No Flutter dependency on any Gemini package.
- [ ] Every Gemini call passes a `responseSchema`.
- [ ] The response is re-validated against the same schema server-side before being written to Firestore.
- [ ] `writing_room` feature code has zero imports touching Gemini-origin generation paths (reading `analysis`/`transcript` for display is fine; generating text is not).
