# Chapter 4: Authentication — Lovable Clone Tutorial

Setting up Clerk JWT authentication on the Cloudflare Workers backend, building an auth middleware with the Jose library, creating an authenticated API client on the frontend, and verifying the full auth flow end to end.

## Clerk Environment Variables

Add the Clerk configuration to the worker's `.dev.vars` file:

```
CLERK_JWKS_URL=<your Clerk JWKS URL>
CLERK_ISSUER=<your Clerk issuer URL>
```

- The **JWKS URL** is found in your Clerk dashboard under Configure > API Keys.
- The **Issuer URL** is the same base URL without the `.well-known/jwks.json` suffix.
- Remove any trailing slash from the issuer URL, or JWT validation will fail.
- Restart the Wrangler dev server after changing `.dev.vars` so the new values load.

## Auth Middleware (Worker)

Create `src/middleware/auth.ts` in the worker project. This middleware validates the Clerk JWT on every `/api/*` request.

### JWKS Caching

Cache the remote JWKS keyset to avoid hammering Clerk on every request:

```typescript
import { createRemoteJWKSet, jwtVerify } from "jose";
import { createMiddleware } from "hono/factory";
import type { AppVariables } from "../types";

let cachedJWKs: ReturnType<typeof createRemoteJWKSet> | null = null;
let cachedJWKsURL: string | null = null;

function getJWKs(jwksURL: string) {
  if (cachedJWKs && cachedJWKsURL === jwksURL) {
    return cachedJWKs;
  }
  cachedJWKs = createRemoteJWKSet(new URL(jwksURL), {
    cooldownDuration: 30000,
    cacheMaxAge: 600000,
  });
  cachedJWKsURL = jwksURL;
  return cachedJWKs;
}
```

- **cooldownDuration** (30 seconds) prevents refetching keys too quickly after a failure.
- **cacheMaxAge** (10 minutes) controls how long cached keys stay valid.

### Middleware Logic

```typescript
export const authMiddleware = createMiddleware<{
  Bindings: Env;
  Variables: AppVariables;
}>(async (c, next) => {
  const authHeader = c.req.header("authorization");

  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    return c.json(
      { error: "Missing or invalid authorization header", code: "unauthorized" },
      401
    );
  }

  const token = authHeader.slice(7);

  try {
    const jwks = getJWKs(c.env.CLERK_JWKS_URL);
    const { payload } = await jwtVerify(token, jwks, {
      issuer: c.env.CLERK_ISSUER,
    });

    const userId = payload.sub as string;
    if (!userId) {
      return c.json({ error: "JWT missing sub claim", code: "unauthorized" }, 401);
    }

    c.set("userId", userId);
    await next();
  } catch (error) {
    const message =
      error instanceof Error ? error.message : "JWT verification failed";
    return c.json({ error: message, code: "unauthorized" }, 401);
  }
});
```

Key points:

- The **Authorization** header is expected in the format `Bearer <token>`.
- `slice(7)` strips the `Bearer ` prefix (7 characters) to extract the raw JWT.
- `jwtVerify` from **Jose** validates the token signature, expiration, and issuer.
- On success, the **user ID** (`sub` claim) is set on the Hono context with `c.set("userId", userId)` so all downstream routes can access it.

### Registering the Middleware

In `src/index.ts`, register the auth middleware for all API routes **after** the health route:

```typescript
import { authMiddleware } from "./middleware/auth";

// Health check (no auth required)
app.get("/health", (c) => c.json({ status: "ok" }));

// Auth middleware applies to all /api/* routes
app.use("/api/*", authMiddleware);

// API routes below this line are protected
app.route("/api/projects", projectRoutes);
```

The wildcard `/api/*` pattern ensures every API endpoint passes through JWT validation. Routes defined above the middleware (like `/health`) are not protected.

## Authenticated API Client (Frontend)

Create `lib/api-client.ts` in the Next.js app. This client attaches the Clerk session token to every backend request.

### Configuration

```typescript
export const WORKER_URL =
  process.env.NEXT_PUBLIC_WORKER_URL || "http://localhost:8787";

export interface APIError {
  error: string;
  code: string;
}

type GetTokenFunction = () => Promise<string | null>;
```

### Authenticated Fetch Wrapper

```typescript
async function authenticatedFetch<T>(
  getToken: GetTokenFunction,
  path: string,
  options?: RequestInit
): Promise<T> {
  const token = await getToken();
  if (!token) {
    throw new Error("Not authenticated — no session token available");
  }

  const response = await fetch(`${WORKER_URL}${path}`, {
    ...options,
    headers: {
      "Content-Type": "application/json",
      Authorization: `Bearer ${token}`,
      ...options?.headers,
    },
  });

  if (!response.ok) {
    const errorBody: { error: string; retryAfter?: number } =
      await response.json().catch(() => ({
        error: "Unknown error",
      }));

    // Rate limiting: dispatch a custom event so the UI can show a banner
    if (response.status === 429) {
      const retryAfter = errorBody.retryAfter ?? 60;
      window.dispatchEvent(
        new CustomEvent("rate-limited", { detail: { retryAfter } })
      );
    }

    throw new Error(errorBody.error || `Request failed with status ${response.status}`);
  }

  return response.json() as Promise<T>;
}
```

- The **Clerk token** is obtained via the `getToken` function from `useAuth()`.
- Every request includes `Authorization: Bearer <token>` and `Content-Type: application/json`.
- **429 responses** dispatch a `rate-limited` custom event on the window so the UI can display a retry banner.

### API Client Factory

```typescript
export function createAPIClient(getToken: GetTokenFunction) {
  return {
    projects: {
      list: () =>
        authenticatedFetch<{ projects: Project[] }>(
          getToken,
          "/api/projects"
        ),
    },
  };
}
```

Additional methods (`get`, `getFiles`, `create`, `update`, `delete`) are added in later chapters as the CRUD routes are built.

## Testing the Auth Flow

To verify authentication works end to end:

1. Sign in on the frontend at `localhost:3000` (Clerk stores the session token in cookies).
2. Call the API from a client component using `useAuth()` to get the token.
3. The worker logs should show the auth header, extracted token, and user ID.
4. Hitting `/api/projects` directly in the browser (without a token) returns a 401 "Missing or invalid authorization header" error.

The frontend must call the API through the authenticated client — direct browser requests to `localhost:8787/api/*` will fail because no Clerk session cookie is sent cross-origin.

## Project Routes Scaffold (Worker)

Create `src/routes/project.ts` to hold all project-related API routes:

```typescript
import { Hono } from "hono";
import type { Env, AppVariables } from "../types";

export const projectRoutes = new Hono<{
  Bindings: Env;
  Variables: AppVariables;
}>();
```

### GET / — List All Projects

```typescript
projectRoutes.get("/", async (c) => {
  const userId = c.var.userId;

  const projectIds =
    (await c.env.METADATA.get<string[]>(`user_projects:${userId}`, "json")) ||
    [];

  if (!projectIds || projectIds.length === 0) {
    return c.json({ projects: [] });
  }

  const projects = await Promise.all(
    projectIds.map((id) =>
      c.env.METADATA.get<Project>(`project:${id}`, "json")
    )
  );

  const validProjects = projects
    .filter((p): p is Project => p !== null)
    .sort(
      (a, b) =>
        new Date(b.updatedAt).getTime() - new Date(a.updatedAt).getTime()
    );

  return c.json({ projects: validProjects });
});
```

- Project IDs are stored as a JSON array under the key `user_projects:<userId>` in **Cloudflare KV**.
- Each project's metadata is fetched individually by key `project:<projectId>`.
- Null entries (corrupted data) are filtered out, and results are sorted newest first.

## Project Type Definition (Worker)

Create `src/types/project.ts` with the shared project interface. This type is used by both the worker routes and the frontend:

```typescript
export interface Project {
  id: string;
  userId: string;
  name: string;
  model: string;
  currentVersion: number;
  createdAt: string;
  updatedAt: string;
}
```

The same interface is also defined on the frontend side in the Next.js `types/` directory.
