# Chapter 6: Dashboard CRUD — Lovable Clone Tutorial

Building the dashboard layout with a responsive sidebar, creating empty state, project create dialog, project card with Sandpack preview, project grid, and the full CRUD API routes (list, get, get files, create, update, delete) on the Cloudflare Worker including the credit system and default project template.

## App Layout

The dashboard uses an `AppLayout` component wrapping all `/dashboard/*` routes. It provides a sidebar, a mobile hamburger header, and a rate-limit banner slot.

### Layout Structure

```
+-------------------+---------------------------+
|     Sidebar       |      Main Content         |
|  - Logo           |   Dashboard / Settings    |
|  - Nav items      |   Project cards           |
|  - Credits        |                           |
|  - User avatar    |                           |
+-------------------+---------------------------+
```

### Editor Page Bypass

If the current pathname starts with `/project/` (the code editor), the sidebar is hidden and only the children are rendered:

```tsx
const pathname = usePathname();
const isEditorPage = pathname.startsWith("/project/");

if (isEditorPage) {
  return (
    <div className="flex h-screen flex-col bg-background text-foreground">
      {/* TODO: Rate limit banner */}
      <div className="flex flex-1 overflow-hidden">{children}</div>
    </div>
  );
}
```

### Sidebar

The sidebar uses an `<aside>` element with fixed positioning and a width of `w-60`:

- **Logo** — links to `/dashboard`
- **Nav items** — Dashboard, Analytics, Settings with icons from `lucide-react`
- **Active state** — determined by matching `pathname` against each nav item's route
- **Credits display** — placeholder for the credit component (built later)
- **User button** — Clerk's `<UserButton>` with a custom avatar size (`appearance={{ elements: { avatarBox: "size-8" } }}`)
- **Separator** components between sections

### Responsive Sidebar

On mobile, the sidebar slides in/out using translate transforms:

```tsx
const [sidebarOpen, setSidebarOpen] = useState(false);

// Overlay backdrop (mobile only)
{sidebarOpen && (
  <div
    className="fixed inset-0 z-40 bg-black/60 backdrop-blur-sm md:hidden"
    onClick={() => setSidebarOpen(false)}
  />
)}

// Sidebar with conditional transform
<aside className={cn(
  "fixed inset-y-0 left-0 z-50 flex w-60 flex-col border-r bg-sidebar transition-transform duration-200 md:static md:translate-x-0",
  sidebarOpen ? "translate-x-0" : "-translate-x-full"
)}>
```

The mobile header with a hamburger menu icon sits above the main content and calls `setSidebarOpen(true)` on click.

### Main Content Offset

Because the sidebar is `fixed` with `w-60`, the main content area needs equivalent left padding (handled by the parent flex layout with `md:pl-60` or similar) to avoid overlap.

## Dashboard Components

All dashboard components live in `components/dashboard/` with a barrel export in `index.ts`.

### Empty State

Shown when the user has no projects. Displays a folder icon, heading, description, and a "Create Project" button:

```tsx
export interface EmptyStateProps {
  onCreateProject: () => void;
}

export function EmptyState({ onCreateProject }: EmptyStateProps) {
  return (
    <div className="flex flex-1 flex-col items-center justify-center px-6 py-20">
      <div className="flex size-16 items-center justify-center rounded-2xl bg-muted">
        <FolderOpen className="size-8 text-muted-foreground" />
      </div>
      <h2 className="mt-6 text-xl font-semibold">No projects yet</h2>
      <p className="mt-2 max-w-sm text-center text-sm text-muted-foreground">
        Create your first project to start building with AI.
        Describe your idea and watch it come to life.
      </p>
      <Button className="mt-6" onClick={onCreateProject}>
        Create Project
      </Button>
    </div>
  );
}
```

### Create Project Dialog

A modal dialog for entering the project name, selecting an AI model, and optionally providing a description. The description is sent as the first AI prompt when the project opens.

**AI model options** (8 models across 4 providers):

| Provider | Models |
|----------|--------|
| OpenAI | `gpt-4o-mini`, `gpt-4o` |
| Google | `gemini-2.0-flash`, `gemini-2.5-pro-preview-05-06` |
| Anthropic | `claude-3-5-sonnet-20241022`, `claude-sonnet-4-20250514` |
| DeepSeek | `deepseek-chat` (V3), `deepseek-reasoner` (R1) |

[REVIEW: Model IDs are transcribed from spoken content and may not match exact API values. Verify against provider documentation.]

The **model value strings must match exactly** what the AI provider APIs expect. The label is display-only; the value is what gets sent to the backend.

**DeepSeek** is recommended for development because it is inexpensive and produces good results.

```typescript
export interface CreateProjectData {
  name: string;
  description: string;
  model: string;
}
```

The dialog uses shadcn/ui components: `Dialog`, `DialogContent`, `DialogHeader`, `DialogTitle`, `DialogDescription`, `DialogFooter`, `Input`, `Select`, `Textarea`, and `Button`.

The submit button is disabled when the name is empty. On submit, values are trimmed, the form resets, and the parent's `onSubmit` callback fires.

### Project Preview (Sandpack)

The `ProjectPreview` component renders a live Sandpack preview of the project's files as a thumbnail.

**Key architecture decisions:**

- Sandpack requires browser APIs, so the component is loaded with `dynamic(() => import(...), { ssr: false })`.
- Virtual dimensions: **1024 x 640** pixels, scaled down to fit the card thumbnail.
- **Tailwind CSS CDN** is injected via Sandpack's `externalResources` option because Sandpack does not natively load Tailwind.

**File transformation** — project files stored as `src/App.tsx` need the `src/` prefix stripped for Sandpack:

```typescript
function toSandpackFiles(files: Record<string, string>) {
  const sandpackFiles: Record<string, { code: string }> = {};
  for (const [path, content] of Object.entries(files)) {
    const sandpackPath = path.startsWith("src/") ? path.slice(4) : path;
    sandpackFiles[`/${sandpackPath}`] = { code: content };
  }
  return sandpackFiles;
}
```

**Dependency extraction** — parses `package.json` from the project files to get dependencies. Falls back to `react` and `react-dom` if no `package.json` exists.

**Load notification** — a `LoadNotifier` sub-component uses the `useSandpack` hook to listen for the `"done"` message, then calls `onLoad()` to switch from skeleton loaders to the live preview.

```tsx
<SandpackProvider
  template="react"
  theme="dark"
  files={sandpackFiles}
  options={{ externalResources: ["https://cdn.tailwindcss.com"] }}
  customSetup={{ dependencies }}
>
  <LoadNotifier onLoad={onLoad} />
  <SandpackLayout style={{ height: "100%", border: "none", borderRadius: 0 }}>
    <SandpackPreview
      showNavigator={false}
      showOpenInCodeSandbox={false}
      showRefreshButton={false}
      style={{ height: "100%" }}
    />
  </SandpackLayout>
</SandpackProvider>
```

### Project Card

Each project card displays a Sandpack preview thumbnail (or initials fallback), the project name, relative time ("3 hours ago"), and a dropdown menu with Rename and Delete actions.

**Scaling** — a `ResizeObserver` watches the thumbnail container width and computes a scale factor (`containerWidth / 1024`) to shrink the 1024px-wide Sandpack preview into the card.

**Relative time formatting** — a utility function converts ISO timestamps to human-readable strings ("just now", "2 minutes ago", "1 week ago") using `Intl.RelativeTimeFormat`.

**Initials fallback** — when no files are available, the card displays the first two initials of the project name (e.g., "Social Media App" becomes "SM").

**Navigation** — clicking the card calls `router.push("/project/<id>")` to open the editor.

### Project Grid

The grid renders a "New Project" card first, followed by all existing project cards:

```tsx
<div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">
  <Card onClick={onNewProject} className="flex h-full ...">
    {/* Plus icon + "New Project" text */}
  </Card>
  {projects.map((project) => (
    <ProjectCard
      key={project.id}
      project={project}
      files={projectFiles[project.id] || {}}
      onRename={onRename}
      onDelete={onDelete}
    />
  ))}
</div>
```

## Worker API Routes

All project routes are in `src/routes/project.ts`. The route endpoints:

| Method | Path | Purpose |
|--------|------|---------|
| GET | `/api/projects` | List all projects for the authenticated user |
| GET | `/api/projects/:id` | Get a single project with ownership check |
| GET | `/api/projects/:id/files` | Get all files for a project version |
| POST | `/api/projects` | Create a new project |
| PATCH | `/api/projects/:id` | Update project name or model |
| DELETE | `/api/projects/:id` | Delete a project and all its data |

### GET /:id — Single Project

Fetches project metadata from KV, verifies ownership, and returns the project:

```typescript
projectRoutes.get("/:id", async (c) => {
  const userId = c.var.userId;
  const projectId = c.req.param("id");

  const project = await c.env.METADATA.get<Project>(`project:${projectId}`, "json");

  if (!project) return c.json({ error: "Project not found", code: "not_found" }, 404);
  if (project.userId !== userId) return c.json({ error: "Access denied", code: "forbidden" }, 403);

  return c.json(project);
});
```

### GET /:id/files — Project Files

Files are stored in **Cloudflare R2** under the key pattern `<projectId>/v<version>/files.json`:

```typescript
projectRoutes.get("/:id/files", async (c) => {
  const userId = c.var.userId;
  const projectId = c.req.param("id");

  const project = await c.env.METADATA.get<Project>(`project:${projectId}`, "json");
  if (!project) return c.json({ error: "Project not found", code: "not_found" }, 404);
  if (project.userId !== userId) return c.json({ error: "Access denied", code: "forbidden" }, 403);

  const versionKey = `${projectId}/v${project.currentVersion}/files.json`;
  const versionObject = await c.env.FILES.get(versionKey);

  if (!versionObject) return c.json({ error: "Files not found", code: "not_found" }, 404);

  const { files } = await versionObject.json<{
    files: Array<{ path: string; content: string }>;
  }>();

  return c.json({ files, version: project.currentVersion });
});
```

### PATCH /:id — Update Project

Updates the project name and/or model. Uses a sanitization service to strip HTML tags and control characters:

```typescript
projectRoutes.patch("/:id", async (c) => {
  const userId = c.var.userId;
  const projectId = c.req.param("id");
  const body = await c.req.json<{ name?: string; model?: string }>();

  const project = await c.env.METADATA.get<Project>(`project:${projectId}`, "json");
  if (!project) return c.json({ error: "Project not found", code: "not_found" }, 404);
  if (project.userId !== userId) return c.json({ error: "Access denied", code: "forbidden" }, 403);

  if (body.name) {
    const sanitized = sanitizeProjectName(body.name);
    if (sanitized) project.name = sanitized;
  }
  if (body.model) project.model = body.model;
  project.updatedAt = new Date().toISOString();

  await c.env.METADATA.put(`project:${projectId}`, JSON.stringify(project));
  return c.json(project);
});
```

### DELETE /:id — Delete Project

Deletes the project metadata, chat history, file versions from R2, and removes the project ID from the user's list:

```typescript
projectRoutes.delete("/:id", async (c) => {
  const userId = c.var.userId;
  const projectId = c.req.param("id");

  const project = await c.env.METADATA.get<Project>(`project:${projectId}`, "json");
  if (!project) return c.json({ error: "Project not found", code: "not_found" }, 404);
  if (project.userId !== userId) return c.json({ error: "Access denied", code: "forbidden" }, 403);

  // Remove project ID from user's list
  const existingIds =
    (await c.env.METADATA.get<string[]>(`user_projects:${userId}`, "json")) || [];
  const updatedIds = existingIds.filter((id) => id !== projectId);

  // Delete all R2 file versions
  const r2Objects = await c.env.FILES.list({ prefix: `${projectId}/` });
  const deletePromises = r2Objects.objects.map((obj) =>
    c.env.FILES.delete(obj.key)
  );

  await Promise.all([
    c.env.METADATA.delete(`project:${projectId}`),
    c.env.METADATA.delete(`chat:${projectId}`),
    c.env.METADATA.put(`user_projects:${userId}`, JSON.stringify(updatedIds)),
    ...deletePromises,
  ]);

  return c.json({ message: "Project deleted", success: true });
});
```

The R2 list uses a **prefix** (`<projectId>/`) to find all version files, then deletes each one. The user's project list, project metadata, and chat history are cleaned up in a single `Promise.all`.

### Sanitization Service

Create `src/services/sanitize.ts`:

- **`sanitizeProjectName(name)`** — trims, strips HTML tags, removes control characters, enforces 100-character max
- **`sanitizeChatMessage(message)`** — removes control characters, trims, enforces 10,000-character max
- **`isValidModelId(modelId, validModels)`** — checks if the model ID exists in the allowed set

## Cloudflare KV and R2 Data Patterns

### KV (Metadata / Database)

| Key Pattern | Value | Purpose |
|------------|-------|---------|
| `user_projects:<userId>` | `string[]` (JSON array of project IDs) | Quick lookup of all projects for a user |
| `project:<projectId>` | `Project` (JSON object) | Project metadata (name, model, version, timestamps) |
| `chat:<projectId>` | Chat message array (JSON) | Full chat history for a project |
| `credits:<userId>` | `UserCredits` (JSON object) | Credit balance, plan, billing period |

### R2 (File Storage)

| Key Pattern | Value | Purpose |
|------------|-------|---------|
| `<projectId>/v<version>/files.json` | `{ files: [{ path, content }] }` | All project files for a specific version |

**Why R2 instead of KV for files?**
- KV has a **25 MB value limit** and is designed for small, frequently read data.
- AI-generated apps can have dozens of files totaling several megabytes.
- R2 is object storage (like S3) with **zero egress fees**.

Each AI generation creates a new version (`v0`, `v1`, `v2`, ...) so the full version history is preserved.

## Credit System

Create `src/services/credits.ts` to manage user credits and billing periods.

### Data Structure

```typescript
export interface UserCredits {
  remaining: number;
  total: number;
  plan: "free" | "pro";
  periodStart: string;
  periodEnd: string;
}

export const DEFAULT_FREE_CREDITS = 50;
export const UNLIMITED_CREDITS = -1;
export const FREE_PROJECT_LIMIT = 3;
```

### Billing Period

Each user gets a 30-day billing cycle. When the period expires, credits reset:

```typescript
function createBillingPeriod() {
  const now = new Date();
  const periodEnd = new Date(now);
  periodEnd.setMonth(periodEnd.getMonth() + 1);
  return {
    periodStart: now.toISOString(),
    periodEnd: periodEnd.toISOString(),
  };
}
```

### Credit Initialization and Reset

- **`initializeCredits(userId, env, plan)`** — creates the initial credit record for a new user (50 credits for free, unlimited for pro).
- **`checkAndResetPeriod(credits, userId, env)`** — if the current date is past `periodEnd`, creates a new billing period and resets credits.
- **`getCredits(userId, env)`** — returns existing credits (with period check) or initializes new ones.

### Free Plan Project Limit

Free-plan users are limited to **3 projects**. The POST route checks this before creating:

```typescript
if (credits.plan === "free") {
  const existingIds =
    (await c.env.METADATA.get<string[]>(`user_projects:${userId}`, "json")) || [];
  const projectCount = existingIds?.length || 0;
  if (projectCount >= FREE_PROJECT_LIMIT) {
    return c.json({
      error: "Free plan is limited to 3 projects",
      code: "project_limit_reached",
      limit: FREE_PROJECT_LIMIT,
      current: projectCount,
    }, 403);
  }
}
```

## POST / — Create Project

The create route generates a unique ID, stores metadata in KV, updates the user's project list, and writes the starter template to R2:

```typescript
projectRoutes.post("/", async (c) => {
  const userId = c.var.userId;
  const body = await c.req.json<{ name: string; model?: string; description?: string }>();

  const sanitizedName = sanitizeProjectName(body.name);
  if (!sanitizedName) return c.json({ error: "Invalid project name", code: "invalid_name" }, 400);

  // Credit / project limit check (see above)

  const projectId = nanoid(12);
  const now = new Date().toISOString();

  const project: Project = {
    id: projectId,
    userId,
    name: sanitizedName,
    model: body.model || "gpt-4o-mini",
    currentVersion: 0,
    createdAt: now,
    updatedAt: now,
  };

  const initialVersion = createInitialVersion(project.name, project.model);

  const existingIds =
    (await c.env.METADATA.get<string[]>(`user_projects:${userId}`, "json")) || [];
  const updatedIds = [projectId, ...existingIds];

  await Promise.all([
    c.env.METADATA.put(`project:${projectId}`, JSON.stringify(project)),
    c.env.METADATA.put(`user_projects:${userId}`, JSON.stringify(updatedIds)),
    c.env.FILES.put(
      `${projectId}/v0/files.json`,
      JSON.stringify({ files: initialVersion.files })
    ),
  ]);

  return c.json({ project }, 201);
});
```

- **`nanoid(12)`** generates a unique 12-character project ID.
- The new project ID is prepended to the existing list so it appears first.
- The default model falls back to `gpt-4o-mini` if none is specified.

## Default Project Template

Create `src/ai/default-project.ts` with the starter files for every new project:

```typescript
export function getDefaultProjectFiles() {
  return [
    { path: "src/App.tsx", content: /* basic React component */ },
    { path: "src/index.tsx", content: /* ReactDOM.createRoot entry */ },
    { path: "src/index.css", content: /* minimal CSS reset */ },
    { path: "package.json", content: /* react, react-dom dependencies */ },
  ];
}

export function createInitialVersion(name: string, model: string) {
  const files = getDefaultProjectFiles();
  return {
    version: 0,
    prompt: "Initial project setup",
    model,
    files,
    changeFiles: files.map((f) => f.path),
    type: "manual",
    createdAt: new Date().toISOString(),
    fileCount: files.length,
  };
}
```

The starter template includes only `react` and `react-dom` as dependencies. Additional packages are added by AI generations later.

## Frontend API Client — Full CRUD Methods

Extend `createAPIClient` with all project operations:

```typescript
export function createAPIClient(getToken: GetTokenFunction) {
  return {
    projects: {
      list: () =>
        authenticatedFetch<{ projects: Project[] }>(getToken, "/api/projects"),
      get: (id: string) =>
        authenticatedFetch<Project>(getToken, `/api/projects/${id}`),
      getFiles: (id: string) =>
        authenticatedFetch<{ files: ProjectFile[]; version: number }>(
          getToken, `/api/projects/${id}/files`
        ),
      create: (data: { name: string; model: string; description: string }) =>
        authenticatedFetch<{ project: Project }>(getToken, "/api/projects", {
          method: "POST",
          body: JSON.stringify(data),
        }),
      update: (id: string, data: { name?: string; model?: string }) =>
        authenticatedFetch<Project>(getToken, `/api/projects/${id}`, {
          method: "PATCH",
          body: JSON.stringify(data),
        }),
      delete: (id: string) =>
        authenticatedFetch<{ success: boolean }>(getToken, `/api/projects/${id}`, {
          method: "DELETE",
        }),
    },
  };
}
```

## Dashboard Page

The dashboard page (`app/dashboard/page.tsx`) is a client component that:

1. **Fetches projects** on mount using `useEffect` and `useCallback`.
2. **Fetches project files** for Sandpack previews in a second `useEffect` that runs when the project list changes.
3. **Shows loading skeletons** while data loads, then either the **EmptyState** or **ProjectGrid**.
4. **Handles create** — opens the `CreateProjectDialog`, calls the API, stores the description in `sessionStorage` as a pending prompt, then navigates to the new project editor.
5. **Handles rename** — uses optimistic updates (update UI immediately, then call API; revert on failure).
6. **Handles delete** — shows a confirmation `AlertDialog` before calling the delete API.

### Optimistic Updates for Rename

```typescript
// Immediately update the UI
setProjects((prev) =>
  prev.map((p) => (p.id === renameTarget ? { ...p, name: trimmed } : p))
);
setRenameTarget(null);

// Then call the API
try {
  const client = createAPIClient(getToken);
  await client.projects.update(renameTarget, { name: trimmed });
  toast.success("Project renamed");
} catch {
  // Revert on failure
  setProjects((prev) =>
    prev.map((p) => (p.id === renameTarget ? { ...p, name: original.name } : p))
  );
  toast.error("Failed to rename project");
}
```

### Session Storage for Pending Prompt

When creating a project with a description, the description is saved to `sessionStorage` before navigating:

```typescript
try {
  sessionStorage.setItem(`pending_prompt:${response.project.id}`, data.description.trim());
} catch {}
router.push(`/project/${response.project.id}`);
```

The editor page reads this on mount and auto-sends it as the first AI prompt, kicking off code generation immediately.

### Toast Notifications

Import `toast` from **Sonner** for success/error notifications throughout the CRUD operations.
