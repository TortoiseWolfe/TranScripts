# Ruby Solutions Deep Dive — February 11, 2026

Mock interview on **Check if a String Is an Acronym of Words** — actually **Type of Triangle** (LeetCode Easy). Long walkthrough on the importance of enumerating all return conditions before coding, plus a sorting-based shortcut for the triangle inequality check.

---

## Problem: Type of Triangle

> Given a 0-indexed integer array `nums` of size 3, representing the sides of a triangle, return a string representing the type:
> - `"equilateral"` — all three sides equal
> - `"isosceles"` — exactly two sides equal
> - `"scalene"` — all sides different
> - `"none"` — if the three numbers cannot form a triangle

### Examples

- `[3, 3, 3]` → `"equilateral"`
- `[3, 4, 5]` → `"scalene"` (the sum of any two sides exceeds the third)
- `[3, 4, 15]` → `"none"` (`3 + 4 = 7` is not greater than `15`)

### Constraints

- `nums.length == 3`
- `1 <= nums[i] <= 100`

---

## The Triangle Inequality Theorem

> "The sum of two sides of a triangle is always greater than the third side — for **all three combinations** of sides. If even one combination fails, the three lengths cannot form a triangle."

### Combinations to check

For sides `a`, `b`, `c`:
1. `a + b > c`
2. `a + c > b`
3. `b + c > a`

If all three hold, it's a triangle. Otherwise, it's `"none"`.

---

## Linda's Initial Struggle

Linda missed the `"none"` case on her first read and thought there were only three return conditions. She got **equilateral** working quickly with `if nums[0] == nums[1] == nums[2]`, then hit an `int object is not iterable` error when she tried `sum(nums[0], nums[1])`.

### The Bug: Misusing `sum()`

```python
sum(nums[0], nums[1])  # ERROR - sum() takes an iterable
```

`sum()` expects an **iterable** as its first argument, not individual numbers. The correct usage is `sum([nums[0], nums[1]])` or simply `nums[0] + nums[1]`.

### Coach's Debug Process

> "When you see `int object is not iterable`, look at the `sum()` call. Check Python docs or W3Schools — `sum()` requires a sequence, not two separate ints."

---

## The Core Lesson: Enumerate All Return Conditions First

The coach restarted the session by walking through the problem from the top:

### Step 1: Identify All Possible Returns

```
- equilateral (all three sides equal)
- isosceles  (two sides equal)
- scalene    (all sides different)
- none       (not a triangle)
```

### Step 2: Under What Conditions Does Each Apply?

- **Equilateral** — all three sides equal. **Always a triangle.**
- **Isosceles** — two sides equal. **Triangle check still required.** (E.g., `[3, 3, 15]` is isosceles by side equality but not a triangle.)
- **Scalene** — all three sides different. **Triangle check still required.**
- **None** — triangle inequality fails.

### Step 3: Order The Checks

```
1. Is it equilateral? (always a triangle if yes)
2. Is it a triangle? (if no → return "none")
3. Is it isosceles or scalene?
```

This flips the naive ordering and avoids redundant work.

---

## Lisa's Insight: Sort First

Lisa suggested sorting the array as a preprocessing step. This unlocks multiple simplifications:

### Benefit 1: Simpler Isosceles vs Scalene

After sorting, the two smallest values are adjacent. If `nums[0] == nums[1]`, the result (given it's already not equilateral) is isosceles. Otherwise scalene. Only one comparison needed.

### Benefit 2: Simpler Triangle Check

With a sorted array `[a, b, c]` where `a <= b <= c`, the triangle inequality reduces to **one check**: `a + b > c`. The other two combinations (`a + c > b`, `b + c > a`) are automatically satisfied when `c` is the largest.

---

## The Clean Solution

```python
class Solution:
    def triangleType(self, nums: List[int]) -> str:
        nums.sort()
        # Triangle inequality check (only need smallest two vs largest)
        if nums[0] + nums[1] <= nums[2]:
            return "none"
        if nums[0] == nums[1] == nums[2]:
            return "equilateral"
        if nums[0] == nums[1] or nums[1] == nums[2]:
            return "isosceles"
        return "scalene"
```

### Walkthrough On `[3, 4, 15]`

- Sorted: `[3, 4, 15]`
- `3 + 4 = 7`, `7 <= 15` → return `"none"` ✓

### Walkthrough On `[3, 3, 5]`

- Sorted: `[3, 3, 5]`
- `3 + 3 = 6 > 5` → is a triangle
- Not all three equal → not equilateral
- `nums[0] == nums[1]` → return `"isosceles"` ✓

---

## Russell's Naming Tip

> "Trying to work directly with `nums[0]` vs `nums[1]` is hard for my brain to visualize. As soon as I write six of those on a line I lose it. Even though it's an extra step, I assign them to their own named variables so I can compare `a` and `b` and `c` rather than `nums[0]` and `nums[1]` and `nums[2]`."

```python
a, b, c = sorted(nums)  # Python tuple unpacking after sort
```

The coach endorsed this strongly:

> "Variable names are very important. When you confidently know there are only going to be three every time, `a`, `b`, `c` or `side1`, `side2`, `side3` make the code far more readable."

---

## Coach Feedback: Don't Jump To Code Before Understanding All Conditions

> "Jumping ahead to say 'oh, I know how I'd solve part one of three, but I don't know the full three-part process yet' — that's shortcutting your progress. Understand all the conditions upfront so you can code with them in mind, instead of hitting obstacles and going backwards."

### The Value of Re-Reading Confusing Sections

> "It's fine to read something for the first time and think 'I don't know what this means.' But once you understand the rest of the problem, go back and try to make sense of the piece you didn't understand. Why are they telling you this? Why does it matter? That's when you see 'oh, there's a none option — is that going to help me determine it?'"

---

## Method: Enumerate Return Values First

Russell summarized the key realization:

> "There are four possible returns. What test do we need to do to return each one? And potentially, what order do we test them in so we can eliminate cases?"

### Coach's Recommended Opening

1. Print `nums` (confirm your parameters match the test cases).
2. Identify the return type — here, a string.
3. List the possible return values — `equilateral`, `isosceles`, `scalene`, `none`.
4. Under what conditions does each apply?
5. In what order should the checks happen to eliminate efficiently?
6. Only then start writing logic.

---

## Takeaways

- **Enumerate all possible return values** at the top of your pseudo code before coding any logic.
- **Triangle inequality:** `a + b > c` for **all** combinations — but sorting reduces it to **one** check.
- **`sum(iterable)`** takes an iterable, not individual numbers. Use `a + b` instead for two-number sums.
- **`nums.sort()`** and tuple unpacking `a, b, c = sorted(nums)` simplify readability.
- **Named variables beat indexed access** for small fixed-size arrays.
- **Re-read confusing sections** of the problem after you understand the rest.
- **"None" as a fourth return condition** is easy to miss on the first read — scan for it explicitly.
