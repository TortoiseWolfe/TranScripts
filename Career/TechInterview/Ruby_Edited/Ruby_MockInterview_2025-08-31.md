# Ruby Mock Interview — August 31, 2025
Source: https://youtu.be/bOgVYYVJGPs

*Nailing the Tech Interview — Sunday session*

## Q&A: When Are You Ready for the Technical Interview?

### The "three in a row" guideline

- General benchmark: solve **3 easy problems consecutively within 15–20 minutes each**, closer to **15 minutes** being the stronger signal.
- Also make sure you're getting practice with **medium problems**.
- "Three in a row" doesn't mean three at a single sitting — it means a consistent streak however you practice (one per day, multiple per week, etc.).

> "It's a good indicator that you *might* be ready. It's hard to say whether someone's ready until they actually take it."

### Extra practice before signing up

- **Peer mentor office hours** are a good place to get additional timed practice with feedback before the real interview.
- You can sign up for the real technical interview at any time, then use peer mentor sessions as warm-ups before your scheduled slot.
- Rebecca runs peer mentor office hours Mondays 9–10 AM and will either work through a problem the student brings or pick one together.

### Why aim for 15 minutes if 20 passes?

- Nerves and pressure during the real interview slow people down.
- A 15-minute self-pace leaves buffer for interview pressure.

### What happens if you fail the technical interview?

- You won't be permanently denied.
- After a failed attempt, Ruby will:
  1. Discuss your performance.
  2. Ask follow-up questions.
  3. Make **specific recommendations** (mod 1/2 concept review, problem-solving tips, etc.).
- Once you've worked through those recommendations and are still consistently hitting the 15–20 minute benchmark, you can schedule again.

### Handling "curveball" problems you get stuck on

- It's okay to hit a curveball occasionally and still sign up.
- When stuck past 20 minutes: **don't immediately look up the solution**. Instead:
  1. Come back on a different day and try fresh.
  2. If still stuck, research the approach, then walk through the solution **line by line** to understand the reasoning.
  3. Give it a few days, then try again from memory without looking at the solution.
- **Don't stick with a broken path for hours.** That's counterproductive.

> "When I find myself coding just to pass the next test and not generalizing the problem, I feel like I'm going down the wrong rabbit hole."

### The "too many if conditions" smell

- One or two (maybe three) `if` conditions is normal — even binary search has about three.
- If you're piling on `if` conditions **to catch specific edge cases one by one**, that's a signal to stop and think of a more **general** approach.
- Mauricio: "That's when I know I'm not generalizing enough."

---

## Breakout Room Experiment: Pseudo Code for "Can Place Flowers"

Ruby ran an experiment using Zoom breakout rooms. Everyone got 10 minutes alone with the problem to produce **pseudo code only** — no real coding unless you finished pseudo code early.

### Problem: Can Place Flowers (LeetCode easy)

> Given an integer array `flowerbed` containing 0s and 1s (0 = empty, 1 = planted), and an integer `n`, return `true` if you can plant `n` new flowers **without any two adjacent flowers**.

### Examples

```
flowerbed = [1,0,0,0,1], n = 1  ->  true
flowerbed = [1,0,0,0,1], n = 2  ->  false
```

### Constraints

- `1 <= flowerbed.length <= 2 * 10^4`
- `flowerbed[i]` is `0` or `1`
- **There are no adjacent flowers in `flowerbed`** — the input will never violate the rule itself.
- `0 <= n <= flowerbed.length`

### Clarification on `n`

- Normally in LeetCode constraints, `n` refers to the **length of the array**.
- **In this problem**, `n` is a separate input variable — the number of flowers you want to plant. Always read the problem statement to confirm.

### Key assumption pulled from constraints

Because the input is guaranteed to follow the no-adjacent rule, you don't need to defend against malformed input. You can trust that if you check "current spot is 0 and neighbors are 0," you'll be safe.

---

## Mauricio's Pseudo Code

Written **above** the function (clean style, like a docstring):

```
# Traverse the flowerbed array
# Identify zeros with zeros on both sides (available spots)
# Edge cases:
#   - First index: only check i + 1
#   - Last index: only check i - 1
# Count occurrences of plantable spots
# Return true if count >= n, else false
```

Partial code attempt (cut short by breakout room disconnect):

```python
for i in range(len(flowerbed)):
    if flowerbed[i] == 0 and flowerbed[i + 1] == 0:
        count += 1
    # handling for length - 1 edge case
```

---

## Ruby's Pseudo Code

Written **in the function** using countdown-style logic:

```
# Given: list of "plots" (0 = empty, 1 = planted)
# Given: n = number of spots we need to plant
# If a spot equals 1, cannot plant at index-1 or index+1 either
# Assumption: the test cases will not violate the no-adjacent rule

# Use n as a countdown — every time we plant, n -= 1
# Iterate through flowerbed one at a time
# Check either side for flowers
# If spot is 0 AND left neighbor is 0 AND right neighbor is 0:
#   plant here (set flowerbed[i] = 1, n -= 1)
# After one iteration:
#   if n <= 0: return true
#   else: return false
# Big O: O(N)
```

### Why iterate only once?

- The problem is **linear** — each spot only depends on its immediate neighbors.
- No need for nested loops or backtracking.
- **O(n)** is the floor because you must look at each plot at least once.

---

## Coaching Feedback

### On writing pseudo code above vs. inside the function

- **Above the function:** cleaner, matches real-world docstring style.
- **Inside the function:** kept closer to where the logic lives, good for interview flow.
- In production, you'd never have pseudo code inside a function — but in an interview, either works.

### Always include the return condition in pseudo code

Ruby initially didn't see a return condition in Mauricio's pseudo code and flagged it — it turned out he'd written it, just phrased differently ("return true if count >= n"). **Always make the return statement explicit.**

### The three parts of a technical interview performance

1. **Read and understand the problem** (~20% of evaluation)
2. **Resummarize and pseudo code** (~20% of evaluation)
3. **Code a working solution that passes all test cases** (~60% of evaluation)

> "You can come up with a solution that passes all the test cases, but if you can't explain what you did or why, that's not going to show you work well with a team."

The first two matter for interviewer impressions because they show:

- Problem decomposition skills
- Clear communication
- Ability to think out loud
- Team/pair-programming readiness

---

## Key Takeaways

- **Readiness benchmark:** 3 consecutive easy problems solved in ~15 minutes each, plus exposure to mediums.
- **Don't reset to zero after a failure** — you'll get specific recommendations and can try again after addressing them.
- **Step away from problems you've been stuck on for more than ~20 minutes.** Coming back fresh beats brute-forcing for hours.
- **Too many if-conditions is a code smell** — generalize your approach instead of patching edge cases.
- Read problem statements **twice**: first for rough understanding, second to confirm assumptions and constraints.
- **Always write the return statement** in pseudo code, even if the logic is simple.
- **Trust the constraints.** "No adjacent flowers in input" saves you from defensive edge cases.
- **Interviewers evaluate communication as well as code.** Think out loud, resummarize the problem, explain tradeoffs.
