# Ruby Mock Interview — August 3, 2025
Source: https://youtu.be/vqK-YLBcIF0

*Nailing the Tech Interview — Sunday session*

## Opening Questions

### Are vector databases common in technical interviews?

Short answer: **no**, not for entry-level or Joy of Coding-style interviews.

- Possibly relevant for **senior-level** interviews focused on **backend / systems design**, particularly if the role involves big data.
- A senior engineer mentioned comfort with vector databases was expected in their big-data-focused role, but that's an outlier for most interview prep.
- Not a common LeetCode topic, though there are adjacent problems that use similar methodology.

---

## Revisit: Maximum Average Subarray (Sliding Window)

Last session's problem was revisited to walk through the **sliding window** approach and to demonstrate writing more **code-adjacent pseudo code** (at Lisa's request).

### Problem statement

You are given an integer array `nums` of `n` elements and an integer `k`. Find a **contiguous subarray of length `k`** with the **maximum average value**, and return that value. Any calculation error less than `10^-5` is accepted.

**Example:** `nums = [1, 12, -5, -6, 50, 3]`, `k = 4` → output `12.75` (the window `[12, -5, -6, 50]` gives the highest average).

### Constraints

- `1 <= k <= 10^5`
- `k <= nums.length <= 10^5`
- `-10^4 <= nums[i] <= 10^4`
- There is always at least one valid answer.

### Two approaches discussed

- **Brute force — O(n²).** Nested loops. For each starting index, sum the next `k` values and compare averages.
- **Sliding window — O(n).** Set a window of size `k`, slide it by one each step, maintain a running sum (add new, subtract old).

### Code-adjacent pseudo code for sliding window

```
# Initialize max_average carefully — keep constraints in mind.
# Options:
#   - negative infinity (float('-inf'))
#   - or slice first k values of nums and use their sum/average
max_average = float('-inf')

# Loop from k to len(nums) so the window always has k elements
for i in range(k, len(nums)):
    # Slide the window: add new value, subtract the one leaving
    current_sum = current_sum + nums[i] - nums[i - k]
    # Compare local sum against global max sum
    max_sum = max(max_sum, current_sum)

return max_sum / k
```

Key reminders:

- Don't initialize `max_average` to `0` — values can be negative, so `0` would be wrong.
- `float('-inf')` is a safe sentinel; `-10^4 * 4` would also work but is fragile.
- Track `max_sum` (an integer) and only divide by `k` at the end to get the float average — cleaner than tracking averages inside the loop.

> "Always, always, always include what you're going to return."

---

## Python 2 vs Python 3 Gotcha: Integer Division

Brian showed his solution and hit a bug: he kept getting `12` instead of `12.75` for the first test case.

### What happened

- Brian was on **"Python"** (Python 2) on LeetCode, not **Python 3**.
- His initial `sum_one = sum(nums[:k])` returned an **integer**, so downstream arithmetic stayed in integer math and truncated the answer.
- Wrapping with `float(sum(nums[:k]))` fixed it in Python 2.
- Switching to **Python 3** made it work without the explicit `float()` cast because the function signature included a return type annotation (`-> float`), and Python 3's division operator `/` already returns a float.

### Takeaway

- Python 2 uses **integer division** when both operands are ints.
- Python 3's `/` always returns a float; integer division is `//`.
- This is **analogous to JavaScript vs TypeScript**: Python 3 allows optional type hints; TypeScript enforces them. Type safety helps you catch these kinds of bugs before they ship.

> "There's been many times I've worked on a project, run it, it looks good, come back the next day and it's in scientific notation or something, and I have to figure out why."

### Brian's working sliding-window code (Python)

```python
class Solution:
    def findMaxAverage(self, nums: List[int], k: int) -> float:
        sum_one = float(sum(nums[:k]))  # cast to float in Python 2
        max_sum = sum_one
        for i in range(k, len(nums)):
            sum_one = sum_one + nums[i] - nums[i - k]
            max_sum = max(max_sum, sum_one)
        return max_sum / k
```

### Runtime discussion

- Submitted at ~73ms. Not the fastest on the board but acceptable.
- Discussed whether initializing with `float('-inf')` would be faster — probably not, because you'd still need to compute the first window's sum somewhere.
- A `while` loop wasn't a meaningful improvement — you still need to track an index for the subtraction step.
- Runtime variance on LeetCode is often just server load or language overhead, not algorithmic.

---

## Walkthrough: Top K Frequent Elements (Brian's Solution)

Brian solved **Top K Frequent Elements** and brought it in because he had a question about the output ordering.

### Approach

- Use `collections.Counter` on the input list to get `{num: frequency}`.
- Build a **list of lists** (LOL) sized `len(nums) + 1`, where index `i` holds all numbers that appear `i` times (bucket sort by frequency).
- Iterate **backwards** from the highest frequency bucket, collecting numbers until `len(ans) == k`, then return.

```python
class Solution:
    def topKFrequent(self, nums: List[int], k: int) -> List[int]:
        c = Counter(nums)
        lol = [[] for _ in range(len(nums) + 1)]  # must be len(nums)+1 to avoid index out of range
        for num, count in c.items():
            lol[count].append(num)
        ans = []
        for j in range(len(nums), 0, -1):
            for num in lol[j]:
                ans.append(num)
                if len(ans) == k:
                    return ans
        return ans
```

### Bug Brian hit

- Originally sized the bucket array `len(c)` (length of the counter) and got **IndexError: list index out of range**.
- A number with frequency `N` needs index `N` to exist in the bucket list, and frequencies can equal `len(nums)`. So the bucket array must be `len(nums) + 1`.

### Confusion about output order

Brian saw `[8, 4]` in the output rather than `[4, 8]` and wondered why.

- `Counter` does **not** sort by frequency — insertion order into the dict is based on first-seen order in the input, and bucket iteration handles ordering.
- The problem statement says: **"You may return the answer in any order."** That's why both orderings are valid.
- When he changed `k = 3` on his custom test case `[1, 1, 1, 2, 2, 3, 4, 4, 4, 8, 8, 8]`, the "answer is not unique" issue surfaced — numbers `1`, `2`, `3` all have unique frequencies, but picking "three most frequent" when there are ties isn't uniquely defined.

> "The uniqueness is hard to build constraints around. Imagine writing all the test cases for this — I feel bad for whoever did that."

### Feedback on the approach

- **It works**, and the runtime is solid.
- But it's doing more than necessary — the LOL bucket approach is clever, but the code is hard to read with many overlapping variables (`c`, `lol`, `j`, `num`, `ans`).
- Suggested refactor: **sort the counter items by frequency** and slice the top `k`. Higher Big-O in theory (O(n log n) vs bucket sort's O(n)), but much more streamlined.

> "Sometimes O complexity doesn't necessarily equal more streamlined code. You could write this to be a lot clearer, but it would be a higher Big-O."

Brian's solution will be explored further in Wednesday's Solutions Deep Dive.

---

## Key Takeaways

- **Sliding window** reduces O(n²) brute-force subarray problems to O(n) by maintaining a running sum and adjusting at the edges.
- Always initialize max/min trackers with **safe sentinels** like `float('-inf')` — not `0`, which fails on negative inputs.
- **Python 2 integer division** is a classic silent bug. Prefer Python 3, and/or cast to float explicitly.
- Type annotations and type safety (Python 3 hints, TypeScript) catch a whole class of these bugs early.
- **Code-adjacent pseudo code** is a useful middle ground between bullet-point plans and full implementation — sketch the loop structure and return statement before coding.
- For "top k" problems, **bucket sort by frequency** is O(n) but can be less readable than **sort + slice** at O(n log n). Readability often wins in interviews.
- **Always write your return statement** in pseudo code — it forces you to think about the final shape of the answer.
