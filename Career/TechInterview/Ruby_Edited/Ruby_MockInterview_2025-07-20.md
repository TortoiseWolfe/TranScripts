# Mock Interview — Insert Interval (2025-07-20)
Source: https://youtu.be/-taB2UY9O3g

Sunday session: deep pseudo-code session on LeetCode's Insert Interval (medium, 43% acceptance). No coding today — entire session spent on understanding, decomposing, and game-planning.

---

## [3:27](https://youtu.be/-taB2UY9O3g?t=207) Problem: Insert Interval

You're given an array of **non-overlapping intervals** sorted in ascending order by start. You're also given a single **new interval**. Insert the new interval into the array such that it remains sorted and non-overlapping. Merge overlapping intervals if necessary. Return the resulting interval array.

### [2:17](https://youtu.be/-taB2UY9O3g?t=137) [approx] Example 1

- Intervals: `[[1, 3], [6, 9]]`
- New interval: `[2, 5]`
- Output: `[[1, 5], [6, 9]]`

The new interval `[2, 5]` overlaps with `[1, 3]` (at 2 and 3), so they merge into `[1, 5]`.

### [4:35](https://youtu.be/-taB2UY9O3g?t=275) [approx] Example 2

- Intervals: `[[1, 2], [3, 5], [6, 7], [8, 10], [12, 16]]`
- New interval: `[4, 8]`
- Output: `[[1, 2], [3, 10], [12, 16]]`

The new interval `[4, 8]` overlaps with `[3, 5]`, `[6, 7]`, and `[8, 10]` — all three merge into `[3, 10]`.

### [20:28](https://youtu.be/-taB2UY9O3g?t=1228) Critical insight

> "An interval represents **all the numbers in between**, not just the endpoints. `[3, 5]` means 3, 4, 5. That's why `[4, 8]` overlaps with it — 4 is inside that range."

---

## [15:50](https://youtu.be/-taB2UY9O3g?t=950) Why This Problem Is Mind-Bending

The wording uses "intervals" so many times in one paragraph that it's hard to track what's being referred to. The coach's tactic: **rewrite the problem in your own words** as you read it.

### [4:55](https://youtu.be/-taB2UY9O3g?t=295) Coach's restatement

- We are given **intervals** = a list of `[start, end]` pairs (the coach calls them "i-j pairs").
- The pairs **do not overlap** with each other.
- They are sorted by start.
- We are given a **single new interval** to insert.
- The new interval may overlap with one or more existing intervals.
- Return a new list with the new interval inserted (or merged if needed), still sorted, still non-overlapping.

### [38:55](https://youtu.be/-taB2UY9O3g?t=2335) Inclusive vs exclusive

The intervals use square brackets `[...]`, which means **inclusive** of the endpoints. If they used parentheses `(...)`, that would be exclusive. Pay attention to bracket notation when dealing with ranges.

---

## [16:05](https://youtu.be/-taB2UY9O3g?t=965) [approx] Decomposing Into Two Test Case Difficulties

### [18:23](https://youtu.be/-taB2UY9O3g?t=1103) [approx] Easy version (modify the example)

- Intervals: `[[1, 3], [6, 9]]`
- New interval: `[4, 5]`
- Output: `[[1, 3], [4, 5], [6, 9]]`

No overlap → just slot it in. **Tackle this first** as a simpler subset of the full problem.

### [38:37](https://youtu.be/-taB2UY9O3g?t=2317) Hard version (original example 2)

- Multi-interval merging required.
- Build the easy solution first, then extend.

> **LeetCode test case trick:** you can edit the test case input fields directly, and LeetCode will compute the expected output for your custom inputs. HackerRank doesn't generate expected output for custom cases.

---

## [22:59](https://youtu.be/-taB2UY9O3g?t=1379) [approx] Approach: Two-Step Game Plan

For the **easy** version (no merging):

### [32:55](https://youtu.be/-taB2UY9O3g?t=1975) Step 0: Initialize a new array to hold the result

(Don't modify the original — the problem note explicitly allows returning a new array.)

### [18:35](https://youtu.be/-taB2UY9O3g?t=1115) Step 1: Loop through the intervals

For each existing interval, **check if the new interval's start is contained within it**.

### [18:35](https://youtu.be/-taB2UY9O3g?t=1115) Step 2: Determine the sort placement

For each interval, check whether the new interval is **less than** or **greater than** the current interval (using start values).

### [49:02](https://youtu.be/-taB2UY9O3g?t=2942) Decision logic

- If no overlap **and** new interval is less than current → add new interval to king array, then add current.
- If no overlap **and** new interval is greater than current → add current to king array, continue iterating.
- Continue this until you've placed the new interval and finished iterating.

### [39:38](https://youtu.be/-taB2UY9O3g?t=2378) Example walk-through (`[1, 3]`, `[6, 9]` + `[4, 5]`)

1. Index 0 = `[1, 3]`. Is `4` between 1 and 3? No. Is `[4, 5]` greater than `[1, 3]`? Yes. Add `[1, 3]` to result. Continue.
2. Index 1 = `[6, 9]`. Is `4` between 6 and 9? No. Is `[4, 5]` less than `[6, 9]`? Yes. Add `[4, 5]` to result, then add `[6, 9]`.
3. Result: `[[1, 3], [4, 5], [6, 9]]` ✓

---

## [36:47](https://youtu.be/-taB2UY9O3g?t=2207) [approx] Useful Python Index Notation

Brian's tip:

```python
intervals[i][0]   # start of interval i
intervals[i][1]   # end of interval i
new_interval[0]   # start of new interval
new_interval[1]   # end of new interval
```

Alternatively, since each interval is just a 2-element list, you can also use `[-1]` for the end and `[0]` for the start. Both work.

---

## [3:36](https://youtu.be/-taB2UY9O3g?t=216) Other Approaches Considered

### [3:36](https://youtu.be/-taB2UY9O3g?t=216) Mindy's dictionary idea

Store intervals as dictionary entries with the start as the key and the rest of the values as the value. Concept is interesting but complicates the merge logic. Not pursued, but the **idea** of using a different data structure to organize the intervals is worth keeping in mind.

### [43:41](https://youtu.be/-taB2UY9O3g?t=2621) [approx] Brian's list-of-lists loop with index notation

Instead of explicit `[0]` / `[1]` access, use Python's list-of-lists semantics directly. Same approach, cleaner notation.

---

## [52:54](https://youtu.be/-taB2UY9O3g?t=3174) The Big Lesson: Stay In Pseudo Code Longer

> "I've gone through and rewritten this portion several times. I added a new step at the beginning. I rewrote this part two or three times. I rewrote this part twice. Now I have a game plan I've been able to modify very quickly. Whereas if this was code, I'd be worried about syntax, implementation, correct order of operations."

### [37:24](https://youtu.be/-taB2UY9O3g?t=2244) Why it matters

- Once you're in code, you're locked into "I have to make this code work" mode.
- Pseudo code is **cheap to edit** — you can rewrite an approach in 30 seconds.
- Rewriting code takes minutes.
- Spending 80% of an interview in comments is fine **as long as** you're confident the resulting code will run when you finally write it.

### [38:38](https://youtu.be/-taB2UY9O3g?t=2318) When to start over vs tweak

- A few small bugs in code → debug and tweak.
- Realized the whole approach was wrong → wipe it, go back to pseudo code, start over.
- The longer you spend tweaking a bad approach, the more time you waste.

### [55:22](https://youtu.be/-taB2UY9O3g?t=3322) What the coach has seen

- 10 minutes of pseudo code → 2 minutes of code → all test cases pass.
- 5 minutes of pseudo code → 5 minutes of code → all pass.
- 0 minutes of pseudo code → 30+ minutes of debugging → still failing.

---

## [34:13](https://youtu.be/-taB2UY9O3g?t=2053) The Easy → Hard Strategy

When a problem has an "easy" base case and a "hard" extension (like the merging here):

1. Build a working solution for the easy case first.
2. Get test cases passing for the easy case.
3. **Then** extend the working code to handle the hard case.
4. Do not try to solve both at once on your first pass.

---

## [38:26](https://youtu.be/-taB2UY9O3g?t=2306) Brute Force First, Always

Even though Insert Interval has elegant solutions, the coach is OK with starting with the worst-performing brute force as long as it works:

> "If your brute force solution that gets all the test cases passing is the worst performance, both time and space — through the charts awful — I could care less as long as it passes all the test cases. The next step is coming back and saying, 'How can I make that better?'"
