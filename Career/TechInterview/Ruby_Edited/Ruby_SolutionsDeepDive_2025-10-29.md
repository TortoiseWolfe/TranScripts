# Ruby Solutions Deep Dive — October 29, 2025
Source: https://youtu.be/EAs0tnJhPVA

Deep dive on **Minimum Time to Make Rope Colorful** (the "balloons" problem) with two presented approaches, plus a follow-up on reverse-engineering Python's string methods `find`, `count`, and `replace`.

---

## [1:20](https://youtu.be/EAs0tnJhPVA?t=80) Problem: Minimum Time to Make Rope Colorful

You are given an array `colors` where each element is a letter representing a balloon's color, and a parallel array `neededTime` where each element is the seconds required to remove the balloon at that index. Remove the **minimum total time** worth of balloons such that no two adjacent balloons share a color.

### [2:22](https://youtu.be/EAs0tnJhPVA?t=142) Constraints

- `len(colors) == len(neededTime)` (one-to-one correspondence)
- `1 <= len(colors) <= 10^5`
- `1 <= neededTime[i] <= 10^4`
- From every consecutive run of same-colored balloons, you must keep exactly one — the **most expensive** one (because removing it would waste time).

---

## [4:21](https://youtu.be/EAs0tnJhPVA?t=261) Mauricio's First Approach — Nested Loops (Brute Force)

Identify each **sub-array of consecutive same-colored balloons**, sum the time for that group, subtract the maximum (the balloon we keep), and accumulate the cost.

```python
def minCost(colors, neededTime):
    n = len(colors)
    total = 0
    i = 0
    while i < n - 1:
        first = i
        last = i
        while last < n - 1 and colors[last] == colors[last + 1]:
            last += 1
        if first != last:
            group = neededTime[first:last + 1]
            total += sum(group) - max(group)
        i = last + 1
    return total
```

- **Outer loop** scans to `n - 1` because we always need a `next` to compare against.
- **Inner loop** advances while the current balloon matches the next.
- Slice is `first:last + 1` because Python slicing is **exclusive** on the upper bound.
- **Cost for a group** = `sum(group) - max(group)` — we keep the single most expensive balloon.

---

## [20:02](https://youtu.be/EAs0tnJhPVA?t=1202) Mauricio's Refined Approach — Single Loop, O(n)

Rather than identifying groups, iterate once and on every match with the previous balloon, add the **minimum** of the two times to the total, then store the **running maximum** back into `neededTime[i]` so the next iteration compares against the right value.

```python
def minCost(colors, neededTime):
    total = 0
    for i in range(1, len(colors)):
        if colors[i] == colors[i - 1]:
            total += min(neededTime[i], neededTime[i - 1])
            neededTime[i] = max(neededTime[i], neededTime[i - 1])
    return total
```

### [7:26](https://youtu.be/EAs0tnJhPVA?t=446) Why Update `neededTime[i]` In Place?

> "As I go through the array, I'm keeping one position before — `i - 1` — always holding the current maximum. So I always get the min against the maximum, because ultimately I'm going to leave the maximum there. This line ensures the next iteration has the correct running maximum at `i - 1`."

- **Time:** O(n) — one pass.
- **Space:** O(1) extra — mutates `neededTime` in place.

---

## [47:47](https://youtu.be/EAs0tnJhPVA?t=2867) Coach's Parallel Approach — External Tracking Variables

The coach wrote a similar one-pass solution but used **external variables** instead of mutating `neededTime`:

- `last_color` — the color of the most recent balloon we've "kept"
- `last_index` — its index (so we can look up its time in `neededTime`)
- An `if/else` block to update the tracked variables whether or not a match happened

```python
def minCost(colors, neededTime):
    total = 0
    last_color = colors[0]
    last_index = 0
    for i in range(1, len(colors)):
        if colors[i] == last_color:
            if neededTime[i] > neededTime[last_index]:
                total += neededTime[last_index]
                last_index = i
            else:
                total += neededTime[i]
        else:
            last_color = colors[i]
            last_index = i
    return total
```

### [26:57](https://youtu.be/EAs0tnJhPVA?t=1617) [approx] Trade-off Comparison

| | Mauricio's refined | Coach's variables |
|---|---|---|
| Extra variables | 0 | 2 (`last_color`, `last_index`) |
| Mutates input | Yes (`neededTime[i]`) | No |
| Conditional branches | 1 | 2 (with else) |
| Lines of code | Fewer | More |

> "From an efficiency standpoint, I like Mauricio's more. For simplicity's sake, I like his more. Mine was easier to implement on the first try just thinking about it, but his makes more sense."

---

## [25:24](https://youtu.be/EAs0tnJhPVA?t=1524) Whiteboarding Worked Example

Colors: `blue, blue, blue, red, green, green`
Times:  `1, 3, 2, 1, 2, 1`

- First blue group sum = 6, max = 3 → remove 3 seconds worth (the 1 and the 2), keep the 3.
- Green group sum = 3, max = 2 → remove 1, keep the 2.
- **Total cost = 3 + 1 = 4 seconds.**

> "Do a trace manually with pen and paper, updating the variables and the arrays. Then you realize how it works. That's the best way to understand somebody else's algorithm."

---

## [42:03](https://youtu.be/EAs0tnJhPVA?t=2523) Is This Really "Medium"?

> "I'd say this is on the lower end of the medium problems. I've seen easy-ranked problems harder to conceptualize than this one. The diagram is clear and the steps are straightforward."

---

## [44:20](https://youtu.be/EAs0tnJhPVA?t=2660) Follow-up Challenge: Reverse-Engineer `count` and `replace`

Revisiting the earlier **Find the Index of the First Occurrence** session where the solution collapsed to a one-liner `haystack.find(needle)`. The challenge was to implement `find` from scratch with a for loop:

```python
def find(haystack, needle):
    for i in range(len(haystack) - len(needle) + 1):
        if haystack[i] == needle[0]:
            if haystack[i:i + len(needle)] == needle:
                return i
    return -1
```

### [47:58](https://youtu.be/EAs0tnJhPVA?t=2878) New Challenges

1. **`str.count(substring)`** — return the number of non-overlapping occurrences of `substring` in the string.
2. **`str.replace(old, new)`** — return a new string where all occurrences of `old` are replaced with `new`.

Both should be implemented **without calling the library method**, to exercise the same from-scratch muscle.

### [52:54](https://youtu.be/EAs0tnJhPVA?t=3174) Use in a Real Interview?

> "You are allowed to use `find` or `count` in the tech interview. It's just rare that a single method solves the whole problem outright. Usually it's part of a larger solution."

### [1:33](https://youtu.be/EAs0tnJhPVA?t=93) Pseudo Code Sketch for `count`

Iterate through the larger string; at each position, check whether the substring starting there matches the target. Increment a counter on match.

```
counter = 0
for i in range(len(text) - len(target) + 1):
    if text[i:i + len(target)] == target:
        counter += 1
return counter
```

---

## [1:01:13](https://youtu.be/EAs0tnJhPVA?t=3673) Session Meta: Sunday vs Wednesday Format

- **Sundays:** new problem introduced, optional mock interview.
- **Wednesdays:** review of the mock interview and/or Sunday's problem.

---

## [52:29](https://youtu.be/EAs0tnJhPVA?t=3149) Stage Fright & Presenting

A participant (Rebecca) committed to presenting her `count`/`replace` code next session despite stage fright.

> "That's a great way to practice. The idea that someone watches you while you do this — whether you look stupid or not — it's a rehearsal for the tech interview."

### [1:04:14](https://youtu.be/EAs0tnJhPVA?t=3854) W3 Schools Gotcha

> "W3 Schools' indentation checking for Python is really strict and annoying. If you're getting a lot of errors, tab everything back to the left and re-indent. Sometimes the exact same code will work on a second attempt."
