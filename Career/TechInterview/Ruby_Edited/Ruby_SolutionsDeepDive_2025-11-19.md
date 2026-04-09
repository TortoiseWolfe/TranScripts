# Ruby Solutions Deep Dive — November 19, 2025
Source: https://youtu.be/-4q6yvWZqxk

Announcement of schedule changes, introduction of the **Technical Interview Success Rubric**, and a mock interview on **Assign Cookies** (LeetCode Easy).

---

## Schedule Change: Wednesdays Only

Starting after Thanksgiving, there will be **no more Sunday sessions**. Wednesday sessions at 2:00 PM will remain, focused exclusively on **mock interviews** plus coaching discussion.

### Rationale

> "I'm kind of overwhelmed. It aligns with the direction Dr. Emily wants us moving — focusing on core things week to week and helping you advance through to the next phase. And the best way to advance is to practice mock interviews."

- **Homework-style problem breakdowns** are discontinued. The existing session recordings cover that material.
- Mock interviews will be **volunteer-based** or random selection — no mandatory sign-ups.
- **Pseudo code-only mock interviews are allowed** for candidates still building coding confidence.

---

## Technical Interview Success Rubric

The coach has conducted **over 115 technical interviews** and compiled observations into a draft rubric covering four dimensions:

### 1. Communication

**Meeting expectations:**
- Restate the problem in your own words.
- Explain what you think you need to do and what you expect to return.
- Sound out your thoughts while writing pseudo code and coding.
- Confidently answer follow-up questions about your code.

### 2. Technical Knowledge

**Meeting expectations:**
- Comfortable with **Mod 2** data structures and algorithms.
- Understand function parameters, input/output types, and test cases.
- Can read library/method documentation and apply it correctly.

### 3. Problem Solving

**Meeting expectations:**
- Break the problem into smaller pseudo-code steps.
- Test incrementally with print statements.
- Troubleshoot errors by identifying where they came from.

### 4. Behavior

**Meeting expectations:**
- Read the full problem including examples and constraints.
- Revisit the problem mid-solution to update assumptions.
- Bounce back from errors quickly without spiraling.
- Accept feedback and use it to advance.

### Time Correlation

- **Below expectations** → 20+ minutes, likely fails.
- **Meeting expectations** → around 20 minutes.
- **Exceeding expectations** → 10–15 minutes, ready for job-hunt level interviews.

### Pass Rate Reality

> "Out of the 115 I've run, eventually everyone passes — there's never been someone who didn't make it through unless they left the program or decided coding wasn't for them. The average is **two to three attempts**. Very rarely do people pass on the first try, and that's from nerves and being put on the spot for the first time."

### Common Failure Causes

- **Nerves and pressure.** Skilled candidates right on the cusp sometimes fail two or three times before passing.
- **Going down a spaghetti path.** Coach's remedy: recognize it fast, scrap it, and restart with better understanding.
- **Getting lost in errors.** One candidate said "I had an idea but every time I tried that in the past I hit errors, so I didn't even try it" — that idea was the solution.

> "Errors don't scare me. They're just telling me that something's wrong in my assumptions. The best way to handle them is incremental testing."

### The Incremental Testing Math

> "If you add 10–20 seconds of print-statement testing after each line, that adds up to maybe 2 minutes across the whole problem. If you're moving at a good pace, that's nothing. You can still solve the problem in under 10 minutes. Versus hitting an error with a whole code block written, now having to figure out which line caused it."

### Difficulty Escalation

Each subsequent attempt gets **incrementally harder** within the easy range — never crossing into medium territory.

> "After each time, I do expect you to be practicing and working on mastery. But we never leave the realm of easy. Probably as close to the edge of easy as we can get."

---

## Mock Interview: Assign Cookies (LeetCode Easy)

### Problem

> Assume you are a parent with several children and you want to give them cookies. Each child `i` has a greed factor `g[i]`, which is the minimum size of a cookie that will content them. Each cookie `j` has a size `s[j]`. If `s[j] >= g[i]`, you can assign cookie `j` to child `i` and the child will be content. Your goal is to maximize the number of content children.

### Function Signature

```python
class Solution:
    def findContentChildren(self, g: List[int], s: List[int]) -> int:
```

### John's Initial Confusion

Coming from a JavaScript/TypeScript background, John got tripped up by Python's type annotations:

- `g: List[int]` means `g` is a parameter of type "list of integers" — **not** a variable named `List`.
- `-> int` means the function returns an `int`.
- `int` in the annotation is **not an actionable variable** — it's a type reference. Similar to TypeScript.

> "Only `g` and `s` are actionable variables. The annotation `int` just tells you the expected return type."

### Coach Feedback: Pull the Problem Into Code Comments

John tried to reverse-engineer the problem from the function signature alone, which wasted time.

> "What can we pull from the problem statement into our code comments so that we can quickly at any point know what the goal of the problem is, what the inputs are, and what our expected output is?"

### Coach Feedback: Test Assumptions Early

John used the word "assumption" naturally while talking through his approach but didn't write or test his assumptions until later.

> "The first thing I would do is test an assumption. Eventually you did with a print statement — but not until a little bit later. Move that up in the timeline."

### The Approach Discussion

John asked which array to iterate through — children (`g`) or cookies (`s`). The coach steered him toward understanding:

- **Length of `g`** = number of children.
- **Each integer in `g`** = how much that child needs.
- **Length of `s`** = number of cookies.
- **Each integer in `s`** = size of that cookie.

### Standard Solution Sketch (Greedy)

```python
def findContentChildren(self, g, s):
    g.sort()
    s.sort()
    i = j = 0
    while i < len(g) and j < len(s):
        if s[j] >= g[i]:
            i += 1
        j += 1
    return i
```

- Sort both arrays, then walk through cookies and assign the smallest-sufficient cookie to the hungriest child who can still be satisfied.
- John didn't reach this in 20 minutes but was on the right conceptual path.

---

## John's Flash Cards / Cheat Sheet Technique

John mentioned he'd made **index cards** as flash cards for Python syntax after coming from JavaScript. They contained concept-level snippets — a basic for loop with `n` for length, data structure templates, not full problem solutions.

> "That's a great way to solidify your knowledge and have something to quickly glance at. The challenge is what to put on the flash cards — you don't want to overwhelm yourself."

> "Absolutely these are good templates/resources for the interview. Code samples at the concept level, not full solved problems."

---

## Silent vs Verbal Time Allocation

A participant asked about dynamics — how long a candidate should silently read the problem.

> "There's no limit. I've had people spend 8–15 minutes reading and pseudo-coding and only 2 minutes writing code. Or the opposite. Each person is different."

> "The important part isn't how long each step takes. It's: once you reach a point where you understand the problem enough to explain it, **can you then explain it out loud** as an observer? And at regular intervals, can you recap what you're thinking and doing?"

### What To Avoid

> "Sitting in silence the entire time until the end — whether all your test cases pass or you've hit an error and run out of time. You can pass while silent, but it's not great. Interviewers want to know how you think, not just whether you got there."

### Time Budget Warning

> "If you're spending 15 out of 20 minutes breaking down the problem with no pseudo code and no actual code, that's an indicator you need to shorten that step — not by skipping it, but by honing in on what you're doing."

---

## Takeaways

- Everyone eventually passes — **two to three attempts is the average**.
- **Communication is a first-class interview skill** alongside raw problem-solving.
- **Write your assumptions as comments and test them early** with prints.
- Python type annotations (`List[int]`, `-> int`) are **not variables** — they're declarative hints.
- **Practice under pressure in front of an audience** replicates the real interview more than solo practice ever can.
- **Flash-card style concept sheets** are legitimate interview aids when focused on syntax and data structure basics.
