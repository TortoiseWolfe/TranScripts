# Mock Interview — Two Sum & Three Sum (2025-06-08)

Sunday session: pseudo code walkthrough + mock interview. This week covers **Two Sum** (easy) and **Three Sum** (medium), both perennial tech-interview favorites.

---

## Q&A

### Using AI assistants during practice

Walter shared that he was using GPT to reorder lines and suggest syntax alternatives.

- If AI is fixing parentheses or small syntax, that's one thing.
- If AI is restructuring logic, **that's problem solving** — letting it do that shortcuts your own learning.

### Writing pseudo code without knowing exact syntax

You don't need to know the exact method name while writing pseudo code.

- Write out the intent in plain sentences.
- When you need something like "count method" or "max method," just note it — look up the syntax later when you write the real code.
- Iterate: write pseudo code → write real code → test assumptions → rewrite pseudo code if needed.

### What does the Joy of Coding tech interview look like?

- 30-minute session.
- 20 minutes on a HackerRank easy-level question.
- Followed by code questions and behavioral questions.
- Coach makes a recommendation for what to work on next, whether pass or fail.
- **New:** follow-up notes are now sent after the session so students don't forget feedback.

---

## Problem 1: Two Sum (pseudo code walkthrough)

**Prompt:** Given array `nums` and integer `target`, return the **indices** of two numbers that add up to `target`. Exactly one solution exists. Cannot use the same element twice.

### Pull out the key pieces

- **Input:** array of integers + a target integer.
- **Output:** two index positions whose values sum to target. Order of indices doesn't matter.
- **Assumption:** exactly one solution always exists → will never return an empty array.
- **"Cannot use same element twice"** means cannot use the **same index** twice. Values can repeat (e.g., `[3,3]` with target 6 → `[0,1]`).

### Constraints

- `nums.length`: 2 to 10⁴.
- Values: −10⁹ to 10⁹ (**can be negative**).
- Target: negative or positive.

> **Important consequence of negative values:** you can't eliminate values that are larger than the target, because a negative plus a positive could still equal the target. E.g., target 15 could come from `−5 + 20`.

### The follow-up hint

> "Can you come up with an algorithm that is less than O(n²) time complexity?"

This tells you:

- Brute-force solution is expected to be **O(n²)**.
- A more efficient solution exists.

### Brute force approach

- Outer loop through each index.
- Inner (nested) loop through remaining indices.
- Check whether outer + inner equal target.
- Return indices when found.

This is **O(n²)**. Will it time out? Depends on the test cases and the language — sometimes brute force squeaks by, sometimes it doesn't.

### Improved approach (Eric's suggestion)

- Loop through the array once.
- For each value, compute the **complement** (`target − current`).
- Search the remaining array for that complement.

Efficiency depends on the search method:

- Unsorted array with linear search → still roughly O(n²).
- Sorted array with binary search → O(n log n).
- With a hash map lookup → O(n). *(This is the standard optimal answer, not covered in detail today.)*

### Big-O clarification

A nested loop where the inner loop only looks at greater indices (`j = i+1`) **is still O(n²)**. It's reduced, but not meaningfully — the class doesn't change.

**O(n) does not mean "loop through every element exactly once."** It means the work scales **linearly** with input size. Looking at 3 of 5 inputs, 30 of 100, 300 of 1000 — that's still O(n) because the ratio is constant.

---

## Problem 2: Three Sum (mock interview)

**Volunteer:** Walter.

**Prompt:** Given integer array `nums`, return **all triplets** `[nums[i], nums[j], nums[k]]` such that `i ≠ j ≠ k` and `nums[i] + nums[j] + nums[k] == 0`. Solution must not contain duplicate triplets.

### What Walter did well

- Recognized it would need multiple nested loops (three pointers: `i`, `j`, `k`).
- Identified the core task: find all groups of three that sum to zero.
- Understood the relationship to Two Sum.

### Key clarification that tripped the group up

The phrase "`i ≠ j ≠ k`" refers to **index positions**, not values.

- `[-1, -1, 2]` is valid if there are two `−1`s at **different indices** in the array.
- You can reuse the same **value** across triplets, but not the same **index** within a single triplet.

### Additional constraints

- **Return shape:** a 2D array of all valid triplets (not index positions — unlike Two Sum, which returns indices).
- **No duplicate triplets:** if `[−1, −1, 2]` has already been found, you cannot add another `[−1, −1, 2]` even if it came from different indices.
- **The same value/index CAN be reused across different triplets** (just not within one triplet, and not forming a duplicate triplet).
- **Order within answer arrays doesn't matter.**
- **There may be no valid triplets** — unlike Two Sum, it's possible an entire array has no solution. Always default to returning an empty array.

### Approach

Brute force is three nested loops (O(n³)) checking all `i,j,k` combinations.

- Unlike Two Sum, Three Sum has **no dramatically better solution** — you can optimize the brute force a smidge (sort first, use two-pointer inside a single loop → O(n²)), but that's about it.

### Strategy: break it into steps

1. First, just find **one** valid triplet. Don't worry about finding all of them.
2. Then figure out how to find **multiple** triplets.
3. Then figure out the dedup condition to avoid repeating triplets already in the answer set.

Each step may take several iterations to get right.

---

## Why These Two Problems Matter

- **Two Sum** and **Three Sum** are still actively used in real job-hunt technical interviews today.
- Often seen together: interviewers start with Two Sum, then add conditions until it becomes Three Sum.
- Rankings (easy/medium) are a little skewed — they're popular enough that expect them to come up.

---

## General Advice

- Try these problems on your own before Wednesday's deep-dive session.
- When stuck, break the problem into the smallest possible step. Don't try to solve "find all triplets with dedup" in one shot — find one triplet first.
- Always add a stub return value (empty array, `False`, `0`) to unlock real test case output when starting.

[REVIEW: coach mentioned moving to Spain and cancelling sessions for one week — scheduling note, not technical content, but kept for completeness.]
