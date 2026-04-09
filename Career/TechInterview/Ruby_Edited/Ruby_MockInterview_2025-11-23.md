# Ruby Mock Interview — November 23, 2025
Source: https://youtu.be/lav3CnpwqtM

*Nailing the Tech Interview — Last Sunday session*

## Session Format Change

This is the **last Sunday session**. Moving forward, only the **Wednesday sessions** will continue, keeping the same mock-interview-and-practice format.

---

## Linda's Walkthrough: Assign Cookies

Linda volunteered to walk through a problem she'd already solved (**LeetCode Assign Cookies**) as a self-directed warm-up. Ruby agreed this counts as a valid mock interview — it tests communication, explaining logic, and debugging under observation.

### Problem statement

Assume you're a parent giving cookies to children. Each child has a **greed factor `g[i]`** (minimum cookie size they'll accept). Each cookie has a **size `s[j]`**. You can give each child at most one cookie. If `s[j] >= g[i]`, child `i` is content. **Return the maximum number of content children.**

### Examples

```
g = [1, 2, 3],   s = [1, 1]     -> 1
g = [1, 2],      s = [1, 2, 3]  -> 2
```

### Linda's approach: two pointers + greedy

1. Sort both arrays.
2. Initialize pointers `i` (kid) and `j` (cookie) to 0.
3. Walk through both arrays simultaneously. If the current cookie satisfies the current kid, advance both pointers. Otherwise, advance the cookie pointer only.
4. Return the kid pointer at the end (it equals the number of content children).

```python
def findContentChildren(g, s):
    g.sort()
    s.sort()
    i = 0   # kid pointer
    j = 0   # cookie pointer
    while i < len(g) and j < len(s):
        if s[j] >= g[i]:
            i += 1   # child is content, move to next child
        j += 1       # always advance cookie pointer
    return i
```

### The bug Linda hit

She was initially writing `return 1` (hardcoded) and couldn't understand why case 2 (expected output 2) was failing. She was also confused why running the code with the stray `1` still passed case 1 — because the expected output for case 1 happens to be `1`, so the hardcoded answer matched coincidentally.

### Debugging process

Ruby coached her through:

1. **Read the error message carefully.** The first run failed on `NameError: l` — she'd typed `l` instead of `len`. Always read error names.
2. **Add print statements** to confirm the loop is behaving as expected.
3. **Step back and re-read the problem.** Ask: "What am I tracking? What drives the return value?" The driver here is **how many children got a cookie**, which is `i`.

> "When you're going along and everything looks right but the output is wrong, take a step back. Ask what inputs you're given, what outputs you're expected to return, and what's driving the problem."

### What Linda did well

- Clear labeling of her thought process and variables.
- Strong verbal communication throughout.
- Explained the algorithm before coding.
- Only tripped up on one return statement and recovered.

### Coaching notes

- **Making assumptions when stuck is good**, but follow it with a concrete action (add prints, test, verify).
- **Watch out for the mental loop** of "just toggle things until it works." Systematic debugging beats guessing.
- Knowing the solution from prior work is fine — the exercise of coming back to it and rewriting tests whether your understanding sticks.

> "This was actually excellent. Your communication throughout is exactly what I'm looking for." — Ruby

---

## Mock Interview: Mauricio on "Majority Element" (LeetCode easy)

### Problem statement

Given an array `nums` of size `n`, return the **majority element** — the element that appears **more than `n/2` times**. You may assume a majority element always exists.

### Examples

```
nums = [3, 2, 3]                    -> 3  (appears 2 times, n/2 = 1.5)
nums = [2, 2, 1, 1, 1, 2, 2]        -> 2  (appears 4 times, n/2 = 3.5)
```

### Constraints

- `1 <= n <= 5 * 10^4`
- `-10^9 <= nums[i] <= 10^9`

### Mauricio's approach: frequency hashmap

```python
def majorityElement(nums):
    freq = {}
    for num in nums:
        freq[num] = freq.get(num, 0) + 1
    n = len(nums)
    for k in freq:
        if freq[k] > n // 2:
            return k
```

- **Time:** O(n)
- **Space:** O(n)
- Solved in about **10 minutes**.

### Coaching feedback

- Clean, confident implementation — Mauricio has frequency dictionaries down cold.
- **Still check your work along the way** even when a problem feels easy. Add a print after building the frequency dict to confirm it's shaped correctly. Don't write a long block of code untested.
- **The follow-up challenge:** solve it in **linear time AND O(1) space** — i.e., without a dictionary. This is the **Boyer-Moore voting algorithm**:

```python
def majorityElement(nums):
    candidate = None
    count = 0
    for num in nums:
        if count == 0:
            candidate = num
        count += 1 if num == candidate else -1
    return candidate
```

- O(n) time, O(1) space. Works because the majority element "wins" enough vote comparisons to survive to the end.

### Early-exit optimization hint

Since the problem guarantees exactly one majority element exists, you could **exit early** from the frequency loop the moment any count exceeds `n/2`. No need to finish building the dict.

> "You don't need to keep considering any other numbers because you found it." — Ruby

---

## Ruby's Real-World Example: Full-Text Search with Highlighting

Ruby showcased a real project she was working on that applies string-manipulation concepts from the tech interview prep to a practical problem.

### The problem

Build a full-text search that:

1. Finds all matches of a substring within a larger string.
2. Is **case-insensitive** (finds "Banana", "BANANA", and "banana").
3. Preserves the **original casing** in the output.
4. Wraps matches in HTML `<highlight>` tags for display.

### Why Python's built-in `str.replace()` isn't enough

```python
"I like bananas BANANAS Bananas".replace("bananas", "apples")
# "I like apples BANANAS Bananas"
```

Only matches the exact casing, and doesn't preserve original casing in the non-matched occurrences you'd also want to highlight.

### The layers of complexity

Starting from a basic `replace` understanding:

1. **Basic replace** — find substring, replace with another.
2. **Case-insensitive replace** — match regardless of case.
3. **Preserve original casing** — find all cases, highlight them, don't alter the surrounding text.
4. **Wrap in HTML** — output `<highlight>original</highlight>` rather than just the match.

### The point

> "Everything you're learning and practicing for the tech interview definitely does come back in the internship and beyond. There are skill sets you're building that will take you from good to great when it comes to performing in the real world."

The interview problem is **the baseline template**. The real world adds layers of abstraction on top. If you're solid on the baseline, the extra layers are manageable.

---

## Key Takeaways

- **Walking through a problem you've solved before counts as valuable mock interview practice** — it tests explanation and debugging skills, not just fresh problem-solving.
- **Read error messages carefully.** Don't assume you know what's wrong — the error tells you.
- **Always write a non-hardcoded return early.** A hardcoded `return 1` passed a test Linda wasn't expecting, hiding the real bug.
- **Add print statements after building any significant data structure** (frequency dictionary, sorted copy, etc.) to confirm it looks right.
- **Majority Element:** frequency dict is the easy O(n) space solution; Boyer-Moore voting is the O(1) space follow-up.
- **Problem-level early exits** are available when the problem guarantees uniqueness ("you may assume a majority element exists").
- **Sort + two pointers + greedy** is the canonical pattern for "maximize matches between two sorted things" (cookies/children, interval scheduling, etc.).
- **Read the follow-up** — it often asks for a more efficient solution and pushes you toward the "textbook" algorithm.
- **Real-world coding layers** on top of interview-baseline problems. Mastering the basics is what makes the layered work tractable.
- **Interview practice applies directly to the internship and beyond** — the foundational skills transfer.
