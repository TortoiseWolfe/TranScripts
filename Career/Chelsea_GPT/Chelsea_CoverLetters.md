# Chelsea on Cover Letters

This file holds the cover-letter-specific reference material for the Chelsea GPT. Unlike LinkedIn and Resume, the Chelsea corpus does not contain full cover-letter transcript sessions — the existing `COVERLETTER_SYSTEM_PROMPT.md` was already self-contained. This file consolidates that material plus expanded examples and templates.

The high-level doctrine is already in `Chelsea_CoachingPhilosophy.md` (Part 3). This file is the deeper reference the GPT can draw on when actually drafting or reviewing a letter.

---

## When to Draft vs. When to Ask

**Never draft a cover letter without the job description.** A cover letter that doesn't reference the specific posting is useless — and Chelsea considers it worse than no cover letter, because it signals the applicant didn't bother to research.

Before drafting, the GPT must have:
1. **Job description** (URL the GPT can fetch, or pasted text)
2. **User's resume** (or at minimum a summary of their key accomplishments and tech stack)
3. **Company name and role title**

Optional but helpful:
- Why the user wants this specific role
- Any connection to the company (referral, mutual contact, product user, attended an event)
- Specific accomplishments the user wants to highlight
- Tone preference based on company culture

**If required inputs are missing, ask. Do not make up content.**

---

## The 3-Paragraph Structure (Full Reference)

A Chelsea cover letter is **three paragraphs, 250–350 words, one page**. Every sentence earns its place.

### Paragraph 1 — The Hook (3–4 sentences)

Grab attention, state the role, show you know the company.

**Sentence 1 — The specific hook.** Never "I am writing to apply for..." Start with something recruiters remember:
- A reaction to a recent company event: "When Stripe published the Sigma internals post, I..."
- A specific product experience: "I've been using Linear daily since the beta and..."
- A referral: "Maria Chen suggested I reach out about the Platform Engineer role."
- A mission connection: "Your mission to make accessibility default instead of opt-in matches..."

**Sentence 2 — Role and company, named.** State exactly what you're applying for. "I'm applying for the Senior React Engineer role at [Company]." This is also a copy-paste sanity check — if you're pasting a template, seeing the wrong name here is easier to catch.

**Sentence 3 — Company connection.** Why THIS company. Not why *a* company in this industry — why this one specifically. Research signal: you read their blog, understand their stack, know their recent moves.

**Sentence 4 — Bridge to value.** Transition into what you bring. "My background in accessible web development and design systems lines up directly with what your job posting emphasizes."

### Paragraph 2 — The Fit (4–6 sentences)

Match your experience to their needs. This is where most cover letters die — they list resume bullets instead of matching needs.

**The formula:** `Their need → Your experience → Outcome/Impact`

Pick the **top 2–3 requirements** from the job posting. For each one, name your matching experience and the result.

**Example (bad — resume bullets restated):**
> I have experience with React, TypeScript, and Node.js. I've built several full-stack applications including a budgeting app and a task manager. I am familiar with Agile methodology and have worked in team environments.

**Example (good — need-matched):**
> Your posting emphasizes building accessible React components for users with disabilities. At Trinam, I developed Revit plugins used daily by a dozen drafters — that experience taught me to build tools that real users depend on, with failure modes that matter. I've since applied that user-focused approach to web development, achieving a 98/100 Lighthouse accessibility score on SpokeToWork.
>
> You also mention cross-functional collaboration with design and product teams. In my current role, I pair weekly with our product designer to translate Figma prototypes into production React, which has cut our design-to-deploy cycle from two weeks to five days.

Notice what the good version does:
- Quotes the job posting ("your posting emphasizes," "you also mention")
- Names a specific prior role
- Uses concrete numbers (dozen drafters, 98/100, two weeks → five days)
- Ties each point back to why it matters to *this* company

### Paragraph 3 — The Ask (2–3 sentences)

Clear call to action, enthusiasm, gratitude. Brief.

**Example:**
> I'd welcome the opportunity to discuss how my background in automation and accessible web development could contribute to [Company]'s engineering team. Thank you for your time and consideration — I look forward to hearing from you.

Avoid:
- "I really need this job" (desperation)
- "I believe I would be a perfect fit" (empty enthusiasm)
- Discussing salary or benefits (save for later)
- Apologizing for gaps or lack of experience

---

## Keyword Integration

Cover letters should mirror the job posting's language, especially in Paragraph 2.

**Process:**
1. Highlight 5–7 keywords from the job description.
2. Use exact terminology — "TypeScript," not "TS." "React," not "React.js" unless the posting uses that form.
3. Embed naturally in Paragraph 2's need/experience statements.
4. Don't force — authenticity over keyword density. If a keyword doesn't fit naturally, skip it.

**Common keywords to mirror:**
- Role title exactly as posted ("Staff Software Engineer" not "senior dev")
- Tech stack names as the company writes them
- Methodology terms (Agile, Scrum, CI/CD, TDD, Kanban)
- Soft skill phrases the posting uses ("cross-functional collaboration," "stakeholder communication," "customer-focused")

---

## Tone Calibration by Company Type

Match the company's voice. A startup and a Fortune 500 financial services firm do not read the same cover letter the same way.

| Company Type | Tone | Example Adjustment |
|---|---|---|
| **Early-stage startup** | Conversational, energetic | "I'm excited to dig into what you're building..." |
| **Enterprise / Fortune 500** | Professional, measured | "I am eager to contribute to [Company]'s engineering initiatives..." |
| **Creative agency / design studio** | Personality-forward | Show wit, a unique voice, a personal angle |
| **Technical / infrastructure / dev tools** | Direct, results-focused | Lead with concrete metrics and technical specifics |
| **Nonprofit / mission-driven** | Values-aware, earnest | Tie personal story to mission without being saccharine |

**Research signals** for calibrating tone:
- Read the company's blog or engineering blog — match its register
- Look at the job description itself: formal vs. casual word choices
- Glassdoor reviews for culture hints
- Twitter/LinkedIn posts from the team

---

## Formatting and Delivery

**File format:** RTF (Rich Text Format)
- RTF is text-based, so it can be written directly with formatting
- Accepted by almost all application systems
- Accepted job application formats: `.doc`, `.docx`, `.rtf`, `.odt`, `.pdf`, `.txt` — RTF is the sweet spot for drafting

**File naming convention:** `CoverLetter_[Company]_[JobID].rtf`
- Example: `CoverLetter_TDOC_73325.rtf`
- Use the job ID from the posting if available; falls back to role name otherwise

**Save location (per TranScripts convention):** `Career/CoverLetter_Edited/private/`
(`private/` is gitignored — cover letters are personal data)

**Layout:**
- Standard business letter format
- 0.75–1 inch margins
- 11pt professional font (Calibri, Arial, Georgia)
- Single page maximum
- No header or footer (ATS compatibility)

**Header block at top:**
```
[Your Name]
[Email] | [Phone] | [LinkedIn URL] | [Portfolio URL]

[Date]

[Hiring Manager Name, if known]
[Company Name]
[City, State]

Dear [Hiring Manager / Hiring Team],
```

Use "Dear Hiring Team" if no hiring manager name is available. Never "To Whom It May Concern" — it's dated and signals no research.

---

## Common Mistakes Checklist

Flag any of these during review:

1. **Generic opening** ("I am writing to apply for the [role] at [company]...")
2. **No company-specific content** — the letter could be sent to any company with name swaps
3. **Resume bullets repeated verbatim** — cover letters are not a second resume
4. **No clear connection** between user's experience and the role's needs
5. **Missing call to action** in paragraph 3
6. **Longer than one page** — never
7. **Wrong company or role name** — copy-paste errors are fatal
8. **Desperation signals** — "I really need this job," "I would do anything for this opportunity"
9. **Salary or benefits discussion** — save for the interview
10. **Apologizing** for gaps, lack of experience, or being a career changer — frame as strength instead
11. **Overformality in a casual startup context**, or excessive casualness in enterprise context
12. **Closing with "Sincerely yours" + typo in signature** — check every word

---

## Starter Templates (Fill-in-the-Blank)

Only offer these after the GPT has the job description and user info. These are scaffolding, not ready-to-send.

### Template 1 — Direct Application, No Referral

```
Dear [Hiring Manager Name / Hiring Team],

[SPECIFIC HOOK — react to a product, mission, or recent company event]. I'm applying for the [EXACT ROLE TITLE] role at [COMPANY NAME] because [ONE-LINE REASON GROUNDED IN RESEARCH]. My background in [YOUR CORE AREA] lines up directly with what you're looking for.

Your posting emphasizes [REQUIREMENT 1]. At [PRIOR COMPANY/PROJECT], I [SPECIFIC EXPERIENCE] — which [CONCRETE OUTCOME]. You also mention [REQUIREMENT 2]; in my [CURRENT ROLE/RECENT PROJECT], I [RELATED EXPERIENCE], [CONCRETE RESULT]. [OPTIONAL: REQUIREMENT 3 + EXPERIENCE + RESULT.]

I'd welcome the opportunity to discuss how my [CORE STRENGTH] could contribute to [COMPANY]'s [SPECIFIC TEAM OR INITIATIVE]. Thank you for your time and consideration.

Sincerely,
[Your Name]
```

### Template 2 — Referral

```
Dear [Hiring Manager Name],

[REFERRAL NAME], [REFERRAL'S RELATIONSHIP TO YOU OR COMPANY], suggested I reach out about the [EXACT ROLE TITLE] role at [COMPANY]. [REFERRAL] and I [SHARED CONTEXT], and they thought my background in [YOUR CORE AREA] would line up well with what your team is building.

[Rest of letter follows Template 1's paragraphs 2 and 3.]
```

### Template 3 — Career Changer

```
Dear Hiring Team,

[SPECIFIC HOOK]. I'm applying for the [ROLE] at [COMPANY] as a [CURRENT FIELD] professional transitioning into [TARGET FIELD]. The skills that made me effective at [PRIOR FIELD] — [TRANSFERABLE SKILL 1], [TRANSFERABLE SKILL 2] — are the same skills your posting emphasizes.

Your posting mentions [REQUIREMENT]. In my [PRIOR ROLE], I [RELEVANT EXPERIENCE FRAMED AS TRANSFERABLE]. Since deciding to make this transition, I've also [RECENT LEARNING PROJECT WITH CONCRETE OUTPUT — e.g., built X, completed Y boot camp and shipped Z, contributed to open-source W].

I'd welcome the chance to show how my cross-domain background could contribute to [COMPANY]'s team. Thank you for considering a non-traditional candidate.

Sincerely,
[Your Name]
```

---

## Review Checklist

When the user pastes a cover letter for review, walk through:

- [ ] Does the hook open with something other than "I am writing to apply..."?
- [ ] Is the specific role and company named in paragraph 1?
- [ ] Is there a clear company connection (product, mission, news) in paragraph 1?
- [ ] Does paragraph 2 quote or paraphrase the job description's needs?
- [ ] Does paragraph 2 match 2–3 specific experiences to those needs?
- [ ] Are there concrete outcomes (numbers, scopes, results) in paragraph 2?
- [ ] Are job-posting keywords integrated naturally (not stuffed)?
- [ ] Does paragraph 3 include a clear call to action?
- [ ] Is the whole letter under 350 words?
- [ ] Does it fit on one page?
- [ ] Is the company/role name spelled correctly and consistent throughout?
- [ ] Are there any resume bullets pasted verbatim? (Flag them.)
- [ ] Are there any desperation, apology, or salary phrases? (Flag them.)
- [ ] Does the tone match the company type?
- [ ] Is there `[PLACEHOLDER]` or `[VERIFY]` content the user still needs to fill in?

---

## Key Principles

1. **A cover letter is not a resume summary — it's a persuasion document.**
2. **Specificity beats enthusiasm.** Show you researched the company.
3. **Match their language.** Use the exact keywords from the job description.
4. **One page, always.** Respect the reader's time.
5. **Every sentence earns its place.** Cut fluff ruthlessly.
6. **Never fabricate.** If you don't know something about the user or the company, ask or leave a placeholder.
