# Ruby Solutions Deep Dive — December 17, 2025
Source: https://youtu.be/23b9sbzY1SM

Two mock interviews: **Lilah's Beautiful Days at the Movies** (HackerRank) and **Move Zeroes** (LeetCode). Core lesson: slow down to re-read the problem, and use a `while` loop when a `for` loop's index can't be mutated during iteration.

---

## Q&A: Tech Interview Format

- **Easy problems only.** The tech interview draws exclusively from easies.
- **Some behavioral follow-up** is asked purely for practice — applying your experience to a dev career.
- **No fixed daily practice minimum.** Coach's advice: pick a focus area (breaking problems down, pseudo code, implementation) and practice it deliberately for a bounded window.

---

## Mock Interview #1: Lilah's Beautiful Days (Daniel)

### Problem

> Lilah determines the difference between a number and its reverse. For instance, `12` reversed is `21`, difference `9`. Given a range of days `i` to `j` and a number `k`, return the count of **beautiful days** — days whose value minus its reverse is evenly divisible by `k`.

### Examples

For `i = 20, j = 23, k = 6`:
- Day 20: `|20 - 02| = 18`, `18 / 6 = 3` → beautiful
- Day 21: `|21 - 12| = 9`, `9 / 6 = 1.5` → not beautiful
- Day 22: `|22 - 22| = 0`, `0 / 6 = 0` → beautiful
- Day 23: `|23 - 32| = 9`, `9 / 6 = 1.5` → not beautiful

Answer: **2**.

### Daniel's Approach

Pseudo code:
- Counter for beautiful days, initialized to 0.
- Reverse each day in the range.
- Check if `(day - reversed_day) % k == 0`.
- Increment counter on match.
- Return counter.

### Reverse Logic

```python
reversed_num = int(str(i)[::-1])
```

- Convert int to string.
- Reverse with slice `[::-1]`.
- Convert back to int.

Tested with `120` → `21` (leading zeros dropped) and `210` → `12`. Confirmed the slice handles trailing-zero cases correctly.

### The Scope Bug

Daniel placed the `reversed_num = ...` line **outside** the for loop, in the global/function scope. When the loop iterated, `reversed_num` never updated because the reverse expression only ran once.

### Fix Direction

Move the reverse calculation **inside the for loop**, so each iteration produces its own reversed value against the current `day` variable.

```python
def beautifulDays(i, j, k):
    count = 0
    for day in range(i, j + 1):
        reversed_day = int(str(day)[::-1])
        if (day - reversed_day) % k == 0:
            count += 1
    return count
```

### Coach Feedback: Slow Down, Re-Read The Problem

> "I think your steps were great up until getting stuck. But I think you might be going a little too quickly. You didn't get the chance to read through the full problem, see the explanation, confirm the formula, or walk through the example step-by-step."

When the coach asked Daniel to restate the **formula for a beautiful day**, he initially said "the reverse divided by k." After re-reading the explanation, he corrected: **`(day - reversed) / k` with no remainder**.

### Coach Feedback: Range Inclusivity

> "`range(i, j)` is exclusive on the upper bound — make sure to use `range(i, j + 1)` to include the final day."

### On Googling Syntax

> "Googling 'how to reverse a string' is fine. Googling 'how to solve beautiful days' is not. It's the level of specificity that matters."

---

## Mock Interview #2: Move Zeroes (Ben)

### Problem

> Given an integer array `nums`, move all `0`s to the end while maintaining the relative order of the non-zero elements. Do this **in-place** without making a copy.

### Ben's Brute Force

Loop through the array and append non-zero values to a new array.

```python
new = []
for num in nums:
    if num != 0:
        new.append(num)
```

> "Before worrying about the in-place constraint, I always recommend doing the brute force first to make sure you understand the approach."

### The In-Place Requirement

LeetCode expects you to **modify `nums` directly** and return nothing — the test runner checks the array by reference.

### Ben's Second Attempt: Delete Elements In Place

Ben switched to deleting zeros from `nums` directly using `del nums[i]` inside a `for i in range(len(nums))` loop.

### The Bug: Index Shifting

When you delete an element from a list, **every subsequent element shifts down by one index**. A `for i in range(...)` loop doesn't know about this — it keeps incrementing `i`, so you skip the element that shifted into the deleted slot.

### The Fix: Use A While Loop

> "For loops are kind of tough because those indexes aren't flexible. In cases like this, it's better to use a `while` loop where you can make index-based decisions while also manipulating the index you're using. If I hit a zero, I don't increment `i` — I just remove the element and move on."

```python
def moveZeroes(nums):
    i = 0
    zeros = 0
    while i < len(nums) - zeros:
        if nums[i] == 0:
            nums.append(nums.pop(i))
            zeros += 1
        else:
            i += 1
```

Alternative two-pointer (more idiomatic):

```python
def moveZeroes(nums):
    write = 0
    for read in range(len(nums)):
        if nums[read] != 0:
            nums[write] = nums[read]
            write += 1
    for k in range(write, len(nums)):
        nums[k] = 0
```

### Coach Feedback: Look Up Specific Syntax, Not Solutions

> "Your use of Google here was fine — you looked up 'delete element from list Python' which is exactly what you'd Google and it gave you exactly the syntax, not a solution. That's a perfect thing. HackerRank doesn't have that luxury, but LeetCode allows it."

### Coach Feedback: Don't Give Up Too Early

Ben wanted to stop when his code wasn't working. The coach encouraged him to push through — "we're in a safe space." Once he moved into the in-place approach, he was on track.

---

## Final Discussion: Pattern Recognition vs Structure

One participant observed:

> "If I do a certain kind of problem over and over, I start to recognize the structure. It's easier to build a template from that. It's like a pattern."

### Coach's Reframe

> "I'm really glad you're saying 'structure' because you know how I feel about 'patterns'. When I think of patterns, I'm really thinking, no, you're just mastering the fundamentals and seeing how those data structures apply in new and interesting ways."

### Reflection After Each Attempt

> "How are you reviewing and improving after each attempt? What did I learn? Did I get it passing? How many attempts did I take? How can I apply those steps to my next problem? That reflection step is important."

---

## Takeaways

- **Slow down to re-read the problem**, especially the explanation section for examples.
- **`range(i, j + 1)`** if you need the upper bound included.
- **String reversal idiom:** `str(num)[::-1]` then cast back to int.
- **Scope matters** — calculations inside a loop must be written inside the loop body, not at global scope.
- **Deleting while iterating a for loop causes index-skip bugs.** Use `while` with manual index control, or use a two-pointer write/read pattern.
- **Brute force first** — then refine to in-place or optimized.
- **Structure is a better word than pattern** — fundamentals applied to new problems, not a cookie-cutter template.
