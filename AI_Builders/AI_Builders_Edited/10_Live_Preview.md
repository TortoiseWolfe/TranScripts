# Chapter 10: Live Preview Panel — Lovable Clone Tutorial

**Kishan Sheth — Build a Full Stack Lovable Clone**
Source: SaaS AI Builder series (React 19, Sandpack, Cloudflare Workers)

> This chapter implements the live preview panel using Sandpack, including the SandpackProvider configuration, error listening, the preview skeleton loader, and a "Built with Lovable" badge overlay.

---

## Preview Panel Component

Create `components/editor/preview-panel.tsx` as a client component.

### Props Interface

```tsx
export interface PreviewPanelProps {
  files: Record<string, string>;
  onError: (error: { message: string }) => void;
}
```

### Extract Dependencies Function

This function reads `package.json` from the project files and merges its dependencies with base dependencies (React, ReactDOM).

```tsx
function extractDependencies(files: Record<string, string>) {
  const baseDependencies = { react: "latest", "react-dom": "latest" };
  const packageJsonContent = files["package.json"];
  if (!packageJsonContent) return baseDependencies;
  const parsed = JSON.parse(packageJsonContent);
  return { ...baseDependencies, ...parsed.dependencies };
}
```

### Convert Files to Sandpack Format

The `toSandpackFiles` function removes trailing slashes from file paths to match Sandpack's expected format. This was previously implemented in `project-preview` and is reused here.

### Error Listener Component

The **ErrorListener** component uses Sandpack's internal hooks to subscribe to compilation errors.

- Uses `useSandpack` from `@codesandbox/sandpack-react`
- Creates a `useRef` for tracking the last error
- Subscribes to the error message bus via `useEffect`
- Calls the `onError` callback when errors are detected
- Returns `null` (renders nothing visually)

### Lovable Badge Component

A simple overlay component that renders a "Built with Lovable" image linking back to the dashboard.

```tsx
function LovableBadge() {
  // useState for visibility
  // Renders an <a> tag linking to /dashboard
  // Displays "Built with Lovable" image
}
```

### Main Preview Panel Return

```tsx
export function PreviewPanel({ files, onError }: PreviewPanelProps) {
  const sandpackFiles = toSandpackFiles(files);
  const dependencies = extractDependencies(files);

  return (
    <div className="sandpack-stretch" style={{ height: "100%", width: "100%" }}>
      <SandpackProvider template="react" theme={/* theme config */} files={sandpackFiles}
        options={/* options */} customSetup={{ dependencies }}>
        {onError && <ErrorListener onError={onError} />}
        <SandpackLayout style={{ height: "100%", border: "none", borderRadius: 0 }}>
          <SandpackPreview
            showNavigator
            showRefreshButton
            showOpenInCodeSandbox={false}
            actionsChildren={<LovableBadge />}
            style={{ height: "100%" }}
          />
        </SandpackLayout>
      </SandpackProvider>
    </div>
  );
}
```

**Key Sandpack configuration:**
- **Template:** `react`
- **Theme:** custom dark theme
- **SandpackPreview:** shows navigator and refresh button, hides "Open in CodeSandbox", adds Lovable badge as action child

---

## Integrating Preview Panel into the Page

In `page.tsx`, import the preview panel **dynamically** to avoid SSR issues with Sandpack.

### Dynamic Import with Skeleton

```tsx
import dynamic from "next/dynamic";

const PreviewPanel = dynamic(
  () => import("@/components/editor/preview-panel"),
  { ssr: false, loading: () => <PreviewSkeleton /> }
);
```

### Preview Skeleton

Create `components/editor/preview-skeleton.tsx` — a simple component that renders Skeleton UI placeholders while Sandpack loads.

### Usage in Page

```tsx
<PreviewPanel
  files={files}
  onError={handleSandpackError}
/>
```

The `handleSandpackError` function supports the **autoheal** feature (covered in a later chapter), which automatically fixes compilation errors by sending them back to the AI.

---

## Tab Visibility

The preview panel uses CSS visibility toggling based on the active tab:

- **Preview tab active:** `z-10`, `visible`
- **Code tab active:** `z-0`, `invisible`

This approach keeps the Sandpack instance mounted (preserving state) while visually switching between preview and code views.

---

## Dark Theme

Switching the Sandpack theme to dark mode is done through the theme configuration passed to `SandpackProvider`. The auto-scroll-to-bottom behavior in the chat panel also needed a fix at this point.

---

## Summary

After this chapter, the live preview panel is fully functional:
- Sandpack renders the project files in an iframe
- Dependencies are extracted from `package.json` automatically
- Compilation errors are captured and surfaced via the error listener
- The preview skeleton provides a loading state during dynamic import
- Tab switching between preview and code editor preserves Sandpack state
