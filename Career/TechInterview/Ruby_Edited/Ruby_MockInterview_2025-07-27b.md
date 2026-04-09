# Mock Interview — Contains Duplicate (2025-07-27b)
Source: https://youtu.be/gyW2s5ERvM0

Sunday session: pseudo code walkthrough of LeetCode's **Contains Duplicate** (easy). New rule going forward: **mock interviews will be pseudo-code only — no coding** until further notice.

---

## [0:28](https://youtu.be/gyW2s5ERvM0?t=28) Q&A

### [0:28](https://youtu.be/gyW2s5ERvM0?t=28) Ice Cream Parlor felt harder than "easy"

Rebecca timed herself reading the Ice Cream Parlor problem and it took 15 minutes just to digest it — and the goal for an easy problem in the interview is to **finish in 15 minutes**.

- The coach agreed — Ice Cream Parlor is borderline medium even though HackerRank labels it easy.
- This is the same problem as Two Sum, just dressed up with new framing.
- Spending 15 minutes reading + 5 pseudo code + 10–15 coding is a totally fine pace when you're just starting out.
- Important: did you understand it by the end of those 15 minutes? If yes, you're on the right path even if it took longer than the official time limit.

---

## [4:30](https://youtu.be/gyW2s5ERvM0?t=270) New Mock Interview Format

> "I want to remove the barrier of jumping into code. We all have this tendency to just dive into the editor. For mock interviews going forward, I want everyone to focus exclusively on **pseudo code only** — no real code at all."

### [2:27](https://youtu.be/gyW2s5ERvM0?t=147) [approx] What this means

- Read and digest the problem.
- Pull out what we can — observations, assumptions, constraints.
- Write pseudo code: explain the problem, present your understanding, lay out steps.
- **Stop** at the point where you would normally start writing code.

### [10:10](https://youtu.be/gyW2s5ERvM0?t=610) Why

- Practice the underused skill of decomposing problems before coding.
- Avoid the trap of "I'm in code now, I have to make this work."
- Improve presentation and explanation skills.

---

## [5:25](https://youtu.be/gyW2s5ERvM0?t=325) Problem: Contains Duplicate

Given an integer array `nums`, return `True` if any value appears at least twice, `False` if all elements are distinct.

### [6:02](https://youtu.be/gyW2s5ERvM0?t=362) Examples

- `[1, 2, 3, 1]` → `True` (1 appears at indices 0 and 3)
- `[1, 2, 3, 4]` → `False` (all distinct)
- `[1, 1, 1, 3, 3, 4, 3, 2, 4, 2]` → `True` (multiple repeats)

### [5:44](https://youtu.be/gyW2s5ERvM0?t=344) [approx] Constraints

- `nums.length`: 1 to 10⁵ (100,000)
- Values: -10⁹ to 10⁹

---

## [7:28](https://youtu.be/gyW2s5ERvM0?t=448) Pulling From the Problem

- **Input:** integer array.
- **Goal:** find the **frequency** of any given number in the array.
- **Return:** `True` if any number repeats, `False` if all numbers are unique.
- We don't need to return indices, counts, or which number is duplicated — just a boolean.

---

## [7:23](https://youtu.be/gyW2s5ERvM0?t=443) [approx] Approach 1: Loop With Count (Brian's idea)

```python
for i in range(len(nums)):
    if nums.count(nums[i]) > 1:
        return True
return False
```

### [10:42](https://youtu.be/gyW2s5ERvM0?t=642) How it works

- For each value in the array, count how many times it appears in the full array.
- If the count is greater than 1, return `True` immediately.
- After the loop, if no duplicates were found, return `False`.

### [7:28](https://youtu.be/gyW2s5ERvM0?t=448) Big-O

- **Time:** O(n²) — `list.count(x)` is O(n), and we call it n times.
- **Space:** O(1)

### [12:55](https://youtu.be/gyW2s5ERvM0?t=775) Tradeoff

Simple, easy to write, but inefficient. Brute force.

---

## [10:10](https://youtu.be/gyW2s5ERvM0?t=610) Approach 2: Set / Hashmap (the optimal answer)

The classic solution to this kind of problem is to use a **set** to track values seen so far.

```python
seen = set()
for num in nums:
    if num in seen:
        return True
    seen.add(num)
return False
```

- **Time:** O(n) — single pass; set lookup and insert are O(1).
- **Space:** O(n) — the set can grow up to n elements.

Even simpler:

```python
return len(set(nums)) != len(nums)
```

If the set version of the array has fewer elements than the original, there were duplicates.

---

## [11:29](https://youtu.be/gyW2s5ERvM0?t=689) [approx] Why This Problem Is Easy

- One condition to check.
- One pass through the data is sufficient with the right data structure.
- The optimal solution is just a few lines.

The challenge for someone new to LeetCode is **knowing the set/hashmap pattern**. Once you've seen it once, it's reusable across many problems.

---

## [3:38](https://youtu.be/gyW2s5ERvM0?t=218) What To Practice

> "Today's mock interview is going to focus on this exact same skill: read the problem, pull out what you can, write some pseudo code, present your understanding, and stop there. No coding. Just the thinking part."

[REVIEW: this transcript ends mid-discussion at line 268, so the actual mock interview portion is not included. The session continues in `Ruby_MockInterview_2025-07-27c.txt`.]
