# Ruby Solutions Deep Dive — October 1, 2025
Source: https://youtu.be/_KV-fzHskuk

Deep dive on HackerRank's **Lisa's Workbook** problem, presented solutions, and coach feedback on study cadence and burnout management.

---

## [16:13](https://youtu.be/_KV-fzHskuk?t=973) Problem: Lisa's Workbook

Lisa has a workbook with `n` chapters. Chapter `i` contains `arr[i]` problems. Each page holds at most `k` problems, and **each new chapter starts on a new page** (problems from different chapters never share a page). A **special problem** is one whose problem number equals the page number it sits on. Return the total count of special problems.

### [3:55](https://youtu.be/_KV-fzHskuk?t=235) [approx] Parameters

- `n` — number of chapters
- `k` — maximum problems per page
- `arr` — 1-indexed array where `arr[i]` is the number of problems in chapter `i`

> "This is technically listed as easy, but it has so many variables to hold in your head. I think it deserves medium. The max score is 25 which is unusual — they know it's complicated."

---

## [13:27](https://youtu.be/_KV-fzHskuk?t=807) Mauricio's Solution (Refined)

Mauricio started with a data-structure approach, then refined to a direct simulation: for each chapter compute pages, for each page compute the first and last problem numbers on that page, then check if the page number falls in that range.

```python
def workbook(n, k, arr):
    page = 0
    special = 0
    for chapter_problems in arr:
        full_pages = chapter_problems // k
        remainder = 1 if chapter_problems % k != 0 else 0
        total_pages = full_pages + remainder
        for p in range(total_pages):
            page += 1
            first_problem = p * k + 1
            last_problem = min(first_problem + k - 1, chapter_problems)
            if first_problem <= page <= last_problem:
                special += 1
    return special
```

### [29:26](https://youtu.be/_KV-fzHskuk?t=1766) Key Math

- **`full_pages = chapter_problems // k`** — integer division gives the count of completely filled pages.
- **Remainder page:** if `chapter_problems % k != 0`, there's a trailing partial page. Add 1.
- **First problem on page offset `p`:** `p * k + 1` (1-indexed problems).
- **Last problem on page offset `p`:** `min(first_problem + k - 1, chapter_problems)` — the `min` handles the final partial page where the chapter runs out before `k` problems are used.

---

## [21:34](https://youtu.be/_KV-fzHskuk?t=1294) Coach's Alternative Framing: Dictionary Approach

The coach's first instinct was a dictionary `{page_number: [problems on that page]}`, building out the diagram from the problem statement as a data structure, then scanning each key to see if any value matches the key.

```python
# Sketch only
workbook = {}
page = 1
for chapter_problems in arr:
    pages_needed = chapter_problems // k
    if chapter_problems % k != 0:
        pages_needed += 1
    # assign problem ranges to page keys...
```

- **Pros:** Mirrors the visual diagram; easy to reason about.
- **Cons:** Extra memory for the data structure, extra loops to populate it.
- Mauricio's version eliminates the intermediate structure by tracking `first_problem` and `last_problem` as locals.

---

## [8:37](https://youtu.be/_KV-fzHskuk?t=517) Coach's Optimization Idea: Early Rejection

The coach proposed a filter that skips pages which **cannot possibly** contain a special problem before running the inner check.

### [3:18](https://youtu.be/_KV-fzHskuk?t=198) The Insight

For a given page number and current chapter:
- On page 1, we need the chapter to contain at least 1 problem.
- On page 2, the chapter must contain more than `k` problems (otherwise chapter 1's problems never reach page 2 from that chapter's page).
- **Generalized:** for page number `P` to possibly contain a special problem from the current chapter, the chapter must contain **more than `P` problems** (roughly — within that chapter's page span).

```
If current_chapter_problems < current_page_number:
    skip the inner page-match check entirely
```

> "It would allow us to do one less loop — or at least eliminate a lot of logic checks. The main thing is declaring from the start: what has to be true on any given iteration for us to move forward? If we can't move forward, skip to the next information."

The coach flagged that she had not tested this and invited the group to try it.

---

## [40:26](https://youtu.be/_KV-fzHskuk?t=2426) Why This Problem Felt Hard

Reactions from the group: *"Spaghetti and meatballs"*, *"I hate this problem"*. Coach agreed:

> "It's a hefty problem just mentally — holding all these variables and concepts in your head while keeping in mind that you're just returning an integer. The one-based indexing is a small annoyance piled onto the mental load."

The value of practicing it is **logical decomposition**, not raw algorithm skill. This mirrors the kind of multi-requirement feature work expected in the internship.

---

## [39:20](https://youtu.be/_KV-fzHskuk?t=2360) Study Cadence Discussion

Mauricio asked about the right mix of easy and medium problems per session.

### [44:11](https://youtu.be/_KV-fzHskuk?t=2651) Coach's Recommendation

- **Do not practice for 5 hours at a stretch.**
- **Start with easies.** Two or three per day. If you knock them out of the park, try **one medium**.
- **One medium per day is the ceiling** while you are at this stage.
- **Don't stack mediums on the same day.**

> "Once you've solved one to three medium problems total in under an hour, regardless of consistency, you're good with mediums at this stage. Move forward with the curriculum, move into the internship, and then keep practicing mediums there because you're preparing for the job hunt."

### [46:23](https://youtu.be/_KV-fzHskuk?t=2783) Signal That You're Ready to Interview

> "If you're finding success multiple times in a week, it's time to sign up for the interview. If the time limit is the only thing holding you back, sign up anyway — we can talk about it one-on-one."

---

## [27:02](https://youtu.be/_KV-fzHskuk?t=1622) Burnout & Emotional Reset

Mauricio observed that after a draining problem, the next one feels impossible regardless of difficulty.

> "If you've hit a problem like that, don't start another that day or even the next day. Your brain is still working on it in the background. Take a day — maybe two — and usually when you come back you can knock it out no problem. You get two wins: the solved problem, and a fresh start on the next."

Applies to easies and mediums alike. If two easies in a row crush you, **today is not a coding day. Don't push it.**

---

## [50:03](https://youtu.be/_KV-fzHskuk?t=3003) Habit-Building Reminder

> "Build good habits now — explaining your thought process, breaking down the problem, taking breaks. Bad habits follow you through your career. If you think you're burned out now, it's a lot worse on a 9-to-5 clock with results expected. Learn what good habits look like and what outcomes they lead to."
