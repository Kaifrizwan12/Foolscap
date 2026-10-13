# Foolscap Docs Index

This folder is the technical brain of the repo. Read in this order the first time:

1. [ARCHITECTURE.md](./ARCHITECTURE.md) — system shape, the AI firewall, repo layout, deployment topology.
2. [FEATURE_PLAN.md](./FEATURE_PLAN.md) — every feature, in build order, with APIs/feasibility/requirements per feature.
3. [TECHNICAL_DEEP_DIVE.md](./TECHNICAL_DEEP_DIVE.md) — every component, every data flow, exactly how the code is structured and why, end to end.
4. [FIRESTORE_SCHEMA.md](./FIRESTORE_SCHEMA.md) — full data model, field by field, indexes, security rule shape.
5. [API_CONTRACTS.md](./API_CONTRACTS.md) — endpoint-by-endpoint contract for backend <-> frontend.
6. [STATE_MANAGEMENT.md](./STATE_MANAGEMENT.md) — controller/notifier conventions for the Flutter app.
7. [NAVIGATION.md](./NAVIGATION.md) — route table and shell structure.
8. [SECURITY_PRACTICES.md](./SECURITY_PRACTICES.md) — auth, validation, secrets, rules.
9. [ENVIRONMENTS.md](./ENVIRONMENTS.md) — dev/staging/prod, env vars, secrets setup.
10. [TESTING_STRATEGY.md](./TESTING_STRATEGY.md) — what gets tested, in what order.
11. [STITCH_UI_PROMPT.md](./STITCH_UI_PROMPT.md) — the master, screen-by-screen design brief for Google Stitch: the "Foolscap Manuscript" aesthetic system and every screen in the app, future-labeled ones included.
12. [STITCH_TO_FLUTTER_WORKFLOW.md](./STITCH_TO_FLUTTER_WORKFLOW.md) — how Stitch's output gets turned into real Flutter widgets once it's generated.
13. [ASSUMPTIONS_AND_DECISIONS.md](./ASSUMPTIONS_AND_DECISIONS.md) — every call made without asking, and why, so it's easy to overturn later.

Also load [FLUTTER_FULL_STACK_PLAYBOOK.md](../FLUTTER_FULL_STACK_PLAYBOOK.md) at the repo root — it's the general engineering rulebook (state management, navigation, theming, performance, testing bar) this project follows unless a doc here says otherwise for a Foolscap-specific reason.

## Repo layout

```text
Foolscap/
  frontend/     Flutter app (the pocket)
  backend/      Plain Node.js/Express server, deployed to a free Node host (the brain)
  docs/         you are here
  firebase.json, firestore.rules, firestore.indexes.json, storage.rules
```
