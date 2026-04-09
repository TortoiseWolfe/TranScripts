# Ruby Solutions Deep Dive — February 25, 2026
Source: https://youtu.be/qzo0MHuLHlU

Coach Ruby does her own mock interview on **Number of Changing Keys**, then Lisa takes a mock on **Sum Multiples**. Lesson: test your core assumption (the math operator) **before** building logic around it.

---

## [2:37](https://youtu.be/qzo0MHuLHlU?t=157) Coach's Self Mock: Number of Changing Keys

### [2:37](https://youtu.be/qzo0MHuLHlU?t=157) Problem

> You are given a 0-indexed string `s` typed by a user. Changing a key is defined as using a key different from the last used key. `s = "ab"` has a key change; `s = "bB"` does not (shift/caps lock are ignored). Return the number of times the user had to change the key.

### [4:28](https://youtu.be/qzo0MHuLHlU?t=268) [approx] Examples

- `"aAbBcC"` → `2` (`a→b` and `b→c`)
- `"AaAaAaaA"` → `0`

### [13:50](https://youtu.be/qzo0MHuLHlU?t=830) Constraints

- `1 <= s.length <= 100`

---

## [8:56](https://youtu.be/qzo0MHuLHlU?t=536) [approx] Coach's Approach

### [11:11](https://youtu.be/qzo0MHuLHlU?t=671) [approx] Assumption Test First

Before writing any logic, she verified in the console that:
- `'a' == 'A'` → **False**
- `'A' == 'A'` → **True**

So case matters for Python string equality. Need to normalize first.

### [13:25](https://youtu.be/qzo0MHuLHlU?t=805) [approx] Normalization With `str.lower()`

```python
>>> "aAbBcC".lower()
"aabbcc"
>>> original = "aAbBcC"
>>> original.lower()
"aabbcc"
>>> original
"aAbBcC"  # unchanged - lower() returns a new string
```

`str.lower()` does **not mutate** the original. It returns a new lowercase string. Assign the result to a variable.

---

## [15:39](https://youtu.be/qzo0MHuLHlU?t=939) [approx] The Solution

```python
class Solution:
    def countKeyChanges(self, s: str) -> int:
        s_lower = s.lower()
        count = 0
        for i in range(1, len(s_lower)):
            if s_lower[i] != s_lower[i - 1]:
                count += 1
        return count
```

### [23:11](https://youtu.be/qzo0MHuLHlU?t=1391) Key Details

- **Normalize first** — `s.lower()` converts the whole string once.
- **Start the loop at index 1** — you need a previous character to compare against.
- **Compare `s_lower[i]` to `s_lower[i - 1]`** — increment count on mismatch.
- **No special edge-case handling** — constraints guarantee `len >= 1`, and the loop naturally handles length-1 strings (no iterations, returns 0).

### [16:26](https://youtu.be/qzo0MHuLHlU?t=986) Self-Reflection

> "16 minutes on an easy problem — not my personal best. I did a lot of chattering at the beginning. No weird edge cases. Memory usage was high probably because of storing a second lowered string and the count. I'd be curious what other approaches avoided allocating the new string."

### [22:22](https://youtu.be/qzo0MHuLHlU?t=1342) [approx] Alternative: In-Place Comparison Without Lowering

```python
def countKeyChanges(self, s):
    count = 0
    for i in range(1, len(s)):
        if s[i].lower() != s[i - 1].lower():
            count += 1
    return count
```

This avoids allocating a full-length copy by lowering just one character at a time per comparison. Slightly more CPU work, less memory.

---

## [20:56](https://youtu.be/qzo0MHuLHlU?t=1256) Mock Interview: Sum Multiples (Lisa)

### [20:56](https://youtu.be/qzo0MHuLHlU?t=1256) Problem

> Given a positive integer `n`, find the sum of all integers in the range `[1, n]` inclusive that are divisible by `3`, `5`, or `7`. Return that sum.

### [29:05](https://youtu.be/qzo0MHuLHlU?t=1745) [approx] Example

- `n = 7` → `3 + 5 + 6 + 7 = 21`

---

## [13:48](https://youtu.be/qzo0MHuLHlU?t=828) Lisa's Approach

Standard accumulator with a for loop over `range(1, n + 1)`:

```python
def sumOfMultiples(n):
    total = 0
    for i in range(1, n + 1):
        if divisible_by_3_5_or_7(i):
            total += i
    return total
```

### [26:43](https://youtu.be/qzo0MHuLHlU?t=1603) The Bug: Wrong Division Operator

Lisa initially wrote her divisibility check as:

```python
if i // 3 == 0:  # BUG: `//` is integer division, not modulo
```

`//` is **floor division** (returns the integer part of the quotient). For divisibility, you need `%` (modulo), which returns the **remainder**.

| Expression | Meaning | `3 // 3` | `3 % 3` |
|---|---|---|---|
| `//` | integer quotient | `1` | - |
| `%` | remainder | - | `0` |

### [45:27](https://youtu.be/qzo0MHuLHlU?t=2727) Testing Exposed The Bug

Lisa added print statements inside the loop and noticed `total` was updating on iteration `i = 1`, which shouldn't happen if the check were correct. `1 // 3 == 0` is True (integer quotient of 1/3 is 0), triggering the false positive.

### [38:01](https://youtu.be/qzo0MHuLHlU?t=2281) [approx] The Fix

```python
if i % 3 == 0 or i % 5 == 0 or i % 7 == 0:
    total += i
```

- `%` returns the remainder.
- If the remainder is 0, `i` is evenly divisible.
- Chain with `or` for the three divisors.

### [40:16](https://youtu.be/qzo0MHuLHlU?t=2416) [approx] Correct Final Solution

```python
class Solution:
    def sumOfMultiples(self, n: int) -> int:
        total = 0
        for i in range(1, n + 1):
            if i % 3 == 0 or i % 5 == 0 or i % 7 == 0:
                total += i
        return total
```

---

## [49:14](https://youtu.be/qzo0MHuLHlU?t=2954) Coach Feedback: Test The Math Before Building Around It

> "You did a great job breaking down the problem — understood what was required, the expected output, the general approach was right. But your basic assumption about the math piece needed more testing. I would have liked to see you test that `i // 3 == 0` logic against a few quick integers like 6 and 15 upfront to make sure it applied across the board."

### [46:46](https://youtu.be/qzo0MHuLHlU?t=2806) Consequence Of Not Testing

Lisa built lots of scaffolding around the broken divisibility check — extra `if n > 2` conditions, guards, special cases — trying to paper over the real problem.

> "There was a lot of little pieces there that maybe we could have skipped. Once we switched to modulus, pretty much everything worked out from there."

---

## [46:58](https://youtu.be/qzo0MHuLHlU?t=2818) [approx] The Lesson: Test Your Core Operator First

Whenever your solution hinges on a single arithmetic or logical operator, **verify the operator does what you expect** with a tiny test case before building the rest of the solution:

```python
print(3 % 3)  # should be 0
print(5 % 3)  # should be 2
print(6 % 3)  # should be 0
```

30 seconds of verification saves minutes of confused debugging.

---

## [9:36](https://youtu.be/qzo0MHuLHlU?t=576) Takeaways

- **`str.lower()` returns a new string** — assign to a variable; doesn't mutate.
- **Start index-based loops at 1** when you need a "previous" reference.
- **`%` is modulo, `//` is floor division** — don't confuse them for divisibility checks.
- **Test your core operator with known values** before building logic around it.
- **`i % k == 0`** is the canonical divisibility-by-`k` test.
- **Normalization (like `lower()`) upfront** is often simpler than per-comparison handling, but costs memory.
