# Chapter 3: Project Bootstrap — Lovable Clone Tutorial

Setting up the full project from scratch: Next.js 16 frontend with all dependencies, Clerk authentication, shadcn/ui components, route structure, TypeScript types, and Cloudflare Workers backend with Hono.

## Tech Stack Choices

| Technology | Purpose |
|-----------|---------|
| **Next.js 16** (React 19) | Frontend framework |
| **Cloudflare Workers** | Backend (edge-deployed) |
| **Cloudflare R2** | File storage |
| **Cloudflare KV** | Key-value metadata store |
| **shadcn/ui** | Component library |
| **Clerk** | Authentication and billing |

## Why Next.js

Next.js 16 (with React 19) provides:

- **App Router** — file-based routing with layouts (no need for react-router-dom)
- **Server Components** — no JavaScript shipped to browser; everything compiled on the server
- **Middleware** — intercept requests to check authentication before page loads
- **Server Actions** — backend handling (though this project uses Cloudflare Workers instead)

## Frontend Setup

### Create the Next.js App

```bash
npx create-next-app@latest next-lovable-clone
```

Accept the recommended settings (Tailwind CSS, TypeScript).

### Install Radix UI Primitives

```bash
npm install @radix-ui/react-dialog @radix-ui/react-avatar @radix-ui/react-dropdown-menu @radix-ui/react-label @radix-ui/react-popover @radix-ui/react-progress @radix-ui/react-scroll-area @radix-ui/react-select @radix-ui/react-separator @radix-ui/react-slot @radix-ui/react-tooltip
```

These are the headless primitive components used by shadcn/ui.

### Install Styling Utilities

```bash
npm install class-variance-authority clsx tailwind-merge
```

- **class-variance-authority (CVA)** — manage CSS class name variants cleanly
- **clsx** — conditionally join class names
- **tailwind-merge** — merge Tailwind classes without conflicts

### Install UI Libraries

```bash
npm install lucide-react sonner next-themes
```

- **lucide-react** — icon library
- **sonner** — toast notifications
- **next-themes** — light/dark mode management

### Install Editor and Preview

```bash
npm install @codesandbox/sandpack-react @monaco-editor/react
```

- **Sandpack** — bundles React components, compiles TypeScript, and renders the preview in an iframe within the browser
- **Monaco Editor React** — the same editor that powers VS Code

### Install Clerk

```bash
npm install @clerk/nextjs @clerk/themes
```

- **@clerk/nextjs** — Clerk SDK for authentication
- **@clerk/themes** — theme switching for Clerk widgets (dark/light mode)

### Install Markdown Rendering

```bash
npm install react-markdown remark-gfm
```

Used to render AI responses (which contain markdown) in the chat panel.

### Install SSE Parser

```bash
npm install eventsource-parser
```

Parses **Server-Sent Events** from the AI code streaming endpoint. Could be done manually, but this library simplifies event parsing.

### Install shadcn/ui

```bash
npx shadcn@latest init
```

Select **Radix** as the component library and **lucide** icons as the preset.

**Why shadcn/ui**: Components are installed directly into your project's `components/ui/` directory (not hidden in node_modules). You can fully customize every component, add variants, and modify styles.

### Add shadcn Components

```bash
npx shadcn@latest add button card dialog dropdown-menu input label popover progress scroll-area select separator skeleton textarea tooltip badge alert-dialog avatar
```

### Global CSS

Replace the default `globals.css` with Lovable's theming styles (custom CSS variables for animations, themes, and color tokens). The source is provided in the video description.

### Utils File

The `lib/utils.ts` file exports a `cn()` function combining `tailwind-merge` and `clsx`:

```typescript
import { twMerge } from "tailwind-merge";
import { clsx, type ClassValue } from "clsx";

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}
```

## Layout Configuration

In `app/layout.tsx`:

- Update metadata title to "Lovable Clone" with an appropriate description
- Add the Lovable heart SVG as the app icon (scrape from lovable.dev)
- Add `suppressHydrationWarning` to the `<html>` tag
- Wrap children with a `<Providers>` component

## Providers Component

Create `components/providers.tsx` as a client component that wraps the app with:

1. **ThemeProvider** — custom context for dark/light/system theme preference stored in `localStorage`
2. **ClerkWithTheme** — Clerk provider that passes the current theme to Clerk widgets

### ThemeProvider

A custom React context that:

- Stores theme preference (`dark`, `light`, `system`) in **localStorage**
- Resolves `system` theme using CSS `prefers-color-scheme` media query
- Applies theme class to `document.documentElement`

### ClerkWithTheme

Wraps `<ClerkProvider>` with an `appearance` prop that passes `dark` theme (from `@clerk/themes`) when the app is in dark mode.

## Route Structure

### Route Groups

```
app/
  (marketing)/
    page.tsx              # Landing page
  (auth)/
    sign-in/[[...sign-in]]/
      page.tsx            # Clerk sign-in (catch-all route)
    sign-up/[[...sign-up]]/
      page.tsx            # Clerk sign-up (catch-all route)
    layout.tsx            # Auth layout (centered, dark background)
  (app)/
    layout.tsx            # App layout (sidebar, rate limit banner)
    dashboard/
      page.tsx            # Dashboard page
    analytics/
      page.tsx            # Analytics page
    project/
      [projectId]/
        page.tsx          # Project editor (dynamic route)
    settings/
      [[...rest]]/
        page.tsx          # Settings (catch-all for Clerk billing widget)
```

### Auth Layout

The auth layout is a simple centered flex container:

```tsx
<div className="flex min-h-screen items-center justify-center bg-zinc-950">
  {children}
</div>
```

### Auth Pages

The sign-in and sign-up pages simply render Clerk's `<SignIn />` and `<SignUp />` components.

## Clerk Configuration

### Environment Variables

Create `.env.local` with:

```
NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=pk_test_...
CLERK_SECRET_KEY=sk_test_...
NEXT_PUBLIC_CLERK_SIGN_IN_URL=/sign-in
NEXT_PUBLIC_CLERK_SIGN_UP_URL=/sign-up
NEXT_PUBLIC_CLERK_AFTER_SIGN_IN_URL=/dashboard
NEXT_PUBLIC_CLERK_AFTER_SIGN_UP_URL=/dashboard
```

Get the API keys from **Clerk dashboard > Configure > API Keys**.

### Middleware

Create `middleware.ts` in the project root:

```typescript
import { clerkMiddleware, createRouteMatcher } from "@clerk/nextjs/server";

const isProtectedRoute = createRouteMatcher([
  "/dashboard(.*)",
  "/project(.*)",
  "/settings(.*)",
]);

export default clerkMiddleware(async (auth, request) => {
  if (isProtectedRoute(request)) {
    await auth.protect();
  }
});
```

This protects the dashboard, project, and settings routes. Unauthenticated users are redirected to sign-in.

## TypeScript Types

Create a `types/` directory with three files:

### `types/analytics.ts`

- **ModelUsage** — breakdown per AI model (model ID, name, count, percentage)
- **ActivityItem** — activity log entry (type: `ai_generation` | `manual_edit` | `restore`, project name, project ID, model, prompt, timestamp)
- **ProjectStat** — per-project statistics (project ID, name, version count, AI generations, last activity)
- **AnalyticsData** — aggregate user analytics (total projects, generations, manual edits, restores)

### `types/chat.ts`

- **ImageAttachment** — base64-encoded image with media type, description, and name
- **ChatMessage** — message with role (`user` | `assistant` | `system`), content, timestamp, version number, model, changed files, images
- **ChatSession** — contains project ID, all messages, and timestamps

### `types/project.ts`

- **Project** — project metadata (name, user ID, model, current version)
- **ProjectFile** — file path and content
- **VersionDetails** — full version data including all files, prompt, model, change files, type (`ai` | `manual` | `restore`), timestamps
- **VersionMeta** — lightweight version metadata for the timeline (file count and change files only, no full file contents)

## Cloudflare Workers Backend Setup

### Initialize the Worker

```bash
mkdir worker
cd worker
npm init -y
```

### Install Runtime Dependencies

```bash
npm install hono jose nanoid fflate
```

- **Hono** — ultra-light web framework for edge runtimes (~14 KB), similar to Express.js but designed for Cloudflare Workers
- **jose** — JSON Object Signing and Encryption; used to verify Clerk's JWT on the backend
- **nanoid** — generates short, unique, URL-safe IDs (used instead of UUIDs)
- **fflate** — JavaScript zip compression for project export

### Install Dev Dependencies

```bash
npm install -D wrangler typescript @cloudflare/workers-types
```

- **Wrangler** — Cloudflare CLI (like Vercel CLI but for Workers)

### Worker Directory Structure

```
worker/
  src/
    index.ts          # Hono app entry point
    types.ts          # Environment and variable types
    ai/               # AI generation providers
    middleware/        # Auth middleware
    routes/           # API route handlers
    services/         # Business logic
  wrangler.jsonc      # Cloudflare configuration
  tsconfig.json
  .dev.env            # Local environment variables
```

### Wrangler Configuration

Create `wrangler.jsonc`:

```jsonc
{
  "$schema": "node_modules/wrangler/config/schema.json",
  "name": "lovable-clone",
  "main": "src/index.ts",
  "compatibility_date": "2025-01-01",
  "kv_namespaces": [
    {
      "binding": "METADATA",
      "id": "<your-kv-id>"
    }
  ],
  "r2_buckets": [
    {
      "binding": "FILES",
      "bucket_name": "lovable-clone-files"
    }
  ]
}
```

Create KV namespace with:

```bash
npx wrangler kv namespace create METADATA
```

For local development, the KV ID can be any value. Update with the real ID before deploying.

### Worker Types

`src/types.ts` defines the environment bindings:

```typescript
export interface Env {
  METADATA: KVNamespace;
  FILES: R2Bucket;
  CLERK_ISSUER: string;
  CLERK_JWKS_URL: string;
  // AI API keys
  FRONTEND_URL: string;
  CLERK_WEBHOOK_SECRET: string;
}

export interface AppVariables {
  userId: string;
}
```

### Hono App Entry Point

`src/index.ts` initializes the Hono app with CORS:

```typescript
import { Hono } from "hono";
import { cors } from "hono/cors";

const app = new Hono<{ Bindings: Env; Variables: AppVariables }>();

// CORS middleware
app.use("*", async (c, next) => {
  const allowedOrigins = c.env.FRONTEND_URL || "http://localhost:3000";
  const middleware = cors({
    origin: [allowedOrigins],
    allowMethods: ["GET", "POST", "PUT", "DELETE", "OPTIONS", "PATCH"],
    allowHeaders: ["Content-Type", "Authorization"],
    maxAge: 600,
    credentials: true,
  });
  return middleware(c, next);
});

// Health check
app.get("/health", (c) => {
  return c.json({ status: "ok", timestamp: new Date() });
});

export default app;
```

### Start the Worker Locally

```bash
npx wrangler dev
```

The worker serves on `http://localhost:8787`. Verify with:

```
GET http://localhost:8787/health
→ { "status": "ok", "timestamp": "..." }
```

## Bootstrap Complete

At this point both services are running:

- **Frontend**: `http://localhost:3000` (Next.js with Clerk auth, route protection, dark mode)
- **Backend**: `http://localhost:8787` (Hono on Cloudflare Workers with CORS and health check)

The next chapter covers wiring up Clerk JWT verification on the backend and building the authentication flow between frontend and worker.
