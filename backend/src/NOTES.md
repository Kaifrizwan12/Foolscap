Phase 0 (`workspaces`, `clients`/Brand Bible) is scaffolded end to end: routes -> controllers -> services -> repositories -> validators.

Everything else is intentionally not started. Add the next vertical slice per docs/FEATURE_PLAN.md phase order, following the exact same five-file pattern (`routes/<name>.routes.js`, `controllers/<name>.controller.js`, `services/<name>.service.js`, `repositories/<name>.repository.js`, `validators/<name>.validators.js`), and mount the new route file in `routes/index.js`:

- `references` — Phase 1. No Storage trigger (this backend is a plain Node server, not Cloud Functions) — instead needs: the client-facing `POST /v1/workspaces/:wid/references` registration endpoint (sets `status: "queued"`), an `/internal/process-analysis-queue` endpoint protected by a shared-secret header (not Firebase auth) meant to be hit periodically by the host's cron/scheduler, and `services/geminiAnalysis.service.js` — the one file in the whole backend allowed to import a Gemini SDK. Read docs/TECHNICAL_DEEP_DIVE.md section 3 before writing this one; it's the most complex flow in the app.
- `scripts` — Phase 2. Version save must also run `services/linter.service.js` (Phase 4) and `services/overlap.service.js` (Phase 2.4) before returning — don't build those as separate deferred endpoints, they ride along with version creation.
- `pitches` — Phase 3. This is the one route group with public, unauthenticated endpoints — see docs/TECHNICAL_DEEP_DIVE.md section 5 and apply `middleware/rateLimit.middleware.js`. Two surfaces, not one: the JSON API (`routes/pitches.routes.js`, mounted under `/v1`) and the server-rendered public HTML page (`routes/pitchPage.routes.js`, already scaffolded, mounted at root in `app.js`, currently a 501 stub) — Foolscap is Android/iOS only, so the HTML page is how a client with no app installed opens a pitch link. Wire both to a shared `services/pitches.service.js`.
- `takes` — Phase 6.2.
- `scripts/:sid/human-ink` — Phase 6.5, needs a PDF-generation dependency (e.g. `pdfkit`) not yet in package.json.

Add the corresponding row to docs/API_CONTRACTS.md in the same change that adds a route.
