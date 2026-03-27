# AI Engine — Lovable Clone Tutorial

Covers the system prompt design, file parser for AI responses, Vercel AI SDK integration with multi-model support, model registry configuration, API key setup, the chat POST route with credit checking, SSE streaming, and credit deduction.

---

## System Prompt (`worker/src/ai/system-prompt.ts`)

The system prompt instructs the AI on how to generate code. It is built from a **base prompt** plus **existing file context**.

### Base Prompt Structure

The prompt tells the AI:

- **Role**: "You are an expert React TypeScript developer."
- **Tech stack**: React, TypeScript, Tailwind CSS, functional components with hooks, default exports.
- **Output format**: Return code in **XML-style tags**, not markdown fences.

```xml
<file path="src/App.tsx">
  // actual code here
</file>
```

- **Code quality and token efficiency** guidelines.
- **Styling guidelines** for how the application should be styled.
- **App completeness**: Generate complete, working applications.

### Mock Data Rules

- Never use placeholder text like "Product 1" or "Item One."
- Generate **realistic mock data** that looks production-ready.
- Use placeholder images from **Pix Photos** for product images.
- Use avatar services for user avatars.
- Provide fallback image URLs.

### Dependencies

The prompt specifies which packages to use:

| Purpose | Package |
|---------|---------|
| Icons | `lucide-react` |
| Routing | `react-router-dom` |
| Charts/Analytics | `recharts` |
| Date manipulation | `date-fns` |
| Animations | `framer-motion` |
| UI Components | shadcn/ui |

These dependencies should be injected into `package.json` when used. To swap UI libraries (e.g., Material UI), update the prompt's dependency and design pattern sections.

### Iteration Rules

- When modifying an existing project, **only output files that changed** — do not re-output unchanged files.
- Package.json rules for how dependencies should be added (dev vs. production).

### Existing File Context

The `formatExistingFilesContext()` function wraps all current project files in XML tags:

```xml
<existing-files>
  <file path="src/App.tsx">
    // existing code
  </file>
  <file path="src/components/Header.tsx">
    // existing code
  </file>
</existing-files>
```

This tells the AI which files already exist so it only outputs changed files on re-prompts.

### Building the System Prompt

```typescript
function buildSystemPrompt(existingFiles: ProjectFile[]): string {
  const fileContext = formatExistingFilesContext(existingFiles);
  return basePrompt + fileContext;
}
```

### Chat History

- **MESSAGE_PASS** — controls how many old messages to send to the AI for context.
- **prepareChatHistory()** — gets recent chat messages where the role is "assistant" and returns them for context.

---

## File Parser (`worker/src/ai/file-parser.ts`)

Parses the AI's XML-formatted response into individual files.

### File Tag Regex

The regex matches the XML file tags:

- **Opening tag**: `<file path="...">` — capture group 1 is the file path.
- **Content**: Everything between tags — capture group 2 is the file content.
- **Closing tag**: `</file>` with newline.
- The `g` flag matches all file blocks in the response.

### Key Functions

- **`stripMarkdownFences(content)`** — Removes triple-backtick code fences as a fallback, since some AI models return markdown format despite being told not to.

- **`parseFilesFromResponse(response)`** — Iterates through all regex matches, extracts path and content, strips markdown fences, validates the file path, and pushes to the files array.

- **`validateFilePath(path)`** — Checks that the file path is valid (no traversal attacks, proper format).

- **`mergeFiles(existingFiles, newFiles)`** — Used when re-prompting. Merges new AI-generated files with existing project files using a Map data structure. Changed files are updated; unchanged files are preserved.

- **`extractExplanation(response)`** — Extracts the AI's text explanation (non-code content) from the response.

---

## Vercel AI SDK Setup

The **Vercel AI SDK** (`ai` package) acts as an ORM for AI models — write code once and swap models without changing application logic.

### Installation

Run inside the `worker/` directory:

```bash
npm install ai @ai-sdk/anthropic @ai-sdk/openai @ai-sdk/google @ai-sdk/deepseek
```

Add only the providers you need. The AI SDK supports many providers including xAI, Groq, ElevenLabs, and more. See the [AI SDK providers documentation](https://sdk.vercel.ai/providers).

**Note**: The tutorial uses custom SSE (server-sent events) instead of the SDK's built-in streaming UI for better compatibility with Hono and more customization (e.g., sending images in chat).

### Wrangler Compatibility Flag

Add to `wrangler.json` after the compatibility date:

```json
{
  "compatibility_flags": ["nodejs_compat"]
}
```

The `nodejs_compat` flag is required because the Vercel AI SDK uses Node.js APIs internally (like `crypto` for request signing), and Cloudflare Workers need this flag to provide those APIs.

### Running the Worker Locally

```bash
npx wrangler dev
```

For local testing, update the API client to use `http://localhost:8787` instead of the deployed URL.

---

## Multi-Model Support (`worker/src/ai/router/index.ts`)

### Model Config Interface

```typescript
interface ModelConfig {
  provider: string;      // "anthropic" | "openai" | "google" | "deepseek"
  displayName: string;
  apiModelId: string;    // actual API model identifier
  creditCost: number;    // cost in app credits per generation
  tier: "fast" | "premium";
  speed: string;
  quality: string;
  description: string;
  supportsVision: boolean;
  maxOutputTokens: number;
}
```

### Model Registry

A const object mapping model IDs to their configurations:

| Model | Provider | Credits | Tier | Vision | Max Tokens |
|-------|----------|---------|------|--------|------------|
| Claude 3.5 Sonnet | Anthropic | 2 | Premium | Yes | 16,384 |
| GPT-4o-mini | OpenAI | 1 | Fast | Yes | — |
| Gemini | Google | — | — | Yes | — |
| DeepSeek V3 | DeepSeek | — | Fast | **No** | 8,192 |
| DeepSeek R1 | DeepSeek | — | — | **No** | 16,384 |

**Key detail**: DeepSeek models do **not** support vision (image input). All other models do.

### Default Model

```typescript
export const DEFAULT_MODEL = "gpt-4o-mini";
```

### getModel Function

```typescript
export function getModel(model: string, env: Env): LanguageModel {
  const config = modelRegistry[model];
  if (!config) throw new Error("Unknown model");

  switch (config.provider) {
    case "anthropic":
      return createAnthropic({ apiKey: env.ANTHROPIC_API_KEY })(config.apiModelId);
    case "openai":
      return createOpenAI({ apiKey: env.OPENAI_API_KEY })(config.apiModelId);
    case "google":
      return createGoogleGenerativeAI({ apiKey: env.GOOGLE_API_KEY })(config.apiModelId);
    case "deepseek":
      return createDeepSeek({ apiKey: env.DEEPSEEK_API_KEY })(config.apiModelId);
    default:
      throw new Error(`Provider not implemented: ${config.provider}`);
  }
}
```

**Important**: In Cloudflare Workers, use `env.ANTHROPIC_API_KEY` (from Hono's env), not `process.env.ANTHROPIC_API_KEY`. The `process.env` pattern does not work in Workers.

---

## API Key Setup

API keys are stored as environment variables in the worker's `.dev.vars` file (for local development):

```
OPENAI_API_KEY=sk-...
GOOGLE_API_KEY=...
DEEPSEEK_API_KEY=...
ANTHROPIC_API_KEY=...
```

### Cost Estimates

- **DeepSeek**: ~$0.04/month during development. Minimum top-up is $2. Very cheap but does not support images.
- **OpenAI**: ~$5 minimum credit purchase. Cheap for GPT-4o-mini.
- **Google Gemini**: Requires a larger minimum commitment (~$200). [REVIEW: exact minimum may vary]
- **Anthropic Claude**: ~$1-2/month during development for Sonnet/Haiku. Higher quality output.

You only need **one provider** to get started. DeepSeek or OpenAI are the cheapest options.

---

## Sanitization (`services/sanitize.ts`)

Input validation functions:

- **`MAX_PROJECT_NAME_LENGTH`** = 100
- **`MAX_MESSAGE_CHAT_LIMIT`** = 10,000
- **`sanitizeProjectName(name)`** — Cleans project name input.
- **`sanitizeChatMessage(message)`** — Cleans chat message input.
- **`isValidModelId(modelId)`** — Validates against the model registry.

---

## Chat POST Route (`routes/chat.ts`)

The main AI generation endpoint: `POST /:projectId`

### Request Validation

1. Extract `userId` from auth context, `projectId` from params.
2. Parse request body: `message` (string), `model` (string), `images` (ImageAttachment[]).
3. Sanitize the user message — return 400 if empty.
4. Default to `DEFAULT_MODEL` if no model specified.
5. Validate images: max **5 images**, each under **4 MB**.
6. Look up model config from registry — return error if invalid.

### Ownership Check

7. Fetch project from KV metadata.
8. Return 404 if project not found.
9. Return 401 if `project.userId !== userId`.

### Credit Check

```typescript
const creditCheck = await checkCredits(userId, modelConfig.creditCost, c.env);
```

10. If the model tier is "premium" and user plan is "free", return error: "This model is only available for pro users."
11. If `creditCheck.allowed` is false, return error: "You have exhausted your credits" with remaining/required counts.

### Load Existing Project

12. Fetch current version files from R2: `{projectId}/v{currentVersion}/files.json`.
13. Parse as `Version` type to get existing files.

### Build AI Context

14. Fetch chat session from KV: `chat:{projectId}`.
15. Build system prompt with `buildSystemPrompt(existingFiles)`.
16. Filter chat history (skip system messages), map to `{ role, content }`.
17. Trim history with `prepareChatHistory()`.
18. Map to SDK message format (`CoreMessage` from `ai` package).
19. Append image attachments to the user message if present.

### Stream AI Response (SSE)

20. Call `streamText()` from the `ai` package with model, system prompt, messages, and max output tokens.
21. For each chunk in the text stream, send an SSE event of type `"chunk"` with the text content.
22. After streaming completes, parse files from the full response using `parseFilesFromResponse()`.
23. Merge new files with existing files using `mergeFiles()`.

### Store New Version in R2

24. Create a new version object and store in R2 at `{projectId}/v{newVersion}/files.json`.
25. Update project metadata in KV with the new current version number.

### Deduct Credits

```typescript
// services/credits.ts
const UNLIMITED_CREDITS = -1;

async function deductCredits(userId, creditCost, env) {
  const credits = await getCredits(userId, env);
  if (credits.remaining === UNLIMITED_CREDITS) return credits; // don't deduct
  const newRemaining = credits.remaining - creditCost;
  // update KV store with new remaining credits
  return updatedCredits;
}
```

26. If credits are unlimited (-1), skip deduction.
27. Otherwise, subtract credit cost from remaining and update KV store.

### Save Chat Messages

28. Save the user message and AI response to the chat session in KV.

### Send Final Event

29. Send SSE event of type `"done"` with the generated files data.
30. If any error occurs during the process, send SSE event of type `"error"`.

---

## SSE Event Types

| Event | Data | When |
|-------|------|------|
| `chunk` | Text content | During AI streaming |
| `done` | Files array | Generation complete |
| `error` | Error message | Any failure |
