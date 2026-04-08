# Ruby Mock Interview — August 10, 2025

*Nailing the Tech Interview — Sunday session*

## HackerRank Certifications: Worth It?

Extended discussion on whether HackerRank certifications are worth pursuing.

### TLDR

- **Most interviewers and companies don't pay much attention to them.**
- They're **fun** and don't hurt to have on a resume or LinkedIn, but they rarely move the needle.
- For **development roles** there is no real equivalent to, say, PMP certification in project management.

> "I don't think companies really care about them too much. Not having them won't hurt you."

### Available HackerRank certification tracks

- **Software Engineer Intern** — Problem Solving + SQL.
- **Software Engineer** — Problem Solving + SQL + REST API.
- **Frontend Developer (React)** — 1–2 multiple choice + 2 mini project-based questions.
- **Frontend Developer (Angular)** — similar format.
- **JavaScript** — Basic, Intermediate (Advanced cert isn't actually offered even though it shows in the dropdown).
- **Python** — Basic, Intermediate.
- **Problem Solving** — Basic, Intermediate, Advanced.
- **PowerShell**, **Selenium**, **Tech Communication**, etc.

### What the Problem Solving levels correspond to

- **Basic** — roughly easy-level HackerRank problems.
- **Intermediate** — hashmaps, stacks, queues, Dijkstra, optimal solutions (medium level).
- **Advanced** — trees, graph traversal, shortest path, dynamic programming (hard level).

### Python intermediate cert topic list

- Closures, decorators
- Advanced object-oriented programming
- Collections, exceptions, context managers
- Regular expressions
- Concurrent programming
- File operations, unit testing, logging, deployment

> "That would basically be like a really good summary of everything you learn in mod 2, scaled into one certification. I imagine it might be kind of tricky to do within an hour."

### When certifications *might* help

- If you've worked in a niche area (e.g., **Selenium** for QA automation) and are applying for a role that specifically asks for that skill, the cert might give a slight edge.
- If everything else is equal between two candidates, certs could tip the scales.

> "I'm a certified data scientist, but companies do not really pay attention to that." — Brian

---

## Q&A: Practicing for Certification Exams

**Mina asked** about sites where you can pay a membership and take mock certification exams repeatedly until the real exam.

- HackerRank has mock exam content in its practice sections.
- Look at the **subskill breakdown** of a target certification (e.g., Software Engineer cert includes Problem Solving, SQL, communication) and practice each subskill individually.

---

## Tech Interview Structure (Joy of Coding)

- Joy of Coding's technical interview uses **HackerRank only**, not LeetCode.
- HackerRank problems at **easy level** give you all the info you need. LeetCode intentionally leaves info out, forcing more assumption-checking — good practice, but harder.
- **Readiness signal:** You can solve roughly **3 easy problems in a row under a 20-minute time limit**.
- The **Problem Solving track** on HackerRank covers everything from Joy of Coding mods 1 and 2.

### Topics that may appear on the tech interview

- Arrays and lists
- Dictionaries
- Searching and sorting
- Linked lists
- Stacks and queues
- Hashmaps
- Sliding window / basic algorithms
- (File I/O is listed in mod 2 but will **not** be tested.)

### Recommended readiness benchmark

Complete mod 2 through **projects 2 or 3**, then you're ready to try a mock interview.

---

## Mock Interview: Jumping on the Clouds (Lisa)

Lisa volunteered for a pseudo-code mock interview on the HackerRank **Jumping on the Clouds** problem.

### Problem summary

You're given an array of 0s and 1s representing clouds:

- `0` = safe (cumulus)
- `1` = unsafe (thundercloud)

Starting at index 0, you can jump **+1 or +2** each move. Find the **minimum number of jumps** to reach the last index.

### Constraints

- `2 <= n <= 100` where `n` is the array length
- `c[i]` is `0` or `1`
- `c[0] == 0` and `c[n-1] == 0` — **first and last are always safe**
- It is always possible to win the game

### Key insight from the constraints

> "It is always possible to win the game."

Because the starting and ending positions are always `0`, and you can always jump `+1` or `+2` from any safe cell, **you never need to track history or backtrack**. No edge case where "I jumped two before, now I'm stuck."

### Assumptions you can safely make

- First index is always `0` (safe).
- Last index is always `0` (safe) — you'll always land on it.
- Minimum array length is 2, so at least one jump is possible.

### Game plan (pseudo code)

```
# Given: c = array of 0s and 1s, starting at index 0
# Return: minimum jumps to reach the last index

i = 0
steps = 0
while i < len(c) - 1:
    # Prefer the +2 jump (fewer total jumps)
    if i + 2 < len(c) and c[i + 2] == 0:
        i += 2
    else:
        i += 1
    steps += 1
return steps
```

### Coaching feedback for Lisa

- **"Least number of jumps" implies a preference** for the `+2` jump whenever it's safe and in range. Always check the `+2` option first, then fall back to `+1`.
- When your index progression is **not fixed** (jumping 1 or 2), a **`while` loop** is usually cleaner than `for i in range(...)`. You can technically manipulate `i` inside a for loop, but it hurts readability.
- Watch for **out-of-range errors** when checking `i + 2` — guard with `i + 2 < len(c)`.
- Good job summarizing the problem in your own words and pulling out constraints before coding.

> "I like that re-summarization of the problem — it makes it easier to say 'all right, you're given an array of 0 or 1, you can land on a zero, one is not safe, and we want the least amount of jumps.'"

### How to classify this problem

- **Not** a specific algorithmic pattern — no sliding window, no DP trick, no formula.
- Just **linear iteration with index manipulation**. Straightforward loop + conditionals.
- Classified as early mod 1 / mod 2 fundamentals. Index manipulation, iterating a list, loop mechanics.

---

## Closing Notes

- Ruby is **running thin on new problems** to pose, since the group has covered arrays, dictionaries, searching/sorting, linked lists, stacks, queues, hashmaps, and sliding window extensively.
- Going forward, Sundays will focus more on **mock interviews** rather than lengthy explanation segments, to conserve problems.
- **Trees** are the one major data structure not yet covered. They're outside the Joy of Coding scope, but Ruby may introduce them if time permits.
- Brian will plan to do a mock interview **next week**.

---

## Key Takeaways

- **HackerRank certifications are mostly for fun** — they rarely affect hiring decisions for dev roles.
- **HackerRank > LeetCode at easy level** for tech interview prep because HackerRank includes all necessary context.
- Readiness benchmark: **3 easy problems solved in 20 minutes each, in a row**.
- **Read the constraints first.** Phrases like "it is always possible to win" eliminate whole categories of edge cases.
- For problems with variable step size (jumping 1 or 2), **prefer `while` over `for i in range`** — cleaner index control.
- **"Least jumps" = prefer the bigger step** when it's safe and in range.
- Always resummarize the problem in your own words before jumping into code.
