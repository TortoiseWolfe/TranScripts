# Chapter 12: Version History and Restore — Lovable Clone Tutorial

**Kishan Sheth — Build a Full Stack Lovable Clone**
Source: SaaS AI Builder series (React 19, Cloudflare Workers, R2 Storage)

> This chapter implements the full versioning system: API routes for fetching versions, computing diffs between versions, restoring previous versions, saving manual edits as new versions, and the frontend version timeline and diff viewer components.

---

## Backend: Version API Routes

All routes are defined in `versions.ts` on the Cloudflare Worker.

### Get Specific Version Files

**Route:** `GET /versions/:v`

Retrieves the files for a specific version number.

```
GET /api/projects/:projectId/versions/:v
```

**Logic:**
1. Parse and validate the version number (must be a non-negative integer)
2. Fetch the project via `getOwnProject` — return 404 if not found
3. Validate that the requested version does not exceed the project's `currentVersion`
4. Fetch version files from R2: `{projectId}/v{versionNumber}/files.json`
5. Return `{ files, versionNumber, meta }` (meta includes type, prompt, model, timestamp)

### Get Diff Between Two Versions

**Route:** `GET /versions/:v1/:v2`

Computes a file-level diff between two versions.

```
GET /api/projects/:projectId/versions/:v1/:v2
```

**Logic:**
1. Parse and validate both version numbers
2. Reject if `v1 === v2` (same version)
3. Fetch both version files in **parallel** with `Promise.all`
4. Build file maps (`Map<string, string>`) for each version (path to content)
5. Compute changes by comparing the maps:

```tsx
const changes: Array<{
  path: string;
  type: "added" | "removed" | "modified";
  oldContent: string | null;
  newContent: string | null;
}> = [];

// Files in v2 not in v1 → "added"
// Files in both but different content → "modified"
// Files in v1 not in v2 → "removed"
// Identical files → skipped
```

6. Sort changes: modified first, then added, then removed
7. Return `{ from: v1, to: v2, changes }`

### Restore a Previous Version

**Route:** `POST /versions/:v/restore`

Creates a new version by copying files from a previous version.

```
POST /api/projects/:projectId/versions/:v/restore
```

**Logic:**
1. Parse `restoreFrom` version number from the URL parameter
2. Validate it does not exceed the current version
3. Fetch the source version's `files.json` from R2
4. Create a **new version** (incrementing `currentVersion + 1`) with:
   - `type: "restore"`
   - `prompt: "Restored from version {n}"`
   - `model`: copied from the source version
   - `files`: copied from the source version
   - `changedFiles`: list of all file paths from the source
   - `restoredFrom`: the source version number
5. Update the project's `currentVersion` and `updatedAt`
6. Store the new version in R2 and update the project metadata — done in **parallel** with `Promise.all`
7. **Persist a system message** to the chat session indicating the restore, so the AI knows the context changed

**Chat session update** (wrapped in try/catch):
- Fetch the chat session for the project
- Push a system message: "Restored to version {n}"
- Save the updated chat session

### Save Manual Edit as New Version

**Route:** `POST /versions`

When a user manually edits files in the code editor, this creates a new version capturing those changes.

```
POST /api/projects/:projectId/versions
```

**Logic:**
1. Get the request body containing the updated `files` array
2. Validate that files are provided
3. Fetch the current version's files to compute what changed
4. Build maps of current and new files
5. Detect **changed files** (added or modified) and **removed files**
6. If nothing changed, skip version creation
7. Create a new version object with `type: "manual"`
8. Store in R2 and update the project
9. Return the new version number and metadata

---

## Frontend: API Client Functions

Add four new functions to the versions API client:

### `get(projectId, versionNumber)`

Fetches a specific version's files and metadata.

```tsx
// Returns: { meta: VersionsMeta, files: ProjectFile[], versionNumber: number }
const response = await authenticatedFetch(
  getToken,
  `/api/projects/${projectId}/versions/${versionNumber}`
);
```

### `diff(projectId, v1, v2)`

Fetches the diff between two versions.

```tsx
const response = await authenticatedFetch(
  getToken,
  `/api/projects/${projectId}/versions/${v1}/${v2}`
);
```

### `restore(projectId, versionNumber)`

Calls the restore endpoint.

```tsx
const response = await authenticatedFetch(
  getToken,
  `/api/projects/${projectId}/versions/${versionNumber}/restore`,
  { method: "POST" }
);
```

### `saveManual(projectId, files)`

Saves a manual edit as a new version.

```tsx
const response = await authenticatedFetch(
  getToken,
  `/api/projects/${projectId}/versions`,
  { method: "POST", body: JSON.stringify({ files }) }
);
```

---

## Frontend: Version Timeline Component

Create `components/editor/version-timeline.tsx` as a client component.

### Props

```tsx
interface VersionTimelineProps {
  versions: VersionsMeta[];
  currentVersion: number;
  viewingVersion: number | null;
  onViewVersion: (versionNumber: number) => void;
  onRestoreVersion: (versionNumber: number) => void;
  onCompareVersions: (from: number, to: number) => void;
  isLoading: boolean;
}
```

### Version Type Badge

A helper function returns label, icon, and variant based on the version type:

| Type | Label | Icon | Variant |
|------|-------|------|---------|
| `ai` | AI Generation | `Bot` | `default` |
| `manual` | Manual Edit | `Pencil` | `secondary` |
| `restore` | Restore | `RotateCcw` | `outline` |

**Badge** is imported from the UI component library (not from `lucide-react`).

### Timestamp Formatting

The `formatVersionTimestamp` function converts ISO strings to relative time (e.g., "5 minutes ago", "2 hours ago").

### Prompt Truncation

```tsx
function truncatePrompt(prompt: string, maxLength = 60): string {
  if (prompt.length <= maxLength) return prompt;
  return prompt.slice(0, maxLength - 3) + "...";
}
```

### Component Structure

- **Empty state:** if no versions, show "No version history yet. Send a message to generate your first version."
- **Header:** "Version History" with a compare button (only shown when 2+ versions exist)
- **Scroll area:** maps over versions, each showing:
  - Version type badge
  - Truncated prompt
  - Metadata line: model name, file count, timestamp
  - **Restore button** for non-current versions
  - **Compare with current** button
- **Restore confirmation dialog:** uses the Dialog UI component with confirm/cancel actions
- Auto-scrolls to the current version on mount via `useRef` and `useEffect`

### Version Timeline Skeleton

A simple skeleton loader exported from the same file, used as a loading placeholder.

---

## Frontend: Version Diff Component

Create `components/editor/version-diff.tsx` as a client component.

### Props

```tsx
interface VersionDiffProps {
  from: number;
  to: number;
  changes: Array<{
    path: string;
    type: "added" | "removed" | "modified";
    oldContent: string | null;
    newContent: string | null;
  }>;
  onClose: () => void;
}
```

### Change Type Icons

Each change type gets an icon indicator:
- **Added** — green indicator
- **Removed** — red indicator
- **Modified** — yellow indicator

### Component Structure

- **File selector:** lists all changed files with their change type icons
- **Selected file index** tracked via `useState`
- **Monaco DiffEditor** from `@monaco-editor/react` shows side-by-side comparison
- Language detection reuses `getLanguageFromPath`
- **Empty state:** "No differences found between version {v1} and {v2}"

Import with `ssr: false` in `page.tsx` since it uses Monaco:

```tsx
const VersionDiff = dynamic(
  () => import("@/components/editor/version-diff"),
  { ssr: false, loading: () => <EditorSkeleton /> }
);
```

---

## Frontend: Page Integration

In `page.tsx`, wire up the version timeline and diff viewer into the history panel.

### State

```tsx
const [viewingVersion, setViewingVersion] = useState<number | null>(null);
const [diffState, setDiffState] = useState(null);
const [loadingVersions, setLoadingVersions] = useState(false);
```

### Handler Functions

**`handleViewVersion`** — fetches a specific version's files and displays them:

```tsx
const handleViewVersion = useCallback(async (versionNumber: number) => {
  // If viewing current version, reset to live files
  // Otherwise, fetch version files via API client
  // Set files and viewingVersion state
}, []);
```

**`handleCompareVersions`** — fetches the diff between two versions:

```tsx
const handleCompareVersions = useCallback(async (from: number, to: number) => {
  const response = await apiClient.versions.diff(projectId, from, to);
  setDiffState(response);
}, []);
```

**`handleRestoreVersion`** — restores a previous version and updates all state:

```tsx
const handleRestoreVersion = useCallback(async (versionNumber: number) => {
  const response = await apiClient.versions.restore(projectId, versionNumber);
  // Set files to restored files
  // Update currentFilesRef and lastFilesRef
  // Update project metadata
  // Reset viewingVersion and diffState to null
  // Add system message: "Restored to version {n}"
  // Refresh versions list
}, []);
```

### History Panel Layout

```tsx
{/* History panel */}
<div className="flex h-full">
  {/* Version timeline sidebar */}
  <VersionTimeline
    versions={versions}
    currentVersion={currentVersion}
    viewingVersion={viewingVersion}
    onViewVersion={handleViewVersion}
    onRestoreVersion={handleRestoreVersion}
    onCompareVersions={handleCompareVersions}
    isLoading={loadingVersions}
  />

  {/* Diff viewer (shown when comparing) */}
  {diffState && (
    <VersionDiff
      from={diffState.from}
      to={diffState.to}
      changes={diffState.changes}
      onClose={() => setDiffState(null)}
    />
  )}
</div>
```

---

## Bug Fix: Missing Version Metadata

During testing, version 0 (the initial project creation) only stored `fileCount` without the full metadata (type, model, prompt, etc.). This caused the version type badge to crash with "Cannot read properties of undefined."

**Fix:** Add a guard in the version timeline component:

```tsx
if (!version.versionNumber) return null;
```

This skips rendering versions that lack complete metadata, which can happen with projects created before the versioning system was fully implemented.

---

## Summary

After this chapter, the versioning system is complete:
- **4 API routes:** get version, diff versions, restore version, save manual edit
- **Version timeline** shows all versions with type badges, metadata, restore/compare buttons
- **Diff viewer** uses Monaco DiffEditor for side-by-side file comparison
- **Restore** creates a new version (never overwrites), updates chat context, and refreshes the UI
- **Manual edits** in the code editor are tracked as separate version types
