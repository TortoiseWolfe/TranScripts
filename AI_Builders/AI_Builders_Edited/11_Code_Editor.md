# Chapter 11: Code Editor Panel — Lovable Clone Tutorial

**Kishan Sheth — Build a Full Stack Lovable Clone**
Source: SaaS AI Builder series (React 19, Monaco Editor, Cloudflare Workers)

> This chapter builds the code editor panel with Monaco Editor and a recursive file explorer tree, allowing users to browse project files, switch between them, and edit code with syntax highlighting.

---

## Code Editor Panel Setup

Create two new components:
- `components/editor/code-editor-panel.tsx`
- `components/editor/file-explorer.tsx`

Also create `components/editor/editor-skeleton.tsx` as a loading placeholder (same pattern as preview skeleton — Skeleton UI components).

### Dynamic Import

In `page.tsx`, import the code editor panel dynamically to avoid SSR issues with Monaco:

```tsx
const CodeEditorPanel = dynamic(
  () => import("@/components/editor/code-editor-panel"),
  { ssr: false, loading: () => <EditorSkeleton /> }
);
```

### Usage in Page

```tsx
<CodeEditorPanel
  files={files}
  activeFile={activeFile}
  onActiveFileChange={setActiveFile}
  onFileContentChange={(path, content) => {
    setFiles((prev) => ({ ...prev, [path]: content }));
  }}
/>
```

---

## Code Editor Panel Component

### Props Interface

```tsx
export interface CodeEditorPanelProps {
  files: Record<string, string>;
  activeFile: string;
  onActiveFileChange: (filePath: string) => void;
  onFileContentChange: (filePath: string, content: string) => void;
}
```

### Language Detection

A utility function maps file extensions to Monaco language identifiers:

```tsx
function getLanguageFromPath(filePath: string): string {
  const ext = filePath.split(".").pop()?.toLowerCase();
  switch (ext) {
    case "tsx":
    case "ts":
      return "typescript";
    case "jsx":
    case "js":
      return "javascript";
    case "css":
      return "css";
    case "json":
      return "json";
    case "html":
      return "html";
    case "md":
      return "markdown";
    default:
      return "plaintext";
  }
}
```

### File Name Extraction

```tsx
function getFileName(filePath: string): string {
  return filePath.split("/").pop() || filePath;
}
```

### Monaco Editor Configuration

**Editor ref** — stored via `useRef` for programmatic access.

**TypeScript compiler options** — configured in `handleEditorWillMount`:

```tsx
const handleEditorWillMount = useCallback((monaco) => {
  monaco.languages.typescript.typescriptDefaults.setCompilerOptions({
    // JSX, module resolution, strict mode, etc.
  });
  monaco.languages.typescript.typescriptDefaults.setDiagnosticsOptions({
    // Diagnostic settings
  });
}, []);
```

**Editor mount handler** — stores the editor instance in the ref:

```tsx
const handleEditorDidMount = useCallback((editor) => {
  editorRef.current = editor;
}, []);
```

**Change handler** — calls `onFileContentChange` when the user edits code:

```tsx
const handleEditorChange = useCallback((value: string | undefined) => {
  if (value !== undefined) {
    onFileContentChange(activeFile, value);
  }
}, [activeFile, onFileContentChange]);
```

### JSX Layout

```tsx
return (
  <div className="flex h-full">
    {/* File explorer sidebar — hidden on small screens, visible on md+ */}
    <div className="hidden w-52 shrink-0 md:block">
      <FileExplorer
        files={files}
        activeFile={activeFile}
        onFileSelect={onActiveFileChange}
      />
    </div>

    {/* Editor area */}
    <div className="flex-1 flex flex-col">
      {/* Active file tab header */}
      <div>{getFileName(activeFile)}</div>

      {/* Monaco Editor */}
      <Editor
        height="100%"
        language={language}
        value={activeContent}
        theme="vs-dark"
        onChange={handleEditorChange}
        beforeMount={handleEditorWillMount}
        onMount={handleEditorDidMount}
        options={/* editor options */}
      />
    </div>
  </div>
);
```

The **Editor** component is from `@monaco-editor/react`.

---

## File Explorer Component

The file explorer uses a **recursive tree structure** to render folders and files, similar to VS Code's sidebar.

### Tree Node Interface

```tsx
interface TreeNode {
  name: string;
  path: string;
  children?: TreeNode[];
}
```

### Props

```tsx
export interface FileExplorerProps {
  files: Record<string, string>;
  activeFile: string;
  onFileSelect: (filePath: string) => void;
}
```

### Building the File Tree

The `buildFileTree` function converts a flat list of file paths into a nested tree:

1. **Split each path** by `/` to get parts
2. **Traverse the tree** level by level, creating nodes as needed
3. **Leaf nodes** (files) have no `children`; **branch nodes** (folders) have a `children` array

```tsx
function buildFileTree(files: string[]): TreeNode[] {
  const root: TreeNode[] = [];

  for (const filePath of files) {
    const parts = filePath.split("/");
    let currentLevel = root;

    for (let i = 0; i < parts.length; i++) {
      const part = parts[i];
      const isFile = i === parts.length - 1;
      let existingNode = currentLevel.find((node) => node.name === part);

      if (!existingNode) {
        existingNode = isFile
          ? { name: part, path: filePath }
          : { name: part, path: filePath, children: [] };
        currentLevel.push(existingNode);
      }

      if (!isFile && existingNode.children) {
        currentLevel = existingNode.children;
      }
    }
  }

  return sortRecursively(root);
}
```

### Sorting

Two sorting functions ensure consistent display order:

- **`sortTree`** — sorts nodes with folders first, then files, both alphabetically
- **`sortRecursively`** — applies `sortTree` at every level of the tree

```tsx
function sortTree(nodes: TreeNode[]): TreeNode[] {
  return nodes.sort((a, b) => {
    const aIsFolder = !!a.children;
    const bIsFolder = !!b.children;
    if (aIsFolder && !bIsFolder) return -1;
    if (!aIsFolder && bIsFolder) return 1;
    return a.name.localeCompare(b.name);
  });
}
```

### TreeNodeItem Component

A recursive component (~60 lines) that renders each node:

- **Folders:** clickable to expand/collapse, shows `ChevronDown`/`ChevronRight` icon and folder icon
- **Files:** clickable to select, highlights the active file
- **Recursion:** if a folder is open, renders `TreeNodeItem` for each child

```tsx
function TreeNodeItem({ node, depth, activeFile, onFileSelect }) {
  const [isOpen, setIsOpen] = useState(false);
  const isFolder = !!node.children;
  const isActive = node.path === activeFile;

  // Renders folder with chevron + expand/collapse
  // Renders file with highlight if active
  // Recursively renders children if folder is open
}
```

### File Explorer Main Component

```tsx
export function FileExplorer({ files, activeFile, onFileSelect }: FileExplorerProps) {
  const fileTree = buildFileTree(Object.keys(files));

  return (
    <div className="tree-view">
      {fileTree.map((node) => (
        <TreeNodeItem
          key={node.path}
          node={node}
          depth={0}
          activeFile={activeFile}
          onFileSelect={onFileSelect}
        />
      ))}
    </div>
  );
}
```

**Required imports:** `cn` utility (for conditional class names) and `FileText` icon from `lucide-react`.

---

## Panel Visibility and Layout

The code editor panel uses the same **CSS visibility** approach as the preview panel:

- **Code tab active:** `absolute`, `z-10`, `visible`
- **Preview tab active:** `z-0`, `invisible`

This keeps the Monaco editor mounted while switching tabs, preserving cursor position and undo history.

---

## Summary

After this chapter, the code editor is fully functional:
- **Monaco Editor** provides syntax highlighting, TypeScript intellisense, and theme support
- **File Explorer** renders a recursive tree with folders-first sorting
- **Tab switching** between preview and code preserves state in both panels
- **File editing** updates the shared `files` state, which flows to both the code editor and live preview
