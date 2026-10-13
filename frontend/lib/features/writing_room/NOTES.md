Empty on purpose — this is Phase 2 in docs/FEATURE_PLAN.md (Writing Room core, live timer, Hook Bench, Overlap Alarm). Do not start until Phase 1 (Library) is working end to end, since the Writing Room pins Library references.

When building: `ScriptModel`/`ScriptVersionModel` in `data/`, `WritingRoomController` (screen-scoped, not app-lifetime — see docs/STATE_MANAGEMENT.md) in `domain/`, two-column editor in `presentation/`.
