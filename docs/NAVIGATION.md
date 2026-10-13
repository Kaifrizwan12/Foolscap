# Navigation

`go_router`, centralized in `frontend/lib/core/routing/`. Route path constants in `route_paths.dart`, router config in `app_router.dart`. No widget hardcodes a path string — see [TECHNICAL_DEEP_DIVE.md](./TECHNICAL_DEEP_DIVE.md) section 1.5 for the router skeleton.

## Route table (v1 scope — grows per [FEATURE_PLAN.md](./FEATURE_PLAN.md))

| Path | Shell tab | Auth required | Notes |
|---|---|---|---|
| `/sign-in` | — | No | redirect target when signed out |
| `/workspaces/select` | — | Yes | shown if user has 0 or >1 workspace and none selected |
| `/library` | Library | Yes | folder/tag/search UI |
| `/library/:referenceId` | Library | Yes | X-Ray detail view |
| `/room/:scriptId` | Room | Yes | Writing Room editor |
| `/pitches` | Pitch | Yes | creator-side pitch list |
| `/pitches/:pitchId` | Pitch | Yes | creator-side pitch detail/comments |
| `/set/:scriptId` | — | Yes | Set Mode, pushed full-screen over the shell, not a tab |
| `/settings` | — | Yes | |

## Shell structure

`StatefulShellRoute.indexedStack` with branches for Library / Room / Pitches, matching the bottom nav (mobile) / side nav (tablet+desktop) per playbook section 5/6. `AppShell` (in `core/widgets/`) owns the breakpoint switch between bottom nav and side nav — pages never check `MediaQuery` for this themselves.

## Guards

- Auth guard: top-level `redirect` in `GoRouter` (section 1.5 of the deep dive).
- Workspace-selected guard: a second `redirect` check once signed in — if `WorkspaceController.currentWorkspaceId == null`, force `/workspaces/select` before anything else loads.

## Not a Flutter route

The Pitch public link (`GET /pitch/:token`) is **not** in this table because it isn't a Flutter screen — Foolscap is Android/iOS only, so a client with no app installed opening that link gets a server-rendered HTML page from the backend instead. See [ARCHITECTURE.md](./ARCHITECTURE.md) section 6 and [FEATURE_PLAN.md](./FEATURE_PLAN.md) Phase 3.1.
