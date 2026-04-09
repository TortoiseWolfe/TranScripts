# Ruby Solutions Deep Dive — September 10, 2025
Source: https://youtu.be/P8TqSsayQC8

Wednesday session covering two problems from the prior Sunday: **Array Partition I** (easy) and **Minimum Number of Arrows to Burst Balloons** (medium). Lisa walks through her sort-then-pair solution, and the coach uses a whiteboard to demonstrate the greedy "reach" technique for the balloon problem.

---

## Problem: Array Partition I

> Given an integer array `nums` of `2n` integers, group these integers into `n` pairs `(a1, b1), (a2, b2), ..., (an, bn)` such that the sum of `min(ai, bi)` for all `i` is **maximized**. Return the maximized sum.

### Example

- `nums = [1, 4, 3, 2]` → `4` (pair as `(1,2), (3,4)`, min sum = `1 + 3 = 4`)

### Constraints

- `nums.length` is always **even** (divisible by 2, so there's always a pair for each element).

---

## Array Partition: Sort-and-Step Solution (Lisa)

```python
def arrayPairSum(nums):
    nums.sort()
    total = 0
    for i in range(0, len(nums), 2):
        total += nums[i]
    return total
```

### How it works

- **Sort** the array ascending.
- **Step by 2** through the sorted array, always taking the element at the even index.
- Each "step 2" index is guaranteed to be the **smaller** of its pair when the array is sorted ascending.

### Why sorting is the key insight

> If you're looking for the minimum of two numbers, you want those two numbers close together. If you pair 1 with 6 in a sorted array, you "lose" the 6 — it gets thrown away because we only take the min. By pairing adjacent values after sorting, the max possible value that gets discarded per pair is minimized.

- Pairing `(1, 2)` throws away `2`; pairing `(3, 4)` throws away `4`. Total discarded: `6`.
- Pairing `(1, 4)` throws away `4`; pairing `(2, 3)` throws away `3`. Total discarded: `7`.
- Minimum discard maximizes the sum of the mins.

### Complexity

- **Time:** O(n log n) — dominated by the sort.
- **Space:** O(1) — sorted in place.

### Is there a non-sorting solution?

The coach tried to find one and couldn't get below O(n²) without sorting. The problem fundamentally relies on the pairing structure that sorting creates — without sorted order, there's no efficient way to identify which pairs minimize discarded values.

---

## Problem: Minimum Number of Arrows to Burst Balloons

> Balloons are given as `points[i] = [xstart, xend]`. Arrows shot straight up at x-coordinate `x` burst any balloon whose `xstart <= x <= xend`. Return the minimum number of arrows needed to burst all balloons.

### Examples

- `points = [[1,6], [2,8], [7,12], [10,16]]` → `2`
- `points = [[1,2], [3,4], [5,6], [7,8]]` → `4` (no overlaps)

### Conceptual setup

- The y-axis doesn't matter — only x-ranges are given, and arrows travel vertically.
- Balloons whose x-ranges **overlap at any point** can all be burst by a single arrow shot through that overlap.
- Coordinates can be **negative** — don't assume positive-only ranges.

---

## Lisa's First Attempt: Compare Adjacent Pairs

```python
def findMinArrowShots(points):
    points.sort()
    count = len(points)  # start assuming one arrow per balloon
    arrow = 0
    for i in range(count - 1):
        if points[i][1] >= points[i + 1][0] and points[i][1] <= points[i + 1][1]:
            arrow += 1
    if arrow == 0:
        return count
    return count - arrow
```

### What it gets right

- Sorts the points to bring overlapping balloons together.
- Walks adjacent pairs checking for overlap.

### What it gets wrong

- Only checks **adjacent** pairs — misses the case where balloon 1 and balloon 3 both overlap with balloon 2 but not with each other.
- Double-counts overlaps — if A overlaps B and B overlaps C, that's two "overlap detections" but should be one arrow covering all three.
- Doesn't track which balloons have already been "used" by a previous arrow.

### The root diagnosis

> You're not really counting how many balloons can be burst with the minimum arrows. You're counting how many balloons that are immediately beside each other have an overlap. Those are different problems.

---

## Mental Model 1: Dynamic Shifting Overlap

Track the **current overlap region** — the intersection of all balloons the current arrow could burst.

- Start with balloon 1's range as the initial overlap.
- For each next balloon: does it fit inside the current overlap?
  - **Yes** → tighten the overlap to the intersection (the balloon is now also covered by the current arrow).
  - **No** → increment arrow count, reset the overlap to this new balloon's range.

### Why this is harder to code

- Requires tracking both the start and end of the shrinking overlap.
- The intersection operation (`max(starts), min(ends)`) has to happen on every balloon.

---

## Mental Model 2: Track the Reach — Greedy O(n log n)

A much simpler encoding of the same idea. Track only the **end** of the current arrow's reach.

### Whiteboard walkthrough

Sorted balloons: `[1,6], [4,8], [7,9], [11,13], [12,15]`

| Step | Balloon | Reach before | Fits? | Action | Arrows |
|---|---|---|---|---|---|
| 1 | `[1,6]` | — | start | reach = 6 | 1 |
| 2 | `[4,8]` | 6 | `4 <= 6` yes | reach = min(6, 8) = 6 | 1 |
| 3 | `[7,9]` | 6 | `7 > 6` no | reach = 9, new arrow | 2 |
| 4 | `[11,13]` | 9 | `11 > 9` no | reach = 13, new arrow | 3 |
| 5 | `[12,15]` | 13 | `12 <= 13` yes | reach = min(13, 15) = 13 | 3 |

**Answer: 3 arrows.**

### The code

```python
def findMinArrowShots(points):
    if not points:
        return 0
    points.sort(key=lambda p: p[0])  # sort by start
    arrows = 1
    reach = points[0][1]
    for start, end in points[1:]:
        if start > reach:
            arrows += 1
            reach = end
        else:
            reach = min(reach, end)  # shrink reach to the intersection
    return arrows
```

### Why it works

- After sorting by start, if the current balloon's start is **within** the previous reach, they share overlap — tighten the reach to `min(reach, end)` so future balloons must also fit the tightened intersection.
- If the current balloon's start is **beyond** the previous reach, no single arrow can cover both — increment the arrow count and reset reach to the new balloon's end.
- We only ever look at one balloon at a time — no nested loops, no dynamic overlap tracking beyond a single scalar.

### Complexity

- **Time:** O(n log n) — dominated by sort.
- **Space:** O(1) after sort.

### Key realization

> We're only tracking one thing: reach. We're not comparing each balloon against a bunch of others. We walk slow along the way and just ask, "Is the next balloon's start within my current arrow's reach?" Yes → stay. No → new arrow.

---

## The Visualization Technique

The coach mentioned needing to pull out a whiteboard and actually draw the balloons to arrive at this solution.

> When you're torturing yourself thinking about edge cases — "what if 3 balloons are stacked? what if they're slightly offset?" — that's a sign you should stop coding and start visualizing. Draw it. 3D the problem. Something about moving the mental model out of your head and onto paper unsticks the logic.

- **Writing out code for every edge case** you find is a red flag.
- **Drawing or diagramming** the problem space usually surfaces the simpler greedy insight.

---

## Edge Cases and Anti-Patterns

### Don't code for every edge case you imagine

Lisa added a `if arrow == 0: return count` fallback to handle "what if there are no overlaps at all?"

> It's good that you thought about those edge cases — that's how you find them. The problem is when you start coding around each one individually. There's a thin line between being clever about edge cases and torturing yourself with them.

The greedy-reach solution handles "no overlaps" naturally — every balloon triggers a new arrow, no special case required.

### Don't randomly tweak operators when stuck

> Don't start changing things randomly, like "what if I add another increment" or "what if I switch greater-than to greater-than-or-equal". If you do that, you're not sure what your code is doing anymore. Take a step back, rethink the approach.

---

## Session Takeaways

- **Array Partition** — sort ascending and sum every other element starting from index 0. The sort is mandatory because the problem depends on pairing close values.
- **Minimum Arrows** — sort by start, track a single scalar "reach" equal to the current arrow's rightmost coverage, and either tighten it (overlap) or advance it (new arrow).
- **Two mental models, one solution** — dynamic overlap region vs reach tracking both encode the greedy insight; the reach version is simpler to implement.
- **Visualize when stuck** — whiteboard diagrams expose greedy solutions that are invisible when you're staring at code.
- **Stop when you find yourself coding edge case by edge case** — your approach is probably wrong, not incomplete.
