# Solutions Deep Dive — Insert Interval & Merge Intervals (2025-07-23)

Wednesday session: Brian shares his clean O(n) solution for Insert Interval. The session also reveals that Merge Intervals is the natural prerequisite — they were covered in the wrong order.

---

## Q&A

### Should LeetCode solutions use object-oriented Python (classes)?

Adam noticed many LeetCode solutions used class-based Python (e.g., creating an `Interval` class). Are tech interview answers supposed to be class-based?

- **No** — for coding challenges, vanilla Python is the norm.
- Class-based code is for **longevity**: code expected to be maintained, tested, and updated over time.
- Some languages (Java) are inherently class-based; Python is not.
- Use the simplest solution that solves the problem.

### What if a problem requires math knowledge you don't have?

- Every problem should have a **brute force** solution that doesn't require special math tricks.
- Even using `mod` (modulus) is a "math trick" you learned and can now apply across many problems.
- If the optimal solution requires unfamiliar math, look it up after solving brute force. Decide whether the trick is worth memorizing (will it appear in other problems?).
- The coach prefers problems that need high school-level math, not advanced calculus.

---

## Brian's Insert Interval Solution

A clean O(n) single-loop solution. Key insight: Brian solved the **merge case** first, then handled the special insert cases around it.

```python
def insert(self, intervals, newInterval):
    ans = []
    for i in range(len(intervals)):
        if newInterval[0] > intervals[i][-1]:
            # New interval starts after current ends — add current as-is
            ans.append(intervals[i])
        elif newInterval[-1] < intervals[i][0]:
            # New interval ends before current starts — insert new + remainder
            return ans + [newInterval] + intervals[i:]
        else:
            # Overlap — merge
            newInterval = [
                min(newInterval[0], intervals[i][0]),
                max(newInterval[-1], intervals[i][-1])
            ]
    ans.append(newInterval)
    return ans
```

### Walking through `[[1, 3], [6, 9]]` + `[2, 5]`

| i | intervals[i] | newInterval | Branch | Action |
|---|---|---|---|---|
| 0 | `[1, 3]` | `[2, 5]` | `2 > 3`? No. `5 < 1`? No. **Else** | Merge: `min(2,1)=1`, `max(5,3)=5` → newInterval = `[1, 5]` |
| 1 | `[6, 9]` | `[1, 5]` | `1 > 9`? No. `5 < 6`? **Yes** | Return `ans + [[1,5]] + [[6,9]]` = `[[1,5], [6,9]]` ✓ |

### Why `[-1]` instead of `[1]`?

Brian's habit: when working with data structures where the **end** is significant, use `[-1]` to communicate intent. In this 2-element case, `[1]` would also work, but `[-1]` reads as "the last element" regardless of length.

### The clever return

```python
return ans + [newInterval] + intervals[i:]
```

When the new interval ends before the current interval starts (no more merging possible), this **slices the rest of intervals from `i` to the end** and concatenates. Saves writing a second loop just to copy the remainder.

### Wrapping the merged result in `[...]`

```python
newInterval = [min(...), max(...)]
```

Brian explicitly returns a list (not a tuple or unpacked values) so it can be appended to `ans` (a list of lists) without type errors. He had hit data-structure errors before adding the brackets.

### Big-O

- **Time:** O(n) — single loop, all operations inside are O(1).
- **Space:** O(n) — `ans` can grow up to n+1 entries.

Brian confirmed via LeetCode's "Analyze Complexity" button.

---

## Alternative Approach: Append + Sort + Merge

Coach demonstrates the "lazy" brute force version:

```python
intervals.append(newInterval)
intervals.sort()
# now merge any overlaps in the sorted list
```

### Why `sort()` works on lists of lists

Python's `sort()` and `sorted()` default to sorting by the **first element** of each sublist. For `[[1, 3], [4, 5], [2, 5]]`, sorting yields `[[1, 3], [2, 5], [4, 5]]` automatically.

You can override the sort key with a `lambda`:

```python
sorted(items, key=lambda x: x[1])  # sort by second element
```

### Why this is cheating (but useful)

This collapses the **insert** problem into a **merge** problem. Then you only need to solve "merge overlapping intervals," which is the simpler companion problem (see below).

---

## Two Approaches Side by Side

| Approach | Strategy |
|---|---|
| **Brian's** | Merge during the loop. Each iteration is either insert-current, insert-new-and-stop, or merge-with-current. |
| **Coach's** | Insert first (brute force), sort, then merge in a second pass. |

Both work. Brian's is more efficient (single pass). The coach's is more decomposed (split into simpler subproblems).

---

## Merge Intervals (the prerequisite the coach skipped)

The coach realized after the fact that **Merge Intervals** is the prerequisite to **Insert Interval**. They covered them in the wrong order.

### Problem statement

You're given an array of intervals. Some may overlap. Merge all overlapping intervals and return the result.

### Example

- Input: `[[1, 3], [2, 6], [8, 10], [15, 18]]`
- Output: `[[1, 6], [8, 10], [15, 18]]` (the first two merge)

### Solution sketch

This is essentially **just the merge logic from Brian's solution**. After sorting, walk through the list and merge adjacent overlapping intervals.

```python
intervals.sort()
ans = [intervals[0]]
for i in range(1, len(intervals)):
    if intervals[i][0] <= ans[-1][-1]:
        ans[-1][-1] = max(ans[-1][-1], intervals[i][-1])
    else:
        ans.append(intervals[i])
return ans
```

### Why it's also "medium" difficulty

Some students argue this should be easy because the logic is straightforward. The coach pushes back: index manipulation, comparing the right endpoints, and handling the merge in O(n) requires confidence that students fresh out of Mod 2 don't usually have.

---

## Errors as Friends

> "When you're first starting out, you're terrified of errors. But errors are kind of like your best friend. If everything's going smoothly, I almost don't trust it — something must be wrong."

Brian hit two errors during development:
- **Index out of range** (forgot a boundary check).
- **Data structure mismatch** (tried to add an int to a list of lists → fixed by wrapping with `[...]`).

Each error taught him something about the data structure he was building.

---

## Resources Mentioned

### NeetCode

A YouTuber/educator (former Amazon engineer) who built courses around LeetCode. Provides a "study roadmap" for learning data structures and tackling LeetCode problems systematically. Some of his videos use class-based solutions.

### Blind 75

A list of 75 LeetCode problems considered the "essential" set for tech interview prep. The coach has been pulling problems from this list. Two from this session:

- **Insert Interval** (covered)
- **Merge Intervals** (the prerequisite)

After this session: **13 of 75** Blind 75 problems covered.

> "The Blind 75 is pretty old now — some people consider it almost outdated. But it's still a good representation of the fundamentals."

### General study advice

- Spend 10–15 minutes on a problem. If stuck, look at the answer.
- Build pattern recognition by **seeing** examples.
- Cut your teeth on easies, then mediums. Hards are rarely asked in real interviews.

---

## Coach's Plan for the Next Session

- Record a video on **sliding window**, **two pointers**, and **binary search** in the context of specific problems.
- Bridge the gap from "I learned binary search in Mod 2" to "I can implement binary search to solve a real problem."
- Cover a problem that uses the **idea** of binary search (splitting in halves) without using the literal algorithm.

---

## Brian's Status

Brian has finished Mod 2 except for the optional Java content. The technical interview is the gate to the **explorer phase** (working on tickets, building apps). Coach: "You're probably ready."
