# Environments

## Firebase projects

Three separate Firebase projects (not one project with Firestore prefixes — full isolation avoids a dev bug touching prod data), all on the free **Spark** plan — Auth/Firestore/Storage all run on Spark; nothing in this architecture needs Blaze, because there's no Cloud Functions (see [ASSUMPTIONS_AND_DECISIONS.md](./ASSUMPTIONS_AND_DECISIONS.md)):

- `foolscap-dev`
- `foolscap-staging`
- `foolscap-prod`

Use `firebase use <alias>` + `.firebaserc` to switch; never hand-edit which project a deploy targets. `firebase deploy` in this project only ever pushes Firestore/Storage rules and indexes (`firebase.json` has no `functions` block) — the backend is deployed separately, directly to its Node host.

## Flutter

- `flutterfire configure` run once per environment, producing `lib/firebase_options_dev.dart` / `_staging.dart` / `_prod.dart` (or use flavors). Select at build time via `--dart-define=ENVIRONMENT=dev|staging|prod`, read in `core/constants/env.dart`.
- `Env.apiBaseUrl` resolves to the matching backend deployment's URL per environment (whatever your Node host assigns it — a Render/Railway/Fly/Vercel URL, or a custom domain pointed at one).

## Backend

Plain Node.js/Express — no Cloud Functions, no `firebase deploy` involvement. Deploy it to any Node-capable host (Render, Railway, Fly.io, Vercel's Node runtime, a VPS — pick whichever free tier is easiest, ideally one that also offers a free scheduled-job/cron feature, since the reference-analysis queue needs periodic invocation, see [TECHNICAL_DEEP_DIVE.md](./TECHNICAL_DEEP_DIVE.md) section 3).

- `backend/.env.example`:
  ```
  PORT=8080
  ALLOWED_ORIGINS=
  FIREBASE_SERVICE_ACCOUNT_BASE64=
  FIREBASE_STORAGE_BUCKET=
  GEMINI_API_KEY=
  ```
- Real secrets go through the host's own env var UI / secret manager (Render/Railway/Vercel all have one) — never into a committed `.env`. `FIREBASE_SERVICE_ACCOUNT_BASE64` is required because a plain Node host has no ambient GCP identity the way Cloud Functions would — see `backend/src/config/firebaseAdmin.js`. Download the service account JSON from Firebase Console > Project Settings > Service Accounts, base64-encode it, and paste the result into the host's secret manager.
- A separate service account (and separate env var values) per environment, matching the three Firebase projects above.

## Budget alerts

Even on Spark, Firestore/Storage have free-tier quotas — set a budget/usage alert where the host allows it (Firebase itself doesn't bill on Spark, but watch quota dashboards) **before** doing any real-volume video analysis testing, not after. If the backend host has its own usage-based free tier limits (most do), watch those too.

## Build verification

Foolscap ships **Android and iOS only** — no Flutter Web, no desktop (see [ASSUMPTIONS_AND_DECISIONS.md](./ASSUMPTIONS_AND_DECISIONS.md)). Before any release, verify per playbook section 17: Android build, iOS build. Skip the web-build step entirely; it doesn't apply here.

The Pitch feature's public link does *not* need a Flutter web build — it's served by the backend as a plain HTML page (`GET /pitch/:token`), verified as part of a normal backend deploy, not a Flutter release. See [ARCHITECTURE.md](./ARCHITECTURE.md) section 6.
