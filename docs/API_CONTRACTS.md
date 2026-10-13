# API Contracts

All backend routes are mounted under `/v1`. Base response envelope (see [TECHNICAL_DEEP_DIVE.md](./TECHNICAL_DEEP_DIVE.md) section 2.8):

```json
// success
{ "ok": true, "data": { ... } }
// failure
{ "ok": false, "error": { "code": "VALIDATION_ERROR", "message": "...", "details": {} } }
```

Add a new row here **before** the frontend consumes it — this file is the source of truth both sides code against.

| Path | Method | Auth | Request | Response `data` | Idempotent? | Notes |
|---|---|---|---|---|---|---|
| `/v1/workspaces` | POST | Bearer | `{ name }` | `Workspace` | No | creates workspace, caller becomes owner |
| `/v1/workspaces/:wid/invites` | POST | Bearer (owner/editor) | `{}` | `{ token, url }` | No | |
| `/v1/workspaces/:wid/invites/:token/accept` | POST | Bearer | `{}` | `Workspace` | Yes | safe to retry |
| `/v1/workspaces/:wid/clients` | POST | Bearer | `BrandBible` fields | `Client` | No | |
| `/v1/workspaces/:wid/clients/:cid` | PATCH | Bearer | partial `BrandBible` fields | `Client` | Yes | |
| `/v1/workspaces/:wid/references/:rid/tags` | PATCH | Bearer | `{ tags: string[] }` | `Reference` | Yes | |
| `/v1/workspaces/:wid/references/:rid/folders` | PATCH | Bearer | `{ folderIds: string[] }` | `Reference` | Yes | maintains `folders/*.referenceCount` |
| `/v1/workspaces/:wid/scripts` | POST | Bearer | `{ title, clientId, format }` | `Script` | No | |
| `/v1/workspaces/:wid/scripts/:sid/versions` | POST | Bearer | `{ rows: Row[] }` | `ScriptVersion` | No | always appends, never mutates a prior version; runs linter + overlap alarm server-side before returning |
| `/v1/workspaces/:wid/pitches` | POST | Bearer | `{ scriptId, scriptVersionId, referenceIds }` | `Pitch` (incl. `shareToken`) | No | |
| `/v1/pitches/by-token/:token` | GET | **None** (public, rate-limited) | — | `{ pitch, scriptVersion, references }` | Yes | only endpoint with no auth middleware |
| `/v1/pitches/by-token/:token/comments` | POST | **None** (public, rate-limited) | `{ rowId?, authorName, text }` | `Comment` | No | |
| `/v1/pitches/:pid/approve` | POST | Bearer | `{}` | `Pitch` | Yes (becomes a no-op once already approved) | locks the version |
| `/v1/workspaces/:wid/takes` | POST | Bearer | `{ scriptId, rowId, takeNumber, verdict, note? }` | `Take` | No | |
| `/v1/workspaces/:wid/scripts/:sid/human-ink` | GET | Bearer | — | `{ downloadUrl }` | Yes | generates/returns signed PDF URL |

## Contract checklist (per playbook section 13)

Every new row above must specify: path, method, auth requirement, request body, query params (if any), response shape, error shape (always the shared envelope), idempotency, pagination (if a list), date/time format (always ISO-8601 UTC strings in JSON; Firestore `Timestamp` only inside Firestore itself, never serialized raw over HTTP).

## Pagination convention

List endpoints accept `?limit=20&cursor=<lastDocId>` and return `{ items: [...], nextCursor: string | null }` inside `data`. Not yet needed for v1 (Flutter reads most lists directly from Firestore with its own query cursors) — reserve this shape for the day a list must go through the backend instead.
