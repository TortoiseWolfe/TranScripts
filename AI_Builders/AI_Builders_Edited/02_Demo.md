# Chapter 2: Feature Demo — Lovable Clone Tutorial

A walkthrough of the finished Lovable clone demonstrating every feature: project creation, AI generation, code editing, version history, billing, image-to-UI, auto-heal, analytics, export, and Cloudflare storage.

## Landing Page and Authentication

The app has a landing page with **Clerk login**. Users authenticate via Google through Clerk's sign-in flow.

## Project Dashboard

After login, the dashboard shows all projects with live previews. From the dashboard you can:

- View existing projects and their previews
- Create new projects
- Access the **sidebar** with Dashboard, Analytics, and Settings sections

## Credit System

The app runs on a **credit-based SaaS model** linked to Clerk:

- **Free plan**: 50 credits per month, limited to free-tier models
- **Pro plan**: Unlimited credits, access to all models
- Higher-tier models cost **2 credits** per generation; lower-tier models cost **1 credit**

## Creating a Project

1. Click "Create New Project" from the dashboard
2. Select an AI model (e.g., DeepSeek V3)
3. Enter a prompt (e.g., "Create a Netflix clone with demo data, make the UI just like Netflix")
4. Hit Create — the AI begins generating files via **Cloudflare Workers**

## Editor Layout

The editor has three resizable panels:

- **Chat interface** (left) — shows all messages; uses **Server-Sent Events (SSE)** for live code streaming
- **Preview panel** (center) — live Sandpack preview with responsive size testing (desktop, tablet, mobile)
- **Code panel** (right) — full **Monaco editor** (same as VS Code) showing all generated files

Additional panels:

- **History** — version timeline with file diffs
- **Credits** — current plan and usage
- **Settings** — appearance (light/dark mode)

## Version History and Diffs

Each AI generation creates a new version. The history panel shows:

- **Version 0**: Initial project setup (basic React app scaffolding)
- **Version 1+**: Each prompt creates a numbered version

You can **diff any version** to see file-by-file changes (added, modified, deleted). You can also **restore to any earlier version**.

## Billing with Clerk

Upgrading to Pro uses Clerk's payment gateway:

- Subscribe monthly or annually
- Pay with test card through Clerk's hosted checkout
- Subscription appears in the **Clerk dashboard** under billing
- Credits become unlimited on Pro

## Image-to-UI Generation

On vision-capable models (not DeepSeek), you can:

1. Paste or upload up to **5 images** directly into the chat
2. Prompt: "Create UI like this"
3. The AI generates components matching the reference image

This works with screenshots from Dribbble or any UI reference.

## Auto-Heal Feature

When generated code produces an error:

1. The app **automatically detects** the error
2. The AI attempts to **fix the error automatically**
3. Up to **3 auto-heal attempts** are made
4. If auto-heal fails, you can manually prompt "Fix the error"

## CodeSandbox Export

Click the preview button to generate a **CodeSandbox URL** where the app is deployed and publicly accessible. This requires the Pro plan.

## Zip Export

Export all project files as a **zip file** handled by the Cloudflare Worker. All source files are included.

## Analytics Dashboard

The analytics page shows:

- Total AI generations
- Total projects
- Credits used
- Model usage breakdown
- Recent activities across projects

## Settings

The settings page provides access to Clerk's account widget:

- Security and active devices
- Billing details, statements, and payments
- Cancel subscription or change payment method

## Cloudflare Storage Architecture

### R2 Bucket (File Storage)

Project files are stored in R2 organized by project ID and version number:

```
projects/{projectId}/version/{versionNumber}/files.json
```

The `files.json` file contains:

- The **model** used for that version
- An array of objects with **file path** and **file content**

This JSON gets sent to CodeSandbox for parsing and rendering.

### KV (Key-Value) Store

KV stores project metadata:

- Project ID
- User who created it
- Project name
- Model used
- Credit information
