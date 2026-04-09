# Solutions Deep Dive — Contains Duplicate (All Approaches) (2025-07-30)
Source: https://youtu.be/YEI5yYOPVus

Wednesday session: explore four different approaches to LeetCode's Contains Duplicate, from O(n²) brute force to a one-line O(n) set comparison.

---

## [2:07](https://youtu.be/YEI5yYOPVus?t=127) Recap: Contains Duplicate problem

Given an integer array `nums`, return `True` if any value appears at least twice, `False` if all elements are distinct.

- `nums.length`: 1 to 10⁵
- Values: -10⁹ to 10⁹

---

## [13:33](https://youtu.be/YEI5yYOPVus?t=813) Approach 1: Brute Force Nested Loop — O(n²)

```python
for index, value in enumerate(nums):
    for j in range(index + 1, len(nums)):
        if value == nums[j]:
            return True
return False
```

### [53:40](https://youtu.be/YEI5yYOPVus?t=3220) How it works

- Outer loop: iterate through each value with its index.
- Inner loop: compare against all subsequent values.
- If any pair matches, return `True`.
- Otherwise, return `False` after the loops complete.

### [24:46](https://youtu.be/YEI5yYOPVus?t=1486) Result

- **Passes 65 of 77 test cases** before hitting LeetCode's time limit on the larger inputs (10,000+ elements).
- **Time:** O(n²)
- **Space:** O(1)

### [12:32](https://youtu.be/YEI5yYOPVus?t=752) Lesson: time limit exceeded ≠ wrong solution

You got the right answer for the cases that ran. The solution is correct, just inefficient. This is your cue to look for a better approach.

> **In the joy of coding tech interview** (HackerRank easy problems), brute force usually passes. **In real job interviews and on LeetCode mediums/hards**, you'll often need to optimize past brute force.

### [7:31](https://youtu.be/YEI5yYOPVus?t=451) Coach's recommendation

If your brute force passes at least **two-thirds of the test cases**, you've proven you understand the problem. Now go look at the Solutions tab or your toolkit of efficient techniques.

---

## [53:40](https://youtu.be/YEI5yYOPVus?t=3220) Approach 2: Sort + Adjacent Comparison — O(n log n)

```python
nums.sort()
for i in range(len(nums) - 1):
    if nums[i] == nums[i + 1]:
        return True
return False
```

### [16:55](https://youtu.be/YEI5yYOPVus?t=1015) [approx] How it works

- Sort the array (O(n log n)).
- Walk through with index `i`, comparing each value to the next one.
- Stop at `len(nums) - 1` to avoid index out of bounds.
- If any adjacent pair matches, return `True`.

### [19:20](https://youtu.be/YEI5yYOPVus?t=1160) [approx] Result

- **Passes all test cases.**
- **Time:** O(n log n) — sort dominates.
- **Space:** O(1) for the sort (in-place) or O(n) depending on the implementation.

### [26:34](https://youtu.be/YEI5yYOPVus?t=1594) `sort()` vs `sorted()`

- `nums.sort()` mutates the list **in place** and returns `None`.
- `sorted(nums)` returns a **new sorted list** without mutating the original.

If you write `sorted_nums = nums.sort()`, you get `None` stored in `sorted_nums` because the method has no return value. This trips people up. Use `sorted_nums = sorted(nums)` if you want a new copy.

### [29:30](https://youtu.be/YEI5yYOPVus?t=1770) Can you import libraries in tech interviews?

- **Built-in functions** (`sort`, `sorted`, `min`, `max`, `len`, etc.) are always fine.
- **Importing libraries** is usually allowed but adds overhead — you have to know how to use them and remember the import syntax.
- For Joy of Coding, stick with built-ins unless you genuinely need a library.

---

## [26:35](https://youtu.be/YEI5yYOPVus?t=1595) [approx] Approach 3: Set With Add and Check — O(n)

```python
seen = set()
for value in nums:
    if value in seen:
        return True
    seen.add(value)
return False
```

### [40:50](https://youtu.be/YEI5yYOPVus?t=2450) How it works

- Build a set as you go.
- For each value, check if it's already in the set.
- If yes → duplicate found, return `True`.
- If no → add it to the set and continue.

### [31:25](https://youtu.be/YEI5yYOPVus?t=1885) [approx] Why this is O(n)

- Single loop: O(n).
- `value in set` is **O(1)** (hash lookup, not linear scan).
- `set.add(value)` is also O(1).
- Inside an O(n) loop, all operations are O(1) → **O(n) overall**.

### [33:50](https://youtu.be/YEI5yYOPVus?t=2030) [approx] `in` is O(n) for lists, O(1) for sets

This is a critical distinction:

- `value in some_list` → linear scan, O(n)
- `value in some_set` → hash check, O(1)
- `key in some_dict` → hash check, O(1)

Sets use **hashing** under the hood. The value's hash determines its index, so checking membership is a constant-time index lookup, not a comparison against every element.

---

## [36:15](https://youtu.be/YEI5yYOPVus?t=2175) [approx] Approach 4: One-Line Set Comparison (Lisa's idea) — O(n)

```python
return len(set(nums)) != len(nums)
```

### [40:24](https://youtu.be/YEI5yYOPVus?t=2424) How it works

- `set(nums)` creates a set from the list, which automatically removes duplicates.
- If the resulting set is **shorter** than the original list, there were duplicates.
- Compare lengths and return the boolean.

### [17:48](https://youtu.be/YEI5yYOPVus?t=1068) Big-O

- `set(nums)` is **O(n)** (one pass through the list to insert into the set).
- `len()` calls are **O(1)**.
- **Overall: O(n)**, same as Approach 3.

### [26:31](https://youtu.be/YEI5yYOPVus?t=1591) Why this is the elegant winner

- One line.
- Uses Python's built-in set semantics to do the heavy lifting.
- No explicit loop, no early-return logic, no extra variables.
- Reads almost like the problem statement: "if the unique values are fewer than all values, there's a duplicate."

### [45:56](https://youtu.be/YEI5yYOPVus?t=2756) [approx] Real-world performance comparison

| Approach | Runtime |
|---|---|
| Brute force O(n²) | ~70 ms (when it passes) |
| Sort + check O(n log n) | ~25 ms |
| Set with add/check O(n) | ~18 ms |
| `len(set) != len(list)` O(n) | ~11 ms |

> "It's rare that the most efficient solution is also shorter than the alternatives. This problem is one of those rare cases."

---

## [57:49](https://youtu.be/YEI5yYOPVus?t=3469) Memory Trade-Off

The set-based approaches use **O(n) space** because they store every unique value. The sort and brute force approaches use **O(1)** extra space.

LeetCode shows your memory usage compared to peers. If you go with a set approach, your runtime is faster but your memory usage is higher.

For most problems, **runtime matters more than memory**. Pick the faster solution unless memory is explicitly constrained.

---

## [53:49](https://youtu.be/YEI5yYOPVus?t=3229) Confused Adam: "Why use enumerate?"

A participant pointed out that `enumerate(nums)` is functionally identical to `for i in range(len(nums))` followed by `nums[i]`. Why use `enumerate`?

### [53:34](https://youtu.be/YEI5yYOPVus?t=3214) Answer

- **Same efficiency** — both are O(n) and do the same thing under the hood.
- `enumerate` is **cleaner syntax** — gives you both the index and the value in one expression.
- Personal preference. Use whichever reads better for you.

> "I just kind of liked it because it's it separates out the index from the value, but it's the exact same level of efficiency."

---

## [52:08](https://youtu.be/YEI5yYOPVus?t=3128) Encouragement: Try the Problems After the Session

Even though all four approaches were walked through live, **try them yourself from memory**. The muscle memory of typing them out, debugging the small mistakes, and making them work is what builds your speed.

> "I always encourage everyone to try these problems on your own. So even though we've gone over these four different approaches, I still think it'll be a good effort for you all to try them on your own so that you get that kind of muscle memory."

---

## [10:12](https://youtu.be/YEI5yYOPVus?t=612) Coming Up: Top K Frequent Elements

The other Sunday problem. The constraint says "your solution must be **better than O(n log n)**" — which rules out sort-based approaches. Try this one before the next session.

> "It kind of implies that there are many solutions of varying O complexities that are better than N log of N."
