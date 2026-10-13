# State Management Conventions

Follows [FLUTTER_FULL_STACK_PLAYBOOK.md](../FLUTTER_FULL_STACK_PLAYBOOK.md) section 4. Foolscap-specific additions below.

## Default: `Provider` + `ChangeNotifier`

Stays the default for the whole v1 build. Revisit `GetX` only if/when controller boilerplate genuinely becomes the bottleneck — not preemptively (playbook section 9's package-selection rule: smallest package that solves the problem).

## Controller scoping rule

- **App-lifetime controllers** (`AuthController`, `WorkspaceController`): provided once in `app/bootstrap.dart`, injected at the root `MultiProvider`.
- **Screen-lifetime controllers** (`LibraryController`, `WritingRoomController` for one specific script, `PitchController` for one pitch): constructed at the route/page level, scoped to that page's lifetime, disposed when the page is popped. Never hoist a screen-scoped controller to app-lifetime "just in case" — that's how stale state and memory leaks creep in.

## One source of truth per feature

- `references/{rid}` state lives only in `LibraryController` (via `ReferencesRepository`'s Firestore stream). The Writing Room reads pinned references through the same repository, not a duplicate cache — two controllers may both depend on `ReferencesRepository`, but neither owns a second copy of the data.

## Async state shape

Every controller exposes the same three-value shape for any network-driven data: `isLoading`, `error` (typed `AppException?`), and the data itself (immutable list/object). Widgets render exactly one of: loading view, error view (with retry), empty view, or populated view — never a partial/ambiguous state.

## Mutation rule

- Controllers expose intent methods (`addTag(id, tag)`, `saveVersion(rows)`), never raw setters on their state lists.
- Lists exposed to widgets are always `List.unmodifiable(...)` — a widget cannot `references.add(...)` directly even by accident.

## Firestore streams vs backend polling

- Prefer a Firestore `snapshots()` stream wherever the client reads Firestore directly (Library, Writing Room, Workspaces) — this is what gives the "status flips from analyzing to ready with zero manual refresh" behavior in [TECHNICAL_DEEP_DIVE.md](./TECHNICAL_DEEP_DIVE.md) section 3.
- Only Pitch's public view uses a one-shot backend fetch, because it has no Firestore access at all (no Firebase Auth identity).
