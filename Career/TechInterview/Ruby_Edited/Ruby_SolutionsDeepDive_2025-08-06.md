# Ruby Solutions Deep Dive — August 6, 2025

Wednesday solutions deep dive session revisiting **Top K Frequent Elements**. Lisa shares her working solution, the coach walks through building it from scratch without the `Counter` shortcut, explores sorting approaches, and contrasts with Brian's optimal bucket-sort solution.

---

## Problem: Top K Frequent Elements

Given an integer array `nums` and an integer `k`, return the `k` most frequent elements. The answer may be returned in any order.

### Examples

- `nums = [1,1,1,2,2,3], k = 2` → `[1, 2]` (1 appears 3x, 2 appears 2x, 3 appears 1x)
- `nums = [1], k = 1` → `[1]`

### Constraints

- `1 <= nums.length <= 10^5`
- `-10^4 <= nums[i] <= 10^4`
- `k` is in the range `[1, number of unique elements]` — guaranteed a valid answer exists
- **Follow-up:** Algorithm's time complexity must be better than **O(n log n)**

> The follow-up is an extra challenge. A solution worse than O(n log n) still passes the judge — the follow-up just raises the bar.

---

## Lisa's Solution: `Counter` + `most_common`

Lisa's approach used Python's `collections.Counter`, inspired by SQL's `SELECT TOP` pattern.

```python
from collections import Counter

def topKFrequent(nums, k):
    counts_frequency = Counter(nums)
    most_common = [item for item, frequency in counts_frequency.most_common(k)]
    return most_common
```

### How it works

- **`Counter(nums)`** builds a frequency dictionary in one call (e.g. `{1: 3, 2: 2, 3: 1}`).
- **`.most_common(k)`** returns the top `k` key/count tuples already sorted descending by frequency.
- The **list comprehension** extracts just the keys (the actual numbers), discarding the counts.

### Coach feedback

> You could just `return counts_frequency.most_common(k)` directly and map out the keys — you don't need a separate sort step because `most_common` is already sorted.

- Lisa's instinct to sort again was redundant; `most_common` handles ordering internally.
- The solution is clean and passes all 22 test cases.

---

## Approach 1: Build the Frequency Dictionary From Scratch

The coach emphasized understanding the underlying mechanics before relying on `Counter`.

```python
frequency = {}
for num in nums:
    if num in frequency:
        frequency[num] += 1
    else:
        frequency[num] = 1
```

### Key takeaways

- A dictionary literal uses **`{key: value, key: value}`** syntax.
- You **cannot `+= 1`** on a key that doesn't exist yet — Python raises `KeyError`.
- The `if num in frequency` check lets you branch between "increment existing" and "create new entry".
- **`in` on a dict is O(1) average case** — hash lookup, not linear scan.

> It's fine to use shortcuts like `Counter`, `min`, and `max` in the technical interview, but you must be able to build them from scratch. Know the underlying principles so you can adapt when the shortcut doesn't fit.

---

## Approach 2: Sorting the Dictionary

Once you have the frequency dictionary, you need to extract the top `k` entries. Sorting is the obvious first attempt.

### Sorting a dict by value

```python
sorted_frequency = sorted(frequency.items(), key=lambda item: item[1], reverse=True)
```

- **`frequency.items()`** returns an iterable of `(key, value)` tuples like `[(1, 3), (2, 2), (3, 1)]`.
- **`key=lambda item: item[1]`** tells `sorted` to sort by the second element of each tuple (the count).
- **`reverse=True`** sorts descending so the most frequent comes first.

### Extracting the top k

```python
answers = []
for i in range(k):
    answers.append(sorted_frequency[i][0])
return answers
```

- `sorted_frequency[i]` is a `(num, count)` tuple.
- `[0]` pulls out just the number.

### Complexity

- **Time:** O(n log n) — dominated by `sorted`.
- **Space:** O(n) for the frequency dict.
- Fails the follow-up constraint but passes all test cases.

> I was talking smack about knowing how to use things without looking them up, then had to Google "Python sort dictionary by value". It happens to everyone — the important thing is recognizing the pattern: `items()` + `key=lambda` + index.

---

## Approach 3: Repeated Max (Brute Force Without Sort)

An attempt to dodge the sort by repeatedly pulling the current max.

```python
k_frequency = []
while len(k_frequency) < k:
    max_frequency = 0
    max_num = None
    for num, freq in frequency.items():
        if freq > max_frequency:
            max_frequency = freq
            max_num = num
    k_frequency.append(max_num)
    del frequency[max_num]
return k_frequency
```

### How it works

- While we haven't collected `k` answers, scan the whole dict for the current max.
- Append it to results and **delete it** from the dict so the next scan finds the next max.

### Complexity

- **Time:** O(k * n) worst case — for each of `k` passes we scan all `n` entries.
- Ends up **worse than** sorting when `k` approaches `n`, but avoids the `O(n log n)` sort.

> I thought I was being clever dodging the sort, but I traded O(n log n) for O(k*n) — not a win in the general case.

---

## Approach 4: Bucket Sort — O(n) (Brian's Solution)

The only standard way to beat O(n log n) on this problem. Brian demonstrated it the prior Sunday.

```python
from collections import Counter

def topKFrequent(nums, k):
    c = Counter(nums)
    buckets = [[] for _ in range(len(nums) + 1)]
    for num, freq in c.items():
        buckets[freq].append(num)

    result = []
    for i in range(len(buckets) - 1, -1, -1):
        for num in buckets[i]:
            result.append(num)
            if len(result) == k:
                return result
```

### The key insight

- A number's frequency is bounded by `len(nums)` — so we can use **frequency as an index** into a list of buckets.
- `buckets[freq]` holds every number that appears exactly `freq` times.
- Walking the buckets **from high index to low** yields numbers in descending frequency order for free — no sorting required.

### Complexity

- **Time:** O(n) — building the counter is O(n), filling buckets is O(n), walking buckets is O(n).
- **Space:** O(n) — the bucket list is sized to `len(nums) + 1`.

> Brian's bucket approach trades a little extra space for linear time. That's the trick whenever you need to beat O(n log n) on a frequency-sorting problem — can you use the value itself as an index?

---

## Big-O Review

When in doubt about a complexity claim, the coach recommended **bigocalc.com** and the classic **Big-O complexity graph**.

| Complexity | Example |
|---|---|
| **O(1)** constant | Hash lookup, array index access |
| **O(log n)** logarithmic | Binary search — cut the input in half each step |
| **O(n)** linear | Single pass through the array |
| **O(n log n)** linearithmic | Comparison sorts (Timsort, merge sort); binary searching each of `n` items |
| **O(n^2)** quadratic | Nested loops over the same input (e.g. naive pair-finding) |

### Why sorting is O(n log n)

Comparison-based sorts (Python's Timsort included) cannot do better than O(n log n) in the general case. Any time you see `sorted(...)` or `.sort()`, assume that's your lower bound unless you're using a non-comparison sort like bucket or radix sort.

### How to know if your solution meets the follow-up

- Break down your code line by line and identify the dominant operation.
- Dictionary operations (`in`, get, set, delete) are **O(1) average**.
- A single `for` over the input is **O(n)**.
- A `sorted()` call is **O(n log n)**.
- Nested loops multiply — `for i in nums: for j in nums:` is **O(n^2)**.

---

## Session Takeaways

- **Counter + most_common** is the cleanest Pythonic solution — know it cold for interviews.
- You must also be able to build the frequency dict manually with `if key in dict` branching.
- **Sorting by dict value** uses `sorted(d.items(), key=lambda item: item[1], reverse=True)` — memorize this idiom.
- **Bucket sort** is the standard trick to beat O(n log n) on frequency problems; frequency becomes the bucket index.
- When exploring shortcuts, always verify they actually improve complexity — Approach 3 was a cautionary tale.

> Commit the `items() + lambda` sort pattern to memory. It's one of those idioms that comes up constantly and is awkward to derive from first principles under interview pressure.
