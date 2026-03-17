# First Look at Drupal CMS BETA (Drupal Starshot)

**Source:** WebWash (Ivan Zugec) — https://www.youtube.com/watch?v=y7pKF9ACUx4
**Date:** November 2024

---

## What Is the Drupal Starshot Initiative

- The **Drupal Starshot Initiative** was announced in 2024 as a major push to move Drupal forward.
- It encompasses multiple components: **automatic updates**, **UX/Experience Builder**, **Project Browser**, **Recipes**, **trial experience**, and **marketing resources**.
- Dries Buytaert (Drupal Project Lead and founder) has presented Starshot at DrupalCon Barcelona and DrupalCon Bonn — search "Drupal Starshot" for his keynotes.

---

## What Is Drupal CMS

- **Drupal CMS** is a packaged version of Drupal that emerged from the Starshot initiative.
- It is similar to an installation profile or distribution, but built using **Recipes** (the new system that replaces the older distributions/features approach).
- The core problem it solves: installing standard Drupal gives you a blank site with no contrib modules, and you immediately need Composer on the command line to add functionality. Drupal CMS ships with contrib modules **pre-installed**.

### How It Differs from Standard Drupal

- Standard Drupal install: no contrib modules, requires Composer knowledge, blank starting point.
- Drupal CMS install: comes with a **front-end theme**, a **backend theme**, and a curated set of **contrib modules** already configured.
- Think of it as picking functionality "off an app store" — download, run, done.

### Historical Context

- Drupal has had distributions since before 2010, but they never took off because maintaining upstream changes was too difficult.
- Config management has improved significantly, and Recipes aim to make shipping functionality between sites reliable.

---

## What Is DDEV

- **DDEV** is a Docker-based local development environment for PHP (not Drupal-specific — works with Laravel, WordPress, etc.).
- The Drupal community has officially endorsed DDEV as the standard local dev tool.
- Available on **Windows**, **Mac**, **Linux**, and **cloud** environments.
- On Mac, install via Homebrew: `brew install ddev` (note: Homebrew updates all packages first, which can take ~10 minutes).
- Other options exist (e.g., **Lando**), but DDEV has been the most stable, especially on Mac with Apple Silicon.

[REVIEW: Ivan mentions hearing that running Docker inside a virtualized Ubuntu via VMware on Apple Silicon may be faster than native Docker — unverified claim.]

---

## Install Drupal CMS with DDEV

There are **two versions** of Drupal CMS available:

1. **Packaged solution (zip file):** All modules, vendor directory, and recipes pre-downloaded. Just unzip and go.
2. **Git version:** Clones the repository and runs `composer install` via DDEV. Includes development tools like **Cypress** for integration testing. Use this version if you want to contribute.

### Installation Steps

1. Install DDEV (pre-requisite)
2. Clone or download the Drupal CMS codebase
3. Navigate to the project folder
4. Run `ddev start` — this starts the Docker containers and runs `composer install` (for the Git version)
5. Wait for the process to complete
6. Access the site via the URL provided by DDEV

---

## Useful DDEV Commands

| Command | Description |
|---------|-------------|
| `ddev start` | Start the development environment |
| `ddev stop` | Stop the environment |
| `ddev list` | List all available DDEV sites |
| `ddev logs` | View logs |
| `ddev launch` | Open the site in your default browser |
| `ddev status` | Show environment status, URLs, and ports |
| `ddev drush <command>` | Run Drush commands inside the container |
| `ddev mysql` | Access the MySQL CLI |
| `ddev phpmyadmin` | Launch phpMyAdmin |
| `ddev xdebug on` | Enable Xdebug (slows performance — only use when needed) |
| `ddev export-db` | Export the database |
| `ddev composer <command>` | Run Composer inside the container |
| `ddev debug` | Debugging tools |

Full CLI reference: https://ddev.readthedocs.io/ (under Usage > CLI Commands)

---

## Installing Drupal CMS

- On first load, Drupal CMS presents a **goal selection screen**: options include Blog, SEO, Forms, etc.
- Enter a site name and click Next.
- The installer runs in the background — wait for it to complete.
- After installation, you are redirected directly to the **backend admin**.

---

## Dashboard

- Drupal CMS provides a **dashboard** out of the box.
- The dashboard is editable — you can click "Edit Layout," add blocks, rearrange them, and save.
- This uses the standard Drupal block layout system.

---

## Themes

- **Front-end theme:** Olivero (with a custom color variant) [REVIEW: Ivan initially said "Olivier" and seemed uncertain whether it was a custom theme or standard Olivero with different colors.]
- **Backend admin theme:** **Gin** (not Claro, which was the previous default admin theme)
- Both Claro and Gin are installed, but Gin is the active admin theme.

---

## Navbar

- The admin navigation uses **Gin's** navigation system.
- Shortcuts are available for common tasks: create blog post, create basic page, create form (Webform), add documents, add YouTube videos (via Media).

---

## Coffee Module

- Drupal CMS ships with the **Coffee** module — a quick-navigation popup (similar to Spotlight or Alfred on macOS).
- Press the keyboard shortcut to open a search dialog, then type to quickly navigate to any admin page.
- Example: type "basic page" to jump directly to the "Add Basic Page" form.

---

## Module Run-Through

Drupal CMS ships with a strong set of contrib modules pre-installed. These are modules that would typically be added to nearly every Drupal site:

### SEO & URL Management
- **Simple XML Sitemap** — automatic sitemap generation
- **Pathauto** — automatic URL alias generation
- **Redirect** — URL redirect management
- **Metatag** — meta tag management (available under Configuration)
- **SEO Checklist** — SEO audit tool
- **robots.txt** — robots.txt management

### Content & Forms
- **Webform** — full-featured form builder (one of the top "product-based" modules — install it and you get a complete product, unlike many Drupal modules that are libraries/frameworks)
- **Media** module with **Media Library** — proper media handling (not just a basic image field)
- **CKEditor** with **Link It** module — enhanced linking in the WYSIWYG editor

### Administration & UX
- **Coffee** — quick navigation popup
- **Easy Breadcrumb** — automatic breadcrumb generation
- **Gin** admin theme
- **Navigation** module

### Security & Compliance
- **Antibot** — bot protection
- **Consent Manager** — cookie/consent management
- **Captcha** — form protection

### Media & Images
- **Focal Point** — set focal points on images for smart cropping
- **Crop Types** — image crop type management

### Developer & Site Building
- **ECA (Event-Condition-Action)** — rules/workflow automation (see dedicated section below)
- **Geocoder** and **Address Field** — location functionality (used by the CMS Locations recipe)
- **Autosave Form** — automatically saves form progress
- **Email Template** — email formatting

---

## CKEditor

- The CKEditor in Drupal CMS is well-configured out of the box.
- **Media Library** integration is built in — you can embed media directly from the editor.
- **Link It** module is integrated for enhanced internal linking with autocomplete/exposed filters.
- Standard formatting tools (headings, lists, bold, italic, etc.) are all present.

---

## Trash Functionality

- Drupal CMS includes a **Trash** module — when you delete content, it goes to a trash bin instead of being permanently removed.
- From the trash, you can **restore** content or **purge** it (permanent deletion).
- This solves a real-world problem: editors who accidentally delete content can now recover it.

### How Trash Works (Database Level)

- There is no separate "trash" table — the node table has a `deleted` column.
- When content is active, `deleted` is set to `NULL`.
- When content is trashed, `deleted` is set to a **timestamp** of when it was deleted.
- Purging removes the record entirely.

---

## Q&A: Allow Editors to Change Text Color

**Question from YouTube:** Can you make it so the text color can be changed?

**Ivan's recommendation:** Avoid giving editors direct color-picking ability. Instead, use **CKEditor Styles**:

- Create named styles (e.g., "primary," "secondary," "info," "warning") that apply CSS classes.
- Each style maps to a color defined in your stylesheet.
- This way, if you need to change "red" to "orange" across the entire site later, you only change the CSS — not every individual piece of content.

**The problem with inline colors:** Editors will apply colors everywhere using inline styles. Six months later, when the client asks to change all red text to orange, every page must be manually updated because the color is hardcoded in the markup.

**Possible module:** **CKEditor Color Dialog** — adds a color picker to CKEditor. It has been updated for Drupal 11, but use with caution for the reasons above.

---

## Project Browser

- **Project Browser** is part of the Starshot initiative — it provides an in-admin UI for browsing and installing Drupal modules (similar to a plugin marketplace).
- Navigate to **Extend** to access the Project Browser.
- You can see what modules are already installed and browse for new ones.
- The browser shows module details and compatibility information.

### Current Limitations (Beta)

- Module installation from the Project Browser **was not fully working** during this demo.
- Attempting to install modules like Feeds resulted in errors ("Failed to run" — likely due to stability/version constraints during beta).
- When fully functional, this will be a **game changer** — installing modules without touching Composer or the command line.

---

## Recipes

- **Recipes** are the new way to package and ship functionality between Drupal sites.
- Think of them as **"Features 2.0"** — for those who remember the Features module in Drupal 7, which allowed exporting and importing configuration between sites.
- Recipes are defined as **YAML files** containing module requirements and configuration.

### How Recipes Work

- Each recipe has a `recipe.yaml` file that defines:
  - **Modules to install** (under the `install` key)
  - **Configuration to import** (YAML config files)
  - **Default content** (optional)
  - **Tests**

### Recipe Structure (Example: Blog Recipe)

```
recipes/drupal_cms_blog/
  recipe.yaml          # Module list and metadata
  config/              # Configuration YAML files to import
  content/             # Default content (optional)
  tests/               # Test files
```

---

## Recipe Code Bases

- Recipes are stored in the `recipes/` directory within the Drupal CMS codebase.
- Available recipes include: **drupal_cms_starter**, **blog**, **events**, **locations**, and more.
- Some recipes are also **projects on drupal.org** — you can find them at `drupal.org/project/drupal_cms`.
- The **starter** recipe pulls in other recipes as dependencies.
- You can **create your own recipes** — the drupal.org contribution page has documentation for this.

### Building a Recipe (Workflow)

1. Build out the desired functionality on a Drupal site (content types, views, fields, etc.)
2. Export the configuration via **Configuration > Single Export** in the admin
3. Copy the exported YAML into recipe config files
4. Remove the `uuid` from exported config (UUIDs are site-specific)
5. Define the recipe's module dependencies in `recipe.yaml`

**Caveat:** You need to know exactly which YAML files to export. Fields are particularly complex — each field has a base field definition, an instance definition, manage display config, and manage form display config.

---

## Installing a Recipe

- Navigate to the **Recipes** section in the admin UI.
- Click **Install** on the desired recipe (e.g., "Events").
- The recipe installs its modules and imports its configuration.
- After installing the Events recipe: a new **Event** content type appears, and you can immediately create Event content with the pre-configured fields.

---

## Configuration Page Walk-Through

Key configuration sections available in Drupal CMS:

- **Captcha** — form protection settings
- **Autosave Form** — automatic form saving
- **Coffee** — quick navigation settings
- **Easy Breadcrumb** — breadcrumb configuration
- **Consent Manager** — cookie consent settings
- **Antibot** — bot protection
- **Crop Types** — image cropping settings
- **Focal Point** — focal point configuration for images
- **SEO Checklist** — SEO audit
- **robots.txt** — search engine crawl rules
- **Metatag** — meta tag defaults
- **Shortcuts** — admin shortcut management
- **Navigation** — navigation settings
- **Geocoder** — geocoding settings (used by Locations recipe)
- **Address Field** — address formatting
- **ECA** — Event-Condition-Action automation (see below)

---

## ECA (Event-Condition-Action)

- **ECA** is a module for creating automation workflows — similar to what the **Rules** module provided in earlier Drupal versions.
- It ships with Drupal CMS and powers some of the built-in functionality.

### Key Capabilities

- Create workflows triggered by events (e.g., user login/logout, content creation)
- Define conditions that must be met
- Execute actions (redirect, modify entities, send emails, etc.)
- **No custom code required** — all configuration is done through the admin UI

---

## Using ECA for Duplicate Functionality

One of the most interesting discoveries in this demo: the **Duplicate** button on content pages is **powered entirely by ECA** — no custom module code.

### How the Duplicate Feature Works

The ECA model for duplication has two parts:

**Part 1 — Add the "Duplicate" Operations Link:**
- **Event:** Alter local tasks / operations links
- **Action:** Add a custom operation link labeled "Duplicate" to content pages
- The link points to a URL with a `duplicate` query parameter containing the node ID

**Part 2 — Perform the Duplication:**
- **Event:** Triggered when the duplicate link is clicked
- **Actions (in sequence):**
  1. Load the original entity using the node ID from the URL argument
  2. **Clone the existing entity** (creates a copy)
  3. Set a status message confirming duplication
  4. Save the cloned entity

### Why This Matters

- Previously, you would need a dedicated module (e.g., **Replicate**, **Entity Clone**) or custom code to add duplication.
- ECA achieves the same result with zero code — entirely through admin configuration.
- The same approach (altering local tasks) can add custom buttons/links to any entity page.
- ECA makes heavy use of **tokens** for passing data between actions (e.g., entity IDs, URL arguments).

---

## Export ECA as Recipe

- ECA models can be **exported as recipes** directly from the admin UI.
- Navigate to the ECA model and click **Export > Recipe**.
- Provide a name, namespace, and output directory (e.g., `/tmp` or the `public://` files directory).

### Exported Recipe Structure

The exported recipe contains:

- `recipe.yaml` — lists ECA as a dependency (`require: eca`)
- `config/` directory — contains the ECA model configuration in YAML
- The ECA model itself is stored in an **XML-like format** that defines:
  - The **visual model** (the UI diagram/layout)
  - The **operations** (events, conditions, actions)
  - **References** between components

This makes it possible to build ECA automation on one site and ship it to other sites via the Recipes system.

---

## Recap

### What Ships with Drupal CMS (Beta)

- **Gin** admin theme (replaces Claro as default backend)
- **Olivero** front-end theme (with custom color configuration)
- **Trash bin** for content recovery
- **Project Browser** for in-admin module installation (still in progress)
- **Recipes** for packaging and installing functionality
- **ECA** for no-code workflow automation
- **Coffee** for quick admin navigation
- Pre-installed contrib modules: Webform, Pathauto, Redirect, Simple XML Sitemap, Metatag, Media Library, Link It, Focal Point, Easy Breadcrumb, Antibot, Consent Manager, Captcha, and more

### Key Takeaways

- Drupal CMS is the most significant packaging effort in Drupal's history — it provides a usable out-of-the-box experience that standard Drupal lacks.
- **Recipes** are the spiritual successor to Features (Drupal 7) and aim to make functionality portable between sites.
- **ECA** is powerful but has a learning curve — the documentation can be hard to follow, and you need hands-on experimentation to understand the event/condition/action model.
- **Project Browser** will be a game changer once stable — installing modules without Composer from the admin UI.
- The initiative walks a fine line between being opinionated enough to be useful and flexible enough for Drupal's "build anything" philosophy.

### Comparison to WordPress

- WordPress still has a better out-of-the-box editor experience (Gutenberg allows drag-and-drop images directly into the editor).
- WordPress has a large paid plugin ecosystem; Drupal's contrib modules are generally free.
- The risk with paid plugin ecosystems is vendor lock-in — the key question is always how easy it is to get your content out.
- Drupal CMS aims to close the gap by providing WordPress-level ease of setup while retaining Drupal's flexibility.

### Resources

- **Dries Buytaert's blog post** on installing Drupal CMS (inspired this video)
- **DDEV documentation:** https://ddev.readthedocs.io/
- **Drupal CMS project page:** https://drupal.org/project/drupal_cms
- **ECA module:** https://drupal.org/project/eca
- **WebWash:** https://webwash.net/ (more Drupal tutorials and live streams)
