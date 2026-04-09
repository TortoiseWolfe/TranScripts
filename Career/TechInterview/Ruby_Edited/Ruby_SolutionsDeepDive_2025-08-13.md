# Ruby Solutions Deep Dive — August 13, 2025
Source: https://youtu.be/itWLg5UCbsk

Wednesday session covering three topics: (1) how to get started practicing on HackerRank, (2) a visual Big-O demo contrasting linear and binary search, and (3) a full walkthrough of the **Jumping on the Clouds** problem showing the coach's end-to-end interview process from reading the prompt to debugging code.

---

## Getting Started on HackerRank

### Where to start

- Use the **Problem Solving track** — it mixes data structure and algorithm questions and shows up by default on new accounts.
- Filter to **Easy** and work through them in order of point value.

### Point values as a difficulty signal

- **10-point problems** are generally easier than **15-point** problems, which are easier than **20-point** problems — even within the Easy tier.
- Stars on HackerRank are gamification only — ignore them as a progress gauge.

### What to practice per problem

- Read the **entire** problem statement — don't stop at the short summary.
- Pull elements from the problem into **pseudo code** — data types, return type, constraints, edge cases.
- Read the **constraints** carefully; they frequently contain guarantees that eliminate the need for edge-case handling.
- Run your code often against their examples; don't write 20 lines before testing.

### Readiness benchmarks

| Metric | Target |
|---|---|
| Easy problems | Solve 3 consecutively in **under 20 minutes** |
| Medium problems | Solve in **45 minutes to 1 hour** |
| Practice cadence | Mix easy + medium; medium trains multi-step decomposition |

> Medium problems aren't harder conceptually — they're easy problems compacted into multiple steps stacked on top of each other. The skill you're training is decomposition.

### Interview mechanics

- The tech interview is a **hard 20 minutes** on a single easy problem.
- The interviewer doesn't answer questions mid-session; assume any question you ask is rhetorical — you are talking to yourself.
- If you ask how much time is left, the interviewer will tell you. Otherwise focus on the code.
- **Job-hunt interviews** will include medium and hard problems — preparing with mediums pays off after the internship interview.

### Practice tips

- Use a **stopwatch (counting up)** rather than a countdown timer when starting out — measure how long problems actually take, then compress.
- Book peer-mentor office hours for low-stakes speaking practice before your real attempt.
- Use a **rubber duck** (stuffed animal, cat, anything with a face) to practice verbalizing your thinking.

---

## Big-O Visualization: Linear vs Binary Search

The coach demonstrated a custom visualizer comparing **linear search** (O(n)) and **binary search** (O(log n)) across library catalogs of different sizes.

### Linear search — O(n)

- Walk the array one index at a time until you find the target or reach the end.
- No prerequisite ordering required.
- Steps scale **diagonally** with input size — double the books, double the average steps.

### Binary search — O(log n)

- **Requires a sorted list.**
- Check the midpoint, decide if the target is in the lower or upper half, discard the other half, repeat.
- Steps grow **logarithmically** — doubling input adds only one more step on average.

### Scale observations

| Books | Linear steps (avg) | Binary steps (avg) |
|---|---|---|
| 22 | ~11 | ~5 |
| 100 | ~50 | ~7 |
| 500 | ~250 | ~9 |
| 1000 | ~500 | ~10 |

> Big-O isn't about performance on a small scale or a large scale — it's about how performance changes between scales. Linear goes diagonal. Log-n goes nearly flat.

### Why this matters beyond interviews

Code written with poor efficiency works fine on small inputs but degrades dramatically as data grows. Whether or not you're implementing a literal binary search, being able to *recognize* when your code is doing wasted work is what separates production-quality code from brute-force code.

---

## Problem: Jumping on the Clouds

> There is a new mobile game that starts with consecutively numbered clouds. Some clouds are thunderheads, others are cumulus. The player can jump on any cumulus cloud with a number equal to the current cloud + 1 or + 2. The player must avoid thunderheads. Determine the number of jumps it takes to reach the last cloud. It is always possible to win the game.

### Restating the problem

- Given an array `c` of integers containing only `0` (safe) or `1` (thunderhead).
- Index the array from `0` to `n-1`.
- Advance the index by **+1 or +2** positions per jump, never landing on a `1`.
- Return the **shortest path** (fewest jumps) to the last index.

### Examples

- `c = [0,0,1,0,0,1,0]` → `4` jumps (e.g. 0 → 1 → 3 → 4 → 6).
- `c = [0,0,0,0,1,0]` → `3` jumps (0 → 2 → 3 → 5 or 0 → 2 → 4? actually 0 → 2 → 3 → 5 since index 4 is unsafe).

### Constraints and what they buy us

- `2 <= n <= 100`.
- `c[0] = 0` and `c[n-1] = 0` — the **first and last clouds are always safe**.
- "It is always possible to win the game" — guaranteed a valid path exists.

> The constraints tell us we never have to check if the start or end is safe, and we never have to handle "impossible" cases. That's a lot of edge-case code we don't need to write.

---

## Coach's Interview Process (End to End)

### Step 1 — Read aloud and restate

Read the problem at least once. Resummarize it in your own words to the interviewer. This buys your brain buffer time and proves comprehension.

```
# array c is a list of integers containing 1 or 0
# 0 is safe, 1 is not
# index the array from 0 to n-1
# can advance the index by either 1 or 2 positions
# return the shortest path from the first index to the last
```

### Step 2 — Print the inputs

Always print the parameters you're given on the first line of the function. Verify the runtime data matches your mental model before writing any logic.

```python
def jumpingOnClouds(c):
    print(c)
    return 0
```

### Step 3 — Default return

Add a default return matching the expected type (here, an integer). Missing return statements cause confusing type errors that can send you down the wrong debugging path.

### Step 4 — Pseudo code the approach

```
# default to jump 2 spaces if the index is safe (not a 1)
# otherwise jump 1 space
# keep track of steps taken with a count variable
```

### Step 5 — Summarize for the interviewer

> The problem gives me a list of 0s and 1s. I can take up any 0 space but not a 1. I can advance by 1 or 2 each jump. I'll loop through the array, prefer jumping by 2 when the landing spot is safe, otherwise jump by 1, and track the count. Thanks to the constraints I know the first and last index are always safe, so I don't need edge cases for either end.

---

## Implementing the Solution

### First attempt — `enumerate` (suggested by Brian)

```python
def jumpingOnClouds(c):
    count = 0
    for index, value in enumerate(c):
        jump_index = index + 2
        if c[jump_index] != 1:
            index = jump_index
        count += 1
    return count
```

### Bugs surfaced by testing

- **`IndexError: list index out of range`** — when `index + 2` exceeds `len(c) - 1`.
- **Reassigning the loop variable `index`** inside a `for` loop does nothing — Python rebinds it on the next iteration.
- The `enumerate` loop always advances by 1 regardless of what you assign to `index`.

> This is why `enumerate` is awkward here. You can't manually advance the iterator. When you need to control the step yourself, use a `while` loop with a manual index, not `for ... in enumerate`.

### When to prefer `enumerate` vs `range`

- Use **`enumerate`** when you need **both** the index and the value and you iterate linearly.
- Use **`for i in range(len(c))`** when you only need the index or need to manipulate positioning.
- Use **`while`** when you need to control the advance step yourself (as here).

### Corrected approach — `while` loop

```python
def jumpingOnClouds(c):
    count = 0
    i = 0
    while i < len(c) - 1:
        if i + 2 < len(c) and c[i + 2] != 1:
            i += 2
        else:
            i += 1
        count += 1
    return count
```

### How it works

- Loop while `i` has not reached the last index.
- **Prefer jumping 2** — check that `i + 2` is in range and safe; if so, advance by 2.
- **Otherwise jump 1** — guaranteed safe by the problem constraints (since any thunderhead must have a safe neighbor, or the game would be unwinnable).
- Increment `count` on every jump regardless of size.
- Return `count`.

### Complexity

- **Time:** O(n) — we visit each index at most once.
- **Space:** O(1) — only `count` and `i` as extra storage.

---

## Debugging Discipline

The coach's session ran into an off-by-one error and several `IndexError`s. Key takeaways:

### Run code frequently

- Don't write 20 lines before your first test run. Write 2-3 lines, print the intermediate state, verify your mental model, repeat.
- If you had tested the for loop in isolation first, the `enumerate` bug would have been obvious within seconds.

### Print intermediate state

- Print loop variables (`i`, `jump_index`) on every iteration.
- Print the condition you're testing so you can see which branch is taken.

### Don't panic-patch

> When you start seeing errors and you're worried about time, you slip into a mindset of "what if I just subtract 1 here" or "what if I flip this operator" — once you're there, you've stopped problem solving and started panicking.

- If you catch yourself adjusting constants randomly to chase passing tests, **stop**. Go back to printing intermediate state and actually understanding what's happening.
- It's often faster to **delete and restart** a broken approach than to keep patching it.

### Test assumptions explicitly

- Every implicit assumption is a potential bug. If you assume the first index is always safe, the constraints confirmed it — but if the constraints hadn't, that's an edge case you'd need to test.
- Gut-check yourself with print statements even when things look obvious. You lose 10 seconds to a print and save 5 minutes of wrong-direction debugging.

---

## Session Takeaways

- **The interview process is a repeatable pipeline:** read → restate → print inputs → pseudo code → summarize → code → test → debug → complexity analysis.
- **HackerRank readiness** means 3 easy problems consecutively under 20 minutes, plus some medium practice.
- **Big-O matters in the real world**, not just interviews — linear vs logarithmic is the difference between "works on 100 items" and "works on 1 million items".
- **`enumerate` is wrong for problems where you control step size** — reach for `while` or `for i in range` instead.
- **Print early, print often, and never panic-patch** a solution you don't understand.
