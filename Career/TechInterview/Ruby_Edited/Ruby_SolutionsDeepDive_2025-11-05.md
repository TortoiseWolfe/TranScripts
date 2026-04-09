# Ruby Solutions Deep Dive — November 5, 2025
Source: https://youtu.be/9SvY-5sgL1Q

Review of Mauricio's solution to **Median of Two Sorted Arrays** (LeetCode Hard) using the merge step from merge sort, followed by a mock interview on **Longest Harmonious Subsequence** (LeetCode Easy, deceptively tricky).

---

## [3:09](https://youtu.be/9SvY-5sgL1Q?t=189) Preamble: Finding "Implementation Algorithm" Problems on LeetCode

A participant asked how to find the HackerRank "Algorithms → Implementation" equivalent on LeetCode, since LeetCode doesn't expose that subcategory.

> "I think you just have to Google the specific algorithm you want to practice, or just do a generic list. Or ask Chat GPT — give it a problem and ask if it knows LeetCode problems similar to it. I haven't really deviated outside of five playlists and the Blind 75."

> "LeetCode is kind of weird — it's easy to find problems, but hard to find problems on the site."

---

## [28:55](https://youtu.be/9SvY-5sgL1Q?t=1735) Problem: Median of Two Sorted Arrays (Hard)

Given two sorted integer arrays `nums1` and `nums2`, return the median of the combined sorted array.

- **Constraint hint:** the problem asks for O((m+n)) or better. A trivial `sort(nums1 + nums2)` is disallowed.
- **Key realization:** the **merge step of merge sort** is exactly what you need. You don't have to merge sort anything — these arrays are already individually sorted. You just need the two-pointer merge.

---

## [7:08](https://youtu.be/9SvY-5sgL1Q?t=428) [approx] Mauricio's Solution — Merge Then Compute

```python
def findMedianSortedArrays(nums1, nums2):
    merged = []
    i = j = 0
    while i < len(nums1) and j < len(nums2):
        if nums1[i] <= nums2[j]:
            merged.append(nums1[i])
            i += 1
        else:
            merged.append(nums2[j])
            j += 1
    # Leftovers — one array is exhausted, the other still has sorted values
    merged.extend(nums1[i:])
    merged.extend(nums2[j:])

    n = len(merged)
    if n % 2 == 1:
        return merged[n // 2]
    else:
        return (merged[n // 2 - 1] + merged[n // 2]) / 2
```

### [12:20](https://youtu.be/9SvY-5sgL1Q?t=740) Key Points

- **Two pointers `i` and `j`** walk each array. Append the smaller of the two current values and advance its pointer.
- **`.extend()` not `.append()`** for the leftovers — `append` would add the remaining slice as a single nested list.
- **Leftovers are already sorted**, so no additional work is needed.
- **Median calculation:** odd length returns the middle element; even length returns the average of the two middle elements.

> "The intuitive part was the two pointers and comparing element by element. The part that's not intuitive and you have to check is the leftovers — first being aware that there even are leftovers. You tend to think you went through everything, but one may have finished first."

---

## [14:17](https://youtu.be/9SvY-5sgL1Q?t=857) [approx] Coach's Alternative — Stop At The Median Index

The coach's approach avoided building the full merged array. Compute the target index `(len(nums1) + len(nums2)) // 2`, then advance through both arrays until reaching that index and return the value there.

### [15:54](https://youtu.be/9SvY-5sgL1Q?t=954) Why the Coach Didn't Like Her Own Version

To handle the case where one array runs out before the target index is reached, she hard-coded a **sentinel value outside the constraint range** (like `10**6 + 1`) so the exhausted side would always lose the `min` comparison.

> "That's kind of a faux pas. I'm hard-coding against the constraints. Mauricio's version is cleaner — mine was ugly because I was excited my idea worked and didn't go back and clean it up. That's real-life coding: you come up with something sloppy, then refine it before pushing to production."

---

## [15:08](https://youtu.be/9SvY-5sgL1Q?t=908) Mock Interview: Longest Harmonious Subsequence (LeetCode Easy)

> A **harmonious array** has `max - min == 1`. Given an integer array, return the length of its longest harmonious **subsequence** (elements in order, but not necessarily contiguous).

### [25:00](https://youtu.be/9SvY-5sgL1Q?t=1500) [approx] Example

`[1, 3, 2, 2, 5, 2, 3, 7]` → answer `5` (the subsequence `[3, 2, 2, 2, 3]`).

> "Subsequence means you can skip elements. You're not restricted to contiguous runs."

### [27:06](https://youtu.be/9SvY-5sgL1Q?t=1626) Mauricio's Attempt

He tried to track a running `max`/`min` while traversing and append the current element to a `current` list if the difference equaled 1. The approach broke down on the first few values because:

- Only tracking `max` and `min` against the current element loses the previous values.
- The array is **not sorted** (contradicting his initial assumption).
- A harmonious subsequence is really a count of **how many times each value and its neighbor (value ± 1) appear**.

### [44:50](https://youtu.be/9SvY-5sgL1Q?t=2690) Coach Feedback

> "You want to return a number, not necessarily an array. Maybe you want to keep count of what would go in the array without actually creating the array. That's a different mindset."

> "Test along the way. You got all of this code written, and when we traced the first few values, it broke down after a few iterations. Testing earlier would have caught it before you moved too far."

### [7:17](https://youtu.be/9SvY-5sgL1Q?t=437) Topic Tags As Hints

LeetCode listed the problem's tags as **Hash Table, Sliding Window, Sorting, Counting**.

> "Hash table is a big clue. Sliding window can be a clue. Sorting is in there. Counting — you were going to count it anyway."

### [39:18](https://youtu.be/9SvY-5sgL1Q?t=2358) [approx] The Hash Table Approach (Coach's Working Solution)

The coach solved it using a frequency counter:

```python
def findLHS(nums):
    counts = {}
    for n in nums:
        counts[n] = counts.get(n, 0) + 1
    longest = 0
    for key in counts:
        if key + 1 in counts:
            longest = max(longest, counts[key] + counts[key + 1])
    return longest
```

- **Build a frequency dictionary** — one pass.
- For each key, check whether `key + 1` exists. If so, the combined count is a candidate harmonious subsequence length.
- **No sorting required.** O(n) time.

### [49:08](https://youtu.be/9SvY-5sgL1Q?t=2948) Sliding Window Variant

Sliding window **can** work, but only if you first sort the array to make the "harmonious" values adjacent — sacrificing time to sorting for logical simplicity.

> "There are a few different versions of the sliding window. It's kind of a misnomer — it's more like sliding windowS."

---

## [47:57](https://youtu.be/9SvY-5sgL1Q?t=2877) Easy vs Hard Labeling

> "This is not an easy problem to me. It's easy when you know how to do it. An acceptance rate of 64% on an 'easy' is a good indication that it shouldn't necessarily be an easy problem. I wouldn't give you a problem like this for the technical interview — but it's a good one to add to your tool belt."

---

## [50:01](https://youtu.be/9SvY-5sgL1Q?t=3001) [approx] Takeaways

- **Merge sort's merge step** solves "combine two sorted arrays" problems cleanly. Don't forget the leftovers.
- Use **`.extend()`** for remaining slices; `.append()` nests them.
- **Hash tables / frequency counts** unlock a whole class of "count occurrences with a relationship" problems — harmonious subsequences included.
- **Pseudo code and pen-and-paper tracing** are worth the up-front time on tricky problems. Don't jump straight to code under pressure.
- When your idea isn't working after a few iterations, **stop and re-trace with real values** before writing more code.
- If you hard-code against a constraint as a sentinel, flag it and clean it up later — it's a real-world "sloppy first draft" move.
