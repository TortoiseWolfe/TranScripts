# Mock Interview — Top K Frequent Elements (2025-07-27c)

Continuation of the Sunday session. After Contains Duplicate, the group does a pseudo-code-only mock interview on **Top K Frequent Elements** (medium). Volunteer: Rebecca.

---

## Contains Duplicate — Final Approaches Discussed

Three different approaches surfaced for the warm-up problem:

### Approach 1: Nested Loop with Count

```python
for i in range(len(nums)):
    if nums.count(nums[i]) > 1:
        return True
return False
```

- **Time:** O(n²)
- Brute force, simple to write.

### Approach 2: Hashmap / Set (Mindy's suggestion)

```python
seen = set()
for num in nums:
    if num in seen:
        return True
    seen.add(num)
return False
```

- **Time:** O(n)
- **Space:** O(n)
- **Optimal.** Single loop, set lookup is O(1).

### Approach 3: Sort + Adjacent Comparison

```python
nums.sort()
for i in range(len(nums) - 1):
    if nums[i] == nums[i + 1]:
        return True
return False
```

- **Time:** O(n log n) — dominated by the sort.
- **Space:** O(1) (or O(n) depending on the sort's implementation).
- Worse than the hashmap, but better than brute force.

### Big-O comparison

- Brute force: O(n²) ❌
- Sort + check: O(n log n) ⚠️
- Hashmap: O(n) ✅

### A note on "shortcutting" by digit range

One participant suggested: "Since digits 0-9 are limited, can we exploit that?" The coach pointed out: **values can be -10⁹ to 10⁹**, so this isn't a finite digit set. The example uses small numbers, but the constraints allow much larger values. Always check the constraints before assuming a shortcut.

---

## Problem 2: Top K Frequent Elements (Medium)

### Problem statement

Given an integer array `nums` and an integer `k`, return the **k most frequent elements**. You may return the answer in any order.

### Examples

- `nums = [1, 1, 1, 2, 2, 3]`, `k = 2` → `[1, 2]`
- `nums = [1]`, `k = 1` → `[1]`

### Critical clarification (Rebecca initially missed)

`k` is **not** how many numbers are duplicated. `k` is the **count of the most frequent values you should return**.

- `k = 2` means "return the 2 most frequent values."
- For `[1, 1, 1, 2, 2, 3]`: 1 appears 3 times, 2 appears 2 times, 3 appears once. The top 2 most frequent are 1 and 2.
- Rebecca initially thought `k = 2` meant "two values appeared more than once," which would be a totally different problem.

### Walking through a harder example

If the input were `[1, 1, 1, 2, 2, 3, 4, 4, 4, 4, 4]` with `k = 2`:

- Frequencies: `{1: 3, 2: 2, 3: 1, 4: 5}`
- Top 2 most frequent: **4 and 1** (4 has 5 occurrences, 1 has 3).
- Output: `[1, 4]` or `[4, 1]` (order doesn't matter).

> The key word is **frequency**, not **value**. Sort the unique values by their frequency, then take the top k.

---

## Rebecca's Pseudo Code Approach

### Step 1: Restate the problem in your own words

```
nums = array of integers
k = how many of the most frequent numbers to return
output = the k values that occur most often
```

### Step 2: Identify the data structure

- Build a **dictionary (hashmap)** mapping each unique value to its frequency count.
- Iterate through `nums`, increment the count for each value in the dictionary.

### Step 3: Find the top k

- After building the frequency dictionary, find the k entries with the highest counts.
- Return those k keys.

### Step 4: Pseudo code

```
loop through nums to find duplicate numbers
create dictionary
when you find a duplicate, increment count in dictionary
loop through dictionary to find the k highest counts
return those k values
```

This is exactly the right shape for the optimal solution. The remaining work is just translating it to actual Python.

---

## Implementing Top K Frequent (next steps for Rebecca)

### Step 1: Build the frequency dictionary

```python
from collections import Counter
freq = Counter(nums)  # or build manually with a dict
```

### Step 2: Sort or select the top k

Several Python options:

- `sorted(freq, key=freq.get, reverse=True)[:k]`
- `freq.most_common(k)` — returns list of `(value, count)` tuples
- Heap-based approach for O(n log k) instead of O(n log n)

### Big-O for the optimal hashmap + sort approach

- **Time:** O(n log n) (the sort dominates)
- **Space:** O(n) (the dictionary)

A heap-based approach can get this down to O(n log k), which matters when k is much smaller than n.

---

## The New Mock Interview Format Worked

> Mindy: "I think this was a really effective session."
>
> Coach: "I agree. Thank you for the suggestion, Mindy."

### Why pseudo-code-only is better (for now)

- **Removes the freeze-up trap.** Rebecca admitted she "couldn't even think of the word 'loop' for a minute" when put on the spot. Without the pressure of code, she could keep thinking.
- **Builds the planning muscle** that students under-practice.
- **Builds presentation confidence** without the secondary pressure of syntax errors.
- Once participants are confident at this level, they can graduate to coding mock interviews.

### Rebecca's success

Even though she froze briefly, she:

- Restated the problem in her own words.
- Realized her initial assumption about `k` was wrong (with a hint).
- Pivoted her approach from "just find duplicates" to "count frequencies and return top k."
- Identified a dictionary as the right data structure.
- Outlined the next steps clearly.

That's exactly what a good interviewer wants to see — adaptability and clear thinking under pressure.

---

## Q&A: Test Plan + Print Statements in the Real Interview

**Q:** "For the technical interview, do I still need to print things out and write a plan first?"

**A:** Not required, but **highly recommended**.

- Following your steps as you practice builds the muscle so it becomes natural.
- Print statements save more time than they cost — you catch bugs immediately instead of after writing 30 lines.
- The 15–20 minute time limit feels short, but if you've been practicing the full process, you'll fit within it.

**Q:** "It took me 15 minutes just to read an easy problem. Will I get faster?"

**A:** Yes, but reading time also depends on the problem itself. Some problems are intentionally tricky and confusing — no amount of practice makes them faster to digest. What you can practice is **pulling out actionable information** quickly: what's the input, what's the output, what are the constraints, what's the goal in one sentence.

> "If they want to make it tricky and confusing, it's going to be tricky and confusing. There's no amount of practice that can make the problem itself easier to digest."

---

## Recap: 15-Minute Interview Time

- Joy of Coding tech interview: **15–20 minutes** for one easy HackerRank problem.
- Practice within that window, but don't sacrifice quality steps to chase speed.
- Speed comes from **practiced steps**, not from rushing.
