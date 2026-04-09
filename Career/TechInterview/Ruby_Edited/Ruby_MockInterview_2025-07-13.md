# Mock Interview — Maximum Average Subarray & Search in Rotated Sorted Array (2025-07-13)
Source: https://youtu.be/sVC-1f0WOZU

Sunday session: pseudo code on Maximum Average Subarray (easy, sliding window intro), then a mock interview on Search in Rotated Sorted Array (medium, binary search). Volunteer: Daniel.

---

## [2:41](https://youtu.be/sVC-1f0WOZU?t=161) Problem 1: Maximum Average Subarray I (easy)

Given an integer array `nums` of length `n` and an integer `k`, find a **contiguous subarray of length k** with the **maximum average value** and return that value.

### [3:23](https://youtu.be/sVC-1f0WOZU?t=203) [approx] Example

- `nums = [1, 12, -5, -6, 50, 3]`, `k = 4`
- Output: `12.75`
- Reasoning: subarray `[12, -5, -6, 50]` sums to 51, divided by 4 = 12.75.

### [6:46](https://youtu.be/sVC-1f0WOZU?t=406) [approx] Constraints

- `nums.length` (n): 1 to 10⁵
- `k`: 1 to n (always have enough elements for at least one subarray of size k)
- Values: -10⁴ to 10⁴

---

## [6:40](https://youtu.be/sVC-1f0WOZU?t=400) Pulling From the Problem

- `nums` = array given to find subarray average in.
- `k` = size of the subarray to calculate an average for.
- `nums.length` is always ≥ k → we can always compute at least one valid average. No empty-array edge cases.

---

## [13:32](https://youtu.be/sVC-1f0WOZU?t=812) [approx] Approaches

### [16:55](https://youtu.be/sVC-1f0WOZU?t=1015) [approx] 1. Brute Force (nested loop)

```python
max_avg = float('-inf')
for i in range(len(nums) - k + 1):
    current_sum = 0
    for j in range(i, i + k):
        current_sum += nums[j]
    current_avg = current_sum / k
    max_avg = max(max_avg, current_avg)
return max_avg
```

- **Complexity:** O(n × k) ≈ O(n²)
- Works, but slow on large inputs.

### [20:18](https://youtu.be/sVC-1f0WOZU?t=1218) [approx] 2. Sliding Window (the optimal approach)

```python
window_sum = sum(nums[:k])
max_sum = window_sum
for i in range(k, len(nums)):
    window_sum += nums[i] - nums[i - k]
    max_sum = max(max_sum, window_sum)
return max_sum / k
```

- **Complexity:** O(n) — single pass.
- Calculate sum of the first window → O(k).
- Slide: add the new right-edge value, subtract the old left-edge value. No need to recalculate the whole sum.
- Track the running max sum, divide by k once at the end.

### [17:42](https://youtu.be/sVC-1f0WOZU?t=1062) Sliding Window keywords (when to use it)

- **Given K** or a fixed window size to track.
- Looking for a **sum, product, or average**.
- Working with **contiguous** subarrays.

> "Having the window size defined really helps you get that O(n) done pretty quickly. Maximum Average Subarray is a great intro to sliding window because the window size is given."

### [3:09](https://youtu.be/sVC-1f0WOZU?t=189) Bonus: prefix sum approach (mentioned but not fleshed out)

Build a prefix-sum array where `prefix[i]` = sum of `nums[0..i]`. Then any window sum = `prefix[i + k] - prefix[i]`. Same O(n) complexity, different mechanism.

---

## [30:27](https://youtu.be/sVC-1f0WOZU?t=1827) [approx] Problem 2: Search in Rotated Sorted Array (medium) — mock interview

**Volunteer:** Daniel.

### [1:44](https://youtu.be/sVC-1f0WOZU?t=104) Problem statement

You're given a sorted (ascending) integer array `nums` with **distinct values** that has been rotated at some unknown pivot index `k` (so the array becomes `nums[k:] + nums[:k]`). Given a target value, return its index in the rotated array, or `-1` if not found.

**Critical constraint:** "You must write an algorithm with **O(log n)** runtime complexity."

### [26:50](https://youtu.be/sVC-1f0WOZU?t=1610) Why it's a medium problem

The O(log n) requirement immediately rules out brute-force linear search (O(n)). You're expected to know **binary search** and adapt it to the rotated case.

---

## [6:53](https://youtu.be/sVC-1f0WOZU?t=413) Daniel's session

### [6:53](https://youtu.be/sVC-1f0WOZU?t=413) What Daniel did well

- Read the problem and pulled out the goal: find target, return its index, or return -1.
- Identified two potential approaches: brute force loop, or sorting first.
- Wrote out comments before code.
- Iterated when stuck, with the coach prompting.

### [1:03:45](https://youtu.be/sVC-1f0WOZU?t=3825) Where he got stuck

- **Variable name conflict:** used `target` as the loop variable in `for target in range(...)`, which shadowed the `target` parameter passed to the function.
- **Indexing confusion:** wasn't sure whether `i` was an index or a value. Coach prompted using `print(nums[i])` to verify.
- **Indentation error:** the code block was at the same level as the function definition, not inside it.

### [51:59](https://youtu.be/sVC-1f0WOZU?t=3119) The fix progression

1. Print the loop variable: `print(i)` → confirmed `i` was the index.
2. Print the array value at that index: `print(nums[i])` → confirmed access works.
3. Add the comparison: `if nums[i] == target: return i`.
4. Return `-1` after the loop ends.

This brute-force solution works but is **O(n)**, which fails the O(log n) requirement.

---

## [1:07:59](https://youtu.be/sVC-1f0WOZU?t=4079) The Iterative Testing Habit

> "Make sure you're taking iterative steps. What am I getting in my for loop? Is it printing an index? A value? How can I make sure I'm hitting all those steps before I write down a full several lines of code?"

**Key advice:** before adding logic, verify the building blocks are working.

- Print the loop variable.
- Print the value you're accessing.
- Compare against expected output by hand.
- Then add the next layer.

This avoids the trap of writing 30 lines, hitting an error, and not knowing which line is wrong.

---

## [57:32](https://youtu.be/sVC-1f0WOZU?t=3452) [approx] Binary Search on a Rotated Array (group discussion)

### [1:00:55](https://youtu.be/sVC-1f0WOZU?t=3655) [approx] Standard binary search recap

```
left = 0, right = len(nums) - 1
while left <= right:
    mid = (left + right) // 2
    if nums[mid] == target:
        return mid
    elif nums[mid] < target:
        left = mid + 1
    else:
        right = mid - 1
return -1
```

- **O(log n)** because you cut the search space in half each iteration.

### [1:09:47](https://youtu.be/sVC-1f0WOZU?t=4187) The rotation challenge

A rotated array is **two sorted segments stitched together**. At any midpoint, **one half is still sorted** and the other half contains the rotation pivot.

### [1:07:41](https://youtu.be/sVC-1f0WOZU?t=4061) [approx] Modified binary search idea

- Compute `mid`.
- Determine which half (left or right of `mid`) is fully sorted.
- Check if the target falls within the sorted half's range. If yes, binary search in that half. If no, search the other half.
- Continue until found or `left > right`.

> "It's almost like you have two sorted lists within a single list and you have to figure out which sorted list you want to start binary searching through as you move through."

This will be explored in depth on Wednesday.

---

## [1:11:04](https://youtu.be/sVC-1f0WOZU?t=4264) [approx] Big-O Reminder

| Big-O | Description | Example |
|---|---|---|
| O(1) | Constant | Array index access |
| O(log n) | Logarithmic | Binary search |
| O(n) | Linear | Single loop through array |
| O(n log n) | Linearithmic | Most sorts |
| O(n²) | Quadratic | Nested loops over the same array |

The medium problem here demands O(log n) — only a tiny step above O(1). That's why the interviewer is essentially requiring the binary search algorithm.

---

## [1:11:58](https://youtu.be/sVC-1f0WOZU?t=4318) Recommendation: Always Get Brute Force First

Even when the problem demands a specific complexity (like O(log n) here):

1. Get a brute force solution working first to confirm you understand the problem.
2. Make sure you're accessing values correctly, comparing correctly, returning the right type.
3. **Then** optimize toward the required complexity.

> "For brute force of just getting how can I approach this problem and get some test cases passing — totally great. Then we make the next step of saying what do I know about potential approaches to get this to that desired runtime."
