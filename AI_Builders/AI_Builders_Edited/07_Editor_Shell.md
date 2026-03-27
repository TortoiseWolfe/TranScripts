# Editor Shell — Lovable Clone Tutorial

Covers deploying the Cloudflare Worker (KV + R2 setup), building the editor page shell with resizable panels, creating the editor header with project menu/theme switcher, and wiring up the smart/dumb component architecture with state management.

---

## Deploying Cloudflare Worker Infrastructure

### Wrangler Setup

- Uninstall and reinstall the latest Wrangler globally:

```bash
npm uninstall wrangler
npm install -g wrangler
wrangler logout
wrangler login
```

- After login, Cloudflare grants authorization to Wrangler in the browser.

### Creating KV Namespace

```bash
wrangler kv namespace create metadata
```

- When prompted, allow Wrangler to add the binding on your behalf.
- Set the binding name to `metadata`.
- Choose to connect to the **remote** resource (not local).
- In `wrangler.json`, comment out the old local KV namespace entry and keep the new remote one.

### Creating R2 Bucket

```bash
wrangler r2 bucket create lovable-clone-files
```

- R2 must be enabled first in the Cloudflare dashboard under **Storage and Databases > R2 Object Storage**.
- Adding a payment method is required, but the free tier includes **10 GB/month** at no charge.
- Set the binding name to `files` in `wrangler.json`.

### Setting Secrets

```bash
wrangler secret put CLERK_SECRET_KEY
wrangler secret put CLERK_JWKS_URL
```

- Paste the values from your `.env` file when prompted.

### Deploying the Worker

```bash
npx wrangler deploy
```

- Copy the deployed worker URL and set it as `NEXT_PUBLIC_WORKER_URL` in the frontend's `.env.local`.
- The API client reads this environment variable to route requests.

### Verifying on Cloudflare Dashboard

After deploying and creating a project through the app:

- **KV Namespace** stores: user ID, project metadata (project ID, name), and user credits (remaining, total, plan, period start/end).
- **R2 Object Storage** stores project files in a directory structure: `{projectId}/v{versionNumber}/files.json`. Each `files.json` contains an array of objects with `path` and `content` fields.

---

## Editor Page Architecture (Smart/Dumb Components)

The editor uses the **smart and dumb components** pattern:

- **Smart component**: `page.tsx` — holds all logic, state, and API calls.
- **Dumb components**: `EditorLayout`, `EditorHeader`, `ChatPanel`, `PreviewPanel` — receive data via props and render UI.

This avoids prop drilling because props only go 2-3 levels deep. No state management library or context is used.

### Component Tree

```
page.tsx (smart component)
├── EditorLayout
│   ├── EditorHeader
│   │   ├── ProjectMenu (dropdown)
│   │   ├── EditorTabs (preview/code/history)
│   │   └── DeviceToggle (desktop/tablet/phone)
│   ├── ChatPanel
│   ├── Drag Handle (resize)
│   └── Right Panel
│       ├── PreviewPanel (with PanelErrorBoundary)
│       ├── CodeEditorPanel (with PanelErrorBoundary)
│       └── HistoryPanel (with PanelErrorBoundary)
```

### File Structure

```
components/editor/
├── index.ts              (barrel exports)
├── editor-layout.tsx
├── editor-header.tsx
├── chat-panel.tsx
├── editor-tabs.tsx
├── device-toggle.tsx
├── project-menu.tsx
└── panel-error-boundary.tsx
```

---

## Editor Page State (page.tsx)

### Refs

- **autoHealRef** — counts auto-heal attempts (max 3 automatic retries on errors).
- **justGeneratedRef** — tracks whether the last generation was AI-initiated or manually edited.
- **streamingRef** — tracks if the AI is still streaming a response (for SSE tracking).
- **pendingPromptRef** — holds the pending prompt from session storage (set on the dashboard when creating a project).
- **handleSendMessageRef** — holds the latest `handleSendMessage` callback for auto-send effects.
- **autoSaveTimerRef** — debounces auto-save when editing files.
- **currentFilesRef** — stores the current files for "back to current" when viewing old versions.

### State Variables

| State | Purpose |
|-------|---------|
| `project` | Project details fetched from API |
| `files` | Current project files (record of path-to-content) |
| `activeFile` | Currently selected file in Monaco editor |
| `messages` | Chat message history |
| `isStreaming` | Whether AI is generating a response |
| `isLoading` | Loading state for initial data fetch |
| `versions` | Version history metadata |
| `isLoadingVersions` | Loading state for versions |
| `creditsRemaining` | User's remaining credits (-1 for unlimited) |
| `creditsTotal` | Total credits allocated |
| `userPlan` | `"free"` or `"pro"` |
| `selectedModelId` | Currently selected AI model (default: `gpt-4o-mini`) |
| `isCreditsExhausted` | Computed: true if free plan and credits <= 0 |
| `viewingVersion` | Which historical version is being viewed |

### Loading Skeleton

While data loads, an `EditorLayoutSkeleton` component renders placeholder UI using the Skeleton component from the UI library.

---

## API Routes (Worker)

Three new route files are created in the worker:

### Chat Routes (`routes/chat.ts`)

```typescript
const chatRoutes = new Hono<{ Bindings: Env; Variables: AppVariables }>();
```

- **GET** `/:projectId` — Returns chat history for a project. Validates ownership, fetches from KV store key `chat:{projectId}`, returns `messages` array.

### Credits Routes (`routes/credits.ts`)

- **GET** `/` — Returns the user's credit balance: `remaining`, `total`, `plan`, `periodEnd`, `isUnlimited`.

### Versions Routes (`routes/versions.ts`)

- **GET** `/` — Lists all version metadata for a project. Base route is `api/projects/:id/versions`.
- Uses `getOwnedProject()` helper to verify ownership.
- Fetches all version objects from R2 using `Promise.all`.
- Maps to `toVersionMeta()` (strips file content, keeps: version number, type, prompt, model, created at, file count, changed files, restored from).
- Sorts by version number (newest first).

### Registering Routes in `index.ts`

```typescript
app.route("/api/chat", chatRoutes);
app.route("/api/credits", creditsRoutes);
app.route("/api/projects/:id/versions", versionRoutes);
```

**Note**: Versions use a nested route because versions are always linked to a project ID.

---

## API Client Updates

The frontend API client gets three new namespaces:

```typescript
chats: {
  getHistory: (projectId: string) => authenticatedFetch(...)
}
credits: {
  get: () => authenticatedFetch(...)
}
versions: {
  list: (projectId: string) => authenticatedFetch(...)
}
```

---

## Data Loading (useEffect)

On mount, the editor page loads five resources in parallel:

```typescript
const [projectRes, filesRes, chatRes, versionsRes, creditsRes] =
  await Promise.all([
    client.projects.get(projectId),
    client.projects.getFiles(projectId),
    client.chats.getHistory(projectId),
    client.versions.list(projectId),
    client.credits.get(),
  ]);
```

After fetching:

- Set project, selected model, credits, user plan.
- Convert files to a record using `filesToRecord()` (strips markdown fences from content).
- Set active file to `src/App.tsx` if it exists, otherwise the first file.
- Check session storage for a `pendingPrompt` — if found, store it in the ref and remove from session storage.

### Helper Functions

- **`filesToRecord(files)`** — Converts project files array to `Record<string, string>`, stripping markdown fences.
- **`stripMarkdownFences(content)`** — Removes triple-backtick code fences using regex.
- **`recordToFiles(record)`** — Converts record back to project files array for API calls.

---

## Editor Layout Component

### Panel Resizing

The chat panel width is controlled by `chatWidthPercent` state (default 30%).

**Constants**:
- `MIN_CHAT_PERCENT` = 20
- `MAX_CHAT_PERCENT` = 60 [REVIEW: exact value not stated, inferred from context]
- `DEFAULT_CHAT_PERCENT` = 30
- `MIN_CHAT_PIXELS` = minimum absolute width to prevent unusable size

**Pointer events** (`onPointerDown`, `onPointerMove`, `onPointerUp`) handle drag resizing:
- `onPointerDown` — captures the pointer and sets `isDragging` to true.
- `onPointerMove` — calculates new width percentage from container bounding rect.
- `onPointerUp` — releases capture and sets `isDragging` to false.

A `useEffect` keeps the chat panel width in sync with window resizes.

An overlay div blocks iframe mouse capture during dragging to prevent interaction issues.

### Tab Panel Switching

Three panels are stacked with absolute positioning. The active tab gets `z-10 visible`; inactive tabs get `z-0 invisible`. Each panel is wrapped in a `PanelErrorBoundary`.

---

## Editor Header Component

### Project Menu (Dropdown)

A `DropdownMenu` component with:
- **Dashboard link**
- **User info** (avatar from Clerk, username, plan badge)
- **Credits display** with progress bar
- **Settings link**
- **Rename project** — opens a dialog with auto-focused input, supports Enter/Escape shortcuts
- **Theme submenu** — light, dark, system (uses `useTheme` hook)
- **Delete project** — opens an AlertDialog for confirmation

### Editor Tabs

Type definition:

```typescript
export type EditorTabValue = "preview" | "code" | "history";
```

Renders pill-shaped buttons for preview, code, and history. Only visible on medium+ screens.

### Device Toggle

Type definition:

```typescript
export type DeviceMode = "desktop" | "tablet" | "phone";
```

Three toggle buttons with icons from **lucide-react** (`Monitor`, `Tablet`, `Smartphone`). Only shown when the preview tab is active.

### Mobile Panel Toggle

On small screens, only two options are shown: **Chat** and **Content** (simplified responsive layout).

---

## Panel Error Boundary

A **class component** (required by React for error boundaries):

- Catches render errors in child components.
- Displays error message with a "Try Again" button that resets the error state.
- Uses `componentDidCatch` lifecycle hook and `getDerivedStateFromError`.

---

## Types

### Chat Types (`types/chat.ts`)

```typescript
interface ImageAttachment {
  image: string;    // base64 encoded
  type: string;     // media type
  name: string;     // filename
}

interface ChatMessage {
  id: string;
  role: "user" | "assistant" | "system";
  content: string;
  timestamp: string;
  images?: ImageAttachment[];
  model?: string;
}

interface ChatSession {
  messages: ChatMessage[];
}
```

---

## Models Configuration (`lib/models.ts`)

Frontend model info for UI rendering:

```typescript
interface ModelInfo {
  id: string;
  name: string;
  provider: string;
  tier: "fast" | "premium";
  speed: "very_fast" | "fast" | "medium";
  quality: string;
  creditCost: number;
  description: string;
  supportsVision: boolean;
}
```

- **Default model**: `gpt-4o-mini`
- **Provider order**: Anthropic, OpenAI, Google, DeepSeek
- DeepSeek models do **not** support vision (image input).
- Speed labels: very fast = 3 bolts, fast = 2, medium = 1.
- Quality displayed as star ratings.
