# Ruby Solutions Deep Dive — August 20, 2025

Mauricio volunteers for a mock interview on **Jumping on the Clouds Revisited** — the circular variant with an energy counter. The session covers live debugging under pressure, when to reach for `while` vs `for`, and how to leverage formulas given in the problem statement.

---

## Mock Interview Context

- **Problem:** Jumping on the Clouds Revisited (HackerRank).
- **Format:** 20 minutes, read → summarize → pseudo code → code → debug.
- **Goal of mock:** practice performing under pressure with Zoom eyes watching. Writing working code is optional; verbalizing the thought process is the main deliverable.

---

## Problem: Jumping on the Clouds Revisited

> The array is circular. From index `i` the player jumps to `(i + k) % n`. The player starts at index 0 with 100 energy, loses 1 energy per jump, and loses an additional 2 energy if they land on a thundercloud (value 1). Return the remaining energy after the player returns to index 0.

### Restated

- Input: array `c` of 0s and 1s (0 = cumulus/safe, 1 = thundercloud) and integer `k` (jump length).
- Starting energy: 100.
- Cost per jump: **1 energy** (always) + **2 additional** if landing on a `1`.
- Movement formula: `next_index = (current_index + k) % n` — the `% n` makes it circular.
- Stop when the player returns to index 0.
- Return final energy.

---

## Mauricio's Pseudo Code

```
# traverse the array with a while loop (unknown number of jumps)
# stop condition: index == 0 again
# on each jump:
#   - deduct 1 if c[index] == 0
#   - deduct 3 if c[index] == 1
# use (i + k) % n to compute the next index
```

### Code attempt

```python
def jumpingOnClouds(c, k):
    n = len(c)
    e = 100
    i = 1  # had to start at 1 to get past the while condition
    while i != 0:
        i = (i + k) % n
        if c[i] == 0:
            e -= 1
        else:
            e -= 3
    return e
```

### The bugs

1. **Starting at `i = 1`** to dodge the `while i != 0` condition means the first real jump is never taken from index 0 — the loop just spins forward.
2. **`i = (i + k) % n` is inside the `if/else`** but happens before the energy deduction, so the first cloud's energy cost is never accounted for correctly.
3. **Time Limit Exceeded** — the loop ran indefinitely because the starting state made the condition impossible to re-enter on the correct step.

---

## Debugging Under Pressure

### Coach feedback on the mock

> You summarized the problem well and got to reasonable pseudo code. Your approach is logical. The specific bugs are normal — what we're practicing is the response when you get stuck.

### When you're stuck, add observability

- **Print the loop variable** (`i`) on every iteration to see if it's actually moving.
- **Print the computed next index** (`(i + k) % n`) to see what path the player is taking.
- **Print the energy** after each deduction to verify costs are applied correctly.

```python
while i != 0:
    i = (i + k) % n
    print(f"i={i}, c[i]={c[i]}, e={e}")
    ...
```

### Counter the panic loop

> When you run into errors and time is ticking, your brain starts looping: "I'm stuck, time is running, I'm stuck, time is running." You stop problem solving. The fix is to stop typing and add print statements — observability breaks the panic loop.

### Use the formula the problem gives you

The problem explicitly gives you `(i + k) % n`. That's a massive hint — don't just use it as an `if` condition, consider using it as:

- The **loop condition** — `while (i + k) % n != 0`.
- The **initial index** — start `i = k % n` and treat the first jump as already taken (deduct its cost immediately, then loop).

> When the problem hands you a formula, print it out first. Figure out exactly what it's telling you before you wrap code around it.

---

## When to Use `while` vs `for`

This session also revisited **Jumping on the Clouds** (the non-circular version from last week) and confirmed why a `while` loop is required.

### Why `for` fails in the original problem

```python
for i in range(len(c)):
    if c[i + 2] != 1:
        i = i + 2  # this does NOTHING
```

- In Python, **reassigning the loop variable inside a `for` loop has no effect** — the iterator rebinds `i` on the next iteration from its own internal state.
- You cannot skip steps in a `for i in range(...)` loop.

> JavaScript's `for (let i = 0; i < n; i++)` does let you mutate `i` mid-loop, which is probably where my intuition got confused last week. Python's `for` is strictly iterator-driven — the variable assignment is a lie.

### Two reasons to reach for `while` on cloud problems

| Reason | Applies to |
|---|---|
| **Variable step size** (jump 1 or jump 2) | Jumping on the Clouds |
| **Circular traversal** (no fixed end) | Jumping on the Clouds Revisited |

- The first problem needs `while` because the **step size isn't consistent**.
- The second problem needs `while` because there is **no fixed end** — the array loops, and you stop based on a condition rather than exhausting a range.

### General rule from the discussion

- **`for` loop** — you know the range up front and the step is consistent (including step sizes other than 1).
- **`while` loop** — you don't know how many iterations you'll take, or you need to manipulate the index yourself, or termination depends on a computed condition.
- ChatGPT's summary matched this: unknown range or inconsistent step → while.

### Count isn't an iterator

A point of confusion: the `count` variable in jumping-on-the-clouds isn't an iterator — it's a **tracker**. Same with `energy` in the revisited version.

- **Iterator** — drives movement through the data structure (the `i` in `c[i]`).
- **Tracker** — records information alongside iteration (`count`, `energy`).

Mixing them up leads to incorrect termination logic. The loop condition should be about the iterator, not the tracker.

---

## Working Through the Revisited Problem

A cleaner approach that starts correctly:

```python
def jumpingOnClouds(c, k):
    n = len(c)
    e = 100
    i = 0
    while True:
        i = (i + k) % n
        e -= 1
        if c[i] == 1:
            e -= 2
        if i == 0:
            break
    return e
```

### Why this works

- **`while True` with a `break`** sidesteps the "starting at 0" paradox — we always take at least one jump before checking termination.
- The jump is always the first thing in the loop body, so the energy deduction is guaranteed.
- The `break` fires after the energy deduction, ensuring the final step's cost is counted.

### Complexity

- **Time:** O(n / gcd(n, k)) — worst case O(n) when `k` and `n` are coprime.
- **Space:** O(1).

---

## Session Takeaways

- **Mock interviews are about performing under pressure**, not about finishing the code. Mauricio's summary, pseudo code, and debugging dialogue were all strong even though the code didn't pass.
- **When stuck, add print statements** before touching logic. Observability defeats panic.
- **`while` loops are the answer** whenever you need to control step size, traverse circularly, or terminate on a condition rather than a range.
- **Python's `for` loop variable is read-only** in practice — reassigning it does nothing.
- **When the problem hands you a formula**, print it in isolation before building around it.
- **Count and energy are trackers, not iterators** — they don't drive the loop termination.

> Even one person silently watching you code is shockingly hard the first time. The only fix is practice — book peer mentor office hours and get reps before the real thing.
