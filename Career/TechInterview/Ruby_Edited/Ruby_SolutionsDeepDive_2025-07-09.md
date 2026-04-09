# Solutions Deep Dive — Missing Numbers, Ice Cream Parlor, and Big-O Walkthroughs (2025-07-09)
Source: https://youtu.be/T5oLd7kqqOo

Wednesday session: solutions for Missing Numbers (Brian's hashmap approach + the group's offset approach), Natalia's Ice Cream Parlor dictionary attempt, and a thorough Big-O breakdown.

---

## [39:21](https://youtu.be/T5oLd7kqqOo?t=2361) Recap: Maximum Product Subarray (extra notes)

The coach felt last week's pseudo code left people with too little to go on. Extra notes for restarting that problem:

- **Initialize a product variable** with the sum/product of all values in the array as a starting baseline. If nothing else beats it, you've got a default answer.
- **Two-pointer concept** (not the literal algorithm) — start from both ends, work inward, calculate products of all subarrays in between.
- **You can't quit early** because of negative numbers. Two negatives multiplied together can flip the sign, so you have to check every subarray.
- This brute force is O(n²) — sliding window can do better.

### [13:04](https://youtu.be/T5oLd7kqqOo?t=784) Sliding Window keywords

When you see all of these together, think **sliding window**:

- Indexes must be **touching** (contiguous).
- Looking at a **subarray**.
- Looking for a **sum or product**.

Lisa learned and used the sliding window approach for Maximum Product Subarray. The Geeks-for-Geeks article on it is O(n²) — there's a better implementation than what they show.

---

## [3:44](https://youtu.be/T5oLd7kqqOo?t=224) Natalia's Ice Cream Parlor Solution (Dictionary Approach)

### [3:44](https://youtu.be/T5oLd7kqqOo?t=224) Approach

Natalia recognized this as a Two Sum variant ("if you have a target value and need to find two values that sum to it, use a complement dictionary").

### [16:19](https://youtu.be/T5oLd7kqqOo?t=979) Initial code issues and fixes

1. **One-based indexing:** use `enumerate(arr, 1)` — pass `1` as the second argument to start counting from 1 instead of 0.
2. **Empty return for HackerRank wrapper:** add `return []` outside the loop to avoid the `_FptrName_join(...)` error.
3. **Indentation bug:** the dictionary update line was indented inside the `if` block, so it never ran when the complement wasn't found. Move `d[value] = index` to the same indentation level as the `if`, still inside the `for` loop.

### [16:19](https://youtu.be/T5oLd7kqqOo?t=979) Final shape

```python
d = {}
for index, value in enumerate(arr, 1):
    complement = m - value
    if complement in d:
        return [d[complement], index]
    d[value] = index
return []
```

### [27:21](https://youtu.be/T5oLd7kqqOo?t=1641) The fix that broke it

Submission gave a runtime error (not a time limit error) on one test case after the fixes. Worth investigating, but the approach is correct.

### [26:29](https://youtu.be/T5oLd7kqqOo?t=1589) Indentation lesson

> Python is **very** strict about indentation. Anything at the same indentation level as the body of an `if` is treated as part of that `if` block. Some other languages let you write a one-liner `if` followed by a separate next line — Python does not.

---

## [22:59](https://youtu.be/T5oLd7kqqOo?t=1379) [approx] Brian's Missing Numbers Solution (Counter / Frequency Map)

### [25:52](https://youtu.be/T5oLd7kqqOo?t=1552) [approx] Approach

```python
from collections import Counter

def missingNumbers(arr, brr):
    count_a = Counter(arr)
    count_b = Counter(brr)
    stack = []
    for value in brr:
        if count_a[value] != count_b[value]:
            stack.append(value)
    return sorted(set(stack))
```

### [44:31](https://youtu.be/T5oLd7kqqOo?t=2671) How `Counter` works

`collections.Counter` creates a dictionary-like object mapping values to their **frequency**. For `[7, 2, 5, 4, 6, 3, 5, 3]` it returns `{7: 1, 2: 1, 5: 2, 4: 1, 6: 1, 3: 2}`.

### [36:21](https://youtu.be/T5oLd7kqqOo?t=2181) Walkthrough

- Build frequency dicts for both arrays.
- Iterate through the original (longer) array.
- If a value's frequency doesn't match between the two dicts, it's missing.
- Append to a stack, then return the sorted unique values.

### [34:29](https://youtu.be/T5oLd7kqqOo?t=2069) [approx] Big-O breakdown

- `Counter(arr)` and `Counter(brr)`: each O(n) → O(2n) → **O(n)**.
- `for value in brr`: O(n).
- Inside the loop: dict lookup `count_a[value]` is O(1), comparison is O(1), append is O(1). All inside the O(n) loop → **O(n)**.
- `sorted(...)`: **O(n log n)** — this is the bottleneck.
- **Overall time:** O(n log n).
- **Space:** O(n) for the two dicts + O(n) for the stack.

> "The sorted kind of messes up your big O there, but otherwise it's pretty good."

---

## [37:22](https://youtu.be/T5oLd7kqqOo?t=2242) [approx] Big-O Reasoning Step by Step (Brian's session)

This was a real-time exercise in determining Big-O by inspection.

### [40:14](https://youtu.be/T5oLd7kqqOo?t=2414) [approx] Question: "Is the for loop O(n) or O(n²)?"

**Answer:** Depends on what's inside.

- **Accessing `arr[index]`** = O(1). Reading a single value from an array is constant time.
- **Comparing two single values** = O(1).
- **`stack.append(x)`** = O(1) amortized.
- **All O(1) inside an O(n) loop** = O(n) overall.
- O(n²) only happens when you have a **nested loop** over the array — e.g., `for i: for j: ...`.

### [40:55](https://youtu.be/T5oLd7kqqOo?t=2455) "But I'm comparing two arrays — isn't that O(n²)?"

No. Comparing **values from two arrays** is O(1) per comparison. You'd only get O(n²) if you wrote a nested loop where the inner loop traversed the second array fully for each element of the first.

### [45:59](https://youtu.be/T5oLd7kqqOo?t=2759) [approx] Big-O of common Python operations

- `dict[key]` lookup: O(1)
- `list.append(x)`: O(1)
- `key in dict`: O(1)
- `value in list`: O(n) (linear scan)
- `list[i]`: O(1)
- `len(list)`: O(1)
- `sorted(list)`: O(n log n)
- `list.sort()`: O(n log n)
- `Counter(iterable)`: O(n)
- `set(iterable)`: O(n)
- `key in set`: O(1)

### [49:16](https://youtu.be/T5oLd7kqqOo?t=2956) Why no O(n) sort exists

- General-purpose comparison sorts have a **theoretical lower bound** of O(n log n).
- "Binary sort" doesn't exist as a sorting algorithm — binary **search** is a search algorithm, and it's O(log n).
- Binary search appears **inside** sorting algorithms (e.g., for finding insertion points), which is one reason sorts come out to O(n log n) — n elements × log n comparisons each.

---

## [1:10](https://youtu.be/T5oLd7kqqOo?t=70) The Group's Offset Approach (Coach's solution)

This was the approach the group had pseudo-coded a few weeks earlier. It's the brute force / non-hashmap version:

### [54:37](https://youtu.be/T5oLd7kqqOo?t=3277) [approx] Core idea

- Sort both arrays first.
- Walk through `brr` (the longer original) one element at a time.
- Compare to `arr[index - offset]`. When they don't match, the current `brr` value is missing — append it and bump the offset.
- Bonus: bounds-check to avoid going out of range when offset grows past `arr`'s length.

### [58:38](https://youtu.be/T5oLd7kqqOo?t=3518) Why sort first?

The hidden test cases on HackerRank are **not in order**. The original assumption ("the order will be the same") was false. Sorting both first lets the index-walk comparison work.

### [1:00:21](https://youtu.be/T5oLd7kqqOo?t=3621) [approx] Why this is worse than Brian's

- Sort A: O(n log n)
- Sort B: O(n log n)
- Walk: O(n)
- Sort the answer: O(n log n)
- **Three O(n log n) operations** vs Brian's **one** O(n log n) sort plus three O(n) operations.

### [16:27](https://youtu.be/T5oLd7kqqOo?t=987) A weird Python set behavior

When you `set.add()` items into a Python set, the **order changes unpredictably** — sets are not ordered, and adding elements can rearrange the internal storage. That's why the coach had to call `sorted(...)` at the end even though the inputs had already been sorted.

> "Apple, banana, cherry. Add orange. Now it's `{orange, banana, cherry, apple}` or some other arrangement. Sets are not ordered."

---

## [37:24](https://youtu.be/T5oLd7kqqOo?t=2244) Hashmap vs Offset: Why Frequency Maps Are Safer

- **Frequency maps eliminate duplicate-tracking entirely** because the value is the key and the count is the value. There's only one entry per unique number.
- **Offset tracking** has to manually account for repeating numbers, bounds checks, and order assumptions — many places to introduce bugs.
- The hashmap approach is "more future-proof" even though it adds a bit of memory complexity.

---

## [44:22](https://youtu.be/T5oLd7kqqOo?t=2662) Memory vs Space Complexity

Big-O space complexity and actual memory usage are **not the same thing**:

- A hashmap is O(n) space, but **takes more bytes** than an O(n) list because dicts have hashing overhead.
- LeetCode/HackerRank report your memory usage compared to peers. A solution can have great Big-O space complexity but still use a lot of actual memory if the data structures involved are heavyweight.

---

## [1:11:51](https://youtu.be/T5oLd7kqqOo?t=4311) [approx] Plan for Next Session

Three named algorithms to focus on:

- **Two pointers**
- **Binary search**
- **Sliding window** (for the Maximum Product Subarray problem)

> "Even just knowing how these algorithms work can help you create and craft solutions to other problems in unique ways so that you can actually get your test cases passing."
