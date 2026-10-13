# Foolscap — Master Stitch UI Prompt

This is a ready-to-paste design brief for Google Stitch, covering every screen of the Foolscap mobile app (Android + iOS Flutter — **no web, no desktop, no tablet-only screens**, though phone-first layouts should flex cleanly up to tablet width). It is long on purpose — the point is that nothing gets designed from a generic SaaS template by default. If you're pasting this into Stitch in chunks, paste **Part 1 (the system)** first, every time, before any individual screen in Part 3 — the screens only make sense against that system.

Screens that are **not buildable yet** (deferred past v1, or legally gated, or blocked on native engineering) are explicitly marked **[FUTURE UI SCREEN]**. Design them with full fidelity anyway — a real screen, not a greyed-out teaser — they're just not getting built into the app yet. One surface is intentionally **excluded** entirely: the public Pitch link a client opens to review a script, which is a plain server-rendered web page viewed in a browser, not a Flutter screen, because the person opening it may never have the app installed — don't design it as part of this app.

---

## Part 1 — The system (read this before any screen)

### 1.1 What this app is, in one paragraph (for context, not for UI copy)

Foolscap is where people who write short-form video scripts for a living hoard reference footage, dissect why it worked, and write their own script by hand next to it — with a hard rule that AI never writes a word of the script itself. It reads; the human writes. Every screen should feel like the app respects that the user is a professional writer at a desk, not a consumer scrolling a feed. The tone is dry, confident, a little self-aware — never chirpy, never "AI magic ✨," never apologetic.

### 1.2 The aesthetic direction: "Foolscap Manuscript" — unorthodox structure, sober surface

Two words that sound like they fight each other, resolved like this: the **palette, type weight, and motion are restrained** almost to the point of austerity (sober) — but the **structural choices, metaphors, and signature components are not what any other app does** (unorthodox). Nothing here should look like a Material 3 default, a Notion clone, or a glossy SaaS dashboard. It should look like a well-kept paper archive crossed with an editor's proofing desk. Concretely:

- **No gradients. No glassmorphism. No neon. No drop-shadow-everything. No bouncy/springy motion. No shimmer skeleton loaders.** These are the "sober" guardrails — if a design decision needs any of these to look finished, it's the wrong decision.
- **Everything is built from paper and ink metaphors, taken completely literally, not as a cute icon pack.** A saved reference doesn't get a bookmark icon — it gets a **dog-eared corner fold**. An approval doesn't get a green checkmark — it gets a **wax-seal stamp** that presses into place. A flagged line of dialogue doesn't get a red underline — it gets an actual **proofreader's redline strikethrough** with a margin note, like a real edited manuscript. This is the unorthodox half: the metaphor is load-bearing, not decorative.
- **Asymmetry is intentional, not sloppy.** Real typeset pages have uneven margins, a gutter, a slightly-off-center running head. Use that: the Writing Room's two columns are not a 50/50 split; settings sections don't all indent the same amount; the bottom nav bar sits slightly inset from the screen edge like a page trimmed by a guillotine cutter, not flush like every other app's nav bar.
- **Confidence over friendliness.** No mascots, no "Woohoo!" empty-state illustrations, no excessive rounding. Corners are mostly sharp or very slightly rounded (2–4px), never pill-shaped buttons as the default (reserve true pill shapes for the one place they're load-bearing: stamp-style status chips).

### 1.3 Color system

Two tokens change meaning between light and dark mode; the rest hold steady. Both modes must be fully, separately designed — dark mode is "the night desk," not an inverted filter.

| Token | Light mode | Dark mode | Use |
|---|---|---|---|
| Ink | `#1A1A1A` (warm near-black, not pure black) | `#F2EEE4` (warm bone white) | Primary text, primary icons, the two-column editor's handwriting |
| Paper | `#FBF8F1` (warm off-white, faint grain texture) | `#15130F` (deep warm charcoal, "midnight ink," faint grain texture) | Backgrounds — always textured, never a flat hex fill. Use a very subtle paper-fiber/noise texture at ~3% opacity, visible only on close inspection |
| Jester Red | `#FF3B6B` | `#FF4D76` (slightly brighter for dark-mode contrast) | The ONE loud color. Primary actions, the record/capture affordance, the brand mark. Used sparingly — if more than ~5% of a screen is this color, pull it back |
| Seal Gold | `#B8860B` muted brass | `#D4A62B` brighter brass | Approvals, wax-seal stamps, "locked/final" states, premium/workspace-owner cues |
| Sage | `#5B7A5E` muted, desaturated | `#7FA083` | Success, "ready" status, positive X-Ray outlier scores |
| Clay | `#B5553A` muted warm rust — NOT the Jester Red | `#D97158` | Warnings, errors, linter flags. Deliberately distinct from Jester Red so the one bright brand color never gets diluted into every error toast |
| Graphite | `#6B6559` | `#8A8475` | Secondary text, dividers, placeholder text, disabled states |

Do not introduce a sixth accent color anywhere. If a screen seems to need one, it's being over-decorated — fall back to Graphite + weight/size changes instead.

### 1.4 Typography

Three families, each doing one job, contrast between them is part of the "unorthodox" structure:

- **Display/headline family**: a confident serif with some personality (visual feel of Fraunces, Source Serif, or similar — not a generic grotesk). Used for page titles, the brand wordmark, and the Hook Bench's hook text (hooks deserve to look like headlines, because that's what they are).
- **Body/UI family**: a clean, highly legible humanist sans (visual feel of Inter or General Sans). Used for everything else — buttons, labels, body copy, form fields.
- **Numeric/readout family**: a monospace typewriter face (visual feel of JetBrains Mono or Space Mono). Used ONLY for: the live speaking-pace timer, X-Ray stat numbers (cuts/min, words/min, outlier score), word counts, take numbers, and the revision counter. This is a signature move — numbers should look like they came off a teleprinter, distinct from everything else on screen, so the eye learns "monospace = a measurement, not prose."

Type scale: Display 32/28/24 (headline/title/subtitle), Body 16/14/13 (body/secondary/caption), all at a 1.4 line-height minimum for body text — this is a reading-and-writing app, legibility beats density every time there's a conflict.

### 1.5 Signature components (define these once, reuse everywhere)

- **The Dog-Ear Fold** — the universal "save/pin/favorite" affordance. A literal folded-corner triangle at the top-right of a card, Paper-colored with a hairline Ink border and a tiny drop-shadow sliver underneath the fold itself (the only place a shadow is allowed in the whole system, because it's structurally true — a folded paper corner casts a shadow). Tap to fold/unfold. Used on reference cards (Library), script cards, and pinned-reference chips in the Writing Room.
- **The Wax Seal** — the approval/locked indicator. A circular stamp, Seal Gold, with a subtle emboss (inner shadow only, no outer glow), a single-letter or small glyph in the center (e.g., "F" in the display serif, or a tiny bell glyph). Appears animated as a quick press-and-settle (120ms scale from 1.15→1.0, no bounce/overshoot) the moment a pitch is approved or a Human Ink export completes. Never used for anything reversible — if the action can be undone, it's not sealed.
- **Redline Annotation** — the linter/Overlap-Alarm flag. The offending text gets a hand-drawn-style strikethrough (slightly irregular, not a perfectly straight line) in Clay, with a small margin note to the right or below in the same Clay color, in the body font at caption size, prefixed with a small pencil-nib glyph. Never a toast, never a modal interrupting typing — it sits in the margin like a real editor's mark and can be dismissed with a tap.
- **Rubber Stamp Status Chip** — every status enum (`queued`/`analyzing`/`ready`/`failed`, `draft`/`approved`/`posted`, etc.) renders as a chip styled like a hand-inked rubber stamp: slightly rotated (-2° to 2°, randomized per-instance so they don't look templated), a faint ink-texture fill, a thin irregular border (not a clean rounded-rect), set in the display serif, uppercase, letter-spaced. Color maps to status family: Graphite (neutral/in-progress), Sage (ready/approved/good), Clay (failed/bad), Seal Gold (posted/final).
- **Folder Tab** — Library's folder chips render like manila folder tabs: a small trapezoid notch at the top of a rounded-top rectangle, not a plain Material chip.
- **The Bell Mark** — the brand's loading/processing indicator and the app's icon motif: a minimal single-line-drawn jester's bell silhouette. (The app is named after foolscap, an old paper size said to be watermarked with a jester's cap — the bell is that cap's one surviving detail, shrunk down into a mark.) Used as the loading spinner (the bell gently tips side to side, no spin, ~600ms ease-in-out, repeating — a "ting" motion, not a generic circular spinner) and as the splash screen mark.
- **Pencil-Sketch Placeholder** — the loading-state treatment everywhere a shimmer skeleton would normally go: a very light (8% opacity) Ink sketch-line outline of the eventual content's shape (a rectangle with a diagonal corner-mark, like a layout placeholder a designer would hand-sketch), static, not animated. No shimmer, ever.

### 1.6 Layout and platform rules

- Phone is the primary target; layouts must also look intentional (not just "stretched") up to a 7–8" tablet in both orientations — widen margins and allow a secondary column (e.g., pinned-reference rail) to reveal itself at tablet width rather than stretching single-column content edge to edge.
- Outer screen margins are generous and asymmetric-leaning: treat the screen like a printed page with a slightly wider outer margin than inner gutter, not a symmetric 16px-everywhere grid.
- Bottom tab bar (phone) sits inset from the bottom edge with visible Paper margin around it, like a trimmed card, not flush full-bleed. On tablet, it becomes a left side rail, same inset treatment.
- Every screen that loads network/Firestore data must be designed in all four states: **loading** (Pencil-Sketch Placeholder), **empty** (a dry, specific, brand-voiced one-liner — never "No data found," always something like the examples given per-screen below), **error** (Clay-toned, with a retry action styled as a plain text button, not a red banner), **populated**. Design all four for every data screen below, not just the happy path.
- Dark mode is not optional polish — design it alongside light mode for every screen, using the token table in 1.3.

### 1.7 Voice and copy tone (for every string Stitch generates)

Dry, specific, a little wry, never exclamation-mark-happy. Examples of the register to hit:
- Empty Library: *"Nothing saved yet. That reel you lost three weeks ago is still out there somewhere."*
- Empty Pitches: *"No pitches sent. The client isn't reading your mind yet."*
- Upload in progress: *"Keeping the receipt."*
- Script Graveyard: *"Dead ideas, on file. Resurrect anytime."*
- Approval locked: *"Approved. The version is locked — this is the one that gets filmed."*

Never: "Oops!", "Let's get started!", "You're all caught up! 🎉", any emoji in UI copy at all (the brand mark is the only "icon" allowed to carry personality).

---

## Part 2 — Full screen inventory (quick reference)

| # | Screen | Phase | Status |
|---|---|---|---|
| A1 | Splash | 0 | v1 |
| A2 | Sign in | 0 | v1 |
| A3 | Sign up | 0 | v1 |
| A4 | Password reset | 0 | v1 |
| A5 | First-run intro (3-card swipe) | 0 | v1 |
| A6 | Create workspace | 0 | v1 |
| A7 | Join workspace via invite | 0 | v1 |
| A8 | Workspace switcher | 0 | v1 |
| B1 | Bottom tab shell (phone) | 0 | v1 |
| B2 | Side rail shell (tablet) | 0 | v1 |
| B3 | Settings home | 0 | v1 |
| B4 | Settings — speaking pace | 2 | v1 |
| B5 | Settings — profile/account | 0 | v1 |
| B6 | Settings — workspace & members | 0 | v1 |
| B7 | Settings — appearance | 0 | v1 |
| C1 | Client (Brand Bible) list | 0 | v1 |
| C2 | Brand Bible editor | 0/4 | v1 |
| C3 | Pillar heatmap dashboard | 4 | v1 |
| D1 | Library home | 1 | v1 |
| D2 | Share-intake sheet | 1 | v1 |
| D3 | Reference detail / X-Ray | 1 | v1 |
| D4 | Folder manager | 1 | v1 |
| D5 | Search results | 1 | v1 |
| D6 | One-tap record capture screen | 1 | **FUTURE UI SCREEN** |
| E1 | Scripts list | 2 | v1 |
| E2 | Writing Room | 2 | v1 |
| E3 | Hook Bench | 2 | v1 |
| E4 | Expression Vault — grid | 2 | v1 |
| E5 | Expression Vault — clip trimmer | 2 | v1 |
| F1 | Compose pitch | 3 | v1 |
| F2 | Pitches list | 3 | v1 |
| F3 | Pitch detail (creator) | 3 | v1 |
| G1 | Set Mode (teleprompter) | 6 | v1 |
| G2 | Take log overlay | 6 | v1 |
| G3 | Script Graveyard | 6 | v1 |
| G4 | Results / retro entry | 6 | v1 |
| G5 | Human Ink export | 6 | v1 |
| H1 | Research Radar dashboard | 5 | **FUTURE UI SCREEN** |
| H2 | Format Arbitrage Board | 5b | **FUTURE UI SCREEN** |

Excluded from this Flutter prompt entirely: the public Pitch review page a client opens in a plain browser (it's a server-rendered web page, not a Flutter screen).

---

## Part 3 — Per-screen specs

Each entry: purpose, layout, key components, states, interactions, and the specific "unorthodox but sober" treatment for that screen. Apply Part 1's system to everything below even where not restated.

### A1 — Splash

Purpose: brief brand moment on cold start while Firebase/auth state resolves.
Layout: full-bleed Paper background with grain texture, The Bell Mark centered, doing its tip-side-to-side idle animation, wordmark "Foolscap" in display serif below it, small tagline in body font: "The machine reads. You write." Nothing else — no progress bar (the bell's motion IS the loading indicator).

### A2 — Sign in

Purpose: email/password + (optionally) a secondary provider, entry to the app.
Layout: single column, generous top margin (like a page's top margin), wordmark small at top, headline "Sign in" in display serif, two form fields (email, password) styled as underlined fields (a single Ink hairline under each, not boxed/outlined Material fields — this is the "unorthodox" structural choice: forms look like filling in blanks on a form, not filling boxes), primary action button bottom-anchored, full-width, Jester Red fill, Ink text, sharp corners (2px radius).
States: default; submitting (button shows the Bell Mark tipping in place of label text, button disabled); error (Redline Annotation-style message appears directly under the password field, not a banner).
Interactions: standard; "Create an account" as a plain text link below the button, not a second button.

### A3 — Sign up

Same structural system as A2, headline "Sign up," add a third field for display name. Same states.

### A4 — Password reset

Single field (email), one action, confirmation state shows as a full-screen takeover of the Bell Mark plus the line "Check your email. We sent the way back in."

### A5 — First-run intro (3-card swipe)

Purpose: one-time orientation for a brand-new account, shown once before workspace creation.
Layout: three full-screen swipeable cards, each a large illustrative mark (not photography — simple single-line-drawn icons in the same style family as The Bell Mark: a dog-ear fold, a wax seal, a torn paper edge) with a headline and one short line of brand-voiced copy per card:
1. "Hoard like a lunatic." / dog-ear icon / "Save the reel before the creator deletes it."
2. "Write it yourself." / wax seal icon / "AI reads. You write. Every time."
3. "Know why it worked." / a simple beat-timeline icon / "Then do it differently."
Dot indicator styled as small ink dots, not Material dots. Final card's button says "Get started," not "Finish" or "Done."

### A6 — Create workspace

Single field (workspace name), one action. Treat this like signing the first page of a new notebook — headline: "Name the workspace." Helper text below field: "You can invite people once it exists."

### A7 — Join workspace via invite

Reached via deep link. Shows the destination workspace name (resolved before showing the screen) in display serif, large, with "You've been invited to join" above it in body/graphite, one button: "Join."

### A8 — Workspace switcher

Purpose: shown when a user belongs to 2+ workspaces, or via Settings.
Layout: a simple list, each row styled like a tabbed folder spine (reuse the Folder Tab motif rotated 90°, or simplified to a left-edge colored tab per workspace) — workspace name in display serif, member count in graphite caption below. Current workspace marked with a small Wax Seal glyph (scaled down) instead of a checkmark. "Create new workspace" as the final list row, styled identically but in Graphite/dashed border to read as "add new."

### B1 — Bottom tab shell (phone)

Three tabs: Library, Room, Pitches. Per Part 1.6: inset from screen edge, visible Paper margin on all sides, not full-bleed. Icons are the custom line-icon set (not Material icons) — a dog-ear for Library, a nib/pencil for Room, a paper-plane-but-drawn-as-a-folded-letter for Pitches. Active tab: Jester Red icon + label, label in caption size, display serif, small; inactive: Graphite, icon only (labels on inactive tabs can hide on very small screens — icon + active label is enough).

### B2 — Side rail shell (tablet)

Same three destinations, vertical rail, same inset-margin treatment, icons stacked above labels, slightly wider than a typical Material nav rail to accommodate the display-serif labels without truncation.

### B3 — Settings home

Simple grouped list: Profile, Workspace & Members, Appearance, Speaking Pace, Sign out (styled distinctly — Clay-toned text, bottom of the list, separated by extra whitespace, not just another row).

### B4 — Settings: speaking pace

Purpose: sets the WPM used by the Writing Room's live timer (Phase 2.2).
Layout: one large numeric readout in the monospace readout font (e.g., "148 wpm") with a horizontal slider styled as a plain ink line with a small dot handle (not a Material slider track/thumb), a "Test it" micro-interaction optional (read a sample line aloud via a stopwatch tap — nice-to-have, not required).

### B5 — Settings: profile/account

Display name, email (read-only), avatar (simple initials-in-a-stamp-circle if no photo, using the Wax Seal shape but in Graphite, not Gold — reserve Gold exclusively for approvals).

### B6 — Settings: workspace & members

List of members with role (owner/editor/viewer) shown as a small text label, not a colored badge (roles aren't a "status," don't borrow the stamp-chip motif here). "Invite" button generates/share-sheets the invite link (native OS share sheet).

### B7 — Settings: appearance

Light / Dark / System, as three large tappable swatches showing an actual miniature preview of the Paper/Ink combination for that mode, not just radio buttons with text labels.

### C1 — Client (Brand Bible) list

Purpose: a workspace can run multiple brands/clients; pick or create one.
Layout: list of client cards, each showing brand name in display serif, a small row of their `brandColors` swatches (tiny filled circles, actual brand colors, not Foolscap's palette), platform icons for which platforms they're active on. Dog-Ear Fold in top-right of each card (acts as "pin to top of list" here, consistent reuse of the motif). "+ New client" as the final card, dashed border.

### C2 — Brand Bible editor

Purpose: the densest screen in the app — the single "Brand Bible" document every other feature reads from (voice, legal/language rules, audience, products, content pillars, competitors — one document per client/brand a workspace manages). Must not feel like a 40-field form.
Layout: a vertically scrolling document with seven clearly bannered sections, each section header styled like a manuscript chapter heading (display serif, a thin horizontal rule below it, a small section number in the monospace font to its left, e.g. "01"). Sections, in order, each collapsed-by-default except the first visit:
1. **Identity** — name, industry, logo upload, brand color swatches (editable chips with a color-picker), platform multi-select as small platform-icon toggle chips.
2. **Voice & Tone** — `voiceAdjectives` as removable tag chips (styled like small torn-paper tags, not Material chips), `toneNotes` as a large multi-line text area styled like ruled notebook paper (faint horizontal baseline rules in the background), `voiceDoExamples`/`voiceDontExamples` as two side-by-side columns headed "✓ Sounds like us" / "✗ Doesn't," each a simple add-a-line list, `formality` as a three-position segmented control (Casual / Neutral / Formal) styled as plain text options with an ink underline marking the selected one, not a filled Material segment.
3. **Language Rules** — `bannedWords` as removable tag chips in Clay; `preferredTerms` as a two-column mini-table (banned → preferred) with a small arrow glyph between columns; `requiredDisclaimers` as a list of expandable rows (text + a placement selector shown as three small icon toggles: speech bubble/caption, eye/on-screen, mic/voiceover); `approvedClaims` as a list styled like index cards (the "claims library" should visually read as a small reference deck within the document — slightly offset stacked-card visual for the section icon); `competitorMentionPolicy` as the same three-position segmented control pattern as `formality`; `legalReviewRequired` as a simple toggle with a small Seal Gold indicator when on.
4. **Audience** — `personas` as a horizontally swipeable row of persona cards (label, age range, pain points as a short bullet list, primary platform icon).
5. **Product/Model Specs** — `products` as a simple repeatable list (name, key features as chips, price/availability notes), with `modelSpecs` free-text overflow field tucked at the bottom labeled "Anything else" in graphite, clearly secondary to the structured list above it.
6. **Content Pillars** — `pillars` as colored chip cards (each pillar's `color`), showing label, description, and `targetFrequency` as a small monospace readout (e.g., "2x/wk").
7. **Competitors** — simple repeatable list: name, handle, platform icon.
A fixed-position small readout in the top-right corner of the whole screen shows the current `brandBibleVersion` in the monospace font (e.g., "v7") — a quiet, constant reminder that this document has history.
States: saving shows a brief Wax Seal micro-stamp animation in place of a save button confirmation, not a snackbar.

### C3 — Pillar heatmap dashboard

Purpose: actual-vs-target cadence per content pillar (Phase 4.2).
Layout: NOT a generic bar chart. Render each pillar as a horizontal "ledger row": pillar label in its chip color, a row of small filled/unfilled ink-dot marks representing posts this period versus `targetFrequency` (literally like checking off tally marks on a paper ledger), a trailing monospace count ("6/8"). Time-range selector as plain text tabs (This week / This month) above the ledger, not a dropdown.

### D1 — Library home

Purpose: the whole reason the app exists — browse saved references.
Layout: top search bar styled as an underlined field (not a boxed Material search bar), a horizontally scrolling row of Folder Tabs below it (including "All"), a grid/list toggle (two small icon buttons, top-right), main content as a grid of reference cards. Each card: thumbnail (16:9), Dog-Ear Fold top-right, Rubber Stamp status chip bottom-left showing `status` (queued/analyzing/ready/failed), source-platform tiny icon bottom-right, caption/title truncated below thumbnail in body font.
States: loading → Pencil-Sketch Placeholder grid; empty → the specific copy from 1.7; error → inline Clay message + retry text button; populated → grid as described. A floating action affordance (bottom-right, NOT a circular FAB — styled as a small torn-paper tab that peeks up from the bottom edge, tap to reveal "Share a reel in" instructions and the D6 future-record entry point) replaces the generic FAB pattern entirely.

### D2 — Share-intake sheet

Purpose: appears after a user shares a video into Foolscap from the OS share sheet.
Layout: bottom sheet, torn-paper-edge top border (a literal jagged-edge graphic where the sheet meets the screen above it, reinforcing "a new page just got torn off and handed to you"), video thumbnail preview, workspace/client picker (defaults to last-used), optional tag input, folder picker, one primary action "Add to Library." Upload progress shown as a slim ink-fill progress bar directly under the thumbnail (fills left-to-right like ink soaking into paper, not a Material linear progress bar), with the copy "Keeping the receipt." beneath it per 1.7.

### D3 — Reference detail / X-Ray

Purpose: the analysis view for one saved reference — the product's core "know why it worked" moment.
Layout: video player pinned at top (controls minimal, Ink-on-Paper, not a dark Material player skin). Below it, a horizontal tab strip styled as manuscript chapter tabs (not Material TabBar underline): **Transcript / On-Screen Text / X-Ray**.
- Transcript tab: timestamped lines, monospace timestamp + body-font text, current playback position highlighted with a thin Jester Red left-border marker (like a margin flag on the exact line playing).
- On-Screen Text tab: same timestamped-list pattern.
- X-Ray tab: this is the signature analytical screen — render it as an annotated manuscript page, not a dashboard. A horizontal beat-timeline strip across the top (hook/cuts/pauses marked as literal tick marks along a ruled line, like marking up a filmstrip by hand), below it a set of stat readouts in the monospace font arranged as a short "ledger" (Hook type: [enum, as a Rubber Stamp chip] / Hook duration: 1.8s / Cuts/min: 14 / Words/min: 162 / Outlier score: a horizontal ink-fill gauge bar, Sage-colored, filled proportionally, with the number inside in monospace). At the very bottom, a clearly distinct card — Paper with a hand-drawn dashed border, headline "Why it worked" in display serif, and an empty multi-line text field below it, placeholder: "That one's yours." This field must visually read as fundamentally different from everything above it — everything above is a machine-filled ledger; this one field is the one blank space on the page, deliberately roomier and quieter.
States: `analyzing` status shows the whole X-Ray tab replaced by a centered Bell Mark + "Reading it now." `failed` shows the Clay-toned failure reason + a "Try again" text action.

### D4 — Folder manager

Simple reorderable list of folders (name, color swatch, reference count in monospace), add/rename/delete via standard list-row actions (swipe or a trailing icon button, not a context menu).

### D5 — Search results

Same search bar as D1 pinned at top (feels continuous, not a new screen), results as the same reference-card grid/list as D1, with matched keyword snippets shown under each card's title in Graphite with the matching term in Ink bold (a literal "find in document" highlight feel).

### D6 — One-tap record capture screen — **FUTURE UI SCREEN**

Purpose (not built yet — needs native platform-level screen-recording integration on both Android and iOS): lets a user record another app's screen without leaving Foolscap.
Design it fully anyway: full-screen capture-in-progress view, a large record indicator as a solid Jester Red circle that pulses subtly (the one place a loud, continuous color moment is allowed, because it's a literal "recording" state convention users already expect), elapsed time in the monospace readout font, a single stop action (a square inside the red circle, standard record/stop convention — don't reinvent this one icon), and a pre-recording permission/explainer screen before it ("Foolscap needs permission to record your screen" with a plain system-style explainer, not a custom illustration — this is the one place system-standard UI is correct, because it's asking for a system permission).

### E1 — Scripts list

Purpose: entry point into Room tab — a creator's scripts for the current workspace.
Layout: list of script cards, title in display serif, Rubber Stamp status chip (draft/in_review/approved/shot/posted/graveyard — graveyard chip styled visibly different: a faded/ashen Graphite stamp rather than a colored one), pillar color as a thin left-edge bar on the card, last-edited relative time in caption/graphite. "+ New script" as a dashed-border final card, same pattern as C1/C2.

### E2 — Writing Room

Purpose: the heart of the app. A two-column editor — hear (left, what's said) / see (right, what's seen) — laid out side by side like a split-page screenplay, so a writer can hold both halves of a beat in view at once.
Layout: NOT a 50/50 split — hear column ~45%, see column ~55% (a deliberate asymmetry, like a script's dialogue column being narrower than its action/visual column in real screenwriting format). A thin vertical ink rule divides them, not a hard panel border. Each row = one beat: left cell is a plain text field (what's said), right cell is a plain text field (what's seen) plus an optional small "direction" tag below it (styled like a stage direction in italics, Graphite). Row numbers in the monospace font sit in a slim left margin outside both columns, like line numbers in a manuscript.
Top bar (above the columns, scrolls away on scroll-down, reappears on scroll-up): script title (tap to rename), target-duration readout vs. live estimate in the monospace font — color-shifts from Ink (on target) to Clay (over target) as you type, never a harsh "ERROR" state, just the number's color telling the story. A horizontally scrollable strip of pinned-reference Dog-Ear chips sits just below the top bar — tap one to open it in a slide-up mini-player without leaving the editor.
Per-row flags: a Redline Annotation appears inline under a row the moment the Overlap Alarm or the Brand Bible linter flags it — these must visually read identically to each other structurally (same Clay strikethrough + margin-note pattern) but the margin note text differs ("Too close to [reference name]" vs. "Banned word — try '[preferred term]'" with a one-tap swap action for the latter specifically).
Bottom: a slim persistent action strip with Hook Bench entry (only visible/relevant when editing row 1) and a "Send pitch" action, styled as plain text actions, not FABs.

### E3 — Hook Bench

Purpose: a scratch pad for writing multiple hook variants for row 1 (Phase 2.3).
Layout: presented as a bottom sheet or full-screen modal (full-screen reads better for focus) — a vertical stack of hook cards, each a large index-card-styled block in the display serif (hooks are headlines, treat them like ones), a small "promote" action (styled like a rubber stamp being pressed — reuse the Wax Seal press animation at small scale) moves the chosen hook into the script and dismisses the Bench. New hook: a plain "+ Add another" text row at the bottom, no limit enforced visually.

### E4 — Expression Vault — grid

Purpose: browse clipped facial-expression/moment references (Phase 2.5).
Layout: a grid of short looping video-thumbnail tiles (silent autoplay loop, muted by default), each tagged with its `tag` label as a small Rubber Stamp chip overlay bottom-left, a filter strip of tag chips above the grid (same Folder Tab visual motif as Library's folders, reused intentionally — both are "ways of grouping clips").

### E5 — Expression Vault — clip trimmer

Purpose: trim a 2–5 second moment out of a reference to save into the Vault.
Layout: video preview on top, a filmstrip scrubber below it showing extracted frame thumbnails in a row (not just a plain seek bar — an actual filmstrip, reinforcing the "physical film" metaphor), two drag handles (start/end) styled as small scissor-blade glyphs rather than generic trim handles, a tag input below, "Save to Vault" primary action.

### F1 — Compose pitch

Purpose: bundle a script version + references + shot list into a shareable pitch (Phase 3).
Layout: a checklist-style builder — script version picker (defaults to current), a multi-select list of the script's pinned references (pre-checked), an auto-generated shot list preview (derived from script rows, editable), a final review card showing exactly what the client will see, styled like an actual folded letter about to be "sent" — the primary action is literally labeled "Send pitch," and tapping it plays a brief animation of the review card folding/sliding away (a sealed-letter send motion, not a generic submit spinner).

### F2 — Pitches list

Purpose: creator's view of all pitches sent.
Layout: list of pitch cards — script title, Rubber Stamp status chip (sent/commented/approved/rejected — approved uses the full Wax Seal treatment, not just a colored chip, since approval is the one truly "sealed" state in this feature), revision counter as a small monospace badge ("v3"), relative sent-time.

### F3 — Pitch detail (creator)

Purpose: see comments and approval status for one pitch, mapped to script rows.
Layout: mirrors the Writing Room's row structure (reinforcing "this is the same script, now being read by someone else") — each row shows its text, and any comment pinned to that row appears as a margin note to the right (same visual slot the linter/overlap margin notes use in E2, different color — use Graphite with a small speech-mark glyph to distinguish "a person said this" from "the system flagged this"). Top of screen shows overall status as the Rubber Stamp/Wax Seal chip plus revision counter. If approved: the whole screen gets a subtle Seal Gold tint wash at ~4% opacity over the Paper background — barely perceptible, but the screen should *feel* finalized.

### G1 — Set Mode (teleprompter)

Purpose: huge-type, offline-capable shooting aid (Phase 6.1).
Layout: full-screen takeover, pure Paper (or pure Ink in a dedicated "set-mode dark" that's even darker than normal dark mode, since this runs on set under variable lighting) background, massive display-serif text auto-scrolling at the user's speaking pace, current line highlighted with a thin Jester Red left-margin tick (not a highlight box over the text itself — keep the text itself clean for reading). Mirror-flip toggle and font-size controls as minimal icon buttons in a corner that auto-hide after a few seconds of no interaction. A small Graphite badge, top corner: "Offline" when no connection, invisible when online (quiet confirmation, not an alarming banner).

### G2 — Take log overlay

Purpose: mark takes good/ok/bad against script lines during a shoot (Phase 6.2).
Layout: a slide-up panel over Set Mode, showing the current line and three large tap targets styled as literal rubber stamps waiting to be pressed — "Good" (Sage), "OK" (Graphite), "Bad" (Clay) — tapping one plays the stamp-press animation and logs the take, panel auto-dismisses back to the teleprompter.

### G3 — Script Graveyard

Purpose: dead scripts, filed not deleted (Phase 6.4).
Layout: same list pattern as E1 but desaturated — cards rendered slightly faded, as if the ink is older, status chips all in the ashen Graveyard treatment regardless of prior status. Each card has one action: "Resurrect" (text link, small, bottom-right of card) — tapping it plays a quick ink-returning-to-full-saturation transition on that one card before it's removed from the list.

### G4 — Results / retro entry

Purpose: manual metrics + notes after a script posts (Phase 6.3).
Layout: three simple labeled number-entry rows (Day 1 / Week 1 / Month 1), each a small set of key:value fields the user defines themselves (views, saves, whatever they track — a flexible 2-column key/value repeatable list, not fixed fields), a large free-text notes area below styled like the X-Ray "Why it worked" field (same ruled-notebook treatment) — this screen and that one should feel like siblings, both are "the human's reflection," not the machine's measurement.

### G5 — Human Ink export

Purpose: export a script's authorship timeline as proof-of-human-writing (Phase 6.5).
Layout: a vertical timeline (literal — a single ink line down the left side with small Wax Seal-style dots at each version event), each dot showing author initials-in-a-circle, timestamp in monospace, and a one-line diff summary if feasible ("edited 4 rows"). Bottom: one primary action "Export as PDF" — tapping it triggers the Wax Seal press animation at full scale, then a native share-sheet with the resulting PDF link.

### H1 — Research Radar dashboard — **FUTURE UI SCREEN**

Purpose (legally gated, not built — would require licensed data access rather than scraping social platforms, which is a legal/business step, not an engineering one): competitor/outlier tracking feed.
Design it fully anyway: a feed of "outlier alert" cards (similar visual language to Library's reference cards, since conceptually these are references too, just machine-surfaced rather than user-saved), each showing the source account, an outlier-score gauge (same Sage ink-fill gauge as D3's X-Ray), and a "Save to Library" action that would promote it into the user's own collection. A secondary tab on this screen: "Comment Mining" — a list of extracted recurring questions/objections from comment sections, each as a short quoted line with a frequency count in monospace, and a "Turn into an angle" action that would pre-fill a new script's first hook.

### H2 — Format Arbitrage Board — **FUTURE UI SCREEN**

Purpose (depends on the Research Radar dashboard's data source existing first): formats crushing it in other niches, surfaced for this one.
Design it fully anyway: a Pinterest-style masonry-ish grid is explicitly wrong here (too "consumer feed") — instead render it as a corkboard/pinboard metaphor: cards pinned at slight random rotations (reuse the Rubber Stamp chip's randomized-rotation idea at card scale) with a small literal pushpin glyph top-center of each card, grouped under niche-label headers styled like index tabs.
