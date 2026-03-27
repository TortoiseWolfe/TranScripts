# Chat System — Lovable Clone Tutorial

Covers building the chat panel UI: message bubbles (user, AI with markdown, and system messages), generation progress indicator, chat input with image support (drag-and-drop, paste, file picker), the `handleSendMessage` function with SSE stream reading, and the generation progress component.

---

## Chat Panel Component (`components/editor/chat-panel.tsx`)

### Props Interface

```typescript
export interface ChatPanelProps {
  messages: ChatMessage[];
  isStreaming: boolean;
  onSendMessage: (message: string, images: ImageAttachment[]) => void;
  creditsRemaining: number;
  isCreditsExhausted: boolean;
  selectedModelId: string;
  onModelChange: (modelId: string) => void;
  userPlan: "free" | "pro";
}
```

### Component Structure

- Uses a `ScrollArea` component with auto-scroll to bottom.
- A `useRef` (`messagesEndRef`) tracks the bottom of the message list.
- A `useEffect` scrolls to bottom when messages change or streaming ends via `scrollIntoView({ behavior: "smooth" })`.
- Determines `supportsVision` from the selected model config using `getModelById()`.

### Empty State

When there are no messages, displays a placeholder UI:
- A glowing icon (from lucide-react).
- Text: "What do you want to build? Describe your app and AI will generate working code with a live preview."
- **Suggestion chips** — clickable buttons like "Landing page" that call `onSendMessage(suggestion.label)` to auto-send a prompt.

### Message Rendering

Messages are mapped with the `MessageBubble` component:

```tsx
messages.map((message, index) => (
  <MessageBubble
    key={message.id}
    message={message}
    isStreaming={isStreaming && message.role === "assistant" && index === messages.length - 1}
    isAutoHealInProgress={
      isStreaming && message.role !== "assistant" && index === messages.length - 2
    }
  />
))
```

- **Streaming detection**: The last assistant message is marked as streaming.
- **Auto-heal detection**: If the second-to-last message is a non-assistant message during streaming, auto-heal is in progress.

The `ChatInput` component is placed **outside** the `ScrollArea` so it stays fixed at the bottom.

---

## Message Bubble Component (`components/editor/message-bubble.tsx`)

A client component that renders three types of messages.

### Props

```typescript
export interface MessageBubbleProps {
  message: ChatMessage;
  isStreaming: boolean;
  isAutoHealInProgress: boolean;
}
```

### File Tag Handling

Two regex patterns strip XML file tags from display content:

- **`FILE_TAG_REGEX`** — Matches complete `<file path="...">...</file>` blocks.
- **`PARTIAL_FILE_REGEX`** — Catches incomplete file blocks (from errors or mid-stream).
- **`stripFileTags(content, isStreaming)`** — Removes file tags from the message content so only the explanation text is shown.
- **`hasFileTags(content)`** — Tests if content contains file tags.

### Model Name Formatting

The `formatModelName()` function maps model IDs to display names:

1. Looks up model info via `getModelById()` from `lib/models`.
2. Falls back to string matching: if the ID includes "claude" returns "Claude", "gemini" returns "Gemini", etc.

### Auto-Heal Display

- **`AUTO_HEAL_PREFIX`** = "The app has a build/runtime error."
- **`extractAttemptNumber(message)`** — Parses "attempt X of 3" from auto-heal messages using regex.
- Auto-heal messages display as system-style messages with attempt counter.

### Time Formatting

```typescript
function formatTime(timestamp: string): string {
  return new Date(timestamp).toLocaleString({
    hour: "numeric",
    minute: "2-digit",
  });
}
```

### Message Types

1. **System messages** — Rendered as pill-shaped, centered messages (for auto-heal notifications, version restores).
2. **User messages** — Displayed on the right side with user avatar, message text, and any attached image thumbnails. Clicking an image opens a lightbox.
3. **AI messages** — Displayed on the left with a bot icon and model name. Content is rendered using **ReactMarkdown** with **remark-gfm** for table support. Includes the `GenerationProgress` component during streaming.

---

## Generation Progress Component (`components/editor/generation-progress.tsx`)

A client component that shows real-time progress during AI code generation.

### Props

```typescript
interface GenerationProgressProps {
  content: string;
  isStreaming: boolean;
  changedFiles: string[];
}
```

### File Progress Tracking

```typescript
interface FileProgress {
  path: string;
  status: "generating" | "complete";
}
```

Uses two regex patterns:
- **`FILE_OPEN_REGEX`** — Detects when a `<file>` tag opens (file generation started).
- **`FILE_COMPLETE_REGEX`** — Detects when a `</file>` tag closes (file generation complete).
- **`parseFileProgress(content)`** — Returns an array of `FileProgress` objects.

### Three Phases

1. **Thinking** — Shown when streaming is active but no files detected yet. Displays a `CircuitBoard` icon from lucide-react with text "Thinking... Analyzing your request."
2. **Generating** — Shown when files are being generated. Displays the file list with status indicators and a progress bar.
3. **Done** — Shown when streaming is complete. Displays a summary card with the number of files generated.

---

## Chat Input Component (`components/editor/chat-input.tsx`)

### Props

```typescript
export interface ChatInputProps {
  onSend: (message: string, images: ImageAttachment[]) => void;
  isStreaming: boolean;
  creditsRemaining: number;
  isCreditsExhausted: boolean;
  supportsVision: boolean;
}
```

Default values: `isCreditsExhausted = false`, `supportsVision = false`.

### State

- `value` / `setValue` — text input content.
- `textAreaRef` — ref for the textarea element (auto-focus on mount).
- `fileInputRef` — ref for the hidden file input.
- `attachedImages` / `setAttachedImages` — array of `ImageAttachment` objects.

### Image Constraints

```typescript
const MAX_IMAGES = 5;
const MAX_IMAGE_SIZE = 4 * 1024 * 1024; // 4 MB
const ACCEPTED_TYPES = ["image/png", "image/jpeg", "image/gif", "image/webp"];
```

### Auto-Resize Textarea

A `useEffect` on `value` change dynamically resizes the textarea:

```typescript
textArea.style.height = "auto";
textArea.style.height = `${Math.min(textArea.scrollHeight, 200)}px`;
```

Maximum height is 200px before scrolling.

### Three Image Input Methods

1. **File picker** — A hidden `<input type="file">` triggered by a paperclip button. The paperclip button is only visible when the selected model supports vision. Disabled when `attachedImages.length >= MAX_IMAGES`.

2. **Drag and drop** — The container div has `onDrop={handleDrop}` and `onDragOver={e.preventDefault()}`. `handleDrop` checks `supportsVision`, then filters `dataTransfer.files` for image types and calls `handleFiles`.

3. **Clipboard paste** — `handlePaste` reads `clipboardData.items`, filters for image files, and calls `handleFiles`.

### File Processing Pipeline

```
handleFileSelect / handleDrop / handlePaste
  → handleFiles(files)
    → processFile(file)  // validates type, size, reads as base64
      → setAttachedImages(prev => [...prev, newImage])
```

- **`processFile(file)`** — Validates file type (PNG, JPG, GIF, WebP only) and size (max 4 MB). Reads the file as base64 using `FileReader`. Shows toast on errors.
- **`handleFiles(files)`** — Checks remaining image slots, processes files up to the limit, shows toast if max images reached.
- **`removeImage(index)`** — Removes an image from `attachedImages` by index.

### Image Preview

When images are attached, they are displayed as thumbnails with:
- Image count badge ("1 of 5").
- Remove button (X icon) on each thumbnail.

### Send Logic

- **`isDisabled`** = `isStreaming || isCreditsExhausted`
- **`hasContent`** = `value.trim().length > 0 || attachedImages.length > 0`
- **`handleSend()`** — Trims value, checks not exhausted and not streaming, calls `onSend(trimmedValue, attachedImages)`, then clears value and images.
- **`handleKeyDown`** — Enter key triggers `handleSend`.

### Layout

```
<div> (container with onDrop, onDragOver)
  <div> (styled border with conditional classes)
    [Attached images preview]
    <div> (flex row)
      <input type="file" hidden />  (fileInputRef)
      [Paperclip button if supportsVision]
      <textarea />
      <Button onClick={handleSend}>
        <SendHorizontal />
      </Button>
    </div>
  </div>
</div>
```

---

## Handle Send Message (`page.tsx`)

The `handleSendMessage` function in the smart component orchestrates the full generation flow.

### Function Signature

```typescript
const handleSendMessage = useCallback(
  async (content: string, images: ImageAttachment[], isAutoHeal?: boolean) => { ... }
)
```

### Step-by-Step Flow

1. **Reset auto-heal counter** if this is not an auto-heal request.
2. **Check for older version** — if viewing an old version, switch back to current version first.
3. Set `justGeneratedRef.current = true` (marks this as AI-initiated generation).

4. **Create user message** object:
   ```typescript
   { id: nanoid(), role: "user", content, timestamp: new Date().toISOString(), images }
   ```

5. **Append to messages state** and set `isStreaming = true`.

6. **Create placeholder AI message** with empty content:
   ```typescript
   { id: nanoid(), role: "assistant", content: "", timestamp, model: selectedModelId }
   ```

7. **Append AI message** to messages state.

8. **Get Clerk auth token** and **worker URL**.

9. **POST to worker API**:
   ```typescript
   fetch(`${workerUrl}/api/chat/${projectId}`, {
     method: "POST",
     headers: { Authorization: `Bearer ${token}`, "Content-Type": "application/json" },
     body: JSON.stringify({ message: content, model: selectedModelId, images }),
   })
   ```

10. Handle error responses (throw if no response).

### Reading the SSE Stream

11. Initialize a `ReadableStream` reader and `TextDecoder`.
12. Maintain a `buffer` string for incomplete SSE chunks.
13. **While loop** reads chunks:
    - If `done` is true, break the loop.
    - Decode the chunk and append to buffer.
    - Parse SSE events from the buffer.
    - For `chunk` events: update the AI message content in state.
    - For `done` events: parse the final files data.
    - For `error` events: show error toast.

### Post-Generation

14. Call `refreshVersions()` — re-fetches the version list from the API and updates state.
15. Call `refreshMessages()` — re-fetches chat history.
16. Set `isStreaming = false`.

### refreshVersions

```typescript
const refreshVersions = useCallback(async () => {
  const result = await client.versions.list(projectId);
  setVersions(result.versions);
}, [projectId]);
```

---

## Debugging Notes

- The `isLoading` early return (`if (isLoading) return <EditorLayoutSkeleton />`) must be placed **after** all hooks in the component. Moving it above hooks causes React's "hooks called in different order" error.
- When testing locally, if KV/R2 calls fail with "internal server error," ensure the worker is running with `npx wrangler dev` and that `.dev.vars` has the required environment variables.
- CORS errors between `localhost:3000` (Next.js) and `localhost:8787` (worker) may require checking the CORS middleware configuration in the worker's `index.ts`.
