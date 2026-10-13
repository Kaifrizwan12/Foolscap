`presentation/pitch_list_page.dart` is a placeholder shell only.

`data/` and `domain/` are intentionally empty — Phase 3 in docs/FEATURE_PLAN.md. Note Pitch is the one feature that reads through the backend instead of Firestore directly (docs/TECHNICAL_DEEP_DIVE.md section 5) — don't copy the Library repository pattern here.

There is deliberately no public/no-auth page in this folder. Foolscap is Android/iOS only — the public pitch link a client opens is a server-rendered HTML page served by `backend/src/routes/pitchPage.routes.js`, not a Flutter screen. See docs/ARCHITECTURE.md section 6 and docs/TECHNICAL_DEEP_DIVE.md section 5. Don't add a `/pitch/public/:token` route here.
