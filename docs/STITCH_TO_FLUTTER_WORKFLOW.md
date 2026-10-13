# Stitch -> Flutter Workflow

The design brief itself — the aesthetic system and every screen, phase by phase, future-labeled screens included — lives in [STITCH_UI_PROMPT.md](./STITCH_UI_PROMPT.md). This doc only covers what happens *after* Stitch generates something from that prompt: how its output gets turned into real code in this repo, so the process is consistent across every feature instead of improvised each time.

## Process

1. **Stitch produces UI** (screens/components) for one feature at a time, matching the phase order in [FEATURE_PLAN.md](./FEATURE_PLAN.md) — don't jump ahead to Phase 4 UI while Phase 1 is still unbuilt.
2. **Translate, don't transliterate.** Stitch output defines visuals and layout; it does not define the widget tree 1:1. Map it onto the existing structure:
   - New screen -> `frontend/lib/features/<feature>/presentation/<name>_page.dart`.
   - Reusable pieces shared across features (buttons, cards, empty states) -> `frontend/lib/core/widgets/`, not duplicated per feature.
   - Colors/type/spacing from the Stitch design get reconciled into `frontend/lib/core/theme/` tokens — never hardcoded inline in a page even if that's how the design tool exports it.
3. **Wire state after structure, not during.** Build the static widget tree first against placeholder data, then connect it to the feature's controller (per [STATE_MANAGEMENT.md](./STATE_MANAGEMENT.md)) in a second pass — keeps visual review and logic review separable.
4. **Responsive pass.** Stitch typically designs one breakpoint; apply the mobile/tablet/desktop rules in [FLUTTER_FULL_STACK_PLAYBOOK.md](../FLUTTER_FULL_STACK_PLAYBOOK.md) section 6 explicitly — don't assume the design tool's single layout is responsive by default.
5. **States pass.** Add loading/empty/error states even if Stitch only designed the "happy path" screen — this is a hard requirement (playbook section 4/21), not optional polish.

## What to hand back when asking for a feature's code

When the user provides the Stitch prompt/output for a feature, the most useful accompanying context is:
- which Phase/feature section of [FEATURE_PLAN.md](./FEATURE_PLAN.md) it maps to,
- which controller/repository it should bind to (already defined per feature in the plan),
- any screens it replaces vs. adds net-new.

This doc will get filled in with concrete before/after examples once the first real Stitch output arrives — intentionally left general until then.
