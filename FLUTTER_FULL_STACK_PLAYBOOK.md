# Flutter Full-Stack Playbook

This document is the operating manual for building and extending the store app with Flutter on the frontend and a Node/Express backend. If a future change conflicts with this guide, follow the guide unless there is a concrete project constraint that makes a rule impossible.

## 1. Core Principles

- Keep UI, state, data, and side effects separated.
- Prefer explicit over clever.
- Keep widgets small and composable.
- Make the app responsive by default, not as a final polish step.
- Treat navigation, storage, and networking as shared infrastructure, not one-off code inside pages.
- Optimize for maintainability first, then performance, then aesthetics.

## 2. Default Architecture

Use a layered structure where the UI does not talk directly to the backend.

### Frontend layers

- Presentation: pages, widgets, layout, navigation, and view-specific UI.
- State: controllers or notifiers that hold UI state and orchestrate actions.
- Data: API clients, repositories, local storage helpers, and model parsing.
- Core: theme, constants, routing, utilities, and shared helpers.

### Backend layers

- Routes: define HTTP endpoints and wire middleware.
- Controllers: translate HTTP requests into service calls.
- Services: contain business logic.
- Repositories: contain data access and persistence logic.
- Validators: define request schemas and payload rules.
- Middleware: auth, rate limiting, validation, logging, and error handling.
- Config: environment, third-party clients, and shared initialization.

### Keep this rule

- Widgets must not call raw backend APIs directly.
- Controllers must not know presentation details.
- Repositories must not know HTTP details.
- Backend controllers must not contain heavy business logic.

## 3. Recommended Folder Structure

### If you keep the current project shape

Use the existing pattern cleanly and consistently:

```text
lib/
  controller/
  model/
  navigation/
  services/
  utils/
  views/
```

Rules for this shape:

- `controller/` holds `ChangeNotifier` or equivalent state objects.
- `model/` holds JSON-safe data classes only.
- `navigation/` holds routing, responsive wrappers, and layout shells.
- `services/` holds API and persistence clients.
- `utils/` holds constants, formatters, helpers, and pure functions.
- `views/` holds pages, widgets, and presentation components only.

### If the app grows further

Move toward feature-first folders:

```text
lib/
  app/
  core/
  features/
    auth/
      data/
      domain/
      presentation/
    cart/
    checkout/
    orders/
    products/
    settings/
```

Use feature-first structure when multiple screens share state, API calls, and reusable widgets.

## 4. Frontend State Management

### Current-safe choice

- `Provider` and `ChangeNotifier` are acceptable for small and medium apps.
- `ValueNotifier` and `ValueListenableBuilder` are fine for tiny UI state such as selected tabs or theme mode.

### Preferred replacement when the app becomes larger

- Replace ad-hoc `Provider` usage with `GetX` when you want lower boilerplate, centralized controllers, and combined state/navigation helpers.
- Keep `ChangeNotifier` only for UI-owned state that is simple and local.
- If you use `GetX`, keep controllers lean and do not turn them into dumping grounds for UI logic, networking, and persistence all at once.

### Rules

- Use one source of truth per feature.
- Keep async loading, error, and empty states inside the controller.
- Expose immutable lists or read-only views from controllers.
- Never mutate model lists directly from widgets.
- Do not put API calls in `build()`.
- Trigger fetches in initialization code, callbacks, or lifecycle hooks.

### Controller responsibilities

- Fetch data.
- Cache data if needed.
- Merge remote and local state.
- Expose loading, error, and success states.
- Convert backend responses into models.

### Widget responsibilities

- Render state.
- Handle taps and gestures.
- Forward events to controllers.
- Display loading, error, and empty views.

## 5. Navigation And Routing

### What to use

- Use `Navigator` for dialogs, sheets, local one-off pushes, and simple flows.
- Use a declarative router such as `go_router` for real app navigation, web support, deep links, nested navigation, and tab shells.

### Preferred replacement

- Replace scattered `Navigator.push` calls with `go_router` when screens need shared route rules, route guards, browser history, or deep linking.

### Navigation rules

- Centralize route definitions.
- Keep route names and paths in one place.
- Avoid hard-coded route strings in widgets.
- Keep authentication guards outside page widgets.
- Use page shell patterns for bottom navigation or side navigation.
- Use `ShellRoute` or `StatefulShellRoute` for tabbed apps.
- Use `Navigator.pop` only for the current stack level.
- Use page arguments or route state instead of global mutable navigation state.

### For the current project style

- If the app keeps the current `navigation/` folder, that folder should own shell layout, breakpoint switching, and route entry points.
- Keep mobile, tablet, and desktop layout wrappers in one navigation layer.
- Keep tab selection state out of page widgets when possible.

### What to avoid

- Route logic inside deeply nested leaf widgets unless it is a local modal or detail push.
- Mixed patterns where some flows use the router and others bypass it without reason.
- Navigation side effects hidden inside model classes or services.

## 6. Responsive And Adaptive UI

### Rule

- Responsive means the layout fits the available space.
- Adaptive means the app chooses the right interaction pattern for that space.

### Breakpoint guidance

- Mobile: one-column layouts, bottom navigation or compact drawer, strong vertical stacking.
- Tablet: two-pane layouts where useful, wider spacing, persistent filters where possible.
- Desktop: side navigation, detail panes, larger hit targets, hover states, keyboard support.

### Implementation rules

- Use `LayoutBuilder` or `MediaQuery` only where the layout truly changes.
- Prefer one responsive shell that delegates to mobile, tablet, and desktop variants.
- Do not duplicate entire pages unless the layouts are fundamentally different.
- Keep breakpoints consistent across the app.
- Respect safe areas, notches, and system UI overlays.
- Test on narrow phone widths, tablet widths, desktop widths, and landscape rotation.

### Better patterns

- For complex apps, use a breakpoint system or adaptive scaffold rather than many manual width checks.
- Use persistent navigation shells for desktop and tablet instead of constantly pushing full-screen routes.

## 7. Theming And Design System

### Non-negotiable rules

- Define colors, typography, spacing, radius, and elevations centrally.
- Avoid hard-coded colors in random widgets.
- Use `ColorScheme` and theme extensions for brand-specific tokens.
- Keep light and dark themes both intentional.
- Use semantic spacing tokens instead of random numbers everywhere.

### Typography

- Pick one primary text family and one display family at most.
- Use consistent text styles for headings, body, captions, labels, and buttons.
- Avoid changing font family in many places.

### Icons and imagery

- Use a single icon strategy consistently.
- Make image ratios explicit.
- Crop and compress product images before shipping them.

### Theme rules

- Theme should live near app initialization.
- Widgets should consume theme tokens, not define design constants inline.

## 8. Asset Management

### Asset rules

- Declare assets explicitly in `pubspec.yaml`.
- Group assets by purpose, not only by file type.
- Keep directory names stable.
- Use resolution-aware images when multiple densities are needed.
- Avoid loading images from scattered hard-coded paths.

### Suggested asset structure

```text
assets/
  icons/
  images/
    categories/
    banners/
    products/
  json/
  lottie/
  fonts/
```

### Practical rules

- Use `AssetImage` or equivalent for bundled assets.
- Use `DefaultAssetBundle` for runtime-loaded text assets when a widget context exists.
- Keep static JSON only for seed data or offline defaults.
- Compress banners and product images aggressively.
- Do not mix temporary design assets with production assets.

### What to avoid

- Deeply nested asset paths with no naming convention.
- Loading images directly from random local file paths in production UI.
- Keeping unused assets in the bundle.

## 9. Package Preferences

### Keep or use as default

- `http` for simple API calls.
- `provider` for small-to-medium state management.
- `shared_preferences` only for low-risk preferences such as onboarding flags, theme mode, and simple UI settings.
- `uuid` for local IDs and draft entities.

### Preferred replacements where appropriate

- Replace `shared_preferences` with `flutter_secure_storage` for access tokens, refresh tokens, or any secret.
- Replace `http` with `dio` when you need interceptors, retries, cancellation, progress callbacks, or a richer client abstraction.
- Replace `provider` with `GetX` when the app benefits from less boilerplate and you want state, dependency injection, and navigation in one pattern.
- Replace manual responsive routing with `go_router` for a large app or any web/deep-link-first app.

### Package selection rules

- Choose the smallest package that solves the problem cleanly.
- Avoid package sprawl.
- If a package is only used in one screen and duplicates built-in Flutter behavior, do not add it.
- Remove packages that only exist because of an old experiment.

## 10. Data And API Integration

### Frontend API rules

- Put all backend communication behind a client or repository layer.
- Keep request/response mapping in one place.
- Normalize backend shapes into frontend models.
- Handle success, empty, auth failure, validation failure, and server failure separately.
- Time out network calls and surface useful error messages.

### Model rules

- Models should be immutable whenever practical.
- Use factory parsing from JSON.
- Keep parsing tolerant of missing fields, but not silent about broken contracts.
- Add `toJson()` only when the app truly needs it.

### API contract rules

- Keep response envelopes consistent.
- Make backend success and error formats stable.
- Keep date formats explicit and consistent.
- Use frontend-safe names in the response payload if the frontend already depends on them.

### For this project type

- Public catalog endpoints should stay simple and cache-friendly.
- Authenticated endpoints should accept access tokens in `Authorization` headers.
- Checkout/order endpoints should be idempotent or protected against double submission.

## 11. Storage And Session Rules

### Storage choices

- Use `shared_preferences` only for non-sensitive settings.
- Use secure storage for tokens and secrets.
- Use a real local database or object store when the app needs offline-first data, complex filtering, or cached domain objects.

### Session rules

- Keep access token refresh logic centralized.
- Do not scatter token parsing through UI widgets.
- Handle token expiry in one place.
- Do not store secrets in plain text preferences.

### Caching rules

- Cache stable lists such as categories or banners when it improves performance.
- Invalidate caches on logout or account switch.
- Add a versioning strategy if cached payloads can change shape.

## 12. Backend Architecture Rules

### Structure

- Keep routes thin.
- Keep controllers thin.
- Keep business logic in services.
- Keep Firestore, SQL, or third-party data access in repositories.
- Keep validation close to request entry points.

### Validation

- Validate every external request.
- Reject invalid payloads before they hit business logic.
- Use schema validation for body, query, params, and headers.
- Never trust client input for prices, role checks, or permissions.

### Error handling

- Return one stable error envelope.
- Use clear error codes.
- Never leak secrets or internal stack details in production responses.
- Separate validation errors from auth errors and server errors.

### Logging

- Log request IDs, route names, status codes, and timings.
- Log structured JSON where possible.
- Avoid logging secrets, tokens, raw card data, or private keys.

### Security

- Use `helmet` or equivalent security headers.
- Use CORS rules intentionally.
- Rate-limit auth and checkout endpoints.
- Verify roles on the server, not in the client.
- Validate Stripe webhook signatures on the server.
- Keep secret keys in environment variables only.

### Payments and orders

- Create orders before or alongside payment intent creation depending on the flow, but keep the state machine explicit.
- Treat webhook confirmation as the source of truth for final payment status.
- Make checkout retry-safe.
- Prevent duplicate order creation from repeated taps or retry storms.

## 13. Backend And Frontend Contract Rules

- Define the API contract before coding a screen that depends on it.
- Keep field names stable once the frontend consumes them.
- Version major breaking changes.
- Preserve backward compatibility for existing app clients whenever possible.
- Document every public endpoint that the app relies on.

### Contract checklist

- Path.
- Method.
- Auth requirement.
- Request body.
- Query parameters.
- Response shape.
- Error shape.
- Idempotency behavior.
- Pagination behavior.
- Date/time format.

## 14. Performance Rules

### Frontend

- Build small widgets.
- Avoid unnecessary rebuilds.
- Use `const` where possible.
- Split heavy lists into dedicated widgets.
- Cache expensive computed values when there is a measurable benefit.
- Load images at the right size.
- Defer heavy work until after the first frame if necessary.

### Backend

- Keep controllers fast.
- Avoid repeated network calls to the same upstream in one request path.
- Paginate lists.
- Add indexes or query optimization where needed.
- Do not over-fetch large objects if the client only needs a subset.

## 15. Accessibility And UX

- Use readable contrast.
- Preserve tap target size.
- Support keyboard navigation on desktop and web.
- Add semantic labels where needed.
- Provide loading, empty, error, and retry states for every network-driven screen.
- Do not depend on color alone to convey meaning.

## 16. Testing Rules

### Frontend tests

- Test models and parsers.
- Test controllers separately from widgets.
- Add widget tests for critical flows.
- Add golden or snapshot tests only when the UI is stable enough to justify them.

### Backend tests

- Test validators.
- Test controllers with mocked services.
- Test repositories with a controlled data source.
- Add integration tests for auth, checkout, and order creation.
- Test webhook handling and failure paths.

### Minimum test priority

1. Authentication.
2. Checkout and payment flow.
3. Product and order parsing.
4. Navigation flows that are easy to break.

## 17. Build, Release, And Env Rules

- Keep `.env.example` updated.
- Never commit secrets or service account files.
- Keep environment-specific config isolated.
- Use separate development, staging, and production settings.
- Verify web, Android, and iOS builds before release.
- Document any platform-specific config change in the repo.

## 18. Code Style Rules For Vibe Coding

When generating or refactoring code, follow these rules exactly:

- Match existing naming conventions.
- Prefer small reusable widgets over giant build methods.
- Keep state close to where it is needed, but not inside every leaf widget.
- Keep one responsibility per file when practical.
- Put reusable formatting and parsing in helpers, not in UI code.
- Do not introduce a new package unless it solves a real, recurring problem.
- Do not mix presentation code with API logic.
- Do not put route strings in random widgets if a centralized router exists.
- Do not store secrets in insecure storage.

## 19. Replacement Matrix

Use this section when deciding whether to keep the current pattern or move to a better one.

| Current Pattern | Keep It When | Better Replacement | Use The Replacement When |
| --- | --- | --- | --- |
| `Provider` + `ChangeNotifier` | The app is modest in size and state is simple | `GetX` | You want less boilerplate and a more centralized app-level pattern |
| Manual `Navigator.push` everywhere | The flow is small and local | `go_router` | Web, deep links, nested tabs, or route guards matter |
| `shared_preferences` for settings | The value is non-sensitive | `flutter_secure_storage` | Tokens, secrets, or credentials are stored |
| `http` | Requests are simple and few | `dio` | Interceptors, retries, progress, or cancellation are needed |
| Ad hoc width checks | One or two layout branches | Adaptive scaffolds or breakpoint utilities | The app has many responsive patterns |
| Direct backend calls from widgets | Never keep this as-is | Repository/client layer | Any screen becomes more than trivial |

## 20. Practical Rules For This Repo

- Keep controllers in `lib/controller` and keep them focused.
- Keep models in `lib/model` and make parsing predictable.
- Keep shell/navigation behavior in `lib/navigation`.
- Keep visual screens in `lib/views`.
- Keep asset paths stable and explicit in `pubspec.yaml`.
- Keep backend controllers thin and business logic in services.
- Keep Firestore access behind repositories.
- Keep payment logic server-side.
- Keep the frontend clean enough that a new page can be built without copying unrelated code.

## 21. Final Quality Bar

Before merging any feature, verify that:

- The UI works on mobile, tablet, and desktop widths.
- The flow handles loading, empty, error, and success states.
- The backend validates and sanitizes the request.
- The API contract is stable and documented.
- The state source is clear.
- Navigation works on the target platforms.
- Assets are bundled correctly.
- Secrets are not exposed.
- The feature is testable and does not require manual hacks to run.

If a future implementation violates this guide, the default fix is to move the behavior into the correct layer rather than adding another shortcut in the UI.