# Solutions Deep Dive — Two Sum: Approaches & Pseudo Code (2025-06-11)
Source: https://youtu.be/CMJ9rEYttdw

Wednesday session: deep dive on Two Sum, comparing brute force, search-based, two-pointer, and set-based approaches. **No coding today** — focus is on the pseudo-code and approach-evaluation phase.

---

## Recap: Two Sum problem statement

Given array `nums` and integer `target`, return the **indices** of two numbers that add up to `target`. Exactly one solution exists. Cannot use the same index twice.

### Pseudo code from Sunday

- We are given an array `nums` and `target` (integer).
- Find two separate indices in `nums` whose values sum to `target`.
- Only two values will be summable.
- Integer values can be **negative**.
- Constraints imply we'll always find a solution (length ≥ 2 + exactly one solution exists) → never return empty.
- The array is **not guaranteed sorted** (one example has `[3, 2, 4]`).
- "Cannot use same element twice" → cannot use the same **index** twice (same value at different indices is fine).
- Return order of indices does not matter.

> **Key habit:** leave your pseudo code in a state where you don't need to re-read the problem description. Pull all the meaningful statements (from prose, examples, and constraints) into your own words at the top.

---

## Approach 1: Brute Force (Daniel's submission)

```python
for i in range(len(nums)):
    for j in range(i + 1, len(nums)):
        if nums[i] + nums[j] == target:
            return [i, j]
```

- **Complexity:** O(n²)
- All test cases pass, but runtime ~2 seconds — way slower than peers.
- LeetCode's "Analyze Complexity" button confirms O(n²) (limited to ~2 free clicks/day).

---

## Approach 2: Sort + Binary Search

**Idea:** for each value, compute the **complement** (`target - current`) and search the array for it.

### Why sort first?

- **Linear search** for the complement is O(n) → overall O(n²). No improvement.
- **Binary search** is O(log n) → overall O(n log n). Better than O(n²).
- But binary search **requires a sorted array**.

### Sort vs sorted in Python

- `nums.sort()` → mutates the original array, returns `None`. Can only be called on lists.
- `sorted(nums)` → returns a new sorted list, original is unchanged. Works on any iterable (lists, tuples, strings, dicts, sets).
- Both use the same **Timsort** algorithm (combination of merge sort and insertion sort) — O(n log n).

> Use `sorted()` here so you can keep the original `nums` for index lookup.

### The index problem

Sorting destroys the original index positions, but the answer requires original indices. After finding the matching values in the sorted array, you need a second linear pass through the original `nums` to recover their indices. (Or use `enumerate` to track original positions during sort.)

### Verdict on this approach

- **Complexity:** O(n log n)
- Requires knowing how to write binary search (or asking the interviewer if you can use a template).
- Many steps to code, marginal improvement over brute force in real terms.
- For the Joy of Coding technical interview: probably not worth it.

---

## Approach 3: Two Pointers

- Worked great for Container With Most Water last week, but **only because that problem doesn't care about index order**.
- Two Sum needs a comparison against a target, which means you'd need a less-than/greater-than condition to decide which pointer to move.
- That decision **only makes sense if the array is sorted**.
- So two pointers also requires sorting → also O(n log n).
- About the same efficiency as the binary search approach, slightly easier to implement.

---

## Approach 4: Hashmap / Set Lookup (the optimal solution)

**Insight from the chat:** sets (and dicts) have **O(1) lookup**, insertion, and deletion.

### The algorithm

```python
seen = {}                          # value -> index
for i, num in enumerate(nums):
    complement = target - num
    if complement in seen:
        return [seen[complement], i]
    seen[num] = i
```

- For each value, check whether its complement is already in the set/dict.
- If yes → we found the pair, return both indices.
- If no → add the current value (and its index) to the set/dict and continue.

### Complexity

- **Time:** O(n) — single pass through the array.
- **Space:** O(n) — the lookup structure can grow up to the size of the input.

### Why a dict instead of a set?

- A **set** can confirm whether the complement exists, but doesn't store the original index.
- A **dict** maps `value → index`, so when you find a complement you can return both indices immediately.
- Using `enumerate` in the loop gives you the index of the current value cleanly.

### Negative numbers?

Works fine. Subtraction and addition behave normally with negatives — the only operations that would get tricky are multiplication or division.

---

## The Bigger Lesson: Pseudo Code Before Code

Today's session deliberately had **zero coding** for almost the entire hour. Why?

- For a medium-difficulty problem, spend ~20 minutes on pseudo code and approach evaluation, then code in ~10 minutes.
- That beats spending 30+ minutes thrashing through one approach in code, hitting walls, and rewriting from scratch.
- Compare approaches **on paper** first:
  - Brute force → O(n²), works but slow
  - Sort + binary search → O(n log n), complex to implement
  - Two pointers → needs sorting, ends up O(n log n)
  - Hashmap → O(n), clean implementation

Once you've evaluated the trade-offs, pick the best one and code it confidently — instead of iterating through approaches in code.

---

## Reddit thread observation

> A CS-degree holder admitted Two Sum was hard for them and they had to Google hints and learn about hashmaps from scratch.

The point: even people with formal CS degrees struggle with these problems. The advantage Joy of Coding students have is that **all of these techniques** (binary search, sets, two pointers, brute force, Big-O) are covered in mods 1 and 2 and reinforced in these weekly sessions.

---

## Joy of Coding Tech Interview vs Job Hunt Interviews

- **Joy of Coding interview:** easy-level problems. Don't need to master mediums.
- **Job hunt interviews:** medium and hard problems are common. Working up to this level matters.
- The **process** (read problem, pull observations, write pseudo code, evaluate approaches, code with print statements, test iteratively) is the same regardless of difficulty.
