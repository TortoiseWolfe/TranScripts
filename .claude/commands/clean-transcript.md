# Clean Transcript for GPT Context

Clean the specified transcript file(s) by removing filler content while preserving actionable, educational material suitable for context engineering a custom GPT.

## Input
$ARGUMENTS

If no file specified, ask which transcript file(s) to clean.

## What to REMOVE

### Conversational Filler
- Pre-session waiting/greetings ("Hey, how's it going?", waiting for people to join)
- Technical difficulties ("My internet is laggy", "Can you hear me?", "Let me share my screen")
- Pure small talk (weather, pets, family chat, personal life tangents)
- Pleasantries ("You're so kind", "Thank you so much everyone")
- Meta-commentary ("I'm going to share my screen now", "Can everyone see this?")

### Verbal Filler
- Remove all: "um", "uh", "you know", "like" (as filler), "right?", "okay so"
- Incomplete/abandoned sentences that trail off
- Repeated false starts

### Off-Topic Content
- Personal job situations not teaching the main subject
- Tangential Q&A unrelated to the core topic
- Inside jokes or references that don't add educational value

## What to KEEP

### Core Educational Content
- Strategic frameworks and methodologies (named systems, step-by-step processes)
- Specific actionable advice and best practices
- Examples, templates, and sample scripts
- Statistics and data points
- Tool recommendations and how-to instructions
- Relevant Q&A that clarifies the topic for all learners

### Structure Elements
- Course/topic context (week number, topic name)
- Section transitions that help organize content
- Summary points and key takeaways

## What to FLAG
Mark ambiguous content with `[REVIEW: reason]` for human review:
- Personal anecdotes that might illustrate a teaching point
- Motivational content that could provide valuable context
- Q&A where relevance is unclear
- Tangents that might circle back to strategy

## Output Format

```markdown
Title of Session (Week/Topic if applicable)
Source URL (if present)

---

## Section Header

- Bullet points for lists
- **Bold** for emphasis on key terms
- Keep paragraphs short (2-3 sentences max)

### Subsection for detailed breakdowns

---

## Next Major Section
```

## Process
1. Read the entire transcript first
2. Identify the core educational structure and topics
3. Remove clear filler content
4. Clean verbal filler from remaining content
5. Reorganize into logical sections with markdown headers
6. Flag any ambiguous sections with [REVIEW: reason]
7. Add section breaks (---) between major topics
8. Write the cleaned version

Report the approximate reduction percentage when complete.
