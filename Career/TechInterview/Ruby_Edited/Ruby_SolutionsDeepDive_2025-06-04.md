# Solutions Deep Dive — Birthday Cake Candles & Container With Most Water (2025-06-04)
Source: https://youtu.be/qCssyZzmhu8

Wednesday session: solutions and alternative approaches for Sunday's two problems. Schedule reminder: Sundays = Q&A + pseudo code + mock interview; Wednesdays = solution deep dives.

---

## [39:05](https://youtu.be/qCssyZzmhu8?t=2345) Q&A

### [39:05](https://youtu.be/qCssyZzmhu8?t=2345) What if you can't finish a tech interview problem in time?

Outcomes vary by company. Many people don't finish all problems and still advance. Interviewers value:

- Confidence speaking out loud and presenting your thought process.
- Ability to break the problem into steps and communicate them.
- Understanding what the problem is asking, even without mastering the execution.

This is also why Big-O comes up in these sessions — being able to explain concepts at that level helps determine eligibility to move forward.

---

## [9:02](https://youtu.be/qCssyZzmhu8?t=542) [approx] Problem 1: Birthday Cake Candles (easy) — solution

**Two-step solution:**

1. Find the **max** value in the candles array → `max(candles)` is O(n).
2. **Count** occurrences of that max → `candles.count(candle_max)` is O(n).

```python
candle_max = max(candles)
return candles.count(candle_max)
```

### [6:23](https://youtu.be/qCssyZzmhu8?t=383) Big-O note

Two separate O(n) operations = O(2n), which simplifies to **O(n)**. Constants are dropped in Big-O. You *could* combine into a single pass for one O(n), but two passes is fine — clarity beats marginal efficiency on an easy problem.

### [18:05](https://youtu.be/qCssyZzmhu8?t=1085) [approx] Bonus question: how to find the second max?

- Two-variable approach: track `max` and `second_max`, single pass.
- Or sort the array and take the second-from-last position.

> Note: `max - 1` doesn't work — second-highest may be far below the max (e.g., max 13, second max 5).

---

## [33:56](https://youtu.be/qCssyZzmhu8?t=2036) Problem 2: Container With Most Water (medium) — brute force solution

**Approach:** nested loop, calculate area for every pair `(i, j)`, track the max.

### [27:08](https://youtu.be/qCssyZzmhu8?t=1628) [approx] Setup

- `n = len(height)`
- Outer loop: `for i in range(n)`
- Inner loop: `for j in range(i+1, n)` — second pointer always after the first to avoid duplicate pairs.
- For each pair, calculate area and update the running max.

### [33:16](https://youtu.be/qCssyZzmhu8?t=1996) Calculating the area

- **Container length** = `j - i` (distance between the two indices on the x-axis).
- **Container height** = `min(height[i], height[j])` — must use the **shorter** of the two walls because water can't slant.
- **Container area** = `length × height`.

> Common bug: writing `j - 1` instead of `j - i` for the length. Test cases may *appear* to pass while still being wrong — print and verify each intermediate value.

### [50:06](https://youtu.be/qCssyZzmhu8?t=3006) Updating the max

```python
water_area = container_area if container_area > water_area else water_area
```

### [55:39](https://youtu.be/qCssyZzmhu8?t=3339) Result

- Brute force gets **55/65 test cases passing** before hitting the time limit.
- That's confirmation the logic is correct — just too slow.
- Big-O = **O(n²)** because of the nested loops.

### [45:14](https://youtu.be/qCssyZzmhu8?t=2714) [approx] Iterative testing discipline

Print at every intermediate step:

- The `i` and `i, height[i]` pair.
- The `i, j` pairs being generated.
- The `container_length` and `container_height`.
- The `container_area`.

If you only print the final area and there's a bug upstream, debugging is much harder. The coach skipped printing length/height in this walkthrough and the `j - 1` bug went unnoticed for several minutes.

---

## [32:27](https://youtu.be/qCssyZzmhu8?t=1947) Problem 2: Optimized — Two-Pointer Approach

Brute force is O(n²). The optimal solution is **O(n)** using **two pointers**.

### [58:39](https://youtu.be/qCssyZzmhu8?t=3519) When to consider two pointers

- You see an O(n²) brute force using two nested loops.
- The data has some monotonic property (here: max area must use the **tallest** lines, so smaller heights can be discarded as you scan).
- Two pointers is **not** a universal replacement for nested loops — it depends on whether the problem has a structure that lets one pointer move at a time.

### [58:48](https://youtu.be/qCssyZzmhu8?t=3528) [approx] Setup

- `i = 0`, `j = len(height) - 1`
- Loop: `while i < j`
- One pointer moves per iteration, not both.

### [26:32](https://youtu.be/qCssyZzmhu8?t=1592) The condition that decides which pointer moves

Move whichever pointer is at the **shorter** vertical line. The shorter wall is what's limiting the area, so discarding it (and hoping for a taller one) is the only way to find a larger area.

```python
if height[i] < height[j]:
    i += 1
else:
    j -= 1
```

### [1:09:56](https://youtu.be/qCssyZzmhu8?t=4196) Why this works

- The container area is bounded by the shorter wall.
- Moving the taller pointer can only ever reduce the length while keeping the height bound the same → can't improve.
- Moving the shorter pointer is the only move that has a chance of finding a taller wall and increasing the area.

### [0:44](https://youtu.be/qCssyZzmhu8?t=44) Verification advice

> Don't copy/paste solution code from LeetCode. Read through it, understand the approach, then close the tab and reimplement from scratch. Only look at solutions after you've gotten **at least two-thirds of the test cases passing** with brute force — that proves you understand the problem.

---

## [35:45](https://youtu.be/qCssyZzmhu8?t=2145) General Lessons

- **Brute force first.** Even if you know the optimized solution, write the brute force to confirm understanding and unlock test cases.
- **Print everything as you go.** Errors can be subtle and look correct at one layer while breaking another.
- **Two-thirds passing = move on.** Once brute force gets you most of the test cases, you've demonstrated understanding. Then optimize or look at solutions.
- LeetCode has an **Analyze Complexity** button that uses AI to estimate Big-O — limited daily uses but useful as a sanity check.

[REVIEW: brief moment where coach noted printing both index and value side-by-side caused confusion for one participant; mostly a UI/zoom issue — kept the lesson about printing both for context.]
