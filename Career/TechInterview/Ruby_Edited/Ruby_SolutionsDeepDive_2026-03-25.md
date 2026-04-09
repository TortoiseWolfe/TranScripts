# Ruby Solutions Deep Dive — March 25, 2026
Source: https://youtu.be/J8mwGq1dgjc

Mock interview on **Move Zeroes** (LeetCode Easy) with Dan. Central lesson: **start with a brute force that violates the constraints**, get it working, then refactor — don't try to solve the hard version first from scratch.

---

## Problem: Move Zeroes

> Given an integer array `nums`, move all `0`s to the end of it while maintaining the relative order of the non-zero elements.
> **Note:** You must do this **in-place without making a copy of the array**.

### Example

- Input: `[0, 1, 0, 3, 12]`
- After: `[1, 3, 12, 0, 0]`

---

## Dan's First Attempt: Bubble Sort

Dan got bogged down trying to implement a bubble-sort-like right-to-left swapping approach without ever running his code once. He was handling multiple edge cases mentally — two adjacent zeros, the last element already being zero, a pair of non-zeros — and building the logic all at once.

### Coach Feedback: Test Iteratively

> "You have quite an intense set of logic here and we haven't hit run or printed anything at all. If something goes wrong, where do you start? The top? The first while loop? The if? The swapping? There are so many things that could go wrong. You want to make sure you're testing iteratively as you're developing your approach."

---

## The Key Insight: Brute Force First, Even If It Breaks The Constraint

### Coach's Prescription

> "With a complicated problem, instead of deferring to the most difficult idea or the approach you're unsure of, it's always better to default to a **brute force approach even if it violates the constraints** — just so you have some code running and some test cases passing. That builds your confidence and gives you a better understanding of what the problem is asking mechanically. Then you can either wipe and start from scratch knowing how it works, or refactor that approach to meet the conditions."

### Dan's Brute Force Idea

Create two lists: one for non-zero values, one for zeros. Concatenate them at the end.

```python
def moveZeroes_bruteforce(nums):
    non_zero = [n for n in nums if n != 0]
    zero_count = nums.count(0)
    return non_zero + [0] * zero_count
```

This violates "no copy" but it's simple, correct, and gets all test cases passing. Use it as a stepping stone.

---

## Dan's Refined Approach: Count And Remove Zeros

After the coach pushed him to break the constraint mentally first, Dan came up with a cleaner idea:

1. Iterate through the list.
2. On each zero, increment a counter and **remove** the element.
3. After the loop, append `counter` zeros to the end.

### Problem With Removing While Iterating

Coach pointed out the classic bug:

> "If you're going through an index loop 0, 1, 2, 3, 4 and you remove the value at index 1, what is the new length? What is the value at index 1 now? Your indexes are not going to be consistent if you're removing values while iterating."

### Dan's Acknowledgment

> "The overall algorithm is sound but incomplete. I'd have to reset my indexing after each removal because now I have a potential non-zero value that shifted into the deleted slot."

---

## The Correct Two-Pointer In-Place Solution

```python
class Solution:
    def moveZeroes(self, nums: List[int]) -> None:
        write = 0
        for read in range(len(nums)):
            if nums[read] != 0:
                nums[write] = nums[read]
                write += 1
        # Fill the rest with zeros
        for k in range(write, len(nums)):
            nums[k] = 0
```

### Walkthrough On `[0, 1, 0, 3, 12]`

- `read=0, nums[0]=0` → skip
- `read=1, nums[1]=1` → `nums[0]=1`, `write=1`
- `read=2, nums[2]=0` → skip
- `read=3, nums[3]=3` → `nums[1]=3`, `write=2`
- `read=4, nums[4]=12` → `nums[2]=12`, `write=3`
- Array now: `[1, 3, 12, 3, 12]`
- Fill from index 3: `[1, 3, 12, 0, 0]` ✓

### Why Two Pointers Work

- **`read`** walks the whole array once.
- **`write`** only advances when a non-zero is placed.
- **No copy is made** — you're writing back into the same array.
- **No index skipping** because `read` and `write` are decoupled.

---

## Clarification: What Does "No Copy" Mean?

Linda (and others) asked whether building a second list is allowed if you assign it back. The coach clarified:

> "The `nums` variable that's passed in has to contain the final value. You can't create a new array and return it — the test runner checks `nums` by reference. There's no rule that you can't create another array **at all**, but the original `nums` has to be mutated in place to contain the answer."

Effectively: **mutate the input array directly.**

---

## Coach Feedback: Verbalize Before Coding

> "From the interview side, I need to know how you got to this point. You didn't mention anything about what your approach would look like until after you had all the code written. Make sure you're outlining what you're observing about the problem and any alternatives you're considering — even if the alternatives don't turn into code. I want to see the thought process."

---

## Dan's Observation About Input Order Assumptions

> "The problem states 'relative order' but doesn't say anything about the order of the non-zero items being sorted. Potentially the non-zero items could be out of order based on this statement."

Coach agreed: you cannot assume the non-zero values are sorted. **Write that down as a comment assumption so you don't forget.**

---

## Session Reflection: Sequence Of Approaches

Dan walked through three progressively better approaches by the end of the session:

1. **Bubble sort** — never ran, too much edge-case complexity up front
2. **Two-list brute force** — violates "no copy" but works
3. **Count and remove** — sound algorithm but index-shifting bug
4. **Two-pointer in place** — (discussed by coach) the canonical answer

### Why The Progression Matters

> "If you had approached this with the second process from the start, we would have had a success. You could explain it clearly, and as long as you're dealing with a mutable object, what you described would work."

---

## Takeaways

- **Brute force first, constraint-compliant second.** Don't try to solve the hard version of a problem from a cold start.
- **Test iteratively** — print, run, check. Don't write 30 lines of logic without executing any of them.
- **Two-pointer `read`/`write` pattern** is the idiomatic in-place rearrangement approach for arrays.
- **Don't mutate a list while iterating it by index** — the indexes shift underneath you.
- **"In-place" means the original variable must end up with the answer.** You can use scratch memory, but the passed-in array has to be the final result.
- **Verbalize your approach out loud** before coding, and outline alternatives you considered.
- **Make assumptions about input explicit** — like "non-zero values aren't necessarily sorted" — and write them as comments.
