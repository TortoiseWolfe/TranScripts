# Mock Interview — Missing Numbers (2025-06-29)
Source: https://youtu.be/g7CrcFvipMs

Sunday session: pseudo code walkthrough of HackerRank's Missing Numbers problem. No volunteer mock interview today — discussion ran long.

---

## [3:09](https://youtu.be/g7CrcFvipMs?t=189) Problem: Missing Numbers

Given two arrays of integers, find which elements in the **second** (longer/original) array are missing from the **first** (shortened) array.

### [3:11](https://youtu.be/g7CrcFvipMs?t=191) [approx] Examples

- `arr = [7,2,5,3,5,3]`, `brr = [7,2,5,4,6,3,5,3]` → missing `[4, 6]`.
- Frequency matters: if `3` appears twice in `brr` and once in `arr`, then `3` is missing.
- But only include each missing number **once** even if its frequency difference is more than one.

### [10:32](https://youtu.be/g7CrcFvipMs?t=632) Constraints worth noting

- `n ≤ m` — the shortened array is always at most as long as the original.
- The difference between max and min values in the original list is ≤ 100. *(Hint at an O(1)-space frequency-array approach using offset indexing.)*
- Return must be a **sorted array**.

---

## [4:53](https://youtu.be/g7CrcFvipMs?t=293) Pulling Statements From the Problem

- Given two lists, find missing numbers from the smaller (`arr`).
- Frequency of a number matters — could count as missing.
- If a number occurs multiple times, only include it as missing **once**.
- Return a sorted array of missing numbers.

### [12:38](https://youtu.be/g7CrcFvipMs?t=758) Assumptions to test

- **Same length implies identical arrays / no missing numbers** — possibly false. Could be all `[203, 203, ...]` vs `[201, 202, 203, ...]` of the same length. Worth verifying with test cases.
- **Both arrays will be in the same general sort order** — not stated explicitly. If true, you can do an index-by-index walk. If false, you need a more complicated search per element.

---

## [15:57](https://youtu.be/g7CrcFvipMs?t=957) [approx] Approach: Index-Walk (assumes sorted order)

```python
tracking = []
offset = 0
for i in range(len(brr)):
    if brr[i] != arr[i - offset]:
        tracking.append(brr[i])
        offset += 1
return sorted(tracking)
```

### [19:08](https://youtu.be/g7CrcFvipMs?t=1148) [approx] How it works

- Walk `brr` (the longer original) one element at a time.
- Compare against the corresponding index in `arr` (the shortened), with an **offset** to skip past missing values.
- When `brr[i]` doesn't match `arr[i - offset]`, that's a missing number — append it to `tracking` and bump the offset.
- Sort the result before returning.

### [24:39](https://youtu.be/g7CrcFvipMs?t=1479) Why offset?

When you find a missing number, the indices in `arr` don't advance — but `brr` does. The offset keeps the comparison aligned.

### [20:11](https://youtu.be/g7CrcFvipMs?t=1211) If the assumption is wrong

If the arrays aren't sorted, you'd need to search the entire `arr` for each `brr` element, bumping complexity from **O(n)** to **O(n²)**.

> Working with assumptions: list them explicitly at the top of your pseudo code so you know which ones to revisit if the approach breaks.

---

## [52:54](https://youtu.be/g7CrcFvipMs?t=3174) Translating Pseudo Code Into Real Code

A common stuck point: "I have an idea, but I don't know how to convert it into Python syntax."

### [10:25](https://youtu.be/g7CrcFvipMs?t=625) Coach's advice

- Write your pseudo code as **discrete steps** (initialize array, loop, conditional, append).
- For each step, ask: "What's the syntax I need? Do I know it, or do I need to look it up?"
- **Looking up syntax is fair game** in tech interviews — Google `Python range` to confirm parameters; that's not cheating.
- What's **not** OK: looking up "how to solve missing numbers in Python" or pasting a full or partial solution.

### [35:05](https://youtu.be/g7CrcFvipMs?t=2105) [approx] Python `range()` recap

- `range(stop)` → 0 to stop-1, increment by 1.
- `range(start, stop)` → start to stop-1.
- `range(start, stop, step)` → custom increment.
- Returns an iterable sequence; commonly used in `for i in range(...)`.

---

## [45:35](https://youtu.be/g7CrcFvipMs?t=2735) Iterative Testing

After writing each step, **run it and print intermediate values** before adding the next step:

```python
for i in range(len(brr)):
    print(i, brr[i])
```

This catches off-by-one errors and assumption failures one step at a time. If you write all the code at once and then run it, you have to debug from scratch.

---

## [43:28](https://youtu.be/g7CrcFvipMs?t=2608) Q&A: How to Track Time During Practice

Question: "I have trouble realizing where I am within the time limit. How should I keep an eye on time while practicing?"

### [44:06](https://youtu.be/g7CrcFvipMs?t=2646) Coach's answer

- **Don't race the clock** while practicing. Take the time you need to do each step properly.
- Use a stopwatch (count-up) to **measure** how long it took, then look at the result. Don't pre-set a 20-minute deadline that pressures you.
- Over time, your speed naturally improves by doing the steps correctly.
- Once you're consistently under 20 minutes, **then** start using a countdown timer to simulate the real interview pressure.
- There's no single "correct" time split between pseudo code and coding. Some people take 3 minutes on pseudo code and 10 on code. Others take 10 on pseudo code and 2 on code. Both work.

### [47:11](https://youtu.be/g7CrcFvipMs?t=2831) Tools

- Built-in stopwatch/timer apps on Windows or your phone.
- Keep the timer visible on screen if it helps, but don't let it distract from the work.

---

## [51:02](https://youtu.be/g7CrcFvipMs?t=3062) [approx] Time Window Goal

- **Target:** 15–20 minutes per easy problem.
- **For practice:** start with 20-minute targets, then tighten as you get faster.
- **Joy of Coding interview:** 20 minutes for one easy HackerRank problem.

[REVIEW: extended discussion about Spanish keyboard quirks and missing `#` / `{}` keys — kept as context for why the coach paused mid-coding multiple times.]
