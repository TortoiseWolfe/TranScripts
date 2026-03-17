# Basic Tailwind CSS Theme Setup for Drupal Canvas

**Source:** WebWash (Ivan Zugec) — https://www.youtube.com/watch?v=B2_6hiEGQBA
**Date:** December 2025

---

## Overview

This tutorial covers how to create a basic Tailwind CSS theme for Drupal and integrate it with Drupal Canvas. The goal is to strip things down to the simplest possible setup: a bare theme with Tailwind, then build a few Single Directory Components (SDC) that work with Canvas's page builder UI.

The components created: **text**, **heading**, **section grid** (with slot), **card** (with media), and **hero image**.

---

## Test Site Setup

- Start with a vanilla Drupal core installation
- Install the **Gin** backend admin theme (the new default admin theme for Drupal 11.3)
- Create some test content so you can focus on theme development
- Turn off CSS/JavaScript aggregation under **Configuration > Performance**
- Enable **Development mode** and turn off caching during development

---

## Create Theme with Drush Generate

Use Drush Generate to scaffold a new theme:

```bash
drush generate theme
```

- **Theme name:** `webwash_tailwind` (or your preferred name)
- **Base theme:** Set to `false` — no base theme, keeping it as bare and simple as possible
- **Breakpoints:** No
- **Configuration:** Skip

Drush generates a bunch of files and folders, many of which are empty scaffolding.

### Clean Up Generated Files

Delete the folders and files you do not need:
- Remove the auto-generated JS file
- Remove unused template folders

The libraries file will need fixing later, but a broken reference just produces a 404 during testing.

---

## Enable Theme

- Go to **Appearance** in the Drupal admin
- Find your new theme (e.g., `webwash_tailwind`) and set it as default
- Turn off the site logo for now under **Site branding** block settings

The site will look broken at this point — that is expected with a bare theme.

---

## Regions

Start with only the regions you actually need, then add more later. Recommended initial regions:

- **Header** — for site branding (logo)
- **Primary Menu** — for main navigation
- **Pre-content** — for breadcrumb, page title, status messages, tabs, action links
- **Content** — every theme requires this
- **Footer** — for footer blocks (e.g., multi-column grid)
- **Footer Bottom** — for copyright or contact info

### Edit the .info.yml File

Remove the default regions that Drush generated and replace with your custom set. Keep it minimal to start.

### Rearrange Blocks in Regions

Go to **Structure > Block Layout** and move blocks into the correct regions:

- **Header:** Site branding
- **Primary Menu:** Main navigation
- **Pre-content:** Status messages, Help, Page title, Primary action links, Primary tabs
- **Content:** Main page content
- **Footer / Footer Bottom:** Your custom footer blocks

---

## Tailwind CSS Integration

### Initialize npm

Navigate into your theme directory and run:

```bash
npm init
```

Accept all defaults.

### Install Tailwind and Vite

```bash
npm install --save-dev vite @tailwindcss/vite tailwindcss
```

### Create Vite Config

Create `vite.config.js` in your theme root:

```js
import { defineConfig } from 'vite';
import tailwindcss from '@tailwindcss/vite';

export default defineConfig({
  plugins: [tailwindcss()],
  build: {
    rollupOptions: {
      input: 'source/css/style.css',
      output: {
        dir: 'dist',
        assetFileNames: 'style.css',
      },
    },
  },
});
```

This tells Vite to look for `source/css/style.css` as input and output compiled CSS to the `dist` directory.

### Modify package.json

Set the module type and add build/watch scripts:

```json
{
  "type": "module",
  "scripts": {
    "build": "vite build",
    "dev": "vite build --watch"
  }
}
```

### Import Tailwind in Source CSS

Create `source/css/style.css` and add:

```css
@import "tailwindcss";
```

### How Tailwind Compilation Works

Unlike Bootstrap (which ships every class in a large CSS file), Tailwind scans your specified folders and only compiles the CSS classes you actually use. This keeps your compiled stylesheet small — starting around 3-4KB.

### Add Tailwind Source Paths

In `source/css/style.css`, add source directives so Tailwind knows where to scan for class usage:

```css
@import "tailwindcss";

@source "../../templates/**/*.twig";
@source "../../components/**/*.twig";
@source "../../*.theme";
```

These paths tell Tailwind to scan all Twig templates, all component Twig files, and the `.theme` file for utility classes.

### Compile Tailwind

```bash
npm run build
```

For development with auto-recompilation on file changes:

```bash
npm run dev
```

The watcher monitors your source files and recompiles whenever classes change. Sometimes you need to restart the watcher if styles are not updating.

### Update .libraries.yml

Clean up the libraries file to reference only the compiled CSS:

```yaml
global:
  css:
    theme:
      dist/style.css: {}
```

Remove any other CSS/JS references that were auto-generated.

After clearing the Drupal cache, your site should load with Tailwind's base reset applied.

---

## Override Page Template

Copy the core `page.html.twig` template into your theme's `templates/` directory. This is found in Drupal core's system module templates.

Build out the page template with your regions and Tailwind classes:

- **Header area:** Wrap header and primary menu regions with classes like `bg-white shadow`
- **Container:** Use `container mx-auto` for centered content
- **Pre-content region:** Include status messages, page title, tabs
- **Content region:** The main body area
- **Footer regions:** Style with appropriate Tailwind grid/flex classes

---

## Override Region Template

Create a `region.html.twig` override that outputs only the raw content without any wrapper markup:

```twig
{{ content }}
```

This removes the default region wrapper divs that can interfere with your Tailwind layout classes.

---

## Style Site Branding Block

Use a theme preprocess function to add Tailwind classes to specific blocks. In your `.theme` file:

```php
function webwash_tailwind_preprocess_block__system_branding_block(&$variables) {
  $variables['attributes']['class'][] = 'flex';
  $variables['attributes']['class'][] = 'items-center';
  $variables['attributes']['class'][] = 'gap-4';
  // Add classes for logo sizing, e.g., w-200
}
```

The double-underscore naming convention (`block__system_branding_block`) targets only that specific block.

---

## Style Menu Block

Similarly, add a preprocess function for the menu block:

```php
function webwash_tailwind_preprocess_block__menu__main(&$variables) {
  $variables['attributes']['class'][] = 'flex';
  $variables['attributes']['class'][] = 'space-x-6';
}
```

**Tip:** You can use a single generic `preprocess_block` function with conditionals, or break them into separate targeted functions for clarity.

---

## Q&A: Handling Large .theme Files

For organizing a growing `.theme` file, use **include files** — break preprocessors into separate files by type (blocks, forms, nodes, etc.) and require them in.

The Radix theme demonstrates this pattern:

```php
// In .theme file
$includes = glob(__DIR__ . '/includes/*.inc');
foreach ($includes as $include) {
  require_once $include;
}
```

Then create files like `includes/block.inc`, `includes/form.inc`, etc.

---

## Tailwind CSS Component Files

Create CSS component files to avoid repeating long class lists in templates. These use Tailwind's `@apply` directive.

### Button Styling

Create `source/css/components/buttons.css`:

```css
.button {
  @apply inline-flex items-center px-4 py-2 border border-transparent
         text-sm font-medium rounded-md shadow-sm text-white
         bg-blue-600 hover:bg-blue-700 focus:outline-none
         focus:ring-2 focus:ring-offset-2 focus:ring-blue-500;
}

.button--primary {
  @apply bg-blue-600 hover:bg-blue-700;
}
```

Use both `button` and `button--primary` classes together for primary buttons.

### Tab Styling

Create `source/css/components/tabs.css`:

Define a custom class (e.g., `ww-canvas--tabs`) to style the Drupal tabs block. Apply it via a preprocess function on the `local_tasks_block`:

```php
function webwash_tailwind_preprocess_block__local_tasks_block(&$variables) {
  $variables['attributes']['class'][] = 'ww-canvas--tabs';
}
```

### Typography Styling

Create `source/css/components/typography.css`:

Style base heading levels (H1 through H6), link styling, and paragraph spacing. Tailwind ships with no default styles, so you need to define these yourself.

### Import Component CSS Files

In your main `source/css/style.css`:

```css
@import "tailwindcss";

@source "../../templates/**/*.twig";
@source "../../components/**/*.twig";
@source "../../*.theme";

@import "./components/buttons.css";
@import "./components/tabs.css";
@import "./components/typography.css";
```

After adding these imports, the compiled CSS grows from ~3-4KB to ~14-20KB.

---

## Tailwind Form Styling

Install the official Tailwind CSS forms plugin for basic form element styling:

```bash
npm install @tailwindcss/forms
```

In `source/css/style.css`, add the plugin with the `base` strategy:

```css
@plugin "@tailwindcss/forms" {
  strategy: base;
}
```

- **`base` strategy:** Applies styles based on element type (input, textarea, select) automatically
- **`class` strategy:** Requires explicit classes like `form-input`, `form-textarea` on each element

The `base` strategy is simpler for Drupal since you do not control all form element markup.

---

## Q&A: Setting Caching Off with development.services.yml

You can override the `development.services.yml` file to disable Twig caching and enable debug mode. However, even with all development settings enabled in Drupal's UI (Performance > Development mode, aggregation off), you may still need to clear cache manually after adding new preprocess functions. The development mode settings and the `development.services.yml` approach both aim to reduce caching during development, but cache clears are still sometimes necessary for certain changes.

---

## Installing Drupal Canvas

As of December 2025, there is a known bug when installing Canvas from the Drupal UI — it produces JSON schema validator errors and half-installs database tables, leaving the site in a broken state.

**Install Canvas using Drush instead:**

```bash
drush en canvas
```

This also installs dependencies like **Media Library** and **Media**.

[REVIEW: This bug was reported as of the recording date and may be fixed in later releases.]

---

## Canvas Page Overview

After installing Canvas, go to **Content > Pages** to manage Canvas pages. Canvas pages are a separate **entity type** from standard content types.

### Canvas UI Elements

- **Right panel:** Manage props for the selected component
- **Preview button:** Live preview of changes
- **Left panel — Components:** Browse and add available components
- **Left panel — Layers:** View the component structure/hierarchy
- **Left panel — Library:** Manage reusable component instances
- **Left panel — Pages:** Manage all Canvas pages
- **Content Templates:** Modify full content view modes for entities (not covered in this tutorial)

### Creating a Canvas Page

- Click **Create Page**, set a title and URL path
- **Publish** the page (you must publish for it to appear)
- Set as homepage via the page settings if desired

### Navigating to Canvas Pages

- Click **Edit** on any Canvas page to enter the editor
- From the admin toolbar, look for the **Drupal Canvas** link (location depends on your toolbar configuration: Gin horizontal, legacy, or modern)

---

## Create Text Component (SDC)

Generate a new Single Directory Component using Drush:

```bash
drush generate sdc
```

- **Theme:** Select your custom theme
- **Component name:** `text`
- **Machine name:** `text`
- **CSS:** No
- **JavaScript:** No
- **Props:** Yes — add one prop called `text` (type: string)
- **Slots:** No

### Component YAML (text.component.yml)

Update the `text` prop to support rich text (HTML):

```yaml
props:
  type: object
  properties:
    text:
      type: string
      title: Text
      format: html
      x-component:
        content-media-type: text/html
      examples:
        - "<p>Example text content</p>"
    align:
      type: string
      title: Align
      enum:
        - left
        - center
        - right
      default: left
      examples:
        - left
```

Key points:
- Setting `format: html` and `content-media-type: text/html` converts the prop from a plain text field to a rich text editor in the Canvas UI
- Add an `examples` value so the component has default preview content

### Twig Template (text.html.twig)

```twig
{% set align_class = {
  'left': 'text-left',
  'center': 'text-center',
  'right': 'text-right',
} %}

<div class="{{ align_class[align] ?? 'text-left' }}">
  {{ text|raw }}
</div>
```

- Use `|raw` filter since the text contains HTML from the rich text editor
- The align prop maps to Tailwind text alignment classes

**Important:** After modifying a component's props, you may need to remove the component from the Canvas page and re-add it for the new prop fields to appear.

---

## Q&A: Text Formats in Canvas

Canvas ships with locked text formats (`block` HTML and `inline` HTML). These cannot be modified through the standard Drupal text format admin UI — they are locked by Canvas configuration. The expectation is that rich text formatting is kept simple, and more complex styling is handled through component props and Twig templates.

---

## Create Heading Component

```bash
drush generate sdc
```

- **Component name:** `heading`
- **Props:** `heading_text` (string), `level` (number), `align` (string)

### Component YAML

```yaml
props:
  type: object
  properties:
    heading_text:
      type: string
      title: Heading Text
      examples:
        - "Section Heading"
    level:
      type: integer
      title: Level
      enum:
        - 1
        - 2
        - 3
        - 4
        - 5
        - 6
      default: 2
      examples:
        - 2
    align:
      type: string
      title: Align
      enum:
        - left
        - center
        - right
      default: left
      examples:
        - left
```

### Twig Template

```twig
{% set align_class = {
  'left': 'text-left',
  'center': 'text-center',
  'right': 'text-right',
} %}

{% set tag = 'h' ~ (level ?? 2) %}

<{{ tag }} class="{{ align_class[align] ?? 'text-left' }}">
  {{ heading_text }}
</{{ tag }}>
```

The level prop dynamically sets the heading tag (h1-h6).

**Tip:** Use AI to generate props and update Twig templates — SDC components have a lot of boilerplate code. Twig is well-understood by AI tools since it is used outside the Drupal ecosystem (Symfony, Craft CMS, etc.).

---

## Create Section Grid Component

This component uses a **slot** to allow nesting other components inside it.

```bash
drush generate sdc
```

- **Component name:** `section_grid`
- **Props:** `title` (string), `highlight` (boolean), `columns` (string)
- **Slots:** Yes — add one slot called `grid`

### Props vs Slots

- **Props** are managed from the right panel — they control component settings (text values, dropdowns, toggles)
- **Slots** allow you to drop other components inside a component — creating nested/composite layouts

### Component YAML

```yaml
props:
  type: object
  properties:
    title:
      type: string
      title: Section Title
      examples:
        - "Grid Section"
    highlight:
      type: boolean
      title: Highlight Background
      default: false
    columns:
      type: string
      title: Columns
      enum:
        - "100"
        - "50-50"
        - "25-25-25-25"
      default: "100"
      examples:
        - "100"

slots:
  grid:
    title: Grid Content
```

### Twig Template

```twig
{% set grid_class = {
  '100': 'grid-cols-1',
  '50-50': 'grid-cols-2',
  '25-25-25-25': 'grid-cols-4',
} %}

{% set bg_class = highlight ? 'bg-gray-300' : '' %}

<section class="py-8 {{ bg_class }}">
  <div class="container mx-auto">
    {% if title %}
      <h2 class="text-2xl font-bold mb-4">{{ title }}</h2>
    {% endif %}
    <div class="grid gap-4 {{ grid_class[columns] ?? 'grid-cols-1' }}">
      {% block grid %}{% endblock %}
    </div>
  </div>
</section>
```

- The `{% block grid %}{% endblock %}` is a **Twig block** (not a Drupal block) — it defines where slotted child components render
- The `highlight` boolean toggles a background color
- Column layout is controlled via a dropdown that maps to Tailwind grid classes

---

## Create Card Component

```bash
drush generate sdc
```

- **Component name:** `card`
- **Props:** `media` (object), `title` (string), `summary` (string), `link_url` (string), `link_label` (string)
- **Slots:** No

### Media Prop — Schema Reference

For the `media` prop to work with Canvas's image upload widget, you must use a `$ref` in the YAML schema:

```yaml
props:
  type: object
  properties:
    media:
      title: Media
      $ref: "json-schema-definitions://canvas.module/media"
    title:
      type: string
      title: Title
      examples:
        - "Card Title"
    summary:
      type: string
      title: Summary
      examples:
        - "Card description text"
    link_url:
      type: string
      title: Link URL
    link_label:
      type: string
      title: Link Label
```

The `$ref: "json-schema-definitions://canvas.module/media"` tells Canvas how to handle the media object and enables the media upload widget in the UI.

### Debugging Missing Components

If a component does not appear in the Canvas "Add" menu:

1. Go to **Appearance > Components** (a page provided by Canvas)
2. Check the **Incompatible** tab
3. Canvas reports why a component is incompatible — e.g., "does not know of a block type widget to allow populating media prop"
4. Fix the issue (usually adding the correct `$ref` for media props) and clear cache

### Twig Template

```twig
<div class="bg-white rounded-lg shadow-md overflow-hidden">
  {% if media.src %}
    <img src="{{ media.src }}" alt="{{ media.alt ?? '' }}" class="w-full h-48 object-cover" />
  {% endif %}
  <div class="p-4">
    {% if title %}
      <h3 class="text-lg font-semibold mb-2">{{ title }}</h3>
    {% endif %}
    {% if summary %}
      <p class="text-gray-600 mb-4">{{ summary }}</p>
    {% endif %}
    {% if link_url and link_label %}
      <a href="{{ link_url }}" class="text-blue-600 hover:underline">{{ link_label }}</a>
    {% endif %}
  </div>
</div>
```

### Using Section Grid with Card Components

Drop card components into a section grid's slot to create card layouts. Use the columns dropdown (50-50, 25-25-25-25, etc.) to control the grid. Cards can be duplicated directly in the Canvas UI.

---

## Create Hero Image Component

```bash
drush generate sdc
```

- **Component name:** `hero_image`
- **Props:** `media` (object with `$ref`), `heading_text` (string), `subtitle` (string), `link_url` (string), `link_label` (string)

### Component YAML

Uses the same `$ref: "json-schema-definitions://canvas.module/media"` pattern as the card component for the media prop.

### Twig Template

```twig
<div class="relative">
  {% if media.src %}
    <img src="{{ media.src }}" alt="{{ media.alt ?? '' }}" class="w-full h-96 object-cover" />
    <div class="absolute inset-0 bg-black bg-opacity-40"></div>
  {% endif %}
  <div class="absolute inset-0 flex flex-col justify-center items-center text-white text-center">
    {% if heading_text %}
      <h1 class="text-4xl font-bold mb-2">{{ heading_text }}</h1>
    {% endif %}
    {% if subtitle %}
      <p class="text-xl mb-4">{{ subtitle }}</p>
    {% endif %}
    {% if link_url and link_label %}
      <a href="{{ link_url }}" class="button button--primary">{{ link_label }}</a>
    {% endif %}
  </div>
</div>
```

The hero uses absolute positioning to overlay text on the image with a semi-transparent background.

---

## Controlling Container on Canvas Pages vs Standard Pages

Canvas pages should go edge-to-edge without container constraints. Standard Drupal pages need normal padding and container widths. The page template handles this with a conditional variable.

### Page Template Logic

```twig
{% if not is_canvas_page %}
  <div class="container mx-auto px-4">
    {{ page.pre_content }}
  </div>
{% endif %}

<main class="{{ is_canvas_page ? 'p-0' : 'container mx-auto px-4 py-8' }}">
  {{ page.content }}
</main>
```

- **Canvas pages:** No container, no padding — components control their own full-width layouts
- **Standard pages:** Wrapped in a container with padding
- The **pre-content region** (page title, tabs, breadcrumbs) is hidden entirely on Canvas pages

### PHP Preprocess for Canvas Page Detection

In your `.theme` file, add a page preprocess function:

```php
function webwash_tailwind_preprocess_page(&$variables) {
  $route_name = \Drupal::routeMatch()->getRouteName();
  $is_canvas = ($route_name === 'entity.canvas_page.canonical');

  // Also check for Canvas API/editing routes
  if (!$is_canvas && str_starts_with($route_name, 'canvas_api.layout')) {
    $is_canvas = TRUE;
  }

  $variables['is_canvas_page'] = $is_canvas;
}
```

- The canonical route check handles the front-end display of Canvas pages
- The `canvas_api.layout` prefix check handles the Canvas editor/preview routes so the pre-content region is also hidden when editing

---

## Q&A: Recipes

Recipes are primarily useful when you are building a product or template that you want to reuse across multiple sites. Use cases include:

- **Government departments** spinning up multiple similar websites
- **Trying out ECA functions** — recipes from the ECA website let you quickly test automation workflows
- **Drupal CMS site templates** are a form of recipe

There is currently no clear upgrade path from Drupal CMS v1 to v2 via recipes — recipes are applied as a one-time template, not as an ongoing updatable dependency.

---

## Recap

1. **Create a theme** using `drush generate theme` with no base theme for maximum control
2. **Set up Tailwind CSS** with Vite — configure source paths, build scripts, and the watch command
3. **Define regions** in `.info.yml` — start minimal (header, primary menu, pre-content, content, footer, footer bottom)
4. **Override page template** to render regions with Tailwind utility classes
5. **Override region template** to strip default wrapper markup
6. **Style blocks** via preprocess functions that add Tailwind classes to attributes
7. **Create Tailwind component CSS files** for buttons, tabs, typography, and forms
8. **Install Drupal Canvas** via Drush (not the UI, due to a known bug)
9. **Create SDC components** using `drush generate sdc`:
   - **Text** — rich text with alignment prop
   - **Heading** — dynamic heading level with alignment
   - **Section Grid** — configurable columns with a slot for child components
   - **Card** — media image, title, summary, link (uses `$ref` for Canvas media compatibility)
   - **Hero Image** — full-width hero with overlay text
10. **Handle Canvas vs standard pages** with a PHP preprocess function that detects the route and passes `is_canvas_page` to the page template

Building Canvas components is repetitive but straightforward once you understand the pattern. The same site-building decisions apply as with paragraphs-based sites: what components to create, how much control to give editors, and how to handle padding and layout between components. AI tools are well-suited for generating the boilerplate SDC YAML and Twig code.
