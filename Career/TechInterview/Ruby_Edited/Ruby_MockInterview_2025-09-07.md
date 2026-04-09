# Ruby Mock Interview — September 7, 2025
Source: https://youtu.be/fvtYZ_QBQK0

*Nailing the Tech Interview — Sunday session*

## Q&A: Not Every Practice Session Has to Hit the Time Target

- It's okay if you don't hit the 15–20 minute target every single time.
- What matters is that **on average** you consistently hit it.
- Even simple-looking problems can stump you on first read — everyone has that experience.

> "Sometimes you take the wrong path to the solution that gets you tangled in a mess that ends up consuming lots of time." — Mauricio

### When to scrap and restart

- If you've gone down a bad path, **it's always okay to scratch it and start from scratch**.
- Often starting over is *faster* than trying to rescue a tangled approach.
- You can still hit the time goal even after restarting.

---

## Warm-Up Problem: Array Partition I (LeetCode easy)

### Problem statement

Given an integer array `nums` of `2n` integers, group them into `n` pairs `(a1, b1), (a2, b2), ...` such that the sum of `min(ai, bi)` for all `i` is **maximized**. Return the maximized sum.

### Examples

```
nums = [1, 4, 3, 2]     -> 4
  Pair: (1, 2), (3, 4) -> min(1,2) + min(3,4) = 1 + 3 = 4

nums = [6, 2, 6, 5, 1, 2] -> 9
  Pair: (1, 2), (2, 5), (6, 6) -> 1 + 2 + 6 = 9
```

### Constraints

- `1 <= n <= 10^4`
- `nums.length == 2 * n` — **always even length**
- `-10^4 <= nums[i] <= 10^4` — **can be negative**

### Problem restated

> "Find the best combination of pairs so that the sum of the min of each two-value pair provides the highest output."

### Key phrase: "all possible pairings"

This phrase in the explanation suggests brute force is possible, but it's actually **two levels of brute force**:

1. Generate all possible pairings of elements.
2. For each pairing, compute the sum of mins.

This explodes to factorial complexity very quickly.

### A partial optimization idea

- Greedily find the best pair first (highest possible min), remove those two elements, then repeat on the remaining set.
- Gets you closer to O(n²) rather than O(n!).
- **Not discussed yet:** the actually-optimal solution, which is to **sort and take every other element**. This is covered in the Wednesday deep-dive.

### Coaching note

This is marked "easy" on LeetCode, but easy problems vary in difficulty. If a particular easy stumps you, don't panic — it happens.

---

## Mock Interview: Mauricio on "Minimum Number of Arrows to Burst Balloons"

### Problem statement

You're given a 2D wall with balloons. Each balloon is represented as `[xstart, xend]` (its horizontal diameter). You can shoot arrows vertically from the x-axis that travel infinitely upward, popping all balloons they pass through.

**Return the minimum number of arrows needed to burst all balloons.**

### Constraint quirk

One constraint Mauricio found confusing: `points[i].length == 2`. This just means each balloon is a 2-element sub-array (2D array with inner length 2), not a constraint on the outer array length.

> "Ah, it means it has two elements. I'm kind of slow today."

The other constraints:

- `1 <= points.length <= 10^5`
- `-2^31 <= xstart < xend <= 2^31 - 1` — values can be **negative**

### Mauricio's game plan

- **Find intersections** between balloon diameters.
- One arrow can pop multiple balloons if their x-ranges overlap.
- Compare each balloon against the others to find overlapping groups, then count how many distinct groups you need.
- Acknowledged this is **O(n²)** nested-loop brute force — he wanted to get an idea down fast rather than find an optimal approach.

### Partial pseudo code

```
# For each balloon, compare its [xstart, xend] against every other balloon
# If xstart1 <= xend2 AND xstart2 <= xend1: they intersect
# Track groups of overlapping balloons
# Count distinct arrows needed = number of groups

start1 = points[i][0]
end1 = points[i][1]
start2 = points[j][0]
end2 = points[j][1]
# check intersection
```

### Coaching feedback

- Good job thinking it through clearly and picking a starting approach even knowing it wasn't optimal.
- Medium problems have a **40-minute to 1-hour** time budget. Spending 20–25 minutes on pseudo code still leaves ample time to code and debug.
- **Two-level brute force tends to balloon into complexity traps** — if you catch yourself saying "compare each with all others" without a tracking mechanism, pause and think about sorting first.

### The actually good approach (hinted)

- **Sort balloons by their end coordinate.**
- Walk through and greedily count: if the current balloon starts *after* the last arrow's position, shoot a new arrow at its end.
- O(n log n) from sorting, O(1) extra space. Covered in more depth on Wednesday.

---

## Group Breakout Session

Ruby split the group into pairs for 20 minutes on the Burst Balloons problem while Mauricio stayed in the main room for his mock interview.

### Group 1 — Chris (solo, possibly muted the whole time)

Chris attempted to code a solution iterating `for i in range(len(points))`, treating each `points[i]` as `[start, end]`, and tracking arrows.

**Bugs/syntax issues found:**

- Used `i` before declaring it properly (`point.Z` typo for `points[i]`).
- Didn't account for the **negative coordinate range** in the constraints (`-2^31`). Coming from a CAD/Revit background, he was used to coordinates starting at zero.

> "A lot of times with CAD blueprints, your coordinate system starts at zero. We don't ever think about going in the negative range." — Chris

Not a bad starting approach — just needs constraint awareness.

### Group 2 — Lisa and Rebecca

Worked on pseudo code only.

**Their approach:**

- Visualize balloons on a horizontal x-axis at different positions.
- Shooting an arrow vertically can pop multiple balloons if their x-ranges overlap.
- **Overlap check:** if `min(balloon1.end, balloon2.end) >= max(balloon1.start, balloon2.start)`, they overlap.
- Considered **sorting the points** to make the comparison easier.
- Planned a `for` loop through each balloon with `if` statements checking overlap, then a counter for arrows needed.

### Rebecca's confusion with nested arrays

Rebecca understood the problem visually but wasn't sure **how to "tell the computer"** to compare the minimum of one inner array against the maximum of the next.

**Ruby's recommendation:**

- Review the **two-dimensional arrays** section in mod 2.
- The mental framework for accessing nested values (`points[i][0]`, `points[i][1]`) is the missing piece, not the logic.

> "The first part is getting the mental framework around it, then the second part is getting the coding framework around it."

---

## On Going Back Through Old Material

Rebecca asked whether she should redo all of mod 2.

- Going back through mod 1 or mod 2 is **not horrible**, but usually not necessary.
- **The second time through is much faster** — you absorb new nuggets you missed the first time.
- Better strategy: when you see a problem, identify the concept it's testing, and revisit just that section.

> "Dr. Emily really knows what she's talking about — who would have thought?" — Mindy, rewatching mod 2 videos

---

## Time Targets Recap

| Difficulty | Target time |
|------------|-------------|
| Easy       | 15–20 minutes |
| Medium     | 40 minutes to 1 hour |

- Array Partition I → easy → 15–20 minute target
- Minimum Arrows to Burst Balloons → medium → 40–60 minute target

Consistently hitting easy targets is the main readiness signal. Medium problems are for stretching and exposure, not for the readiness benchmark.

---

## Key Takeaways

- **Consistency matters more than every-time perfection.** Hit the time target on average, not always.
- **Start over when stuck.** A fresh attempt is often faster than debugging a tangled approach.
- **"All possible pairings" is a brute force red flag** — look for sort-based or greedy optimizations.
- **Pseudo code first, code second**, especially on mediums where you have an hour budget.
- **Check constraint ranges** for negative values and unusual bounds (`-2^31`, `10^5`, etc.) before coding.
- **Nested arrays** need the right mental model — practice `matrix[i][j]` access patterns in mod 2.
- **Review material on a second pass** is dramatically more efficient than the first.
- **O(n²) brute force is fine as a starting point.** Get something working, then think about optimizing.
