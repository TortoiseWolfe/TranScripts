# Multi-Model Selector — Lovable Clone Tutorial

Adds a model selector component to the chat panel, allowing users to switch between AI models (grouped by provider). The selected model persists per project and updates via the API.

---

## Handle Model Change Callback

In `page.tsx` (project ID page), wrap the model change handler in `useCallback`:

```typescript
const handleModelChange = useCallback(
  async (modelId: string) => {
    setSelectedModelId(modelId);

    // Optimistically update local state
    setProject((prev) => ({
      ...prev,
      modelId,
    }));

    // Persist to backend
    try {
      const client = createApiClient(getToken);
      await client.projects.update(projectId, { model: modelId });
    } catch {
      console.error("Failed to update model");
      toast.error("Failed to update model, try again");
    }
  },
  [getToken, projectId]
);
```

- **Optimistic update**: Sets the selected model immediately in local state.
- **Persistence**: Calls `client.projects.update()` to save the model choice to the backend.
- The `useCallback` dependency array includes `getToken` and `projectId`.
- This callback is passed down to the model selector component automatically via existing props.

---

## Model Selector Component

Create `model-selector.tsx` in the editor components directory.

```typescript
"use client";

interface ModelSelectorProps {
  selectedModelId: string;
  onModelChange: (modelId: string) => void;
  userPlan: "free" | "pro";
  disabled?: boolean;
}
```

### Component Features

- **Speed indicator**: Shows relative speed of the selected model.
- **Quality indicator**: Shows quality rating of the selected model.
- **Popover UI**: Uses a popover (open/close toggle) as the selector dropdown.
- **Grouped models**: Models are organized by **provider** (e.g., Anthropic provides Opus and Sonnet; OpenAI provides GPT-4, GPT-4.5).
- **Display name**: Shows the currently selected model name on the trigger button.
- **Plan gating**: Premium models can be restricted based on `userPlan`.

### Popover Structure

```tsx
<Popover>
  <PopoverTrigger>
    <Button>{displayName}</Button>
  </PopoverTrigger>
  <PopoverContent>
    {groupedModels.map((group) => (
      <div key={group.provider}>
        <h4>{group.provider}</h4>
        {group.models.map((model) => (
          <button
            key={model.id}
            onClick={() => onModelChange(model.id)}
          >
            {model.name}
          </button>
        ))}
      </div>
    ))}
  </PopoverContent>
</Popover>
```

---

## Integration in Chat Panel

In `chat-panel.tsx`, wrap the chat input and model selector together when credits are not exhausted:

```tsx
{!isCreditsExhausted && (
  <div className="border-t border border-opacity-50 bg-card/50 backdrop-blur-sm">
    <div className="px-3 pt-2">
      <ModelSelector
        selectedModelId={selectedModelId}
        onModelChange={onModelChange}
        userPlan={userPlan}
        disabled={isStreaming}
      />
    </div>
    <ChatInput />
  </div>
)}
```

- The model selector sits **above** the chat input inside a styled container.
- It is **disabled during streaming** to prevent model switches mid-generation.
- When credits are exhausted, neither the model selector nor chat input appear (replaced by the upgrade CTA).

---

## Model Persistence

The selected model **persists per project**. When the page reloads, it fetches the saved model from the project data, so the selector reflects the last-chosen model.

---

## Demo: Testing Multi-Model

1. Select a model (e.g., GPT-4.5) from the selector.
2. Refresh the page — the selection persists.
3. Create a new project and choose a different model.
4. Send a prompt and verify the response comes from the selected model.

Example prompt tested: "Create a social media app with dark theme for AI agents. Use Framer Motion for animations. All components should be working and I need responsive ready components for all screens."

The generated app included working UI with animations, responsive layout, and interactive components — all rendered in the Sandpack preview.
