# Make-Up Session — Two Pointers on Ice Cream Parlor (2025-07-27)

A long-overdue make-up session: implementing the **two-pointer** approach on the Ice Cream Parlor problem. (Binary search version still pending — saved for next session.)

---

## Problem Recap: Ice Cream Parlor

Two friends pool money `m`. Given a list of ice cream costs, return the **one-based indices** of the two distinct flavors that sum exactly to `m`. There will always be a valid solution.

### Key constraints

- `m`: 2 to 10⁴.
- `n` (length of cost array): 2 to 10⁴.
- Cost values: 1 to 10⁴.
- Always exactly one valid solution.
- Two indices must be **distinct** but the **values** can repeat.

---

## Brute Force Recap (Nested Loop)

```python
for index, value in enumerate(cost, 1):
    for j in range(index, len(cost)):
        if value + cost[j] == m:
            return [index, j + 1]
```

- `enumerate(cost, 1)` for one-based outer index.
- `range(index, len(cost))` for the inner loop (zero-based, since `cost[j]` uses zero-based access).
- Add `+1` to `j` when returning to convert to one-based.
- **Time:** O(n²)
- **Space:** O(1)

### Important indexing nuance

`enumerate(cost, 1)` gives a one-based **counter**, but the underlying list `cost` is still zero-based. When you mix `enumerate` with raw `cost[j]` access, you have to mentally track which is which. **Print everything to verify.**

---

## Two-Pointer Implementation

### Why this problem needs sorting first

Two pointers requires a condition to decide which pointer to move. Here, the condition is "is `cost[left] + cost[right]` greater than or less than `m`?" That comparison only makes sense if the values are **sorted**.

```python
sorted_cost = sorted(cost)  # don't mutate the original
left = 0
right = len(sorted_cost) - 1

value_one = 0
value_two = 0

while left < right:
    if sorted_cost[left] + sorted_cost[right] == m:
        value_one = sorted_cost[left]
        value_two = sorted_cost[right]
        break
    elif sorted_cost[left] + sorted_cost[right] > m:
        right -= 1
    else:
        left += 1
```

### Why `sorted()` instead of `cost.sort()`

- `cost.sort()` mutates the original list **in place** → destroys the original indices.
- `sorted(cost)` returns a **new sorted list**, leaving `cost` unchanged.
- We need the **original** array to look up the **original** indices of our found values.

> **Bug discovered during the live coding:** The coach initially used `cost.sort()`, found the right values, but then returned wrong indices because the indices in the sorted array don't match the original. Fix: switch to `sorted(cost)` and store the result in a separate variable.

### Recovering the original indices

```python
answer = []
for index, value in enumerate(cost, 1):
    if value == value_one:
        answer.append(index)
    elif value == value_two:
        answer.append(index)
return answer
```

### Why `elif` instead of two separate `if`s

If both target values are the same (e.g., `[2, 2]` summing to 4), two separate `if` statements would both fire on the same value and return the same index twice. Using `elif` ensures each iteration only matches one of the two targets, so you get two **distinct** indices.

---

## Big-O Analysis

- **Sort:** O(n log n)
- **Two-pointer loop:** O(n)
- **Index recovery loop:** O(n)
- **Overall:** O(n log n)

### Why this is barely better than brute force

Brute force was O(n²), and the two-pointer approach is O(n log n). On the Big-O graph, that's a meaningful improvement on paper. But for this problem specifically, you have to write **way more code** (sort + two-pointer + index recovery), so the actual runtime gain is marginal compared to just nesting two loops.

### When two-pointer really shines

Two pointers is genuinely O(n) **when the input is already sorted** and you don't need to recover original indices. Container With Most Water (a previous problem) is the classic example — the input doesn't need to be sorted because the conditions for moving pointers depend on heights, not sums.

---

## The Lesson: Knowing the Algorithm vs Using It

Even though two-pointer wasn't the **best** solution for Ice Cream Parlor, the implementation exercise teaches:

- How to write the **truthy case** (the condition for "we found it").
- How to write the **conditions** that decide which pointer moves.
- How to **modify a standard algorithm** to fit a problem's quirks (like needing to recover original indices via a second loop).

> "We can modify an algorithm to meet our use cases if it's something that we know would work or meet the goal."

---

## Two-Pointer Template

```python
left = 0
right = len(arr) - 1

while left < right:
    if [truthy condition]:
        return [solution]
    elif [condition to shrink right]:
        right -= 1
    else:
        left += 1
```

- **Loop condition:** `while left < right` — stops when pointers meet or cross.
- **Truthy case:** the win condition. Return immediately.
- **Two condition cases:** decide which pointer moves based on the data.

### Things to debug

- **Index out of range:** initial `right` should be `len(arr) - 1`, not `len(arr)`.
- **Wrong indices returned:** check whether you're using a sorted view or the original.
- **Infinite loop:** make sure both branches actually move a pointer.

---

## Errors as Friends (Debugging Walk-Through)

### Bug 1: index out of range

Initial `right = len(cost)` instead of `len(cost) - 1`. Caused an out-of-bounds access.

### Bug 2: returning indices from sorted array, not original

After fixing bug 1, the function returned `[1, 3]` instead of `[1, 4]`. The values were correct but the indices were from the sorted view.

**Diagnosis:** print `left, right, sorted_cost[left], sorted_cost[right]` and compare against the unsorted `cost` array. Realized the indices were from the sorted view.

**Fix:** use `sorted(cost)` to keep both versions, then do a second loop on the original to recover the original indices.

### Bug 3: visual confusion from a "find" highlight

The coach accidentally had Ctrl+F find-mode active in the editor, which highlighted random text and made it hard to see what was wrong. Took several minutes to notice. **Lesson:** if the editor is acting weird, check for stray modal states.

---

## Plan for Next Session

- **Binary search** implementation on the same Ice Cream Parlor problem.
- Will dive straight in without the long buildup since the problem is now well-understood.
- Goal: see binary search applied to a real problem, not just as an isolated Mod 2 exercise.

> "Today's point is just seeing that implementation of two pointer in the context of this problem so that you can learn how to use it in unique and variety of ways."
