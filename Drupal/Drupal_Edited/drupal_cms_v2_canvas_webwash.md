# First Look at Drupal CMS Version 2 (alpha1) + Drupal Canvas

**Source:** WebWash — https://www.youtube.com/watch?v=dAkNEA4u2Eg
**Date:** November 2025

---

## What's New in Drupal CMS v2

- Drupal CMS version 2 alpha 1 was released around DrupalCon Vienna
- The biggest change is **Drupal Canvas** — a new page builder for Drupal
- Canvas was previously known as **Experience Builder** (renamed due to trademark issues)
- Canvas has a release candidate (RC2), so it's considered fairly stable
- Acquia is already using Canvas internally
- Project page: `drupal.org/project/canvas`

---

## Installing Drupal CMS v2

- Create a folder and use **DDEV** for your local environment
- Run the Composer commands from the Drupal CMS readme
- Installation page is polished and modern-looking
- During install, you choose between two **site templates**: **Starter** and **Bite**

### Site Templates vs Themes

- **Site templates are NOT themes** — this is a common point of confusion
- Site templates are a form of **Drupal recipe** — think of them as another type of installation profile
- They define website functionality (and optionally look/feel), not just appearance
- The new default theme is called **Mercury** (replaces Olivero)
- Mercury uses **Tailwind CSS**

---

## Reviewing Drupal CMS v2

- Backend uses **Gin** as the admin theme (same as v1)
- Dashboard has a new "Recent Pages" section
- Content section has a new **Pages** tab for Canvas-managed pages
- **Recommended add-ons** reduced from many (v1) to just four (v2 with Bite template)
- Recipes are defined in YAML with different types: `site_template` vs `drupal_cms`
- **ECA** now includes the **Modeler API** for additional automation capabilities
- New content types automatically get default fields created via an ECA model

---

## Drupal Canvas UI

### Accessing Canvas

- Click **Edit** on any page to enter the Canvas editor
- Or navigate directly to `/canvas`
- Canvas-managed pages are their own **entity type** (not standard content nodes)
- Canvas pages won't appear in the regular Content listing — use **Content > Pages** tab

### Canvas Page Entity

- Canvas pages are a dedicated entity type, not a content type with bundles
- You cannot create custom Canvas page types or add extra fields
- Fields are hard-coded in the entity definition (title, components, etc.)

### UI Layout

- **Right panel:** Page data and component properties; also has a preview panel
- **Left panel:**
  - **Library:** All available components (views blocks, theme components, custom components)
  - **Layers:** Tree structure showing all components on the page
  - **Manage Library:** Component management interface
  - **Patterns:** Design patterns
  - **Pages:** List of all Canvas pages
  - **Templates:** Content type display templates (replaces Manage Display)
- **Top bar:** Page selector, responsive preview (mobile/tablet/desktop), zoom controls
- **Zoom:** Ctrl/Cmd + scroll wheel to zoom in/out

### Component Types

There are two types of components in Canvas:

1. **SDC (Single Directory Components)** — Standard Drupal components provided by the theme
2. **Code Components** — Built in JSX using **Preact** (React-like, but not React)

---

## Customize Header and Footer

- Header and footer regions appear in **green** in the editor (vs purple for page content)
- These regions appear on **all pages**
- Double-click into the header/footer region to edit
- Components snap into place (similar to Notion or Gutenberg block editors)

### Adding a Button to the Header

1. Click the plus icon in the header region
2. Double-click into the header group
3. Drag in a **Button** component
4. Configure: label ("Sign Up"), link URL, size, icon
5. Click **Review Changes** to see what will be saved
6. **Publish** to apply

### Editing the Footer

1. Scroll to footer, double-click to enter edit mode
2. Drag in text or other components
3. Components snap into layout positions
4. Save all changes

---

## Responsive Breakpoints

- Breakpoints are controlled at the **theme level**, not by Canvas
- Mercury theme uses Tailwind CSS, which handles responsive design
- Canvas editor provides mobile/tablet/desktop preview modes

---

## Create a Canvas Page (FAQ Example)

### Basic Page Creation

1. Go to **Pages > New Page**
2. Enter title ("FAQs") and page metadata on the right panel
3. Add a **Section** component (layout container with header, grid, footer regions)

### Adding Components

- **Heading component:** Change size, alignment, add links
- **Text component:** Rich text with formatting
- **Section grid:** Configure column layout (50/50, 75/25, 100%, three-column)
  - Grid options are predefined — no click-and-drag resizing
- **Accordion:**
  1. Add an **Accordion Container**
  2. Add **Collapsible Sections** inside it
  3. Use the page structure/layers panel to verify nesting
  4. Set "open by default" on specific sections
- **Group component:** Wraps other components; supports background color, padding, border radius
- **Webform component:** Embed existing webforms (e.g., Contact Us)
- **Hero component:** Large hero images and content blocks

### Custom CSS Classes

- Some components support custom CSS classes, but only if the component's schema allows it
- No universal "add custom class" option yet (likely a future contrib module)

---

## Content Templates (Replacing Manage Display)

Templates in Canvas replace the traditional **Manage Display** page for controlling how content types render.

### Creating a Content Type

1. Go to **Structure > Content Types > Add**
2. Create fields (e.g., Tags, Content/body, Estimate, Status dropdown)
3. Drupal CMS v2 auto-creates some default fields via ECA

### Creating a Template

1. In Canvas, go to **Templates > Add New Template**
2. Select the content type and view mode (e.g., "Full Content")
3. Available view modes: Card, Card on Page, Full Content
  - Not all view modes may be configurable through the UI yet
4. Add layout components (Section, Breadcrumb, Heading, Text, Badge, etc.)

### Dynamic Field Mapping

- Click the **link field icon** on a component to map content type fields
- Select the field to dynamically pull data (e.g., Title → Heading component)
- **Limitations in alpha:**
  - Text list fields don't map through the UI yet
  - Entity reference fields (tags, images) can't be mapped yet
  - Pre-configured fields (title, body) work fine
  - Full field mapping may be possible through config/code
- The system auto-detects compatible field types for each component slot
- **Preview:** Select specific content items to preview template rendering

---

## Code Components

Code components let you build custom components using JSX (Preact).

### Creating a Code Component

1. Go to **Manage Library > Code > Add**
2. Name the component (e.g., "Task Summary")
3. Use the built-in code editor

### Component Data

- **Props:** Variables passed into the component (like React props)
  - Define name (camelCase), type (text, number, etc.), and default value
  - Access in JSX: `{estimate}`
- **Slots:** Areas where other components can be inserted
- **Data Fetch:** Pull external data into the component

### Using Tailwind in Code Components

- Since Mercury theme uses Tailwind, you can use Tailwind utility classes in code components
- Full access to Tailwind's styling system within the JSX

### Adding Code Components to Pages

1. Create and save the code component
2. Click **"Add to Components"** to make it available in the library
3. Go to any page, click Add, find the component, drag it in
4. Fill in prop values in the right panel

### Modifying Code Components

- **Code:** Can always be modified, even when component is used on pages
- **Props and Slots:** **Cannot be changed** once the component is added to any page
- To modify props/slots: remove from all pages first ("Remove from Components"), make changes, then re-add
- **Important:** This could be challenging if the component is used across many pages

### JavaScript Dependency

- Code components are **JavaScript-dependent** — they won't render with JS disabled
- Canvas uses **Astro Islands** architecture for rendering code components
- Astro hydration handles the client-side rendering pipeline

---

## Views Integration with Canvas

### Creating a Views Block

1. Go to **Structure > Views > Add**
2. Create a **Block** display (e.g., "Tasks Block")
3. Configure the view to show desired content type

### Adding Views to Canvas Pages

1. In Canvas, create a new page
2. Add a Section with Breadcrumb and Heading
3. The Views block appears in the component library
4. Drag it onto the page
5. Save and publish

### URL Configuration (Pathauto)

- Go to **Configuration > URL Aliases > Patterns**
- Create a pattern for the content type (e.g., `tasks/[node:title]`)
- This ensures breadcrumbs work correctly on content pages

---

## Custom Task Listing Component (JSON:API + Canvas Dev Mode)

### Setup

1. Enable **JSON:API** module
2. Enable **Canvas Dev Mode** module

### Creating a Data-Driven Component

1. Create a new code component (e.g., "Task Listing")
2. Use the **Data Fetch** feature to pull from JSON:API
3. Style with Tailwind classes
4. Test the component in the preview panel

---

## Canvas AI

Canvas includes AI-powered features for page building.

### Setup

1. Go to Canvas AI configuration
2. Add an **API key** (supports OpenAI and other providers)
3. Configure the AI agent settings

### AI Capabilities

- **Create pages:** Describe the page you want (e.g., "Terms and Conditions page")
- **Add components:** "Add a hero component with [description]"
- **Generate content:** "Add pricing components" or "Add testimonial components"
- **Create custom components:** Describe what you need and AI generates the code
- **Modify existing components:** "Update this component to [changes]"

### Token Usage

- Canvas AI tracks token usage
- You can view consumption in the admin interface
- Be mindful of API costs with complex generation requests

---

## Key Takeaways

1. **Canvas is the future of Drupal page building** — it will replace Layout Builder
2. **Not yet in Drupal Core** — it's a contrib module, but likely headed that direction
3. **Mercury theme + Tailwind CSS** is the new default stack for Drupal CMS
4. **SDC integration** is central — Canvas is built around Single Directory Components
5. **Code components use Preact JSX** with Astro Islands for rendering
6. **Alpha limitations:** Some field mapping doesn't work through the UI yet; workarounds through config may exist
7. **Storybook** is being discussed as a workflow for building/previewing components
8. **Canvas AI** adds AI-assisted page building with component generation
9. **DDEV + Docker** remains the recommended local development environment
10. **The way Drupal sites are built is changing again** — from PHP templates → Twig → Display Suite → Paragraphs → Layout Builder → Canvas
