# Drupal CMS v1: Installation and Demo

**Source:** WebWash (Ivan Zugec) — https://www.youtube.com/watch?v=jXG0wbASmlw
**Date:** January 2025

---

## Introduction

- **Drupal CMS version 1** was released on January 15, 2025 — also Drupal's 24th birthday
- About eight months prior, the **Starshot initiative** was announced to create a packaged version of Drupal
- Drupal CMS is still Drupal underneath, but packaged with additional functionality out of the box

### Drupal Core vs Drupal CMS

- **Drupal Core** is the framework — what was previously just called "Drupal"
- **Drupal CMS** is the packaged product built on top of Drupal Core
- Drupal CMS includes recipes, automatic updates, a polished backend, and pre-configured modules
- The naming clarifies the longstanding question of whether Drupal is a framework or a product — it is both

---

## How to Install Drupal CMS Using DDEV

### What is DDEV

- **DDEV** is a Docker-based local development environment
- It is the standard development environment adopted by the Drupal community
- DDEV works on Mac, Linux, and Windows
- Make sure you have Docker installed before setting up DDEV

### Installation Steps

1. Go to the Drupal CMS project page on drupal.org
2. Download the **v1 ZIP file** from the release page
3. Extract the ZIP file into a folder
4. Open a terminal and navigate to that folder
5. Run the launch script: `launch-drupal-cms.sh`
   - This runs `ddev start` under the hood and sets everything up

There is also a **Composer-based installation** option (`composer create-project`) available on the project page, though the ZIP download method is demonstrated here.

---

## Drupal CMS Installation Page

- The installation page has been redesigned with a clean, modern look
- You can select a **preconfigured site type** (e.g., Blog) during installation
- Enter your site name and admin account details
- Click **Install/Finish** — the installation is surprisingly quick
- After installation, you land directly on the admin dashboard

---

## DDEV Commands

Essential DDEV commands for managing your local environment:

| Command | Purpose |
|---------|---------|
| `ddev` | List all available commands |
| `ddev start` | Start the environment |
| `ddev stop` | Stop the environment (data is preserved) |
| `ddev stop --remove-data` | Stop and remove all data |
| `ddev status` | Show site URLs and status |
| `ddev drush` | Run Drush commands inside the container |
| `ddev composer` | Run Composer commands inside the container |
| `ddev ssh` | SSH into the container |
| `ddev mysql` | Access the MySQL database directly |
| `ddev drush uli` | Generate a one-time admin login link |

---

## Backend Theme

- Drupal CMS ships with **Gin** as the default backend (admin) theme instead of Claro
- The admin interface includes a **left-hand navigation bar** (Navbar) that is more polished than standard Drupal
- The front-end theme is the standard Drupal theme, which you would typically replace with something like **Tailwind** or **Bootstrap**

### Navigating the Admin Interface

- The new Navbar may hide some admin pages you are used to accessing
- **Tip:** Click on top-level menu items like **Structure** or **Configuration** to see the full list of available options, rather than relying solely on the Navbar

---

## Create Basic Page

- From the **Create** menu you can create: user accounts, images (media types), blog posts, basic pages
- When creating content, the right-hand sidebar includes:
  - **Workflow** status (draft, published, etc.)
  - **URL aliases** — Path Auto and Redirect modules are included by default
  - **Scheduling** — publish/unpublish scheduling is available out of the box
- The **Coffee** module is also included — a quick-navigation tool similar to Alfred/Spotlight/Raycast that lets you jump to any admin page

---

## Trash Functionality

- Drupal CMS includes a **Trash** module out of the box
- When you delete content, it goes to the trash instead of being permanently removed
- From the Trash view you can:
  - **Restore** content
  - **Purge** content (permanent deletion)
- This solves a longstanding Drupal pain point where accidentally deleted content was unrecoverable
- The Trash module is also available as a standalone contrib module for existing Drupal sites

---

## Workflow

- **Editorial workflow** is included out of the box with states: Draft, Published, Unpublished
- Workflow allows you to configure **transitions** between these states
- The trash feature is separate from the publish/unpublish workflow — it adds an extra base field to the database rather than simply unpublishing content
- You can also **duplicate content** directly from the admin interface

---

## Dashboards

- Drupal CMS includes a **Dashboard** feature accessible from Structure > Dashboards
- You can add and edit dashboard widgets
- Multiple dashboards can be created for different purposes

### Additional Out-of-the-Box Features

- **Symfony Mailer Lite** — email template management built in
- **Media types** — full media support including **SVG images**
- Standard Drupal features: menus, taxonomy, views

---

## Project Browser

- Drupal CMS includes the **Project Browser** — a built-in module installer
- Navigate to **Extend > Browse** to search and install modules directly from the admin UI
- Modules now have **icons** on the project page for easier identification
- Installing a module is as simple as clicking the **Install** button
- Example: Installing **Field Group** takes just one click

### How It Works

- The Project Browser handles dependencies automatically
- Modules are installed into `modules/contrib/`
- Some modules (like Field Group) may already be a dependency of Drupal CMS

### Automatic Updates

- Drupal CMS supports automatic updates, though this was not demonstrated live
- This addresses a major pain point compared to WordPress, where automatic module updates have long been standard

---

## Recipes

- **Recipes** are a new way to package and install Drupal functionality
- They are similar to the older **Features** module concept: bundle content types, fields, and configuration together
- Recipes ship configuration as **YAML files** along with a `composer.json` for dependencies and a `recipe.yml` manifest

### How Recipes Work

- A recipe can include: content types, fields, views, default content, and configuration overrides
- Recipes can override configuration from other modules
- Each recipe has its own `composer.json` to manage dependencies
- Drupal CMS ships with many built-in recipes

### Installing a Recipe

- Go to **Extend > Recipes** to see available recipes
- Click **Install** on any recipe (e.g., Events)
- The recipe creates the content type, fields, and any default content automatically
- Installation is fast — the Events recipe creates a full event content type in seconds

### Uninstalling Recipes

- There is no formal "uninstall recipe" mechanism
- You can manually delete whatever the recipe created (content types, fields, etc.)
- Unlike installation profiles, **recipes do not lock you in** — you can freely modify or remove what they created

### Developing Recipes

- There are discussions about a `drush generate:recipe` command for creating custom recipes
- The goal is to build functionality once, package it as a recipe, and reuse it across projects

---

## Install AI Modules

- Drupal CMS ships with several AI modules in the Extend page
- Key AI modules to install:
  - **AI** (base module)
  - **AI Extras Form Integration**
  - **AI Agents Explorer**
  - **AI Chatbot**
- Installing these modules automatically pulls in all required dependencies
- The AI modules provide: CKEditor integration, content suggestions, and **AI Agents** for site building

---

## Add OpenAI Key

1. Go to **Configuration > Keys**
2. Add a new key — the **Keys** module manages API keys securely in Drupal
3. Select **OpenAI** as the provider
4. Enter your OpenAI API key (requires an OpenAI account with billing enabled)
5. Save the key

**Security note:** When you edit a saved key, Drupal shows a confirmation step before revealing it. This prevents accidental exposure during screen shares or live streams — an improvement over some other CMS platforms where API keys are displayed in plain text.

---

## Create AI Assistants

1. Go to **Configuration > AI Assistants**
2. Click **Add AI Assistant**
3. Name it (e.g., "Drupal Site Builder")
4. You can create **multiple assistants** for different purposes — one for content management, another for site building
5. Add **extra instructions** to customize the assistant's behavior
6. Select your **provider** (e.g., OpenAI)
7. Select **Agent Actions** — these determine what the assistant can do

---

## Agent Actions

- Agents are provided by the installed AI modules and define specific capabilities
- Available agents include:
  - **Content Type** management (create, modify content types)
  - **Field** management (add, configure fields)
  - **Taxonomy** management (create vocabularies and terms)
  - **Web Form** management
  - **Module** management (enable/disable modules)
  - **Views** management (still experimental)
- Agent code lives in `modules/contrib/ai_agents/src/Plugins/`
- **Limitation:** AI agents currently **cannot create or edit nodes** (content) — they can only manage site structure (content types, fields, taxonomy)

---

## AI Default Settings

- Under **Configuration > AI**, you can adjust default settings
- The system auto-detects which capabilities your provider supports (e.g., audio-to-audio)
- OpenAI-supported features are pre-selected by default

---

## AI Agents Settings

- Each agent has its own configuration page with additional settings
- The **Field Type Agent** has extra configuration options
- There is significant depth to the configuration — a dedicated deep-dive presentation would be valuable
- AI operations can feel like a "black box" — the Agent Decisions log (see below) helps with transparency

---

## Display Chatbot via Blocks

1. Go to **Structure > Block Layout**
2. Select the **Gin** theme (admin theme) — not the front-end theme
3. Add a block to a region (e.g., Content)
4. Select **Deep Chat** as the block type
   - Deep Chat is a JavaScript chat library
   - If you select "AI Chatbot" it will redirect you to use Deep Chat anyway
5. Configure introductory messages and styling
6. Save — the chatbot now appears in the admin interface

---

## Create Prompt to Create Content Types

- You can use the chatbot to create content types by writing detailed prompts
- Example prompt: "Create a course system in Drupal with a Course content type, Lesson content type, and Course Category vocabulary"

### Tips for Effective Prompts

- **Be as specific as possible** — include machine names, field types, and labels
- Specify machine names explicitly (e.g., `field_course`, `field_lesson_video`)
- Specify field types (e.g., text, entity reference, formatted long text)
- Include taxonomy terms you want pre-created
- Complex prompts may take ~20 seconds to process
- If a prompt fails, try breaking it into smaller requests

---

## Debug Using Agent Decisions

- Navigate to the **Agent Decisions** log to see all actions taken by AI agents
- Each decision shows:
  - The **prompt** sent to the AI (including system context)
  - The **response format** the AI generated
  - The **action** taken (e.g., field manipulation, content type creation)
  - **Success or failure** status with error details
- This is invaluable for debugging when AI actions fail or produce unexpected results
- Example: A creation step may fail because a content type "already exists" — the log makes this clear

---

## Create Project Content Type and Fields Using Chatbot

- Example: "Please create a content type called Project with a description field, machine name field_project_description"
- The chatbot created the content type and field successfully
- For simple, well-specified requests, the AI is reliable and fast

---

## Create Taxonomy Vocabulary Using Chatbot

- Example: "Create a taxonomy vocabulary called Project Category with terms: Drupal, WordPress. On the Project content type, create an entity reference field pointing to the Project Category vocabulary with machine name field_project_cat"
- The chatbot can handle multi-step requests: create vocabulary, add terms, create reference field

---

## Reorder and Change Widget Using Chatbot

- You can ask the chatbot to change field widgets and reorder fields on content types
- **What worked:** "On the lesson content type, change the field_lesson_video widget to use the Media Library" — successfully changed from autocomplete to media library
- **What worked:** "On the lesson content type, change the field_course widget to select list widget" — successfully changed from autocomplete to select list
- **What did not work initially:** The chatbot sometimes responds with *instructions on how to make the change* instead of actually making it. You need to explicitly say "can you please make the change for me" rather than just describing what you want.

### Key Lesson

- Be very specific with machine names and widget names
- Read the chatbot's response carefully — it may describe the steps rather than execute them
- Sometimes you need to repeat or rephrase the request
- Even getting **80% of site building done through AI** saves significant time

---

## Intro to ECA

- **ECA** stands for **Event, Condition, Action** — a workflow automation module
- ECA has been in the Drupal ecosystem for a while and now ships with Drupal CMS
- You can set up automated workflows triggered by events, filtered by conditions, and executing actions
- The **content duplication** feature in Drupal CMS is actually implemented entirely using ECA (not a custom or contrib module)

### ECA + AI Integration

- Install the **ECA AI Integration** sub-module from Extend
- This enables AI-powered actions within ECA workflows

---

## Install AI ECA Module

- Go to Extend and install **ECA Content** (endpoint) and **AI Integration** modules
- This enables AI actions to be used as steps in ECA workflows

---

## Add List Summary Field to Content Type

- For the demo, a **Formatted Long Text** field called "List Summary" was added to the Blog Post content type
- This field will hold AI-generated summaries
- The field was added manually through the admin UI (sometimes faster than asking the AI for a single field)

---

## Create ECA Model to Summarize Content

- **Goal:** On saving a blog post, automatically grab the content body, send it to OpenAI for summarization in bullet-point format, and save the summary to the List Summary field
- This uses an ECA workflow with:
  - **Event:** Content save (node presave or postsave)
  - **Condition:** Check content type is Blog Post
  - **Action:** Send body text to OpenAI, receive summary, populate the List Summary field

[REVIEW: The transcript is cut off during this section. The raw transcript ends mid-sentence while Ivan is explaining the ECA summarization workflow setup. The following video chapters are not covered in the available transcript:]

- Create ECA model to summarize content (partial)
- Install AI sub-modules
- AI API Explorers
- Added AI button to CKEditor
- Ending

---

## Viewer Q&A Highlights

**Q: Can AI agents be used to debug existing issues?**
A: Not really for PHP fatal errors — the site needs to be running for the agents to work. The agents are more about asking questions about your site and getting it to perform structural tasks, not debugging code errors.

**Q: Can you uninstall a recipe?**
A: There is no formal uninstall mechanism. You manually delete whatever the recipe created. Unlike installation profiles, recipes do not lock you in.

**Q: How does this compare to WordPress module management?**
A: The Project Browser makes module installation similar to WordPress in terms of ease. WordPress still has the advantage of long-standing automatic updates, though those can also cause breakage. Drupal CMS now supports automatic updates as well.

**Q: Can AI agents run Drush commands?**
A: The agents work through specific agent plugins, not arbitrary Drush commands. Each agent handles a particular domain (content types, fields, taxonomy, etc.) and you need to have the corresponding agent module installed and enabled in your AI Assistant configuration.

**Q: Could you record a requirements meeting and have AI build the site?**
A: That is the direction things are heading — record a meeting, have AI generate a summary, and build the site structure automatically. We are not far from this being a reality.
