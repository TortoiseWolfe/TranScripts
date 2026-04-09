# Solutions Deep Dive — Two Sum: Optimal Hashmap Solution (2025-06-25)
Source: https://youtu.be/FxIUSmfXe94

Wednesday session: revisiting Two Sum after a 2-week gap. Brian shares the dictionary/hashmap solution achieving O(n) runtime.

---

## [8:33](https://youtu.be/FxIUSmfXe94?t=513) Quick recap: Two Sum problem

Given `nums` (list of integers) and `target` (integer), return the indices of the two numbers that add up to `target`. Exactly one solution exists. Cannot use the same index twice.

### [10:33](https://youtu.be/FxIUSmfXe94?t=633) Key facts pulled from Sunday's pseudo code

- We will always find a solution → never return empty.
- Array is **not guaranteed sorted** (example 2 has `[3, 2, 4]`).
- Integer values can be **negative**.
- Cannot reuse the same index.

---

## [17:33](https://youtu.be/FxIUSmfXe94?t=1053) Approach 1: Brute Force with Complement Variation

Original brute force used `nums[i] + nums[j] == target`. The complement variation is conceptually clearer:

```python
for i in range(len(nums)):
    complement = target - nums[i]
    for j in range(i + 1, len(nums)):
        if nums[j] == complement:
            return [i, j]
```

### [43:15](https://youtu.be/FxIUSmfXe94?t=2595) Complexity

- **Time:** O(n²) — outer loop O(n), inner linear search O(n).
- **Space:** O(1) — only storing a single `complement` variable. Variables, comparisons, and loop counters are all constant space.

> Space complexity refers to memory used. Creating an array or modifying a data structure changes space to O(n). Single variables = O(1).

### [13:16](https://youtu.be/FxIUSmfXe94?t=796) [approx] Python comment trick

Use triple apostrophes `'''...'''` for multi-line block comments instead of `#` on every line.

---

## [16:36](https://youtu.be/FxIUSmfXe94?t=996) [approx] Approach 2: Brian's Hashmap Solution (the optimal answer)

```python
def twoSum(self, nums, target):
    d = {}
    for count, num in enumerate(nums):
        if target - num in d:
            return [d[target - num], count]
        d[num] = count
```

### [32:51](https://youtu.be/FxIUSmfXe94?t=1971) How it works

- `enumerate(nums)` gives back `(index, value)` pairs in a single iteration, no need for `for i in range(len(nums))` + `nums[i]`.
- For each value, check whether its **complement** (`target - num`) is already in the dictionary.
- If yes → return `[d[complement], current_index]`.
- If no → store `num → index` in the dictionary and continue.

### [37:09](https://youtu.be/FxIUSmfXe94?t=2229) Walkthrough on `[3, 2, 4]`, target 6

| Step | index | num | dict before | complement | in dict? | dict after |
|---|---|---|---|---|---|---|
| 1 | 0 | 3 | `{}` | 3 | no | `{3: 0}` |
| 2 | 1 | 2 | `{3: 0}` | 4 | no | `{3: 0, 2: 1}` |
| 3 | 2 | 4 | `{3: 0, 2: 1}` | 2 | **yes** | return `[1, 2]` |

### [26:33](https://youtu.be/FxIUSmfXe94?t=1593) [approx] Complexity

- **Time:** O(n) — single pass.
- **Space:** O(n) — dictionary can grow up to n entries.
- **Runtime:** ~0 milliseconds on LeetCode.

### [13:36](https://youtu.be/FxIUSmfXe94?t=816) Why dictionary instead of set?

- A set could confirm "complement exists," but you also need its **index**.
- A dictionary stores `value → index`, giving you both pieces of information in one lookup.

### [3:00](https://youtu.be/FxIUSmfXe94?t=180) `enumerate` trick

`enumerate(iterable, start=N)` lets you set the starting index. Default is 0. You can also rename for clarity: `for index, value in enumerate(nums)`.

---

## [36:31](https://youtu.be/FxIUSmfXe94?t=2191) [approx] Big-O Comparison Table

| Approach | Time | Space | Notes |
|---|---|---|---|
| Brute force | O(n²) | O(1) | Always works, slow |
| Linear search for complement | O(n²) | O(1) | Same as brute force |
| Sort + binary search | O(n log n) | O(1) | Need to sort first; loses original indices |
| Two pointers | O(n log n) | O(1) | Needs sorted array; index-loss problem |
| **Hashmap** | **O(n)** | **O(n)** | **Optimal** |

### [44:08](https://youtu.be/FxIUSmfXe94?t=2648) Important Big-O insight

A binary search **inside** a loop is `O(n × log n) = O(n log n)`, **not** `O(n²)` and **not** `O(n² log n)`. Multiplication of nested complexities, not addition.

### [47:15](https://youtu.be/FxIUSmfXe94?t=2835) Two-pointer caveat

Two-pointer would be O(n) **on a sorted input**. Since Two Sum gives unsorted input, sorting it first puts you back at O(n log n). The hashmap approach beats it because it doesn't require sorting.

---

## [46:29](https://youtu.be/FxIUSmfXe94?t=2789) [approx] Why Big-O Keeps Coming Up

- **Joy of Coding interview:** won't be quizzed on Big-O for a grade.
- **Job hunt interviews:** Big-O is commonly asked. Being able to explain time/space complexity confidently is a major plus.
- Practice talking through approaches **using Big-O language** so it's natural by the time you need it.

---

## [49:48](https://youtu.be/FxIUSmfXe94?t=2988) [approx] Cheat Sheets in Tech Interviews

Q: "Can I bring a cheat sheet?"

- **OK:** small syntax snippets (basic for loop syntax, modulus operator examples).
- **Not OK:** full or partial solutions (e.g., a binary search implementation written out).
- Time spent reviewing a cheat sheet during the interview is time taken away from solving the problem.
- An easy problem can be solved in 7 minutes with practice — 20 minutes feels long until you're in the seat.

---

## [53:07](https://youtu.be/FxIUSmfXe94?t=3187) [approx] Homework: Three Sum

Try Three Sum (LeetCode #15):

- Given an integer array, return all triplets `[nums[i], nums[j], nums[k]]` where `i ≠ j ≠ k` and the three values sum to **zero**.
- Returns the **values** themselves (not indices), and there can be multiple valid triplets.
- Empty return is valid if no triplet exists.
- You now have brute force, two-pointer, and hashmap techniques to apply.

Both Two Sum and Three Sum are still actively used in real tech interviews — getting comfortable with both is a high-value investment.
