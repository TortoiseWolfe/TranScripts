# Ruby Solutions Deep Dive — January 7, 2026
Source: https://youtu.be/pitBLw8iuyo

Group walkthrough of **Plus One** (LeetCode Easy) with the coach as mock interviewer and participants contributing approaches. Emphasis on verbalizing during problem analysis and handling edge cases with trailing 9s.

---

## [3:29](https://youtu.be/pitBLw8iuyo?t=209) Q&A: When Can You Stay Silent At The Start?

A participant asked about the pressure to start talking immediately during an interview.

> "There's never too soon, but there is a little bit of a too late. If you start talking when you've already figured out the problem and say 'here's what I'm going to do,' you might pass all the test cases, but I don't have a good understanding of your process — how you're thinking through problems, breaking them down, asking and answering questions, getting stuck, moving past obstacles."

### [5:18](https://youtu.be/pitBLw8iuyo?t=318) The Advice

> "Be afraid, be scared, and then do it anyway. Talk yourself out of it. Mumble to yourself. Write it down and then read what you wrote aloud. A third of the process is trying to understand the problem — I want to hear that."

> "If we get to the end of 20 minutes and you haven't said anything I can latch onto, I can't coach you on how to improve."

---

## [8:51](https://youtu.be/pitBLw8iuyo?t=531) Q&A: Getting Back Into It After A Long Pause

> "Review problems you've worked on before. Clear out your code right away — you'll be familiar enough to have a vague recollection. Focus on rebuilding your routine: how do I break the problem into steps? How do I get pseudo code down? How do I start writing code? Focus on the process piece, not the solving piece."

---

## [12:04](https://youtu.be/pitBLw8iuyo?t=724) Problem: Plus One

> You are given a large integer represented as an integer array `digits`, where each `digits[i]` is the `i`-th digit of the integer. The digits are ordered from most significant to least significant in left-to-right order. Increment the large integer by one and return the resulting array of digits.

### [12:27](https://youtu.be/pitBLw8iuyo?t=747) [approx] Examples

- `[1, 2, 3]` → `[1, 2, 4]`
- `[4, 3, 2, 1]` → `[4, 3, 2, 2]`
- `[9]` → `[1, 0]`

### [15:34](https://youtu.be/pitBLw8iuyo?t=934) [approx] Constraints

- `1 <= digits.length <= 100`
- `0 <= digits[i] <= 9`
- No leading zeros.

---

## [19:23](https://youtu.be/pitBLw8iuyo?t=1163) Approach 1: Last Index + 1 (Fails On 9)

Linda proposed: just grab the last index, add 1, return. Works for most cases. Fails when the last digit is 9 because you'd get `[1, 2, 3, 10]`, not `[1, 2, 4, 0]`.

---

## [21:48](https://youtu.be/pitBLw8iuyo?t=1308) [approx] Approach 2: Convert To Int, Add, Convert Back

Coach sketched a cleaner alternative:

```python
def plusOne(digits):
    num = int("".join(str(d) for d in digits)) + 1
    return [int(d) for d in str(num)]
```

- **Join** digits into a string, convert to int, add 1, convert back, split into a list of ints.
- Avoids the carry-propagation mess entirely.

---

## [16:20](https://youtu.be/pitBLw8iuyo?t=980) Approach 3: Reverse For Loop + Carry Propagation (Chosen)

The group chose to implement the carry-propagation approach because it exercises more Python concepts.

### [19:21](https://youtu.be/pitBLw8iuyo?t=1161) The `range` Function For Reverse Iteration

```python
for i in range(len(digits) - 1, -1, -1):
    # i goes from last index down to 0
```

- **Start:** `len(digits) - 1` (the last valid index)
- **Stop:** `-1` (exclusive — iterates down through 0)
- **Step:** `-1` (decrement)

> "When reversing, you actually have to include all three parameters. The normal shorthand only works when you accept the defaults of start=0 and step=1."

### [52:04](https://youtu.be/pitBLw8iuyo?t=3124) Side Note: `range` Requires Integers, Not Collections

- `for i in range(len(digits))` → iterates indexes (0, 1, 2…)
- `for digit in digits` → iterates values directly
- You need indexes here because you're modifying the array in place.

### [34:16](https://youtu.be/pitBLw8iuyo?t=2056) [approx] Initial Carry Logic

```python
def plusOne(digits):
    for i in range(len(digits) - 1, -1, -1):
        if digits[i] != 9:
            digits[i] += 1
            return digits
        else:
            digits[i] = 0
    return digits
```

Walks through `[1, 2, 9]`:
- `i = 2`, value is 9 → set to 0, keep going
- `i = 1`, value is 2 → add 1, become 3, return `[1, 3, 0]`

### [37:23](https://youtu.be/pitBLw8iuyo?t=2243) [approx] Edge Case: All 9s

`[9, 9, 9]`:
- `i = 2`, 9 → 0
- `i = 1`, 9 → 0
- `i = 0`, 9 → 0
- Loop ends with `[0, 0, 0]` — **wrong**. The expected output is `[1, 0, 0, 0]`.

### [7:08](https://youtu.be/pitBLw8iuyo?t=428) The Fix: Insert A Leading 1

If we fall through the whole loop without returning, it means every digit was 9 and we need to prepend a 1:

```python
def plusOne(digits):
    for i in range(len(digits) - 1, -1, -1):
        if digits[i] != 9:
            digits[i] += 1
            return digits
        else:
            digits[i] = 0
    digits.insert(0, 1)
    return digits
```

### [52:10](https://youtu.be/pitBLw8iuyo?t=3130) `list.insert(index, value)`

- Inserts `value` at `index`, shifting everything else right.
- `digits.insert(0, 1)` prepends a 1 to the front.
- Official Python docs say this is **O(n)** because of the shifting.

---

## [1:02:16](https://youtu.be/pitBLw8iuyo?t=3736) Big O Analysis

- **For loop:** O(n)
- **If/else inside loop:** O(1) per iteration
- **`insert(0, 1)`** at the end: O(n)
- **Total:** O(n) + O(n) = **O(n)**

### [4:47](https://youtu.be/pitBLw8iuyo?t=287) Performance Result

Passed all 112 test cases at 0ms runtime. Memory usage was higher than expected — likely due to the `insert` at the front requiring internal array reallocation.

---

## [58:24](https://youtu.be/pitBLw8iuyo?t=3504) The Math Parallel

> "This is how I learned addition. `1 2 9 9 9 + 1`: 9 + 1 = 10, put zero, carry the 1. 9 + 1 = 0, carry the 1. Etc. That's exactly what the formula does: if it's not a 9, add 1 and done. If it is a 9, set to 0 and carry to the next index."

The `insert(0, 1)` at the end is the "carry out of the top" case — when the carry needs a new digit because the number grew in length.

---

## [56:05](https://youtu.be/pitBLw8iuyo?t=3365) [approx] Approach Comparison

| Approach | Time | Space | Complexity |
|---|---|---|---|
| Last index + handle 9 (incomplete) | O(1) avg | O(1) | Edge cases get ugly |
| int ↔ list conversion | O(n) | O(n) | Very clean, uses language features |
| Reverse loop + carry + insert | O(n) | O(1) in-place | Explicit, teaches array indexing |

---

## [4:15](https://youtu.be/pitBLw8iuyo?t=255) Session Takeaways

- **Verbalize even when you don't fully understand the problem yet.** That's the phase the coach wants to hear the most.
- **`range(start, stop, step)` with negative step** for reverse iteration in Python.
- **Always include the edge cases as your own test cases** — `[9, 9, 9]` would have been skipped without Rebecca bringing it up.
- **Pen and paper is fine mid-interview.** Return to it when your approach breaks on a new edge case.
- **`list.insert(0, x)` is O(n)**, not O(1), because it shifts every subsequent element.
- **Carry propagation** translates directly from pencil-and-paper addition to code.
- **Googling "how to add an index to the front of a list"** is an acceptable interview lookup because it's specific syntax, not a full solution.
