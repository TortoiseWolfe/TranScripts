# Using AI Automators (Drupal AI) in Drupal CMS

**Source:** WebWash (Ivan Zugec) — https://www.youtube.com/watch?v=C8jMb0Ie6x0
**Date:** October 2025

---

## Introduction to Drupal AI

- AI is everywhere, but Drupal is well-positioned to benefit from the AI wave
- At **DrupalCon Vienna**, Dries Buytaert (founder of Drupal) emphasized in his keynote that Drupal needs to "head into the storm" of AI
- The **Drupal AI** module is a suite of modules available at `drupal.org/project/ai`
- Sub-modules include: **AI Core**, **Explorer**, **Automators**, **Search**, **Assistant**, **CKEditor Content**, and more
- Multiple **providers** are supported (OpenAI, Anthropic, etc.) plus third-party modules that extend Drupal AI
- This tutorial focuses on **AI Automators** specifically, which are easier to set up than full AI agents

---

## What Are AI Automators

- An **automator** is essentially a prompt attached to a field in Drupal
- When that field gets updated or inserted, the prompt runs automatically
- Example: attach an automator to a summary field that uses the article title as context, then prompt "generate a summary using the context below" -- the LLM generates and saves the result
- This tutorial covers:
  - Basic field automators (description, tags)
  - Audio-to-text transcription
  - CKEditor button automators
  - Chained automators
  - Social media post generation
  - Field Widget Actions

---

## Setting Up AI Assistant in Drupal CMS

- **Drupal CMS** comes with an AI assistant recipe that simplifies setup (you can also do this on vanilla Drupal Core)
- Go to **Extend > Recommended** and install the **AI Assistant** recipe
- The recipe installs all required modules and configures defaults
- After installation, **refresh the page** -- recipes install via Ajax and the UI does not auto-update
- Run `ddev drush cr` (clear cache) to ensure all buttons and UI elements appear
- A new **assistant chat button** appears in the admin UI (new in Drupal AI 1.2)

### Setting Up in Drupal Core (Without Drupal CMS)

- Examine the recipe source at `recipes/drupal_ai/` to see which modules are installed and what configuration is applied
- Install those modules manually and replicate the configuration

---

## Drupal AI Configuration

- Navigate to **Configuration > AI** to access default settings
- You can run **multiple providers** simultaneously (OpenAI, Anthropic, etc.) and select different models for different tasks (text generation, text-to-speech, etc.)
- Provider and model selections appear throughout the UI on individual automators as well

### Changing API Keys

- Go to **Configuration > System > Keys** -- Drupal AI uses the **Key module** for key management
- For local/test sites, database storage is acceptable
- For **production**, store keys as **environment variables** at the server level -- never in the database
- Configure the Key module to pull from environment variables so you can rotate keys without database access
- When editing a key, a confirmation warning appears because the actual key value will be displayed

---

## Installing Required Modules

### Install the Events Recipe

- Go to **Extend > Recommended** and install the **Events** content type recipe
- This creates an "Event" content type to use for the tutorial

### Install AI Automator Sub-Module

- Go to **Extend > List**, search for **AI Automators** and **AI CKEditor Integration**
- Install both modules

---

## What We Will Automate

- When creating an event, entering a **title** will automatically:
  - Generate a **description** (SEO-optimized)
  - Generate **tags** (taxonomy terms)
- Example title: "How to Set Up Drupal on Google Cloud and AWS"

---

## Description Field Automator

- Go to **Structure > Content Types > Event** and edit the **description field**
- Remove the "required" checkbox (the field must be empty on save for the automator to run)
- At the bottom of the field settings, find **Enable AI Automator**
- The available automator types are determined automatically by field type

### Configuration Steps

- Select **LLM Text** as the automator type
- Set **Input Mode** to **Base mode** (uses the title as context)
- Select **Title** as the context source (important -- it defaults to "revision log" which will not work)
- Enter a prompt, e.g.: "Generate a 200 character SEO description using the following context"
- Pass the context placeholder into the prompt

### Advanced Options

- **Workers** control how the automator executes:
  - **Direct** -- runs when you save the form (default, best for quick operations)
  - **Queue + Cron** -- for longer processes that might time out; requires cron
  - **Batch** -- processes through batch queue (not recommended)
- **"Edits when changed"** option:
  - By default, the automator only runs when the field is **empty**
  - If the field already has a value (manual or AI-generated), it will not run again
  - Enable "edits when changed" only if you want it to regenerate on every save

---

## Tags Field Automator

- Navigate to the **Tags** field on the Event content type
- Scroll down and enable the AI automator
- Select **Taxonomy** as the automator type (the list differs from the description field because this is an entity reference field)
- Set to **Base mode** and select **Title** as context
- Prompt example: "Based on the context given, generate three to five tags"
- Keep worker set to **Direct**
- **Weight** can be adjusted if one automator depends on another running first

---

## Testing the Automators

- Go to **Content > Add Content > Event**
- Enter a title like "Hosting a Drupal Site on AWS and Google Cloud"
- Set a date/time, leave description and tags **empty**
- Click **Save** -- the response takes a few seconds (if it saves instantly, something is wrong)
- After saving, tags appear immediately on the content page
- Edit the node to verify the description was populated (it is used for SEO, so may not display on the page)
- To **regenerate**: clear the field value, save again, and the automator will run again
- You can also manually edit the generated content and save without the automator overwriting it

---

## Audio Transcription Automator

### Create Audio Media Type

- Go to **Structure > Media Types** and add a new media type
- Name: **Audio**, description: "Used for audio files"
- Set **Media source** to **Audio file**
- Save -- a file field is automatically created

### Create Transcript Field

- Add a new field to the Audio media type: **Plain long text**, named **Transcript**

### Configure Audio Automator

- On the Transcript field, scroll down to **Enable AI Automator**
- Select **Audio to Text** as the automator type
- Input mode: **Base mode**
- Audio source: **Audio file** (auto-detected as the only other field)
- Under Advanced, you can optionally change the provider or add extra prompts, and adjust temperature
- Leave defaults and save

### Testing the Audio Automator

- Go to **Media > Add Media > Audio**
- Upload an MP3 file and save
- The **Whisper** model transcribes the audio and populates the Transcript field
- Whisper is highly accurate -- it handles accents well and recognizes technical terms like "Drupal" and "Drush"
- Minor issues: compound words or camelCase names (e.g., "WebProfiler") may not be formatted perfectly

---

## CKEditor Automators

CKEditor automators let you create **custom toolbar buttons** that trigger AI generation directly within the rich text editor.

### Create Automator for Event Full Details

#### Create the Automator Chain

- Go to **Configuration > AI > Automator Chain Settings**
- Add a new chain called **Generate Full Details**
- This creates an entity type with Manage Fields, Manage Form Display, and Manage Display tabs

#### Add Fields

- Create an **Input** field (text plain long) -- set it as **required**
- Create an **Output** field (text formatted long) -- this is what gets passed to CKEditor

#### Configure the Output Automator

- On the Output field, enable the AI automator and select **LLM Text**
- Set **Base mode** with **Input** as the context source
- Enter a detailed prompt with examples of desired output style
- **Context matters enormously** -- providing real-world examples in your prompt produces much better results
- If your data is already in Drupal, you can use custom tokens to pass real data as examples
- Set worker to **Direct**

### Add Automator to CKEditor

- Go to **Configuration > Text Formats and Editors** and configure your text format
- Find the **AI CKEditor** button in the toolbar and drag it into the toolbar
- Under **AI Tools CKEditor**, enable the **Generate Full Details** automator
- Configure: set **Input** as the input field, output is auto-detected
- **Write mode**: Replace (replaces editor content with the generated output)
- If using **Limit Allowed HTML** filter, make sure required HTML tags (like `<hr>`) are in the toolbar so they are allowed

### Testing the CKEditor Automator

- Edit an Event, click the **AI** button in CKEditor toolbar
- A popup appears with Input and Output fields
- Enter a prompt like: "Can you generate an event description using the following title: [paste title]"
- Click **Generate** -- the automator runs and populates the output
- **Always review the output** -- AI can hallucinate; verify specific keywords from your input appear in the response
- Click **Save Changes to Editor** to insert the generated text

---

## Create Automator for Event Summary Details

### Create the Summary Chain

- Go to **Automator Chain Settings** and create **Generate Summary**
- Reuse the **Input** and **Output** fields (every automator needs these)
- Add a **Length** field (text plain, required) to make character count configurable (e.g., 200 or 300 characters)

### Configure the Summary Output Automator

- Enable AI automator on the Output field, select **LLM Text**
- Use **Advanced mode** (needed when pulling context from multiple fields)
- In advanced mode, placeholders are replaced with **tokens** -- browse available tokens under "Automated Chain" to find input and length fields
- Prompt includes instructions to rewrite the event description, respect the character length, add hashtags, and wrap in a blockquote

### Add Summary Automator to CKEditor

- In text format configuration, enable the **Generate Summary** automator
- Set **Input** to use **text selection** -- this grabs the currently selected text in the editor (no need to copy/paste manually)
- Set input as required
- Set **Write mode** to **Prepend** (adds summary above existing content without replacing it)

### Testing the Summary CKEditor Automator

- Select existing text in the editor, click AI > Summary
- Set a length value (e.g., 250 characters)
- Click Generate -- the summary is created and prepended to the existing content
- The original text is preserved; the summary appears above it in a blockquote

---

## Combined Full + Summary Automator

To avoid a two-step process, create a single automator that generates both full details and a summary in one pass.

### Create the Combined Chain

- Go to **Automator Chain Settings** and create **Generate Full + Summary Details**
- Add fields: **Input**, **Output**, **Generate Full Details** (text formatted long), **Generate Summary Details** (text formatted long)

### Configure Chained Automators

1. **Generate Full Details** field: enable automator, select LLM Text, base mode, context = Input
2. **Generate Summary Details** field: enable automator, select LLM Text, base mode, context = **Generate Full Details** (uses the full output as its input)
   - Hardcode the character length in the prompt (e.g., 200 characters) instead of using a configurable field
3. **Output** field: enable automator, use **tokens** to combine both full and summary outputs
   - Tokens reference the Generate Full Details and Generate Summary Details fields

### Verify Run Order

- Check **AI Automator Run Order** to confirm the execution sequence:
  1. Full Details (uses Input)
  2. Summary (uses Full Details)
  3. Output (uses Full + Summary)
- Adjust order if needed

### Add to CKEditor and Test

- In text format configuration, enable the **Full + Summary** automator
- Configure input and output fields as before
- When triggered, it runs three automators in sequence and produces the combined output with a horizontal line separator
- The result contains both the full event description and the summary in one generation pass

---

## AI Logging

### Why Use Logging

- Essential for debugging when automators produce unexpected results
- Shows exactly what context and prompts are being sent to the LLM
- Reveals token usage per request (important for cost monitoring)

### Enable AI Logging

- Go to **Extend** and install the **AI Logging** module
- Navigate to **Configuration > AI > Logging > Settings**
- Enable both **Log Requests** and **Log Responses**

### Viewing AI Logs

- Go to **Configuration > AI > AI Logs**
- Each automator run creates separate log entries (e.g., a chained automator with 3 steps creates 3 log entries)
- Log entries show:
  - The full prompt with all tokens **rendered** (not just placeholder names)
  - Input tokens and output tokens consumed
  - The actual LLM response
- Use logs to verify that context variables are being passed correctly and that the AI is not hallucinating

---

## Generating Social Media Posts

### Use Case

- For each live stream event, generate pre-show and post-show social media posts
- Pull the event description and date from the parent event to populate social posts automatically

### Create "Social Post" Content Type

- You can use the **AI Assistant chatbot** in Drupal CMS to create content types via natural language:
  - "Create a new content type called social post"
  - "Reuse and attach the field_content field and create an entity reference field with machine name field_parent targeting the event content type"
- The AI assistant uses **agents** under the hood to execute site-building tasks
- It may not complete everything perfectly -- in this case, it created the content type and parent reference but did not attach the content field (manual fix needed)
- Agent operations consume significant tokens (8,000-9,000 per request in the logs)

### Add Content Field to Social Post

- Manually reuse the **field_content** field on the Social Post content type if the AI assistant did not attach it

### Import a Custom View

- Import a pre-built view configuration to display social posts as a tab on the Event page
- You can import Drupal config YAML directly via the configuration import UI
- The view shows a list of social posts filtered by their parent event

### Create and Configure Social Post Automator

- On the Social Post content type, edit the **Content** field
- Enable AI automator, select **LLM Text**
- Use **Advanced mode** to pull context from the parent event (description, date) via tokens
- The automator generates social media post content based on the parent event's data

[REVIEW: The raw transcript cuts off at this point (around 1:07:45 in the video). The following sections are summarized from chapter titles only -- the full transcript content for these sections was not available.]

### Test Social Post Automator

- Create a social post linked to an event and save
- The automator pulls event data and generates a social media post

---

## Field Widget Actions

- **Field Widget Actions** provide an alternative to the Direct worker for triggering automators
- Instead of running automatically on save, a **button appears on the field widget** that the user clicks to trigger generation
- This gives editors more control over when AI generation happens

### Configure Field Widget Actions

- On the automator configuration, change the **worker** from Direct to **Field Widget Actions**
- On the field's **form display** settings, configure the widget to show the action button
- When editing content, a button appears next to the field -- click it to trigger the automator on demand

### Using Field Widget Actions on Taxonomy Fields

- Field Widget Actions also work on taxonomy/entity reference fields
- Useful for generating tags on demand rather than automatically on every save

---

## Extending Automators with Custom Code

- The automator plugin system is extensible -- browse existing plugins at `ai/automators/source/plugins/`
- Available plugin types include: audio-to-string, audio-to-text, speech generation, video-to-HTML (uses FFmpeg), video-to-image
- To integrate with an external API endpoint, create a custom automator plugin by extending an existing one
- **ECA (Events, Conditions, Actions)** is another option for complex workflows that go beyond what automators provide
- Progression path: Automators (80-90% of use cases) > ECA for customization > Custom code for full control

---

## Recap

- **AI Automators** attach prompts to Drupal fields that run on save or on demand
- **Basic automators**: generate descriptions, tags, and transcriptions automatically
- **CKEditor automators**: add AI generation buttons to the rich text editor toolbar
- **Chained automators**: link multiple generation steps together (e.g., full details then summary)
- **AI Logging**: essential for debugging prompts, verifying context, and monitoring token costs
- **Social post generation**: use entity references and tokens to pull context from related content
- **Field Widget Actions**: give editors manual control over when AI runs
- **Context is king**: providing examples and real data in prompts dramatically improves output quality
- **Key management**: always use environment variables for API keys in production
- Learn more at `drupal.org/project/ai`
