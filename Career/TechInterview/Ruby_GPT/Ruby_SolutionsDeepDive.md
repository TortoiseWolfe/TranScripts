# Make-Up Session — Two Pointers on Ice Cream Parlor (2025-07-27)

A long-overdue make-up session: implementing the **two-pointer** approach on the Ice Cream Parlor problem. (Binary search version still pending — saved for next session.)

---

## Problem Recap: Ice Cream Parlor

Two friends pool money `m`. Given a list of ice cream costs, return the **one-based indices** of the two distinct flavors that sum exactly to `m`. There will always be a valid solution.

### Key constraints

- `m`: 2 to 10⁴.
- `n` (length of cost array): 2 to 10⁴.
- Cost values: 1 to 10⁴.
- Always exactly one valid solution.
- Two indices must be **distinct** but the **values** can repeat.

---

## Brute Force Recap (Nested Loop)

```python
for index, value in enumerate(cost, 1):
    for j in range(index, len(cost)):
        if value + cost[j] == m:
            return [index, j + 1]
```

- `enumerate(cost, 1)` for one-based outer index.
- `range(index, len(cost))` for the inner loop (zero-based, since `cost[j]` uses zero-based access).
- Add `+1` to `j` when returning to convert to one-based.
- **Time:** O(n²)
- **Space:** O(1)

### Important indexing nuance

`enumerate(cost, 1)` gives a one-based **counter**, but the underlying list `cost` is still zero-based. When you mix `enumerate` with raw `cost[j]` access, you have to mentally track which is which. **Print everything to verify.**

---

## Two-Pointer Implementation

### Why this problem needs sorting first

Two pointers requires a condition to decide which pointer to move. Here, the condition is "is `cost[left] + cost[right]` greater than or less than `m`?" That comparison only makes sense if the values are **sorted**.

```python
sorted_cost = sorted(cost)  # don't mutate the original
left = 0
right = len(sorted_cost) - 1

value_one = 0
value_two = 0

while left < right:
    if sorted_cost[left] + sorted_cost[right] == m:
        value_one = sorted_cost[left]
        value_two = sorted_cost[right]
        break
    elif sorted_cost[left] + sorted_cost[right] > m:
        right -= 1
    else:
        left += 1
```

### Why `sorted()` instead of `cost.sort()`

- `cost.sort()` mutates the original list **in place** → destroys the original indices.
- `sorted(cost)` returns a **new sorted list**, leaving `cost` unchanged.
- We need the **original** array to look up the **original** indices of our found values.

> **Bug discovered during the live coding:** The coach initially used `cost.sort()`, found the right values, but then returned wrong indices because the indices in the sorted array don't match the original. Fix: switch to `sorted(cost)` and store the result in a separate variable.

### Recovering the original indices

```python
answer = []
for index, value in enumerate(cost, 1):
    if value == value_one:
        answer.append(index)
    elif value == value_two:
        answer.append(index)
return answer
```

### Why `elif` instead of two separate `if`s

If both target values are the same (e.g., `[2, 2]` summing to 4), two separate `if` statements would both fire on the same value and return the same index twice. Using `elif` ensures each iteration only matches one of the two targets, so you get two **distinct** indices.

---

## Big-O Analysis

- **Sort:** O(n log n)
- **Two-pointer loop:** O(n)
- **Index recovery loop:** O(n)
- **Overall:** O(n log n)

### Why this is barely better than brute force

Brute force was O(n²), and the two-pointer approach is O(n log n). On the Big-O graph, that's a meaningful improvement on paper. But for this problem specifically, you have to write **way more code** (sort + two-pointer + index recovery), so the actual runtime gain is marginal compared to just nesting two loops.

### When two-pointer really shines

Two pointers is genuinely O(n) **when the input is already sorted** and you don't need to recover original indices. Container With Most Water (a previous problem) is the classic example — the input doesn't need to be sorted because the conditions for moving pointers depend on heights, not sums.

---

## The Lesson: Knowing the Algorithm vs Using It

Even though two-pointer wasn't the **best** solution for Ice Cream Parlor, the implementation exercise teaches:

- How to write the **truthy case** (the condition for "we found it").
- How to write the **conditions** that decide which pointer moves.
- How to **modify a standard algorithm** to fit a problem's quirks (like needing to recover original indices via a second loop).

> "We can modify an algorithm to meet our use cases if it's something that we know would work or meet the goal."

---

## Two-Pointer Template

```python
left = 0
right = len(arr) - 1

while left < right:
    if [truthy condition]:
        return [solution]
    elif [condition to shrink right]:
        right -= 1
    else:
        left += 1
```

- **Loop condition:** `while left < right` — stops when pointers meet or cross.
- **Truthy case:** the win condition. Return immediately.
- **Two condition cases:** decide which pointer moves based on the data.

### Things to debug

- **Index out of range:** initial `right` should be `len(arr) - 1`, not `len(arr)`.
- **Wrong indices returned:** check whether you're using a sorted view or the original.
- **Infinite loop:** make sure both branches actually move a pointer.

---

## Errors as Friends (Debugging Walk-Through)

### Bug 1: index out of range

Initial `right = len(cost)` instead of `len(cost) - 1`. Caused an out-of-bounds access.

### Bug 2: returning indices from sorted array, not original

After fixing bug 1, the function returned `[1, 3]` instead of `[1, 4]`. The values were correct but the indices were from the sorted view.

**Diagnosis:** print `left, right, sorted_cost[left], sorted_cost[right]` and compare against the unsorted `cost` array. Realized the indices were from the sorted view.

**Fix:** use `sorted(cost)` to keep both versions, then do a second loop on the original to recover the original indices.

### Bug 3: visual confusion from a "find" highlight

The coach accidentally had Ctrl+F find-mode active in the editor, which highlighted random text and made it hard to see what was wrong. Took several minutes to notice. **Lesson:** if the editor is acting weird, check for stray modal states.

---

## Plan for Next Session

- **Binary search** implementation on the same Ice Cream Parlor problem.
- Will dive straight in without the long buildup since the problem is now well-understood.
- Goal: see binary search applied to a real problem, not just as an isolated Mod 2 exercise.

> "Today's point is just seeing that implementation of two pointer in the context of this problem so that you can learn how to use it in unique and variety of ways."


---

# Solutions Deep Dive — Birthday Cake Candles & Container With Most Water (2025-06-04)

Wednesday session: solutions and alternative approaches for Sunday's two problems. Schedule reminder: Sundays = Q&A + pseudo code + mock interview; Wednesdays = solution deep dives.

---

## Q&A

### What if you can't finish a tech interview problem in time?

Outcomes vary by company. Many people don't finish all problems and still advance. Interviewers value:

- Confidence speaking out loud and presenting your thought process.
- Ability to break the problem into steps and communicate them.
- Understanding what the problem is asking, even without mastering the execution.

This is also why Big-O comes up in these sessions — being able to explain concepts at that level helps determine eligibility to move forward.

---

## Problem 1: Birthday Cake Candles (easy) — solution

**Two-step solution:**

1. Find the **max** value in the candles array → `max(candles)` is O(n).
2. **Count** occurrences of that max → `candles.count(candle_max)` is O(n).

```python
candle_max = max(candles)
return candles.count(candle_max)
```

### Big-O note

Two separate O(n) operations = O(2n), which simplifies to **O(n)**. Constants are dropped in Big-O. You *could* combine into a single pass for one O(n), but two passes is fine — clarity beats marginal efficiency on an easy problem.

### Bonus question: how to find the second max?

- Two-variable approach: track `max` and `second_max`, single pass.
- Or sort the array and take the second-from-last position.

> Note: `max - 1` doesn't work — second-highest may be far below the max (e.g., max 13, second max 5).

---

## Problem 2: Container With Most Water (medium) — brute force solution

**Approach:** nested loop, calculate area for every pair `(i, j)`, track the max.

### Setup

- `n = len(height)`
- Outer loop: `for i in range(n)`
- Inner loop: `for j in range(i+1, n)` — second pointer always after the first to avoid duplicate pairs.
- For each pair, calculate area and update the running max.

### Calculating the area

- **Container length** = `j - i` (distance between the two indices on the x-axis).
- **Container height** = `min(height[i], height[j])` — must use the **shorter** of the two walls because water can't slant.
- **Container area** = `length × height`.

> Common bug: writing `j - 1` instead of `j - i` for the length. Test cases may *appear* to pass while still being wrong — print and verify each intermediate value.

### Updating the max

```python
water_area = container_area if container_area > water_area else water_area
```

### Result

- Brute force gets **55/65 test cases passing** before hitting the time limit.
- That's confirmation the logic is correct — just too slow.
- Big-O = **O(n²)** because of the nested loops.

### Iterative testing discipline

Print at every intermediate step:

- The `i` and `i, height[i]` pair.
- The `i, j` pairs being generated.
- The `container_length` and `container_height`.
- The `container_area`.

If you only print the final area and there's a bug upstream, debugging is much harder. The coach skipped printing length/height in this walkthrough and the `j - 1` bug went unnoticed for several minutes.

---

## Problem 2: Optimized — Two-Pointer Approach

Brute force is O(n²). The optimal solution is **O(n)** using **two pointers**.

### When to consider two pointers

- You see an O(n²) brute force using two nested loops.
- The data has some monotonic property (here: max area must use the **tallest** lines, so smaller heights can be discarded as you scan).
- Two pointers is **not** a universal replacement for nested loops — it depends on whether the problem has a structure that lets one pointer move at a time.

### Setup

- `i = 0`, `j = len(height) - 1`
- Loop: `while i < j`
- One pointer moves per iteration, not both.

### The condition that decides which pointer moves

Move whichever pointer is at the **shorter** vertical line. The shorter wall is what's limiting the area, so discarding it (and hoping for a taller one) is the only way to find a larger area.

```python
if height[i] < height[j]:
    i += 1
else:
    j -= 1
```

### Why this works

- The container area is bounded by the shorter wall.
- Moving the taller pointer can only ever reduce the length while keeping the height bound the same → can't improve.
- Moving the shorter pointer is the only move that has a chance of finding a taller wall and increasing the area.

### Verification advice

> Don't copy/paste solution code from LeetCode. Read through it, understand the approach, then close the tab and reimplement from scratch. Only look at solutions after you've gotten **at least two-thirds of the test cases passing** with brute force — that proves you understand the problem.

---

## General Lessons

- **Brute force first.** Even if you know the optimized solution, write the brute force to confirm understanding and unlock test cases.
- **Print everything as you go.** Errors can be subtle and look correct at one layer while breaking another.
- **Two-thirds passing = move on.** Once brute force gets you most of the test cases, you've demonstrated understanding. Then optimize or look at solutions.
- LeetCode has an **Analyze Complexity** button that uses AI to estimate Big-O — limited daily uses but useful as a sanity check.

[REVIEW: brief moment where coach noted printing both index and value side-by-side caused confusion for one participant; mostly a UI/zoom issue — kept the lesson about printing both for context.]


---

# Solutions Deep Dive — Two Sum: Approaches & Pseudo Code (2025-06-11)

Wednesday session: deep dive on Two Sum, comparing brute force, search-based, two-pointer, and set-based approaches. **No coding today** — focus is on the pseudo-code and approach-evaluation phase.

---

## Recap: Two Sum problem statement

Given array `nums` and integer `target`, return the **indices** of two numbers that add up to `target`. Exactly one solution exists. Cannot use the same index twice.

### Pseudo code from Sunday

- We are given an array `nums` and `target` (integer).
- Find two separate indices in `nums` whose values sum to `target`.
- Only two values will be summable.
- Integer values can be **negative**.
- Constraints imply we'll always find a solution (length ≥ 2 + exactly one solution exists) → never return empty.
- The array is **not guaranteed sorted** (one example has `[3, 2, 4]`).
- "Cannot use same element twice" → cannot use the same **index** twice (same value at different indices is fine).
- Return order of indices does not matter.

> **Key habit:** leave your pseudo code in a state where you don't need to re-read the problem description. Pull all the meaningful statements (from prose, examples, and constraints) into your own words at the top.

---

## Approach 1: Brute Force (Daniel's submission)

```python
for i in range(len(nums)):
    for j in range(i + 1, len(nums)):
        if nums[i] + nums[j] == target:
            return [i, j]
```

- **Complexity:** O(n²)
- All test cases pass, but runtime ~2 seconds — way slower than peers.
- LeetCode's "Analyze Complexity" button confirms O(n²) (limited to ~2 free clicks/day).

---

## Approach 2: Sort + Binary Search

**Idea:** for each value, compute the **complement** (`target - current`) and search the array for it.

### Why sort first?

- **Linear search** for the complement is O(n) → overall O(n²). No improvement.
- **Binary search** is O(log n) → overall O(n log n). Better than O(n²).
- But binary search **requires a sorted array**.

### Sort vs sorted in Python

- `nums.sort()` → mutates the original array, returns `None`. Can only be called on lists.
- `sorted(nums)` → returns a new sorted list, original is unchanged. Works on any iterable (lists, tuples, strings, dicts, sets).
- Both use the same **Timsort** algorithm (combination of merge sort and insertion sort) — O(n log n).

> Use `sorted()` here so you can keep the original `nums` for index lookup.

### The index problem

Sorting destroys the original index positions, but the answer requires original indices. After finding the matching values in the sorted array, you need a second linear pass through the original `nums` to recover their indices. (Or use `enumerate` to track original positions during sort.)

### Verdict on this approach

- **Complexity:** O(n log n)
- Requires knowing how to write binary search (or asking the interviewer if you can use a template).
- Many steps to code, marginal improvement over brute force in real terms.
- For the Joy of Coding technical interview: probably not worth it.

---

## Approach 3: Two Pointers

- Worked great for Container With Most Water last week, but **only because that problem doesn't care about index order**.
- Two Sum needs a comparison against a target, which means you'd need a less-than/greater-than condition to decide which pointer to move.
- That decision **only makes sense if the array is sorted**.
- So two pointers also requires sorting → also O(n log n).
- About the same efficiency as the binary search approach, slightly easier to implement.

---

## Approach 4: Hashmap / Set Lookup (the optimal solution)

**Insight from the chat:** sets (and dicts) have **O(1) lookup**, insertion, and deletion.

### The algorithm

```python
seen = {}                          # value -> index
for i, num in enumerate(nums):
    complement = target - num
    if complement in seen:
        return [seen[complement], i]
    seen[num] = i
```

- For each value, check whether its complement is already in the set/dict.
- If yes → we found the pair, return both indices.
- If no → add the current value (and its index) to the set/dict and continue.

### Complexity

- **Time:** O(n) — single pass through the array.
- **Space:** O(n) — the lookup structure can grow up to the size of the input.

### Why a dict instead of a set?

- A **set** can confirm whether the complement exists, but doesn't store the original index.
- A **dict** maps `value → index`, so when you find a complement you can return both indices immediately.
- Using `enumerate` in the loop gives you the index of the current value cleanly.

### Negative numbers?

Works fine. Subtraction and addition behave normally with negatives — the only operations that would get tricky are multiplication or division.

---

## The Bigger Lesson: Pseudo Code Before Code

Today's session deliberately had **zero coding** for almost the entire hour. Why?

- For a medium-difficulty problem, spend ~20 minutes on pseudo code and approach evaluation, then code in ~10 minutes.
- That beats spending 30+ minutes thrashing through one approach in code, hitting walls, and rewriting from scratch.
- Compare approaches **on paper** first:
  - Brute force → O(n²), works but slow
  - Sort + binary search → O(n log n), complex to implement
  - Two pointers → needs sorting, ends up O(n log n)
  - Hashmap → O(n), clean implementation

Once you've evaluated the trade-offs, pick the best one and code it confidently — instead of iterating through approaches in code.

---

## Reddit thread observation

> A CS-degree holder admitted Two Sum was hard for them and they had to Google hints and learn about hashmaps from scratch.

The point: even people with formal CS degrees struggle with these problems. The advantage Joy of Coding students have is that **all of these techniques** (binary search, sets, two pointers, brute force, Big-O) are covered in mods 1 and 2 and reinforced in these weekly sessions.

---

## Joy of Coding Tech Interview vs Job Hunt Interviews

- **Joy of Coding interview:** easy-level problems. Don't need to master mediums.
- **Job hunt interviews:** medium and hard problems are common. Working up to this level matters.
- The **process** (read problem, pull observations, write pseudo code, evaluate approaches, code with print statements, test iteratively) is the same regardless of difficulty.


---

# Solutions Deep Dive — Two Sum: Optimal Hashmap Solution (2025-06-25)

Wednesday session: revisiting Two Sum after a 2-week gap. Brian shares the dictionary/hashmap solution achieving O(n) runtime.

---

## Quick recap: Two Sum problem

Given `nums` (list of integers) and `target` (integer), return the indices of the two numbers that add up to `target`. Exactly one solution exists. Cannot use the same index twice.

### Key facts pulled from Sunday's pseudo code

- We will always find a solution → never return empty.
- Array is **not guaranteed sorted** (example 2 has `[3, 2, 4]`).
- Integer values can be **negative**.
- Cannot reuse the same index.

---

## Approach 1: Brute Force with Complement Variation

Original brute force used `nums[i] + nums[j] == target`. The complement variation is conceptually clearer:

```python
for i in range(len(nums)):
    complement = target - nums[i]
    for j in range(i + 1, len(nums)):
        if nums[j] == complement:
            return [i, j]
```

### Complexity

- **Time:** O(n²) — outer loop O(n), inner linear search O(n).
- **Space:** O(1) — only storing a single `complement` variable. Variables, comparisons, and loop counters are all constant space.

> Space complexity refers to memory used. Creating an array or modifying a data structure changes space to O(n). Single variables = O(1).

### Python comment trick

Use triple apostrophes `'''...'''` for multi-line block comments instead of `#` on every line.

---

## Approach 2: Brian's Hashmap Solution (the optimal answer)

```python
def twoSum(self, nums, target):
    d = {}
    for count, num in enumerate(nums):
        if target - num in d:
            return [d[target - num], count]
        d[num] = count
```

### How it works

- `enumerate(nums)` gives back `(index, value)` pairs in a single iteration, no need for `for i in range(len(nums))` + `nums[i]`.
- For each value, check whether its **complement** (`target - num`) is already in the dictionary.
- If yes → return `[d[complement], current_index]`.
- If no → store `num → index` in the dictionary and continue.

### Walkthrough on `[3, 2, 4]`, target 6

| Step | index | num | dict before | complement | in dict? | dict after |
|---|---|---|---|---|---|---|
| 1 | 0 | 3 | `{}` | 3 | no | `{3: 0}` |
| 2 | 1 | 2 | `{3: 0}` | 4 | no | `{3: 0, 2: 1}` |
| 3 | 2 | 4 | `{3: 0, 2: 1}` | 2 | **yes** | return `[1, 2]` |

### Complexity

- **Time:** O(n) — single pass.
- **Space:** O(n) — dictionary can grow up to n entries.
- **Runtime:** ~0 milliseconds on LeetCode.

### Why dictionary instead of set?

- A set could confirm "complement exists," but you also need its **index**.
- A dictionary stores `value → index`, giving you both pieces of information in one lookup.

### `enumerate` trick

`enumerate(iterable, start=N)` lets you set the starting index. Default is 0. You can also rename for clarity: `for index, value in enumerate(nums)`.

---

## Big-O Comparison Table

| Approach | Time | Space | Notes |
|---|---|---|---|
| Brute force | O(n²) | O(1) | Always works, slow |
| Linear search for complement | O(n²) | O(1) | Same as brute force |
| Sort + binary search | O(n log n) | O(1) | Need to sort first; loses original indices |
| Two pointers | O(n log n) | O(1) | Needs sorted array; index-loss problem |
| **Hashmap** | **O(n)** | **O(n)** | **Optimal** |

### Important Big-O insight

A binary search **inside** a loop is `O(n × log n) = O(n log n)`, **not** `O(n²)` and **not** `O(n² log n)`. Multiplication of nested complexities, not addition.

### Two-pointer caveat

Two-pointer would be O(n) **on a sorted input**. Since Two Sum gives unsorted input, sorting it first puts you back at O(n log n). The hashmap approach beats it because it doesn't require sorting.

---

## Why Big-O Keeps Coming Up

- **Joy of Coding interview:** won't be quizzed on Big-O for a grade.
- **Job hunt interviews:** Big-O is commonly asked. Being able to explain time/space complexity confidently is a major plus.
- Practice talking through approaches **using Big-O language** so it's natural by the time you need it.

---

## Cheat Sheets in Tech Interviews

Q: "Can I bring a cheat sheet?"

- **OK:** small syntax snippets (basic for loop syntax, modulus operator examples).
- **Not OK:** full or partial solutions (e.g., a binary search implementation written out).
- Time spent reviewing a cheat sheet during the interview is time taken away from solving the problem.
- An easy problem can be solved in 7 minutes with practice — 20 minutes feels long until you're in the seat.

---

## Homework: Three Sum

Try Three Sum (LeetCode #15):

- Given an integer array, return all triplets `[nums[i], nums[j], nums[k]]` where `i ≠ j ≠ k` and the three values sum to **zero**.
- Returns the **values** themselves (not indices), and there can be multiple valid triplets.
- Empty return is valid if no triplet exists.
- You now have brute force, two-pointer, and hashmap techniques to apply.

Both Two Sum and Three Sum are still actively used in real tech interviews — getting comfortable with both is a high-value investment.


---

# Solutions Deep Dive — Maximum Product Subarray (2025-07-02)

Wednesday session: mock interview on LeetCode's **Maximum Product Subarray** (medium, 35% acceptance rate). Volunteer: Lisa.

---

## Problem statement

Given an integer array `nums`, find the **subarray** with the **largest product** and return the product.

### Definitions

- **Subarray:** a **contiguous** non-empty sequence of elements within an array. "Contiguous" = sharing a common border, touching, in sequence.
- A subarray can be any length from 1 up to the full array.
- Test cases are guaranteed to fit in a 32-bit integer.

### Examples

- `[2, 3, -2, 4]` → output `6` (subarray `[2, 3]`).
- `[-2, 0, -1]` → output `0` (since `-2` and `-1` are not contiguous, you can't multiply them; the only valid subarrays produce 0).

### Constraints

- Length of `nums`: 1 to ~20,000.
- Values: -10 to 10.

---

## Where Lisa got stuck (and the lesson)

### Initial confusion

Lisa (and most people on first read) assumed "product" meant "the multiplication of any two numbers in the array." That's why `2 * 3 = 6` made sense as the answer for example 1.

But then example 2 (`[-2, 0, -1]` → `0`) breaks that theory because `-2 * -1 = 2` would be larger than `0` if you could pair them.

**The key insight:** the problem says "**subarray** with the largest product." A subarray must be **contiguous**. `-2` and `-1` aren't touching (`0` is between them), so they can't form a subarray together.

### The lesson: write assumptions explicitly

Lisa's assumption was "product means multiplying two numbers." That's a fine starting assumption — but it should be **written down explicitly** so you can spot when it conflicts with the examples.

> "I would actually prefer you spend the entire technical interview doing pseudo code and getting some code written in the last two minutes, if that means your code is going to be rock solid."

---

## How to attack the problem

### Step 1: Restate in your own words

- We're looking for a product (multiplication result) of a **subarray** (contiguous sub-sequence) that produces the **largest number**.
- A subarray can be **multiple numbers**, not just two.

### Step 2: Use Google for unfamiliar terminology

Looking up "what is contiguous" is fair game in a tech interview. Looking up "how to solve maximum product subarray" is not.

### Step 3: Build your own test case

For `[2, 3, -2, 4]`, the examples are sparse. Build a more complex test case where the answer is a subarray **in the middle** of the array — that forces you to think beyond just pairs.

> **LeetCode pro tip:** you can directly edit the test case input fields to add your own. LeetCode will compute the expected output for you. HackerRank lets you input custom test cases but won't generate the expected output.

### Step 4: Walk through how the answer is computed

For `[2, 3, -2, 4]`:

- Touching pairs: `(2,3)=6`, `(3,-2)=-6`, `(-2,4)=-8`.
- Touching triples: `(2,3,-2)=-12`, `(3,-2,4)=-24`.
- All four: `2*3*-2*4 = -48`.
- Max = `6` ✓.

---

## Approach: Brute Force with Slicing

One viable approach (suggested in the chat):

```python
max_product = nums[0]
for i in range(len(nums)):
    for j in range(i + 1, len(nums) + 1):
        sub = nums[i:j]
        product = math.prod(sub)
        max_product = max(max_product, product)
return max_product
```

- Outer loop: start index `i`.
- Inner loop: end index `j` (slice end is exclusive, so `+1`).
- `nums[i:j]` is a list slice — the subarray.
- `math.prod(sub)` multiplies all elements.
- Track the running max.

### Complexity

- **Time:** O(n³) — nested loops O(n²) plus the `math.prod` O(n) inside.
- **Space:** O(n) for the slice.
- Will likely time out on larger test cases but proves the logic works on smaller ones.

### Why start with brute force

- Get any working solution first → confirms you understand the problem.
- Then optimize once you've passed some test cases.
- The optimal solution uses **dynamic programming** tracking running max and min (because two negatives can flip a min into a new max), but that's a significant leap from brute force.

---

## Pattern Recognition: Looking at Past Problems

When you don't know how to approach a new problem, ask: "Have I seen something similar before?"

- If you've solved a problem that built subarrays inside an original array, go look at that one.
- Two Sum and Three Sum work this way — Three Sum builds on Two Sum techniques.
- For Maximum Product Subarray, no obvious previous template applies, so you experiment with paper or comments first.

---

## Mock Interview Lessons (for Lisa)

### What Lisa did well

- Started with a paint program to draw out the problem visually.
- Wrote a stub `return` statement so the code would compile.
- Tried to test her assumption ("product means multiplication") in code.
- Asked clarifying questions about `self` and other syntax.

### What to improve

- **Spend longer in pseudo code before writing real code.** Getting a clear understanding of the problem is more valuable than getting code on the screen quickly.
- **Write down assumptions explicitly.** When the example contradicts an assumption, you'll know which one to revisit.
- **Use `range()` loops when you need control over indices.** A `for i in nums` loop iterates over **values**, not indices. If you want index `i + 1`, you need `for i in range(len(nums))`.

---

## On `self` in LeetCode functions

LeetCode wraps all problems in a `class Solution:` definition, so the function signatures include `self`. **Ignore `self`** in any LeetCode question — it's just Python class boilerplate, not part of the problem.

[REVIEW: extended discussion about Spanish keyboard quirks and one participant losing their pseudo code when accidentally switching languages — context for why the mock interview took so long.]


---

# Solutions Deep Dive — Missing Numbers, Ice Cream Parlor, and Big-O Walkthroughs (2025-07-09)

Wednesday session: solutions for Missing Numbers (Brian's hashmap approach + the group's offset approach), Natalia's Ice Cream Parlor dictionary attempt, and a thorough Big-O breakdown.

---

## Recap: Maximum Product Subarray (extra notes)

The coach felt last week's pseudo code left people with too little to go on. Extra notes for restarting that problem:

- **Initialize a product variable** with the sum/product of all values in the array as a starting baseline. If nothing else beats it, you've got a default answer.
- **Two-pointer concept** (not the literal algorithm) — start from both ends, work inward, calculate products of all subarrays in between.
- **You can't quit early** because of negative numbers. Two negatives multiplied together can flip the sign, so you have to check every subarray.
- This brute force is O(n²) — sliding window can do better.

### Sliding Window keywords

When you see all of these together, think **sliding window**:

- Indexes must be **touching** (contiguous).
- Looking at a **subarray**.
- Looking for a **sum or product**.

Lisa learned and used the sliding window approach for Maximum Product Subarray. The Geeks-for-Geeks article on it is O(n²) — there's a better implementation than what they show.

---

## Natalia's Ice Cream Parlor Solution (Dictionary Approach)

### Approach

Natalia recognized this as a Two Sum variant ("if you have a target value and need to find two values that sum to it, use a complement dictionary").

### Initial code issues and fixes

1. **One-based indexing:** use `enumerate(arr, 1)` — pass `1` as the second argument to start counting from 1 instead of 0.
2. **Empty return for HackerRank wrapper:** add `return []` outside the loop to avoid the `_FptrName_join(...)` error.
3. **Indentation bug:** the dictionary update line was indented inside the `if` block, so it never ran when the complement wasn't found. Move `d[value] = index` to the same indentation level as the `if`, still inside the `for` loop.

### Final shape

```python
d = {}
for index, value in enumerate(arr, 1):
    complement = m - value
    if complement in d:
        return [d[complement], index]
    d[value] = index
return []
```

### The fix that broke it

Submission gave a runtime error (not a time limit error) on one test case after the fixes. Worth investigating, but the approach is correct.

### Indentation lesson

> Python is **very** strict about indentation. Anything at the same indentation level as the body of an `if` is treated as part of that `if` block. Some other languages let you write a one-liner `if` followed by a separate next line — Python does not.

---

## Brian's Missing Numbers Solution (Counter / Frequency Map)

### Approach

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

### How `Counter` works

`collections.Counter` creates a dictionary-like object mapping values to their **frequency**. For `[7, 2, 5, 4, 6, 3, 5, 3]` it returns `{7: 1, 2: 1, 5: 2, 4: 1, 6: 1, 3: 2}`.

### Walkthrough

- Build frequency dicts for both arrays.
- Iterate through the original (longer) array.
- If a value's frequency doesn't match between the two dicts, it's missing.
- Append to a stack, then return the sorted unique values.

### Big-O breakdown

- `Counter(arr)` and `Counter(brr)`: each O(n) → O(2n) → **O(n)**.
- `for value in brr`: O(n).
- Inside the loop: dict lookup `count_a[value]` is O(1), comparison is O(1), append is O(1). All inside the O(n) loop → **O(n)**.
- `sorted(...)`: **O(n log n)** — this is the bottleneck.
- **Overall time:** O(n log n).
- **Space:** O(n) for the two dicts + O(n) for the stack.

> "The sorted kind of messes up your big O there, but otherwise it's pretty good."

---

## Big-O Reasoning Step by Step (Brian's session)

This was a real-time exercise in determining Big-O by inspection.

### Question: "Is the for loop O(n) or O(n²)?"

**Answer:** Depends on what's inside.

- **Accessing `arr[index]`** = O(1). Reading a single value from an array is constant time.
- **Comparing two single values** = O(1).
- **`stack.append(x)`** = O(1) amortized.
- **All O(1) inside an O(n) loop** = O(n) overall.
- O(n²) only happens when you have a **nested loop** over the array — e.g., `for i: for j: ...`.

### "But I'm comparing two arrays — isn't that O(n²)?"

No. Comparing **values from two arrays** is O(1) per comparison. You'd only get O(n²) if you wrote a nested loop where the inner loop traversed the second array fully for each element of the first.

### Big-O of common Python operations

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

### Why no O(n) sort exists

- General-purpose comparison sorts have a **theoretical lower bound** of O(n log n).
- "Binary sort" doesn't exist as a sorting algorithm — binary **search** is a search algorithm, and it's O(log n).
- Binary search appears **inside** sorting algorithms (e.g., for finding insertion points), which is one reason sorts come out to O(n log n) — n elements × log n comparisons each.

---

## The Group's Offset Approach (Coach's solution)

This was the approach the group had pseudo-coded a few weeks earlier. It's the brute force / non-hashmap version:

### Core idea

- Sort both arrays first.
- Walk through `brr` (the longer original) one element at a time.
- Compare to `arr[index - offset]`. When they don't match, the current `brr` value is missing — append it and bump the offset.
- Bonus: bounds-check to avoid going out of range when offset grows past `arr`'s length.

### Why sort first?

The hidden test cases on HackerRank are **not in order**. The original assumption ("the order will be the same") was false. Sorting both first lets the index-walk comparison work.

### Why this is worse than Brian's

- Sort A: O(n log n)
- Sort B: O(n log n)
- Walk: O(n)
- Sort the answer: O(n log n)
- **Three O(n log n) operations** vs Brian's **one** O(n log n) sort plus three O(n) operations.

### A weird Python set behavior

When you `set.add()` items into a Python set, the **order changes unpredictably** — sets are not ordered, and adding elements can rearrange the internal storage. That's why the coach had to call `sorted(...)` at the end even though the inputs had already been sorted.

> "Apple, banana, cherry. Add orange. Now it's `{orange, banana, cherry, apple}` or some other arrangement. Sets are not ordered."

---

## Hashmap vs Offset: Why Frequency Maps Are Safer

- **Frequency maps eliminate duplicate-tracking entirely** because the value is the key and the count is the value. There's only one entry per unique number.
- **Offset tracking** has to manually account for repeating numbers, bounds checks, and order assumptions — many places to introduce bugs.
- The hashmap approach is "more future-proof" even though it adds a bit of memory complexity.

---

## Memory vs Space Complexity

Big-O space complexity and actual memory usage are **not the same thing**:

- A hashmap is O(n) space, but **takes more bytes** than an O(n) list because dicts have hashing overhead.
- LeetCode/HackerRank report your memory usage compared to peers. A solution can have great Big-O space complexity but still use a lot of actual memory if the data structures involved are heavyweight.

---

## Plan for Next Session

Three named algorithms to focus on:

- **Two pointers**
- **Binary search**
- **Sliding window** (for the Maximum Product Subarray problem)

> "Even just knowing how these algorithms work can help you create and craft solutions to other problems in unique ways so that you can actually get your test cases passing."


---

# Solutions Deep Dive — Insert Interval & Merge Intervals (2025-07-23)

Wednesday session: Brian shares his clean O(n) solution for Insert Interval. The session also reveals that Merge Intervals is the natural prerequisite — they were covered in the wrong order.

---

## Q&A

### Should LeetCode solutions use object-oriented Python (classes)?

Adam noticed many LeetCode solutions used class-based Python (e.g., creating an `Interval` class). Are tech interview answers supposed to be class-based?

- **No** — for coding challenges, vanilla Python is the norm.
- Class-based code is for **longevity**: code expected to be maintained, tested, and updated over time.
- Some languages (Java) are inherently class-based; Python is not.
- Use the simplest solution that solves the problem.

### What if a problem requires math knowledge you don't have?

- Every problem should have a **brute force** solution that doesn't require special math tricks.
- Even using `mod` (modulus) is a "math trick" you learned and can now apply across many problems.
- If the optimal solution requires unfamiliar math, look it up after solving brute force. Decide whether the trick is worth memorizing (will it appear in other problems?).
- The coach prefers problems that need high school-level math, not advanced calculus.

---

## Brian's Insert Interval Solution

A clean O(n) single-loop solution. Key insight: Brian solved the **merge case** first, then handled the special insert cases around it.

```python
def insert(self, intervals, newInterval):
    ans = []
    for i in range(len(intervals)):
        if newInterval[0] > intervals[i][-1]:
            # New interval starts after current ends — add current as-is
            ans.append(intervals[i])
        elif newInterval[-1] < intervals[i][0]:
            # New interval ends before current starts — insert new + remainder
            return ans + [newInterval] + intervals[i:]
        else:
            # Overlap — merge
            newInterval = [
                min(newInterval[0], intervals[i][0]),
                max(newInterval[-1], intervals[i][-1])
            ]
    ans.append(newInterval)
    return ans
```

### Walking through `[[1, 3], [6, 9]]` + `[2, 5]`

| i | intervals[i] | newInterval | Branch | Action |
|---|---|---|---|---|
| 0 | `[1, 3]` | `[2, 5]` | `2 > 3`? No. `5 < 1`? No. **Else** | Merge: `min(2,1)=1`, `max(5,3)=5` → newInterval = `[1, 5]` |
| 1 | `[6, 9]` | `[1, 5]` | `1 > 9`? No. `5 < 6`? **Yes** | Return `ans + [[1,5]] + [[6,9]]` = `[[1,5], [6,9]]` ✓ |

### Why `[-1]` instead of `[1]`?

Brian's habit: when working with data structures where the **end** is significant, use `[-1]` to communicate intent. In this 2-element case, `[1]` would also work, but `[-1]` reads as "the last element" regardless of length.

### The clever return

```python
return ans + [newInterval] + intervals[i:]
```

When the new interval ends before the current interval starts (no more merging possible), this **slices the rest of intervals from `i` to the end** and concatenates. Saves writing a second loop just to copy the remainder.

### Wrapping the merged result in `[...]`

```python
newInterval = [min(...), max(...)]
```

Brian explicitly returns a list (not a tuple or unpacked values) so it can be appended to `ans` (a list of lists) without type errors. He had hit data-structure errors before adding the brackets.

### Big-O

- **Time:** O(n) — single loop, all operations inside are O(1).
- **Space:** O(n) — `ans` can grow up to n+1 entries.

Brian confirmed via LeetCode's "Analyze Complexity" button.

---

## Alternative Approach: Append + Sort + Merge

Coach demonstrates the "lazy" brute force version:

```python
intervals.append(newInterval)
intervals.sort()
# now merge any overlaps in the sorted list
```

### Why `sort()` works on lists of lists

Python's `sort()` and `sorted()` default to sorting by the **first element** of each sublist. For `[[1, 3], [4, 5], [2, 5]]`, sorting yields `[[1, 3], [2, 5], [4, 5]]` automatically.

You can override the sort key with a `lambda`:

```python
sorted(items, key=lambda x: x[1])  # sort by second element
```

### Why this is cheating (but useful)

This collapses the **insert** problem into a **merge** problem. Then you only need to solve "merge overlapping intervals," which is the simpler companion problem (see below).

---

## Two Approaches Side by Side

| Approach | Strategy |
|---|---|
| **Brian's** | Merge during the loop. Each iteration is either insert-current, insert-new-and-stop, or merge-with-current. |
| **Coach's** | Insert first (brute force), sort, then merge in a second pass. |

Both work. Brian's is more efficient (single pass). The coach's is more decomposed (split into simpler subproblems).

---

## Merge Intervals (the prerequisite the coach skipped)

The coach realized after the fact that **Merge Intervals** is the prerequisite to **Insert Interval**. They covered them in the wrong order.

### Problem statement

You're given an array of intervals. Some may overlap. Merge all overlapping intervals and return the result.

### Example

- Input: `[[1, 3], [2, 6], [8, 10], [15, 18]]`
- Output: `[[1, 6], [8, 10], [15, 18]]` (the first two merge)

### Solution sketch

This is essentially **just the merge logic from Brian's solution**. After sorting, walk through the list and merge adjacent overlapping intervals.

```python
intervals.sort()
ans = [intervals[0]]
for i in range(1, len(intervals)):
    if intervals[i][0] <= ans[-1][-1]:
        ans[-1][-1] = max(ans[-1][-1], intervals[i][-1])
    else:
        ans.append(intervals[i])
return ans
```

### Why it's also "medium" difficulty

Some students argue this should be easy because the logic is straightforward. The coach pushes back: index manipulation, comparing the right endpoints, and handling the merge in O(n) requires confidence that students fresh out of Mod 2 don't usually have.

---

## Errors as Friends

> "When you're first starting out, you're terrified of errors. But errors are kind of like your best friend. If everything's going smoothly, I almost don't trust it — something must be wrong."

Brian hit two errors during development:
- **Index out of range** (forgot a boundary check).
- **Data structure mismatch** (tried to add an int to a list of lists → fixed by wrapping with `[...]`).

Each error taught him something about the data structure he was building.

---

## Resources Mentioned

### NeetCode

A YouTuber/educator (former Amazon engineer) who built courses around LeetCode. Provides a "study roadmap" for learning data structures and tackling LeetCode problems systematically. Some of his videos use class-based solutions.

### Blind 75

A list of 75 LeetCode problems considered the "essential" set for tech interview prep. The coach has been pulling problems from this list. Two from this session:

- **Insert Interval** (covered)
- **Merge Intervals** (the prerequisite)

After this session: **13 of 75** Blind 75 problems covered.

> "The Blind 75 is pretty old now — some people consider it almost outdated. But it's still a good representation of the fundamentals."

### General study advice

- Spend 10–15 minutes on a problem. If stuck, look at the answer.
- Build pattern recognition by **seeing** examples.
- Cut your teeth on easies, then mediums. Hards are rarely asked in real interviews.

---

## Coach's Plan for the Next Session

- Record a video on **sliding window**, **two pointers**, and **binary search** in the context of specific problems.
- Bridge the gap from "I learned binary search in Mod 2" to "I can implement binary search to solve a real problem."
- Cover a problem that uses the **idea** of binary search (splitting in halves) without using the literal algorithm.

---

## Brian's Status

Brian has finished Mod 2 except for the optional Java content. The technical interview is the gate to the **explorer phase** (working on tickets, building apps). Coach: "You're probably ready."


---

# Solutions Deep Dive — Contains Duplicate (All Approaches) (2025-07-30)

Wednesday session: explore four different approaches to LeetCode's Contains Duplicate, from O(n²) brute force to a one-line O(n) set comparison.

---

## Recap: Contains Duplicate problem

Given an integer array `nums`, return `True` if any value appears at least twice, `False` if all elements are distinct.

- `nums.length`: 1 to 10⁵
- Values: -10⁹ to 10⁹

---

## Approach 1: Brute Force Nested Loop — O(n²)

```python
for index, value in enumerate(nums):
    for j in range(index + 1, len(nums)):
        if value == nums[j]:
            return True
return False
```

### How it works

- Outer loop: iterate through each value with its index.
- Inner loop: compare against all subsequent values.
- If any pair matches, return `True`.
- Otherwise, return `False` after the loops complete.

### Result

- **Passes 65 of 77 test cases** before hitting LeetCode's time limit on the larger inputs (10,000+ elements).
- **Time:** O(n²)
- **Space:** O(1)

### Lesson: time limit exceeded ≠ wrong solution

You got the right answer for the cases that ran. The solution is correct, just inefficient. This is your cue to look for a better approach.

> **In the joy of coding tech interview** (HackerRank easy problems), brute force usually passes. **In real job interviews and on LeetCode mediums/hards**, you'll often need to optimize past brute force.

### Coach's recommendation

If your brute force passes at least **two-thirds of the test cases**, you've proven you understand the problem. Now go look at the Solutions tab or your toolkit of efficient techniques.

---

## Approach 2: Sort + Adjacent Comparison — O(n log n)

```python
nums.sort()
for i in range(len(nums) - 1):
    if nums[i] == nums[i + 1]:
        return True
return False
```

### How it works

- Sort the array (O(n log n)).
- Walk through with index `i`, comparing each value to the next one.
- Stop at `len(nums) - 1` to avoid index out of bounds.
- If any adjacent pair matches, return `True`.

### Result

- **Passes all test cases.**
- **Time:** O(n log n) — sort dominates.
- **Space:** O(1) for the sort (in-place) or O(n) depending on the implementation.

### `sort()` vs `sorted()`

- `nums.sort()` mutates the list **in place** and returns `None`.
- `sorted(nums)` returns a **new sorted list** without mutating the original.

If you write `sorted_nums = nums.sort()`, you get `None` stored in `sorted_nums` because the method has no return value. This trips people up. Use `sorted_nums = sorted(nums)` if you want a new copy.

### Can you import libraries in tech interviews?

- **Built-in functions** (`sort`, `sorted`, `min`, `max`, `len`, etc.) are always fine.
- **Importing libraries** is usually allowed but adds overhead — you have to know how to use them and remember the import syntax.
- For Joy of Coding, stick with built-ins unless you genuinely need a library.

---

## Approach 3: Set With Add and Check — O(n)

```python
seen = set()
for value in nums:
    if value in seen:
        return True
    seen.add(value)
return False
```

### How it works

- Build a set as you go.
- For each value, check if it's already in the set.
- If yes → duplicate found, return `True`.
- If no → add it to the set and continue.

### Why this is O(n)

- Single loop: O(n).
- `value in set` is **O(1)** (hash lookup, not linear scan).
- `set.add(value)` is also O(1).
- Inside an O(n) loop, all operations are O(1) → **O(n) overall**.

### `in` is O(n) for lists, O(1) for sets

This is a critical distinction:

- `value in some_list` → linear scan, O(n)
- `value in some_set` → hash check, O(1)
- `key in some_dict` → hash check, O(1)

Sets use **hashing** under the hood. The value's hash determines its index, so checking membership is a constant-time index lookup, not a comparison against every element.

---

## Approach 4: One-Line Set Comparison (Lisa's idea) — O(n)

```python
return len(set(nums)) != len(nums)
```

### How it works

- `set(nums)` creates a set from the list, which automatically removes duplicates.
- If the resulting set is **shorter** than the original list, there were duplicates.
- Compare lengths and return the boolean.

### Big-O

- `set(nums)` is **O(n)** (one pass through the list to insert into the set).
- `len()` calls are **O(1)**.
- **Overall: O(n)**, same as Approach 3.

### Why this is the elegant winner

- One line.
- Uses Python's built-in set semantics to do the heavy lifting.
- No explicit loop, no early-return logic, no extra variables.
- Reads almost like the problem statement: "if the unique values are fewer than all values, there's a duplicate."

### Real-world performance comparison

| Approach | Runtime |
|---|---|
| Brute force O(n²) | ~70 ms (when it passes) |
| Sort + check O(n log n) | ~25 ms |
| Set with add/check O(n) | ~18 ms |
| `len(set) != len(list)` O(n) | ~11 ms |

> "It's rare that the most efficient solution is also shorter than the alternatives. This problem is one of those rare cases."

---

## Memory Trade-Off

The set-based approaches use **O(n) space** because they store every unique value. The sort and brute force approaches use **O(1)** extra space.

LeetCode shows your memory usage compared to peers. If you go with a set approach, your runtime is faster but your memory usage is higher.

For most problems, **runtime matters more than memory**. Pick the faster solution unless memory is explicitly constrained.

---

## Confused Adam: "Why use enumerate?"

A participant pointed out that `enumerate(nums)` is functionally identical to `for i in range(len(nums))` followed by `nums[i]`. Why use `enumerate`?

### Answer

- **Same efficiency** — both are O(n) and do the same thing under the hood.
- `enumerate` is **cleaner syntax** — gives you both the index and the value in one expression.
- Personal preference. Use whichever reads better for you.

> "I just kind of liked it because it's it separates out the index from the value, but it's the exact same level of efficiency."

---

## Encouragement: Try the Problems After the Session

Even though all four approaches were walked through live, **try them yourself from memory**. The muscle memory of typing them out, debugging the small mistakes, and making them work is what builds your speed.

> "I always encourage everyone to try these problems on your own. So even though we've gone over these four different approaches, I still think it'll be a good effort for you all to try them on your own so that you get that kind of muscle memory."

---

## Coming Up: Top K Frequent Elements

The other Sunday problem. The constraint says "your solution must be **better than O(n log n)**" — which rules out sort-based approaches. Try this one before the next session.

> "It kind of implies that there are many solutions of varying O complexities that are better than N log of N."


---

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


---

# Ruby Solutions Deep Dive — August 13, 2025

Wednesday session covering three topics: (1) how to get started practicing on HackerRank, (2) a visual Big-O demo contrasting linear and binary search, and (3) a full walkthrough of the **Jumping on the Clouds** problem showing the coach's end-to-end interview process from reading the prompt to debugging code.

---

## Getting Started on HackerRank

### Where to start

- Use the **Problem Solving track** — it mixes data structure and algorithm questions and shows up by default on new accounts.
- Filter to **Easy** and work through them in order of point value.

### Point values as a difficulty signal

- **10-point problems** are generally easier than **15-point** problems, which are easier than **20-point** problems — even within the Easy tier.
- Stars on HackerRank are gamification only — ignore them as a progress gauge.

### What to practice per problem

- Read the **entire** problem statement — don't stop at the short summary.
- Pull elements from the problem into **pseudo code** — data types, return type, constraints, edge cases.
- Read the **constraints** carefully; they frequently contain guarantees that eliminate the need for edge-case handling.
- Run your code often against their examples; don't write 20 lines before testing.

### Readiness benchmarks

| Metric | Target |
|---|---|
| Easy problems | Solve 3 consecutively in **under 20 minutes** |
| Medium problems | Solve in **45 minutes to 1 hour** |
| Practice cadence | Mix easy + medium; medium trains multi-step decomposition |

> Medium problems aren't harder conceptually — they're easy problems compacted into multiple steps stacked on top of each other. The skill you're training is decomposition.

### Interview mechanics

- The tech interview is a **hard 20 minutes** on a single easy problem.
- The interviewer doesn't answer questions mid-session; assume any question you ask is rhetorical — you are talking to yourself.
- If you ask how much time is left, the interviewer will tell you. Otherwise focus on the code.
- **Job-hunt interviews** will include medium and hard problems — preparing with mediums pays off after the internship interview.

### Practice tips

- Use a **stopwatch (counting up)** rather than a countdown timer when starting out — measure how long problems actually take, then compress.
- Book peer-mentor office hours for low-stakes speaking practice before your real attempt.
- Use a **rubber duck** (stuffed animal, cat, anything with a face) to practice verbalizing your thinking.

---

## Big-O Visualization: Linear vs Binary Search

The coach demonstrated a custom visualizer comparing **linear search** (O(n)) and **binary search** (O(log n)) across library catalogs of different sizes.

### Linear search — O(n)

- Walk the array one index at a time until you find the target or reach the end.
- No prerequisite ordering required.
- Steps scale **diagonally** with input size — double the books, double the average steps.

### Binary search — O(log n)

- **Requires a sorted list.**
- Check the midpoint, decide if the target is in the lower or upper half, discard the other half, repeat.
- Steps grow **logarithmically** — doubling input adds only one more step on average.

### Scale observations

| Books | Linear steps (avg) | Binary steps (avg) |
|---|---|---|
| 22 | ~11 | ~5 |
| 100 | ~50 | ~7 |
| 500 | ~250 | ~9 |
| 1000 | ~500 | ~10 |

> Big-O isn't about performance on a small scale or a large scale — it's about how performance changes between scales. Linear goes diagonal. Log-n goes nearly flat.

### Why this matters beyond interviews

Code written with poor efficiency works fine on small inputs but degrades dramatically as data grows. Whether or not you're implementing a literal binary search, being able to *recognize* when your code is doing wasted work is what separates production-quality code from brute-force code.

---

## Problem: Jumping on the Clouds

> There is a new mobile game that starts with consecutively numbered clouds. Some clouds are thunderheads, others are cumulus. The player can jump on any cumulus cloud with a number equal to the current cloud + 1 or + 2. The player must avoid thunderheads. Determine the number of jumps it takes to reach the last cloud. It is always possible to win the game.

### Restating the problem

- Given an array `c` of integers containing only `0` (safe) or `1` (thunderhead).
- Index the array from `0` to `n-1`.
- Advance the index by **+1 or +2** positions per jump, never landing on a `1`.
- Return the **shortest path** (fewest jumps) to the last index.

### Examples

- `c = [0,0,1,0,0,1,0]` → `4` jumps (e.g. 0 → 1 → 3 → 4 → 6).
- `c = [0,0,0,0,1,0]` → `3` jumps (0 → 2 → 3 → 5 or 0 → 2 → 4? actually 0 → 2 → 3 → 5 since index 4 is unsafe).

### Constraints and what they buy us

- `2 <= n <= 100`.
- `c[0] = 0` and `c[n-1] = 0` — the **first and last clouds are always safe**.
- "It is always possible to win the game" — guaranteed a valid path exists.

> The constraints tell us we never have to check if the start or end is safe, and we never have to handle "impossible" cases. That's a lot of edge-case code we don't need to write.

---

## Coach's Interview Process (End to End)

### Step 1 — Read aloud and restate

Read the problem at least once. Resummarize it in your own words to the interviewer. This buys your brain buffer time and proves comprehension.

```
# array c is a list of integers containing 1 or 0
# 0 is safe, 1 is not
# index the array from 0 to n-1
# can advance the index by either 1 or 2 positions
# return the shortest path from the first index to the last
```

### Step 2 — Print the inputs

Always print the parameters you're given on the first line of the function. Verify the runtime data matches your mental model before writing any logic.

```python
def jumpingOnClouds(c):
    print(c)
    return 0
```

### Step 3 — Default return

Add a default return matching the expected type (here, an integer). Missing return statements cause confusing type errors that can send you down the wrong debugging path.

### Step 4 — Pseudo code the approach

```
# default to jump 2 spaces if the index is safe (not a 1)
# otherwise jump 1 space
# keep track of steps taken with a count variable
```

### Step 5 — Summarize for the interviewer

> The problem gives me a list of 0s and 1s. I can take up any 0 space but not a 1. I can advance by 1 or 2 each jump. I'll loop through the array, prefer jumping by 2 when the landing spot is safe, otherwise jump by 1, and track the count. Thanks to the constraints I know the first and last index are always safe, so I don't need edge cases for either end.

---

## Implementing the Solution

### First attempt — `enumerate` (suggested by Brian)

```python
def jumpingOnClouds(c):
    count = 0
    for index, value in enumerate(c):
        jump_index = index + 2
        if c[jump_index] != 1:
            index = jump_index
        count += 1
    return count
```

### Bugs surfaced by testing

- **`IndexError: list index out of range`** — when `index + 2` exceeds `len(c) - 1`.
- **Reassigning the loop variable `index`** inside a `for` loop does nothing — Python rebinds it on the next iteration.
- The `enumerate` loop always advances by 1 regardless of what you assign to `index`.

> This is why `enumerate` is awkward here. You can't manually advance the iterator. When you need to control the step yourself, use a `while` loop with a manual index, not `for ... in enumerate`.

### When to prefer `enumerate` vs `range`

- Use **`enumerate`** when you need **both** the index and the value and you iterate linearly.
- Use **`for i in range(len(c))`** when you only need the index or need to manipulate positioning.
- Use **`while`** when you need to control the advance step yourself (as here).

### Corrected approach — `while` loop

```python
def jumpingOnClouds(c):
    count = 0
    i = 0
    while i < len(c) - 1:
        if i + 2 < len(c) and c[i + 2] != 1:
            i += 2
        else:
            i += 1
        count += 1
    return count
```

### How it works

- Loop while `i` has not reached the last index.
- **Prefer jumping 2** — check that `i + 2` is in range and safe; if so, advance by 2.
- **Otherwise jump 1** — guaranteed safe by the problem constraints (since any thunderhead must have a safe neighbor, or the game would be unwinnable).
- Increment `count` on every jump regardless of size.
- Return `count`.

### Complexity

- **Time:** O(n) — we visit each index at most once.
- **Space:** O(1) — only `count` and `i` as extra storage.

---

## Debugging Discipline

The coach's session ran into an off-by-one error and several `IndexError`s. Key takeaways:

### Run code frequently

- Don't write 20 lines before your first test run. Write 2-3 lines, print the intermediate state, verify your mental model, repeat.
- If you had tested the for loop in isolation first, the `enumerate` bug would have been obvious within seconds.

### Print intermediate state

- Print loop variables (`i`, `jump_index`) on every iteration.
- Print the condition you're testing so you can see which branch is taken.

### Don't panic-patch

> When you start seeing errors and you're worried about time, you slip into a mindset of "what if I just subtract 1 here" or "what if I flip this operator" — once you're there, you've stopped problem solving and started panicking.

- If you catch yourself adjusting constants randomly to chase passing tests, **stop**. Go back to printing intermediate state and actually understanding what's happening.
- It's often faster to **delete and restart** a broken approach than to keep patching it.

### Test assumptions explicitly

- Every implicit assumption is a potential bug. If you assume the first index is always safe, the constraints confirmed it — but if the constraints hadn't, that's an edge case you'd need to test.
- Gut-check yourself with print statements even when things look obvious. You lose 10 seconds to a print and save 5 minutes of wrong-direction debugging.

---

## Session Takeaways

- **The interview process is a repeatable pipeline:** read → restate → print inputs → pseudo code → summarize → code → test → debug → complexity analysis.
- **HackerRank readiness** means 3 easy problems consecutively under 20 minutes, plus some medium practice.
- **Big-O matters in the real world**, not just interviews — linear vs logarithmic is the difference between "works on 100 items" and "works on 1 million items".
- **`enumerate` is wrong for problems where you control step size** — reach for `while` or `for i in range` instead.
- **Print early, print often, and never panic-patch** a solution you don't understand.


---

# Ruby Solutions Deep Dive — August 20, 2025

Mauricio volunteers for a mock interview on **Jumping on the Clouds Revisited** — the circular variant with an energy counter. The session covers live debugging under pressure, when to reach for `while` vs `for`, and how to leverage formulas given in the problem statement.

---

## Mock Interview Context

- **Problem:** Jumping on the Clouds Revisited (HackerRank).
- **Format:** 20 minutes, read → summarize → pseudo code → code → debug.
- **Goal of mock:** practice performing under pressure with Zoom eyes watching. Writing working code is optional; verbalizing the thought process is the main deliverable.

---

## Problem: Jumping on the Clouds Revisited

> The array is circular. From index `i` the player jumps to `(i + k) % n`. The player starts at index 0 with 100 energy, loses 1 energy per jump, and loses an additional 2 energy if they land on a thundercloud (value 1). Return the remaining energy after the player returns to index 0.

### Restated

- Input: array `c` of 0s and 1s (0 = cumulus/safe, 1 = thundercloud) and integer `k` (jump length).
- Starting energy: 100.
- Cost per jump: **1 energy** (always) + **2 additional** if landing on a `1`.
- Movement formula: `next_index = (current_index + k) % n` — the `% n` makes it circular.
- Stop when the player returns to index 0.
- Return final energy.

---

## Mauricio's Pseudo Code

```
# traverse the array with a while loop (unknown number of jumps)
# stop condition: index == 0 again
# on each jump:
#   - deduct 1 if c[index] == 0
#   - deduct 3 if c[index] == 1
# use (i + k) % n to compute the next index
```

### Code attempt

```python
def jumpingOnClouds(c, k):
    n = len(c)
    e = 100
    i = 1  # had to start at 1 to get past the while condition
    while i != 0:
        i = (i + k) % n
        if c[i] == 0:
            e -= 1
        else:
            e -= 3
    return e
```

### The bugs

1. **Starting at `i = 1`** to dodge the `while i != 0` condition means the first real jump is never taken from index 0 — the loop just spins forward.
2. **`i = (i + k) % n` is inside the `if/else`** but happens before the energy deduction, so the first cloud's energy cost is never accounted for correctly.
3. **Time Limit Exceeded** — the loop ran indefinitely because the starting state made the condition impossible to re-enter on the correct step.

---

## Debugging Under Pressure

### Coach feedback on the mock

> You summarized the problem well and got to reasonable pseudo code. Your approach is logical. The specific bugs are normal — what we're practicing is the response when you get stuck.

### When you're stuck, add observability

- **Print the loop variable** (`i`) on every iteration to see if it's actually moving.
- **Print the computed next index** (`(i + k) % n`) to see what path the player is taking.
- **Print the energy** after each deduction to verify costs are applied correctly.

```python
while i != 0:
    i = (i + k) % n
    print(f"i={i}, c[i]={c[i]}, e={e}")
    ...
```

### Counter the panic loop

> When you run into errors and time is ticking, your brain starts looping: "I'm stuck, time is running, I'm stuck, time is running." You stop problem solving. The fix is to stop typing and add print statements — observability breaks the panic loop.

### Use the formula the problem gives you

The problem explicitly gives you `(i + k) % n`. That's a massive hint — don't just use it as an `if` condition, consider using it as:

- The **loop condition** — `while (i + k) % n != 0`.
- The **initial index** — start `i = k % n` and treat the first jump as already taken (deduct its cost immediately, then loop).

> When the problem hands you a formula, print it out first. Figure out exactly what it's telling you before you wrap code around it.

---

## When to Use `while` vs `for`

This session also revisited **Jumping on the Clouds** (the non-circular version from last week) and confirmed why a `while` loop is required.

### Why `for` fails in the original problem

```python
for i in range(len(c)):
    if c[i + 2] != 1:
        i = i + 2  # this does NOTHING
```

- In Python, **reassigning the loop variable inside a `for` loop has no effect** — the iterator rebinds `i` on the next iteration from its own internal state.
- You cannot skip steps in a `for i in range(...)` loop.

> JavaScript's `for (let i = 0; i < n; i++)` does let you mutate `i` mid-loop, which is probably where my intuition got confused last week. Python's `for` is strictly iterator-driven — the variable assignment is a lie.

### Two reasons to reach for `while` on cloud problems

| Reason | Applies to |
|---|---|
| **Variable step size** (jump 1 or jump 2) | Jumping on the Clouds |
| **Circular traversal** (no fixed end) | Jumping on the Clouds Revisited |

- The first problem needs `while` because the **step size isn't consistent**.
- The second problem needs `while` because there is **no fixed end** — the array loops, and you stop based on a condition rather than exhausting a range.

### General rule from the discussion

- **`for` loop** — you know the range up front and the step is consistent (including step sizes other than 1).
- **`while` loop** — you don't know how many iterations you'll take, or you need to manipulate the index yourself, or termination depends on a computed condition.
- ChatGPT's summary matched this: unknown range or inconsistent step → while.

### Count isn't an iterator

A point of confusion: the `count` variable in jumping-on-the-clouds isn't an iterator — it's a **tracker**. Same with `energy` in the revisited version.

- **Iterator** — drives movement through the data structure (the `i` in `c[i]`).
- **Tracker** — records information alongside iteration (`count`, `energy`).

Mixing them up leads to incorrect termination logic. The loop condition should be about the iterator, not the tracker.

---

## Working Through the Revisited Problem

A cleaner approach that starts correctly:

```python
def jumpingOnClouds(c, k):
    n = len(c)
    e = 100
    i = 0
    while True:
        i = (i + k) % n
        e -= 1
        if c[i] == 1:
            e -= 2
        if i == 0:
            break
    return e
```

### Why this works

- **`while True` with a `break`** sidesteps the "starting at 0" paradox — we always take at least one jump before checking termination.
- The jump is always the first thing in the loop body, so the energy deduction is guaranteed.
- The `break` fires after the energy deduction, ensuring the final step's cost is counted.

### Complexity

- **Time:** O(n / gcd(n, k)) — worst case O(n) when `k` and `n` are coprime.
- **Space:** O(1).

---

## Session Takeaways

- **Mock interviews are about performing under pressure**, not about finishing the code. Mauricio's summary, pseudo code, and debugging dialogue were all strong even though the code didn't pass.
- **When stuck, add print statements** before touching logic. Observability defeats panic.
- **`while` loops are the answer** whenever you need to control step size, traverse circularly, or terminate on a condition rather than a range.
- **Python's `for` loop variable is read-only** in practice — reassigning it does nothing.
- **When the problem hands you a formula**, print it in isolation before building around it.
- **Count and energy are trackers, not iterators** — they don't drive the loop termination.

> Even one person silently watching you code is shockingly hard the first time. The only fix is practice — book peer mentor office hours and get reps before the real thing.


---

# Ruby Solutions Deep Dive — August 27, 2025

Wednesday session covering two problems: a walk-through of **Best Time to Buy and Sell Stock** (brute force vs optimal), followed by a mock interview on LeetCode's **Jump Game** (medium) with John.

---

## Problem: Best Time to Buy and Sell Stock

> You are given an array `prices` where `prices[i]` is the price of a stock on day `i`. Choose a single day to buy and a different day in the future to sell. Return the maximum profit. If no profit is possible, return 0.

### Examples

- `prices = [7, 1, 5, 3, 6, 4]` → `5` (buy at 1, sell at 6).
- `prices = [7, 6, 4, 3, 1]` → `0` (monotonically decreasing — no profit possible).

---

## Brute Force: Nested Loop — O(n²)

Compare every buy day to every possible sell day and track the max profit.

```python
def maxProfit(prices):
    n = len(prices)
    profit = 0
    for i in range(n):
        for j in range(i + 1, n):
            sell = prices[j] - prices[i]
            if sell > profit:
                profit = sell
    return profit
```

### Result on LeetCode

- **198 / 212 test cases pass**, then **Time Limit Exceeded**.
- Logic is correct; efficiency is the bottleneck.

### Complexity

- **Time:** O(n²) — nested loop over the same array.
- **Space:** O(1).

### When brute force is OK to start with

> Start with brute force to validate your logic. If it passes, great. If it times out but passes most cases, that tells you the approach is logically sound — you just need a better algorithm, not a different understanding of the problem.

- Passing **198/212** is a strong signal: the approach works, efficiency is the problem.
- Passing **75/212** would be a warning: your solution may also be logically wrong.

---

## Don't Micro-Optimize — Drop a Rung

When your brute force times out, resist the urge to tweak the existing nested loop with small tricks (reversing iteration, swapping `+`/`-`, starting from the end). Those optimizations stay **within** O(n²) and won't get you under the time limit.

Instead, consult the Big-O hierarchy:

```
O(1) < O(log n) < O(n) < O(n log n) < O(n²) < O(2^n) < O(n!)
```

If you're at O(n²), aim for **O(n log n)** or **O(n)**. You need to remove the inner loop entirely, not optimize it.

---

## Optimization Attempt 1: Replace Inner Loop With `max()`

```python
def maxProfit(prices):
    n = len(prices)
    profit = 0
    for i in range(n - 1):
        max_value = max(prices[i + 1:])
        sell = max_value - prices[i]
        if sell > profit:
            profit = sell
    return profit
```

### Why this doesn't help

- `max(prices[i+1:])` is itself an **O(n)** operation.
- The outer O(n) loop times O(n) max calls = still **O(n²)**.
- However, this rephrasing helps you **think about the problem differently** — we're looking for the max value to the right of each buy position.

---

## Optimal Solution: Single Pass — O(n) (Mindy's Solution)

Flip the thinking. Instead of asking "what's the max price after this day?", track the **minimum price seen so far** and calculate profit from it as you walk the array.

```python
def maxProfit(prices):
    min_price = float('inf')
    profit = 0
    for price in prices:
        if price < min_price:
            min_price = price
        elif price - min_price > profit:
            profit = price - min_price
    return profit
```

### How it works

- Walk the array once.
- **Update `min_price`** whenever you see a lower value — this is "the best day to have bought so far".
- Otherwise, **calculate the profit** from selling today relative to `min_price` and update `profit` if it beats the current best.
- You never need to look backward because `min_price` already holds the best buy point from everything to the left.

### The mental flip

> The brute force asks "for each buy, what's the best sell?" — that's O(n²) because every buy needs its own search. The optimal asks "for each sell, what's the best buy so far?" — and the answer to that is just a running minimum, which is O(1) to maintain.

### Complexity

- **Time:** O(n) — single pass.
- **Space:** O(1) — just two scalars.

### Coach's two-pointer attempt (failed)

The coach tried converging two pointers from opposite ends, but the array isn't sorted — there's no structural guarantee that shrinking from the outside preserves the optimal pair. **Two pointers only work when the array has monotonic or sorted properties to exploit.**

---

## Problem-Solving Process Reminder

> When you've done your due diligence — tried brute force, tried an alternate technique, and still can't find a better approach — that's when you can look at the solutions tab. Don't copy; read, close the tab, and re-implement from memory. Add the pattern to your mental toolkit.

Mindy likely didn't find the running-minimum solution on her first try either. Tutorial videos make it look like experts pull optimal algorithms out of thin air — they don't. Everyone iterates.

---

## Mock Interview: Jump Game (Medium)

> You are given an integer array `nums`. You are initially positioned at the array's first index. Each element in the array represents your **maximum** jump length at that position. Return `true` if you can reach the last index, or `false` otherwise.

### Examples

- `nums = [2, 3, 1, 1, 4]` → `true` (jump 1 → then 3 → reach the end).
- `nums = [3, 2, 1, 0, 4]` → `false` (stuck on the 0 at index 3).

### John's key insight during the read-through

> Each element represents your **maximum** jump length — not a required jump length. You can jump *up to* that many steps, including fewer. That's half the problem right there.

- If `nums[i] == 0` you're stuck at position `i` unless you can skip over it from an earlier jump.
- The "maximum" wording is critical — John initially misread it as a required jump before catching the assumption on a second read.

### John's attempt

John got initial test cases passing in under 15 minutes on his first medium problem ever. The code hit an edge case when `nums` had a single zero-only scenario, which led to an `IndexError`.

### Coach feedback

> You jumped straight into code, which works for the small cases, but for a medium problem you want to slow down. Pull out your assumptions, comment them in, test them. You'll iterate on code endlessly — distilling the problem first is where the real wins happen.

### Approach outline (for future iteration)

```
# greedy approach: track the furthest index reachable so far
# iterate through nums
#   if current index is beyond furthest reachable, return false
#   otherwise update furthest reachable to max(furthest, i + nums[i])
#   if furthest reachable >= last index, return true
```

### Complexity target

- **Time:** O(n) — single pass.
- **Space:** O(1).

---

## Why Mock Interviews Use Medium Problems

Mauricio asked: the tech interview academy uses easy problems, so why does the mock use medium?

### Reasons

1. **Real-world interviews** on the job market are **medium to hard** — getting early exposure builds tolerance.
2. **Medium problems are not just "hard math"** — they're usually easy problems composed together. They stress-test decomposition skills.
3. **Hoarding easy problems** for actual practice — the coach reserves easy problems for practice runs and reserves mediums for mock stress.
4. **The mock isn't about writing working code** — it's about the problem-solving dialogue: pulling assumptions from the prompt, breaking steps down, verbalizing thinking.

### Expectation on a mock medium

- Read the full problem, including constraints.
- Pull out assumptions (what it tells you, what it doesn't).
- Summarize it aloud.
- Write pseudo code at whatever granularity fits your brain — high-level bullet points or line-by-line.
- Optionally attempt code if time permits.

---

## Session Takeaways

- **Brute force first when you're stuck** — validate logic, then optimize.
- **Passing most but not all test cases** with TLE means efficiency, not correctness. Drop a full Big-O rung, don't micro-optimize.
- **Flip the question** — "best sell after each buy" is O(n²); "best buy before each sell" is O(n) because you only need a running minimum.
- **Two pointers requires sorted or monotonic structure** — arbitrary arrays don't qualify.
- **Read medium problems twice** before coding. Words like "maximum" and "at most" radically change the problem.
- **Mock interviews are dialogue stress-tests**, not code-writing exercises. Focus on narrating your assumptions out loud.


---

# Ruby Solutions Deep Dive — September 3, 2025

Wednesday session revisiting two problems after breakout room practice: **Can Place Flowers** (easy) and **Jump Game** (medium). Mauricio, Jenny, and the coach each walk through their own solutions to Jump Game, revealing three subtly different implementations of the same greedy insight.

---

## Problem: Can Place Flowers

> You have a long flowerbed in which some plots are planted and others are not. However, flowers cannot be planted in adjacent plots. Given an integer array `flowerbed` containing `0`s (empty) and `1`s (not empty), and an integer `n`, return `true` if `n` new flowers can be planted without violating the no-adjacent rule.

### Example

- `flowerbed = [1,0,0,0,1], n = 1` → `true` (plant at index 2).
- `flowerbed = [1,0,0,0,1], n = 2` → `false` (can only fit one).

### Edge rule

- The positions **outside** the array count as empty — you can plant at index 0 as long as index 1 is empty, and similarly at the last index.

---

## Can Place Flowers: Solution

The approach uses `n` as a **countdown** of flowers still to plant, walks the bed once, and checks each empty slot against its neighbors.

```python
def canPlaceFlowers(flowerbed, n):
    for i, val in enumerate(flowerbed):
        pre = flowerbed[i - 1] if i - 1 >= 0 else 0
        post = flowerbed[i + 1] if i + 1 < len(flowerbed) else 0
        if val == 0 and pre == 0 and post == 0:
            flowerbed[i] = 1
            n -= 1
    return n <= 0
```

### How it works

- **`pre`** and **`post`** fetch the left and right neighbors, defaulting to `0` when out of bounds (handling the edge rule cleanly).
- If the current slot is empty **and** both neighbors are empty, plant a flower (mutate the array to `1`) and decrement `n`.
- After walking the bed, return `n <= 0` — we either planted everything requested or we didn't.

### Why mutate the array

- Setting `flowerbed[i] = 1` prevents the next iteration from planting an adjacent flower.
- Without this step, `[0, 0, 0]` with `n = 2` would incorrectly succeed.

### Complexity

- **Time:** O(n) — single pass.
- **Space:** O(1) — in-place mutation.

---

## Problem: Jump Game

> You are given an integer array `nums`. You are initially positioned at the first index. Each element represents your **maximum** jump length at that position. Return `true` if you can reach the last index.

### Examples

- `nums = [2,3,1,1,4]` → `true`
- `nums = [3,2,1,0,4]` → `false` (stuck on the `0`)

### The sneaky part

> You don't have to jump the full distance. `nums[i] = 3` means you can jump 1, 2, **or** 3 steps. Sometimes the optimal path uses a shorter jump to land on a cell with a larger value.

Example: `[2, 5, 0, 0, 0, 0, 1]` — jumping the full 2 from index 0 lands on the `0` and gets stuck. Jumping only 1 lands on the `5` which reaches the end.

---

## Jump Game: Three Solutions, Same Insight

### Solution 1 — Mauricio (Python): Track `farthest`, Bail on Overshoot

```python
def canJump(nums):
    if len(nums) == 1:
        return True
    farthest = 0
    for i in range(len(nums)):
        if i > farthest:
            return False
        farthest = max(farthest, i + nums[i])
    return True
```

### How it works

- **`farthest`** tracks the highest index we've proven reachable so far.
- At each step, if the current index `i` has already passed `farthest`, we can't possibly be standing here — return `False`.
- Otherwise, update `farthest` to the better of its current value or `i + nums[i]` (the furthest we could jump from here).
- If the loop completes without failing, we made it — return `True`.

### The key insight

> If `i > farthest` is never true during the walk, it means every position up to `len(nums) - 1` was reachable. The single check at the top of each iteration is sufficient — you don't need a separate "did we reach the end?" check.

### Complexity

- **Time:** O(n) — single pass.
- **Space:** O(1).

---

### Solution 2 — Jenny (JavaScript): Same Approach, Early Return on Reach

```javascript
function canJump(nums) {
    let maxReach = 0;
    for (let i = 0; i < nums.length; i++) {
        if (i > maxReach) return false;
        maxReach = Math.max(maxReach, i + nums[i]);
        if (maxReach >= nums.length - 1) return true;
    }
    return true;
}
```

### Differences from Mauricio's

- Identical core logic; adds an **early return** when `maxReach` can already reach the last index.
- Slightly faster on inputs where the reachable frontier expands quickly.

---

### Solution 3 — Ruby (Coach): Decrementing Fuel

A subtly different mental model: track the remaining "fuel" rather than the furthest reachable index.

```python
def canJump(nums):
    n = len(nums)
    if nums[0] == 0 and n > 1:
        return False
    if n == 1:
        return True

    jump = nums[0]
    for i in range(1, n):
        jump = max(jump - 1, nums[i])  # decrement, but refuel if current cell is better
        if jump == 0:
            return False
        if jump + i >= n - 1:
            return True
    return False
```

### How it works

- **`jump`** represents "how many more steps of momentum I currently have".
- At each index, decrement `jump` by 1 (we used a step) but refill to `nums[i]` if that's larger — we just landed on a better launchpad.
- If `jump` ever hits `0` before reaching the end, return `False`.
- Early-exit when `jump + i` can reach the last index.

### Why all three work

They're three encodings of the same greedy observation: **the furthest reachable index is monotonically non-decreasing as you walk forward, and you only need to know whether it ever reaches the end**. Whether you track "farthest index" or "remaining fuel" is just a representation choice.

---

## The Coach's Bogus First Attempt

Before arriving at the decrementing-fuel solution, the coach first tried "always jump the maximum distance, back up if stuck":

- Jump to `i + nums[i]` immediately.
- If you land on a `0`, go backward looking for an earlier index that could reach the end.
- Added a `circular` flag to break infinite loops when the backward search found another "jump as far as possible" index that looped back.

### Why it failed

- The bailout logic kept finding the same position it just came from, creating infinite loops.
- Each new edge case required another flag or condition — accumulating complexity is a red flag.

> When you start adding code for every single nuance you find, that means you're going bad ways. Step away, rethink, come back with a cleaner model.

### The discipline

- If you catch yourself stacking more conditions and flags to handle edge cases, **stop**. The problem is probably in your overall approach, not in a missing condition.
- The coach lost ~10 minutes on this attempt, then solved the problem in 15-20 minutes with the fresh approach.

---

## When to Use `while` vs `for` — Revisited

Lisa started working on Jump Game with a `while` loop because the step sizes are variable. Both `while` and `for` work here:

- **`for`** works because you only need to **walk** the array checking a condition at each index — the iterator itself isn't doing the jumping; `farthest` or `jump` tracks the state.
- **`while`** would be required if you actually advanced the index by `nums[i]` each iteration, but that greedy strategy is what led the coach's first attempt into infinite loops.

> The trick to greedy jump problems: don't have the loop variable do the jumping. Let it walk every index, and use a separate variable to track the reachable frontier.

---

## Tech Interview Cookbook Note

Rebecca asked if she could keep the Mod 1 cookbook open during the tech interview.

- **No for full solutions** — the cookbook shouldn't contain complete problem solutions from previous students.
- **Yes for basic syntax** — your own notes on for-loop syntax, dictionary access, sort methods, etc. are fine.
- **Google is allowed** during the Joy of Coding tech interview for syntax lookups (e.g. "how do I use Python's max method") — when in doubt, ask in the moment.

---

## Session Takeaways

- **Can Place Flowers** — mutate the array in place to prevent planting adjacent flowers in the same pass. Use out-of-bounds defaults to handle the edge rule cleanly.
- **Jump Game** — the greedy insight is that the furthest reachable index is monotonic; three different representations (`farthest`, `maxReach`, `jump`) all encode the same idea.
- **Don't have the loop variable do the jumping** — walk every index, track reachability separately.
- **Accumulating flags is a code smell** — when you're stacking special cases, your approach is probably wrong.
- **Three working solutions to the same problem** is great for mental flexibility — recognizing the same insight in different encodings is a skill.


---

# Ruby Solutions Deep Dive — September 10, 2025

Wednesday session covering two problems from the prior Sunday: **Array Partition I** (easy) and **Minimum Number of Arrows to Burst Balloons** (medium). Lisa walks through her sort-then-pair solution, and the coach uses a whiteboard to demonstrate the greedy "reach" technique for the balloon problem.

---

## Problem: Array Partition I

> Given an integer array `nums` of `2n` integers, group these integers into `n` pairs `(a1, b1), (a2, b2), ..., (an, bn)` such that the sum of `min(ai, bi)` for all `i` is **maximized**. Return the maximized sum.

### Example

- `nums = [1, 4, 3, 2]` → `4` (pair as `(1,2), (3,4)`, min sum = `1 + 3 = 4`)

### Constraints

- `nums.length` is always **even** (divisible by 2, so there's always a pair for each element).

---

## Array Partition: Sort-and-Step Solution (Lisa)

```python
def arrayPairSum(nums):
    nums.sort()
    total = 0
    for i in range(0, len(nums), 2):
        total += nums[i]
    return total
```

### How it works

- **Sort** the array ascending.
- **Step by 2** through the sorted array, always taking the element at the even index.
- Each "step 2" index is guaranteed to be the **smaller** of its pair when the array is sorted ascending.

### Why sorting is the key insight

> If you're looking for the minimum of two numbers, you want those two numbers close together. If you pair 1 with 6 in a sorted array, you "lose" the 6 — it gets thrown away because we only take the min. By pairing adjacent values after sorting, the max possible value that gets discarded per pair is minimized.

- Pairing `(1, 2)` throws away `2`; pairing `(3, 4)` throws away `4`. Total discarded: `6`.
- Pairing `(1, 4)` throws away `4`; pairing `(2, 3)` throws away `3`. Total discarded: `7`.
- Minimum discard maximizes the sum of the mins.

### Complexity

- **Time:** O(n log n) — dominated by the sort.
- **Space:** O(1) — sorted in place.

### Is there a non-sorting solution?

The coach tried to find one and couldn't get below O(n²) without sorting. The problem fundamentally relies on the pairing structure that sorting creates — without sorted order, there's no efficient way to identify which pairs minimize discarded values.

---

## Problem: Minimum Number of Arrows to Burst Balloons

> Balloons are given as `points[i] = [xstart, xend]`. Arrows shot straight up at x-coordinate `x` burst any balloon whose `xstart <= x <= xend`. Return the minimum number of arrows needed to burst all balloons.

### Examples

- `points = [[1,6], [2,8], [7,12], [10,16]]` → `2`
- `points = [[1,2], [3,4], [5,6], [7,8]]` → `4` (no overlaps)

### Conceptual setup

- The y-axis doesn't matter — only x-ranges are given, and arrows travel vertically.
- Balloons whose x-ranges **overlap at any point** can all be burst by a single arrow shot through that overlap.
- Coordinates can be **negative** — don't assume positive-only ranges.

---

## Lisa's First Attempt: Compare Adjacent Pairs

```python
def findMinArrowShots(points):
    points.sort()
    count = len(points)  # start assuming one arrow per balloon
    arrow = 0
    for i in range(count - 1):
        if points[i][1] >= points[i + 1][0] and points[i][1] <= points[i + 1][1]:
            arrow += 1
    if arrow == 0:
        return count
    return count - arrow
```

### What it gets right

- Sorts the points to bring overlapping balloons together.
- Walks adjacent pairs checking for overlap.

### What it gets wrong

- Only checks **adjacent** pairs — misses the case where balloon 1 and balloon 3 both overlap with balloon 2 but not with each other.
- Double-counts overlaps — if A overlaps B and B overlaps C, that's two "overlap detections" but should be one arrow covering all three.
- Doesn't track which balloons have already been "used" by a previous arrow.

### The root diagnosis

> You're not really counting how many balloons can be burst with the minimum arrows. You're counting how many balloons that are immediately beside each other have an overlap. Those are different problems.

---

## Mental Model 1: Dynamic Shifting Overlap

Track the **current overlap region** — the intersection of all balloons the current arrow could burst.

- Start with balloon 1's range as the initial overlap.
- For each next balloon: does it fit inside the current overlap?
  - **Yes** → tighten the overlap to the intersection (the balloon is now also covered by the current arrow).
  - **No** → increment arrow count, reset the overlap to this new balloon's range.

### Why this is harder to code

- Requires tracking both the start and end of the shrinking overlap.
- The intersection operation (`max(starts), min(ends)`) has to happen on every balloon.

---

## Mental Model 2: Track the Reach — Greedy O(n log n)

A much simpler encoding of the same idea. Track only the **end** of the current arrow's reach.

### Whiteboard walkthrough

Sorted balloons: `[1,6], [4,8], [7,9], [11,13], [12,15]`

| Step | Balloon | Reach before | Fits? | Action | Arrows |
|---|---|---|---|---|---|
| 1 | `[1,6]` | — | start | reach = 6 | 1 |
| 2 | `[4,8]` | 6 | `4 <= 6` yes | reach = min(6, 8) = 6 | 1 |
| 3 | `[7,9]` | 6 | `7 > 6` no | reach = 9, new arrow | 2 |
| 4 | `[11,13]` | 9 | `11 > 9` no | reach = 13, new arrow | 3 |
| 5 | `[12,15]` | 13 | `12 <= 13` yes | reach = min(13, 15) = 13 | 3 |

**Answer: 3 arrows.**

### The code

```python
def findMinArrowShots(points):
    if not points:
        return 0
    points.sort(key=lambda p: p[0])  # sort by start
    arrows = 1
    reach = points[0][1]
    for start, end in points[1:]:
        if start > reach:
            arrows += 1
            reach = end
        else:
            reach = min(reach, end)  # shrink reach to the intersection
    return arrows
```

### Why it works

- After sorting by start, if the current balloon's start is **within** the previous reach, they share overlap — tighten the reach to `min(reach, end)` so future balloons must also fit the tightened intersection.
- If the current balloon's start is **beyond** the previous reach, no single arrow can cover both — increment the arrow count and reset reach to the new balloon's end.
- We only ever look at one balloon at a time — no nested loops, no dynamic overlap tracking beyond a single scalar.

### Complexity

- **Time:** O(n log n) — dominated by sort.
- **Space:** O(1) after sort.

### Key realization

> We're only tracking one thing: reach. We're not comparing each balloon against a bunch of others. We walk slow along the way and just ask, "Is the next balloon's start within my current arrow's reach?" Yes → stay. No → new arrow.

---

## The Visualization Technique

The coach mentioned needing to pull out a whiteboard and actually draw the balloons to arrive at this solution.

> When you're torturing yourself thinking about edge cases — "what if 3 balloons are stacked? what if they're slightly offset?" — that's a sign you should stop coding and start visualizing. Draw it. 3D the problem. Something about moving the mental model out of your head and onto paper unsticks the logic.

- **Writing out code for every edge case** you find is a red flag.
- **Drawing or diagramming** the problem space usually surfaces the simpler greedy insight.

---

## Edge Cases and Anti-Patterns

### Don't code for every edge case you imagine

Lisa added a `if arrow == 0: return count` fallback to handle "what if there are no overlaps at all?"

> It's good that you thought about those edge cases — that's how you find them. The problem is when you start coding around each one individually. There's a thin line between being clever about edge cases and torturing yourself with them.

The greedy-reach solution handles "no overlaps" naturally — every balloon triggers a new arrow, no special case required.

### Don't randomly tweak operators when stuck

> Don't start changing things randomly, like "what if I add another increment" or "what if I switch greater-than to greater-than-or-equal". If you do that, you're not sure what your code is doing anymore. Take a step back, rethink the approach.

---

## Session Takeaways

- **Array Partition** — sort ascending and sum every other element starting from index 0. The sort is mandatory because the problem depends on pairing close values.
- **Minimum Arrows** — sort by start, track a single scalar "reach" equal to the current arrow's rightmost coverage, and either tighten it (overlap) or advance it (new arrow).
- **Two mental models, one solution** — dynamic overlap region vs reach tracking both encode the greedy insight; the reach version is simpler to implement.
- **Visualize when stuck** — whiteboard diagrams expose greedy solutions that are invisible when you're staring at code.
- **Stop when you find yourself coding edge case by edge case** — your approach is probably wrong, not incomplete.


---

# Ruby Solutions Deep Dive — September 17, 2025

Mock interview session on the HackerRank **Number Line Jumps** (Kangaroo) problem, with coach feedback on problem-solving process, reading constraints, and pseudo code discipline.

---

## Session Format

The coach opened by offering breakout rooms or a mock interview. With only four attendees, the group stayed together and **John** volunteered as the candidate. He filtered HackerRank Algorithms by **status: unsolved** and **difficulty: easy**, selecting **Number Line Jumps**.

> Typical steps: restate the problem, pull useful information into pseudo code, write comments about your assumptions, sound out your thinking, and explain yourself as you code.

---

## Problem: Number Line Jumps (Kangaroo)

Two kangaroos start at positions `x1` and `x2` on a number line and jump with velocities `v1` and `v2` respectively. Determine whether they will ever land on the same position **at the same jump**. Return the string `"YES"` or `"NO"`.

### Inputs

- `x1` — starting location of kangaroo 1
- `v1` — jump velocity (meters per jump) of kangaroo 1
- `x2` — starting location of kangaroo 2
- `v2` — jump velocity of kangaroo 2

### Key Insight the Candidate Missed Initially

Both kangaroos jump **simultaneously**. After each jump, kangaroo 1 is at `x1 + v1` and kangaroo 2 is at `x2 + v2`. They either meet on a shared jump or they never do.

> "It's the fourth dimension" — the candidate realized the jumps happen in lockstep, not independently.

---

## Candidate's Initial Attempt

John renamed `x1, v1, x2, v2` to more readable names like `kang_one_location`, `kang_one_velocity`, etc. He then tried a `while` loop but ran into an **infinite loop / timeout** on the test run.

```python
# Rough shape of the first attempt
def kangaroo(x1, v1, x2, v2):
    answer = False
    while kang_one != kang_two:
        if (kang_one + kang_one_velocity) == (kang_two + kang_two_velocity):
            answer = True
    return answer
```

### Bugs the Coach Flagged

- **Positions never updated inside the loop.** The candidate computed `kang_one + velocity` each iteration but never reassigned `kang_one += velocity`, so the comparison evaluated the same values forever.
- **Return type mismatch.** The function signature expects a **string** (`"YES"` / `"NO"`), not a boolean. HackerRank's `if __name__ == "__main__":` block parses the return value and will error on a bool.
- **Chained assignment + comparison.** An attempt like `kang_one += v1 == kang_two += v2` is not valid Python.
- **No loop termination condition** for the case where the kangaroos can never meet.

---

## Coach Feedback: Reading the Constraints

The coach pushed the candidate to re-read the **Constraints** section of the problem, where it states `1 <= x1 < x2 <= 10000`. The strict `<` between `x1` and `x2` is load-bearing:

- `x1` can **never** equal `x2` at the start, so the answer safely initializes to `false`.
- You do **not** need a defensive equality check on starting positions.
- `x2` is always further right than `x1`, which shapes the termination logic: if kangaroo 2 is ahead and moves at least as fast as kangaroo 1, they can never meet.

> "Sometimes the constraints don't give you anything, but it's a good practice to always check. More often than not they help eliminate assumptions or give you hints."

### Velocity Constraints

`1 <= v1, v2 <= 10000`. The problem does **not** tell you whether `v1` is greater than, less than, or equal to `v2` — you must handle all three cases in your logic.

---

## Coach Feedback: Assumptions in Comments

The coach pointed out that John verbalized several good observations while reading the problem ("they can jump forever", "x2 starts ahead") but never wrote them down, and then contradicted them in code.

> "If you're saying something out loud or having an assumption while you're reading the problem, literally write it in the comments. That way you're keeping those things in mind when you're thinking about your code."

---

## Coach Feedback: Pseudo Code First

> "Getting some preliminary code out can help you think, but always take a step back and ask: what is the overall system this problem is asking me to implement? What requirements, outputs, and assumptions do I need to consider? Dealing with those at the front end saves time because you're not mitigating errors along the way."

---

## Language Notes

The candidate's Python carried **JavaScript/TypeScript accent** — braces where colons belonged, missing indentation cues. The coach confirmed HackerRank allows any supported language; Python is used in the course because Mod 2 teaches Python, but candidates may use JavaScript, TypeScript, or others in their real interview.

- **TypeScript** enforces types as you go (helpful, but can slow you down).
- **JavaScript / Python** are more permissive — you must be mindful of types yourself.

---

## Side Discussion: Example Walkthrough

A participant (Mauricio) asked why the example shows `x1 + v1 = 2 + 1`. The coach clarified:

- `x1 = 2` is the starting coordinate.
- `v1 = 1` is **meters per jump**.
- After one jump: `2 + 1 = 3`, so kangaroo 1 is at position 3.
- Kangaroo 2 starts at `x2` and moves `v2` per jump simultaneously.

The velocities are applied at the same time each iteration; that simultaneity is what makes the meeting condition solvable with a single check per jump.

---

## Side Discussion: React Practice on HackerRank

John noted HackerRank's **Get Certified → Front End Developer** track has **React** problems. The coach confirmed these exist and are not too difficult, and also noted that candidates will get significant React practice during the Explorer phase and internship.

---

## Takeaways

- **Read constraints first** — they often eliminate entire branches of defensive code.
- **Write your verbal assumptions into comments** before writing code.
- **Match the return type** the problem signature demands (string vs. bool vs. int).
- **Update loop state** inside the loop, or your `while` will never terminate.
- A **well-structured pseudo code pass** is cheaper than debugging an infinite loop under time pressure.


---

# Ruby Solutions Deep Dive — September 24, 2025

Walkthrough of **Valid Anagram** with three solutions at different complexities (O(n²), O(n log n), O(n)), plus discussion of scaling considerations leading into **Group Anagrams**.

---

## Opening Question: Is More Practice The Only Way To Improve?

> "The simple answer is yes — if you're taking the right practice steps. Are you breaking the problem down? Testing along the way? Reviewing what you get stuck on and applying that to new problems? If you're doing everything right and just not hitting the time limit, then yes, the only way to improve is practice. That's the same with any sport or task. And resting. Taking breaks."

---

## Problem: Valid Anagram

Given two strings `s` and `t`, return `true` if `t` is an anagram of `s`.

### Approach 1 — O(n²) Nested Membership + Count

```python
def isAnagram(s, t):
    if len(s) != len(t):
        return False
    for letter in s:
        if letter not in t or s.count(letter) != t.count(letter):
            return False
    return True
```

- **Complexity:** O(n²). For each letter in `s`, `in t` is O(n) and `.count()` is O(n).
- **Runtime observed:** ~2.8 seconds on LeetCode's 53 test cases — passes, but beats only ~5%.
- **Lines of code:** small, which is nice, but scales poorly.

---

### Approach 2 — O(n log n) Sort and Compare

```python
def isAnagram(s, t):
    return sorted(s) == sorted(t)
```

- **Complexity:** O(n log n) dominated by the sort.
- **Runtime observed:** ~15 ms — beats ~82%.
- **Insight:** If both strings contain the same letters with the same frequencies, sorting them produces identical sequences.

> "On the Big O graph, O(n²) and O(n log n) aren't very far apart, but this is a huge improvement in practice — also with only a few lines of code."

---

### Approach 3a — O(n) Two Dictionaries

Build a frequency dictionary for each string, then compare key/value pairs.

```python
def isAnagram(s, t):
    if len(s) != len(t):
        return False
    d1, d2 = {}, {}
    for i in range(len(s)):
        d1[s[i]] = d1.get(s[i], 0) + 1
        d2[t[i]] = d2.get(t[i], 0) + 1
    for key in d1:
        if key not in d2 or d1[key] != d2[key]:
            return False
    return True
```

- **Complexity:** O(n) time, O(n) space.
- **Key check `key in dict` is O(1)** (hash lookup), versus `letter in string` which is O(n).
- Trade-off: **uses more memory** — two dictionary objects.

---

### Approach 3b — O(n) One Dictionary (Decrement Pattern)

Chris's contributed solution (with help from a friend):

```python
def isAnagram(s, t):
    if len(s) != len(t):
        return False
    count = {}
    for i in s:
        count[i] = count.get(i, 0) + 1
    for i in t:
        if i not in count or count[i] == 0:
            return False
        count[i] -= 1
    return all(c == 0 for c in count.values())
```

- **`dict.get(key, 0)`** returns the default `0` if the key doesn't exist, collapsing an if/else into one line. You must know this method exists.
- **Second loop decrements** instead of building a second dictionary — halves the memory footprint.
- The **final `all(...)` check** catches the edge case where one string has extra counts of a letter that the other doesn't.

> "This is a little bit more optimized. Even though both O(n) versions do the same thing, this one scales slightly better on memory."

---

## Coach's Nerdy Probability Aside

The coach wondered whether the final `all(count == 0)` check is strictly necessary for **real English words**. For two real words with the same letters and same length but differing frequencies (e.g., `racecar` vs a hypothetical `carrera` with matching letter sets but different counts), the probability is vanishingly low. For arbitrary random strings in test cases, though, it **is** reachable, so the check stays.

---

## Why Scalability Matters (Lead-in to Group Anagrams)

> "If this were production code loading a web page, and the page sits while the server groups millions of anagrams, the user is staring at a blank screen. Even a really efficient website can struggle at scale with millions of users and millions of rows. How efficiently your code runs is one of the main ways you deal with that."

**Group Anagrams** is the harder follow-up: determine which strings in a list are anagrams of each other and return them grouped. The efficient one-dictionary pattern above is the building block.

### Question: Two Dictionaries for Group Anagrams?

A participant asked whether to use two dictionaries for the group version. Coach's answer:

> "You could follow a very similar technique — create one dictionary per string, and for each new string do the key/count comparison. You'd do a bit more work because you're comparing across multiple strings, but it works."

---

## Space vs. Time Trade-off Summary

| Approach | Time | Space | LoC |
|---|---|---|---|
| Nested `in` + `count` | O(n²) | O(1) | ~5 |
| `sorted(s) == sorted(t)` | O(n log n) | O(n) for the sort buffer | 1 |
| Two dictionaries | O(n) | O(n) ×2 | ~10 |
| One dictionary + decrement | O(n) | O(n) | ~8 |

- **Space and time complexity go hand in hand** — improving one often costs the other.
- At small scale (n ≤ 50,000), the O(n log n) and O(n) versions look nearly identical. At 5M+ inputs the O(n) solutions pull ahead clearly.

---

## Review Habit Recommendation

> "Go back through problems, break down the elements so you understand them, then in a week delete it all and try to implement it from scratch. That way the knowledge really cements."


---

# Ruby Solutions Deep Dive — October 1, 2025

Deep dive on HackerRank's **Lisa's Workbook** problem, presented solutions, and coach feedback on study cadence and burnout management.

---

## Problem: Lisa's Workbook

Lisa has a workbook with `n` chapters. Chapter `i` contains `arr[i]` problems. Each page holds at most `k` problems, and **each new chapter starts on a new page** (problems from different chapters never share a page). A **special problem** is one whose problem number equals the page number it sits on. Return the total count of special problems.

### Parameters

- `n` — number of chapters
- `k` — maximum problems per page
- `arr` — 1-indexed array where `arr[i]` is the number of problems in chapter `i`

> "This is technically listed as easy, but it has so many variables to hold in your head. I think it deserves medium. The max score is 25 which is unusual — they know it's complicated."

---

## Mauricio's Solution (Refined)

Mauricio started with a data-structure approach, then refined to a direct simulation: for each chapter compute pages, for each page compute the first and last problem numbers on that page, then check if the page number falls in that range.

```python
def workbook(n, k, arr):
    page = 0
    special = 0
    for chapter_problems in arr:
        full_pages = chapter_problems // k
        remainder = 1 if chapter_problems % k != 0 else 0
        total_pages = full_pages + remainder
        for p in range(total_pages):
            page += 1
            first_problem = p * k + 1
            last_problem = min(first_problem + k - 1, chapter_problems)
            if first_problem <= page <= last_problem:
                special += 1
    return special
```

### Key Math

- **`full_pages = chapter_problems // k`** — integer division gives the count of completely filled pages.
- **Remainder page:** if `chapter_problems % k != 0`, there's a trailing partial page. Add 1.
- **First problem on page offset `p`:** `p * k + 1` (1-indexed problems).
- **Last problem on page offset `p`:** `min(first_problem + k - 1, chapter_problems)` — the `min` handles the final partial page where the chapter runs out before `k` problems are used.

---

## Coach's Alternative Framing: Dictionary Approach

The coach's first instinct was a dictionary `{page_number: [problems on that page]}`, building out the diagram from the problem statement as a data structure, then scanning each key to see if any value matches the key.

```python
# Sketch only
workbook = {}
page = 1
for chapter_problems in arr:
    pages_needed = chapter_problems // k
    if chapter_problems % k != 0:
        pages_needed += 1
    # assign problem ranges to page keys...
```

- **Pros:** Mirrors the visual diagram; easy to reason about.
- **Cons:** Extra memory for the data structure, extra loops to populate it.
- Mauricio's version eliminates the intermediate structure by tracking `first_problem` and `last_problem` as locals.

---

## Coach's Optimization Idea: Early Rejection

The coach proposed a filter that skips pages which **cannot possibly** contain a special problem before running the inner check.

### The Insight

For a given page number and current chapter:
- On page 1, we need the chapter to contain at least 1 problem.
- On page 2, the chapter must contain more than `k` problems (otherwise chapter 1's problems never reach page 2 from that chapter's page).
- **Generalized:** for page number `P` to possibly contain a special problem from the current chapter, the chapter must contain **more than `P` problems** (roughly — within that chapter's page span).

```
If current_chapter_problems < current_page_number:
    skip the inner page-match check entirely
```

> "It would allow us to do one less loop — or at least eliminate a lot of logic checks. The main thing is declaring from the start: what has to be true on any given iteration for us to move forward? If we can't move forward, skip to the next information."

The coach flagged that she had not tested this and invited the group to try it.

---

## Why This Problem Felt Hard

Reactions from the group: *"Spaghetti and meatballs"*, *"I hate this problem"*. Coach agreed:

> "It's a hefty problem just mentally — holding all these variables and concepts in your head while keeping in mind that you're just returning an integer. The one-based indexing is a small annoyance piled onto the mental load."

The value of practicing it is **logical decomposition**, not raw algorithm skill. This mirrors the kind of multi-requirement feature work expected in the internship.

---

## Study Cadence Discussion

Mauricio asked about the right mix of easy and medium problems per session.

### Coach's Recommendation

- **Do not practice for 5 hours at a stretch.**
- **Start with easies.** Two or three per day. If you knock them out of the park, try **one medium**.
- **One medium per day is the ceiling** while you are at this stage.
- **Don't stack mediums on the same day.**

> "Once you've solved one to three medium problems total in under an hour, regardless of consistency, you're good with mediums at this stage. Move forward with the curriculum, move into the internship, and then keep practicing mediums there because you're preparing for the job hunt."

### Signal That You're Ready to Interview

> "If you're finding success multiple times in a week, it's time to sign up for the interview. If the time limit is the only thing holding you back, sign up anyway — we can talk about it one-on-one."

---

## Burnout & Emotional Reset

Mauricio observed that after a draining problem, the next one feels impossible regardless of difficulty.

> "If you've hit a problem like that, don't start another that day or even the next day. Your brain is still working on it in the background. Take a day — maybe two — and usually when you come back you can knock it out no problem. You get two wins: the solved problem, and a fresh start on the next."

Applies to easies and mediums alike. If two easies in a row crush you, **today is not a coding day. Don't push it.**

---

## Habit-Building Reminder

> "Build good habits now — explaining your thought process, breaking down the problem, taking breaks. Bad habits follow you through your career. If you think you're burned out now, it's a lot worse on a 9-to-5 clock with results expected. Learn what good habits look like and what outcomes they lead to."


---

# Ruby Solutions Deep Dive — October 15, 2025

Walkthrough of **Find the Index of the First Occurrence in a String** with an emphasis on reading constraints, translating problems into your own words, and the role of library methods versus from-scratch implementation. Also: how to effectively reverse-engineer a lookup solution for learning.

---

## Opening: Reverse-Engineering Solutions When You're Stuck

Recap of the prior Sunday's session on using other people's solutions as a learning tool when you've exhausted your own attempts.

### The Process

1. **Exhaust your own effort first.** Debug, break down, understand your failing test cases. Don't jump to the solution at the first sign of struggle.
2. **Look up the solution** when you've genuinely done your due diligence.
3. **Read it line by line.** Add print statements, ask questions, use the debugger until you fully understand how it works.
4. **Write pseudo code for it in your own words** — reverse engineer your understanding.
5. **Delete the solution** and set the pseudo code aside.
6. **Come back in a day or two.** Rewrite the code from your pseudo code, Googling specific syntax questions (like how to insert into a dictionary) as they come up — that's normal developer work.

> "You're learning the solution, you're learning to reverse engineer it, you're learning what good pseudo code looks like, and you're learning not to rely on pasting in a solution but actually applying the knowledge you just gained."

### Bonus Benefit: Reading Other People's Code

> "That's huge. Even when you get to the internship, you'll be thrown into situations where you need to fix code, and you need to know what it says. Reverse engineering is practice reading unfamiliar code."

---

## Chat GPT & Learning

Side discussion sparked by a participant in the low-code internship. Coach's take on AI assistants during learning:

> "Chat GPT is great for when you already know what you want to do — it's helping you, it's assisting you. But if you're using it because you're not sure how to make the next step, that's when you want to pause and ask: is this actually helping me learn, or is it doing the learning and I'm just floating through?"

If your goal is to go to the full-stack or front-end internship, **put Chat GPT on pause until later**. If your goal is to stay in low code, become an expert prompter — either way, know which you're choosing.

---

## Problem: Find the Index of the First Occurrence in a String

> Given two strings `needle` and `haystack`, return the index of the first occurrence of `needle` in `haystack`, or `-1` if `needle` is not part of `haystack`.

### Example 1

- `haystack = "sadbutsad"`, `needle = "sad"` → `0`
- `"sad"` occurs at indices `0` and `6`; first occurrence is at `0`.

### Example 2

- `haystack = "leetcode"`, `needle = "leeto"` → `-1`

---

## Translating the Problem Into Your Own Words

> "It's very important to write it in your own words. Make the translation of what they're telling you into how you are understanding it."

```
Given string `needle`, find exact string match as a substring within `haystack`.
If we find a string match (e.g. "sad" in "sadbutsad"), return the index position
of the first character of the first occurrence.
Return an int representing a valid index position.
If no match, return -1.
```

### The `-1` Sentinel Convention

> "Returning `-1` is very common — you'll see it a lot in library methods. Binary search returns `-1` if nothing matches. It's a standard way to signal 'not found' for anything that normally returns an integer."

---

## Reading the Constraints

```
1 <= haystack.length, needle.length <= 10^4
haystack and needle consist of only lowercase English characters.
```

### What the Constraints Do NOT Tell Us

The constraints give bounds on **each** length independently, but they do **not** say that `needle.length <= haystack.length`. So `needle` could in theory be **larger** than `haystack`.

> "It's not specifically telling me those implementation details, so I have to account for both possibilities — that's what you get from the constraint."

### What the Constraints DO Tell Us

- Both strings are **non-empty** (length >= 1).
- Only **lowercase English characters** — no whitespace, unicode, or special characters to parse out. Exact string matches work.

### Resulting Pseudo Code Addition

```
Check that haystack.length >= needle.length.
Otherwise return -1.
Then search for needle inside haystack...
```

> "We're not assuming needle is smaller than haystack. We're assuming it's possible that it is. Since the problem doesn't promise otherwise, we're almost guaranteed to see a test case where needle > haystack."

---

## First Approach Attempt: `in` Operator

A participant defaulted to a `for` loop. The coach nudged toward a simpler first check:

```python
print("sad" in "sadbutsad")  # True
```

The `in` operator tests substring containment and returns a bool. That's a useful confirmation but it **only tells you if the match exists** — it does not give you the index.

> "An `if` statement is testing a condition that returns true or false. But you don't actually need the `if` to test the condition — you can write the condition directly."

---

## Second Approach: `str.find()`

Googling "how to get the index of a character in a string" surfaces two Python string methods:

### `str.find(substring)`

- Returns the **first index** where `substring` occurs.
- Returns **`-1`** if not found.
- **This matches the problem signature exactly.**

### `str.index(substring)`

- Same as `find()` on success.
- **Raises `ValueError`** if not found.

### Why the Two Variants Exist

> "In production, maybe you're checking an API response or a data exchange, and if the thing isn't there you need to throw an error and surface it on the front end. Instead of checking for `-1` and writing the error yourself, `index` does it for you."

### Final Solution

```python
class Solution:
    def strStr(self, haystack: str, needle: str) -> int:
        return haystack.find(needle)
```

**One line.** Beats high percentile on runtime. The coach contrasted with a participant's working for-loop solution that also beat 100%.

---

## Is the One-Liner "Preferred"?

A participant asked whether using the library method counts as cheating or is preferred in an interview.

> "It wouldn't matter to me. You knew the method, you learned it, you applied it, we solved all the test cases. The purpose of the technical interview isn't to confirm you can code from scratch — that's just a muscle you build over your career."

> "'There is no intellectual work other than knowing that the function exists.' — That IS intellectual work. Knowing `find` exists, knowing what it takes and returns, knowing how to implement it to solve a problem — that is knowledge."

**Use library methods.** Both in the Joy of Coding interview and in real-world interviews. But also understand **how** they work under the hood so you can solve problems in environments where the method doesn't exist.

---

## The Challenge: Reverse-Engineer `find`

The coach's homework: solve this problem **without** any library method. Research how `find` works behind the scenes, write pseudo code from that explanation, delete the reference, and implement it from scratch.

### Why Bother?

> "All the little sub-parts — the if condition, the for loop, checking for a specific index, returning the index — show up in almost every problem. If you can master doing that part from scratch, you're expanding your ability to solve a wider variety of problems where `find` isn't available."

> "Mod 2 teaches you the bare bones — the foundation — so you could solve any problem without needing a library method. The library methods are shortcuts. You should learn them, but learning the from-scratch version makes you a much stronger developer."

---

## Key Takeaways

- **Read constraints, then determine which assumptions the constraints resolve for you.** Write less code by relying on what the problem guarantees.
- **Write the problem in your own words** before coding.
- **Test a quick idea** (like `"sad" in haystack`) to confirm feasibility before committing to a full approach.
- **Add `find` and `index` to your string methods toolkit.** They differ only in how they signal "not found".
- **`-1` is the standard sentinel** for integer-returning functions when a result isn't available.


---

# Ruby Solutions Deep Dive — October 29, 2025

Deep dive on **Minimum Time to Make Rope Colorful** (the "balloons" problem) with two presented approaches, plus a follow-up on reverse-engineering Python's string methods `find`, `count`, and `replace`.

---

## Problem: Minimum Time to Make Rope Colorful

You are given an array `colors` where each element is a letter representing a balloon's color, and a parallel array `neededTime` where each element is the seconds required to remove the balloon at that index. Remove the **minimum total time** worth of balloons such that no two adjacent balloons share a color.

### Constraints

- `len(colors) == len(neededTime)` (one-to-one correspondence)
- `1 <= len(colors) <= 10^5`
- `1 <= neededTime[i] <= 10^4`
- From every consecutive run of same-colored balloons, you must keep exactly one — the **most expensive** one (because removing it would waste time).

---

## Mauricio's First Approach — Nested Loops (Brute Force)

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

## Mauricio's Refined Approach — Single Loop, O(n)

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

### Why Update `neededTime[i]` In Place?

> "As I go through the array, I'm keeping one position before — `i - 1` — always holding the current maximum. So I always get the min against the maximum, because ultimately I'm going to leave the maximum there. This line ensures the next iteration has the correct running maximum at `i - 1`."

- **Time:** O(n) — one pass.
- **Space:** O(1) extra — mutates `neededTime` in place.

---

## Coach's Parallel Approach — External Tracking Variables

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

### Trade-off Comparison

| | Mauricio's refined | Coach's variables |
|---|---|---|
| Extra variables | 0 | 2 (`last_color`, `last_index`) |
| Mutates input | Yes (`neededTime[i]`) | No |
| Conditional branches | 1 | 2 (with else) |
| Lines of code | Fewer | More |

> "From an efficiency standpoint, I like Mauricio's more. For simplicity's sake, I like his more. Mine was easier to implement on the first try just thinking about it, but his makes more sense."

---

## Whiteboarding Worked Example

Colors: `blue, blue, blue, red, green, green`
Times:  `1, 3, 2, 1, 2, 1`

- First blue group sum = 6, max = 3 → remove 3 seconds worth (the 1 and the 2), keep the 3.
- Green group sum = 3, max = 2 → remove 1, keep the 2.
- **Total cost = 3 + 1 = 4 seconds.**

> "Do a trace manually with pen and paper, updating the variables and the arrays. Then you realize how it works. That's the best way to understand somebody else's algorithm."

---

## Is This Really "Medium"?

> "I'd say this is on the lower end of the medium problems. I've seen easy-ranked problems harder to conceptualize than this one. The diagram is clear and the steps are straightforward."

---

## Follow-up Challenge: Reverse-Engineer `count` and `replace`

Revisiting the earlier **Find the Index of the First Occurrence** session where the solution collapsed to a one-liner `haystack.find(needle)`. The challenge was to implement `find` from scratch with a for loop:

```python
def find(haystack, needle):
    for i in range(len(haystack) - len(needle) + 1):
        if haystack[i] == needle[0]:
            if haystack[i:i + len(needle)] == needle:
                return i
    return -1
```

### New Challenges

1. **`str.count(substring)`** — return the number of non-overlapping occurrences of `substring` in the string.
2. **`str.replace(old, new)`** — return a new string where all occurrences of `old` are replaced with `new`.

Both should be implemented **without calling the library method**, to exercise the same from-scratch muscle.

### Use in a Real Interview?

> "You are allowed to use `find` or `count` in the tech interview. It's just rare that a single method solves the whole problem outright. Usually it's part of a larger solution."

### Pseudo Code Sketch for `count`

Iterate through the larger string; at each position, check whether the substring starting there matches the target. Increment a counter on match.

```
counter = 0
for i in range(len(text) - len(target) + 1):
    if text[i:i + len(target)] == target:
        counter += 1
return counter
```

---

## Session Meta: Sunday vs Wednesday Format

- **Sundays:** new problem introduced, optional mock interview.
- **Wednesdays:** review of the mock interview and/or Sunday's problem.

---

## Stage Fright & Presenting

A participant (Rebecca) committed to presenting her `count`/`replace` code next session despite stage fright.

> "That's a great way to practice. The idea that someone watches you while you do this — whether you look stupid or not — it's a rehearsal for the tech interview."

### W3 Schools Gotcha

> "W3 Schools' indentation checking for Python is really strict and annoying. If you're getting a lot of errors, tab everything back to the left and re-indent. Sometimes the exact same code will work on a second attempt."


---

# Ruby Solutions Deep Dive — November 5, 2025

Review of Mauricio's solution to **Median of Two Sorted Arrays** (LeetCode Hard) using the merge step from merge sort, followed by a mock interview on **Longest Harmonious Subsequence** (LeetCode Easy, deceptively tricky).

---

## Preamble: Finding "Implementation Algorithm" Problems on LeetCode

A participant asked how to find the HackerRank "Algorithms → Implementation" equivalent on LeetCode, since LeetCode doesn't expose that subcategory.

> "I think you just have to Google the specific algorithm you want to practice, or just do a generic list. Or ask Chat GPT — give it a problem and ask if it knows LeetCode problems similar to it. I haven't really deviated outside of five playlists and the Blind 75."

> "LeetCode is kind of weird — it's easy to find problems, but hard to find problems on the site."

---

## Problem: Median of Two Sorted Arrays (Hard)

Given two sorted integer arrays `nums1` and `nums2`, return the median of the combined sorted array.

- **Constraint hint:** the problem asks for O((m+n)) or better. A trivial `sort(nums1 + nums2)` is disallowed.
- **Key realization:** the **merge step of merge sort** is exactly what you need. You don't have to merge sort anything — these arrays are already individually sorted. You just need the two-pointer merge.

---

## Mauricio's Solution — Merge Then Compute

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

### Key Points

- **Two pointers `i` and `j`** walk each array. Append the smaller of the two current values and advance its pointer.
- **`.extend()` not `.append()`** for the leftovers — `append` would add the remaining slice as a single nested list.
- **Leftovers are already sorted**, so no additional work is needed.
- **Median calculation:** odd length returns the middle element; even length returns the average of the two middle elements.

> "The intuitive part was the two pointers and comparing element by element. The part that's not intuitive and you have to check is the leftovers — first being aware that there even are leftovers. You tend to think you went through everything, but one may have finished first."

---

## Coach's Alternative — Stop At The Median Index

The coach's approach avoided building the full merged array. Compute the target index `(len(nums1) + len(nums2)) // 2`, then advance through both arrays until reaching that index and return the value there.

### Why the Coach Didn't Like Her Own Version

To handle the case where one array runs out before the target index is reached, she hard-coded a **sentinel value outside the constraint range** (like `10**6 + 1`) so the exhausted side would always lose the `min` comparison.

> "That's kind of a faux pas. I'm hard-coding against the constraints. Mauricio's version is cleaner — mine was ugly because I was excited my idea worked and didn't go back and clean it up. That's real-life coding: you come up with something sloppy, then refine it before pushing to production."

---

## Mock Interview: Longest Harmonious Subsequence (LeetCode Easy)

> A **harmonious array** has `max - min == 1`. Given an integer array, return the length of its longest harmonious **subsequence** (elements in order, but not necessarily contiguous).

### Example

`[1, 3, 2, 2, 5, 2, 3, 7]` → answer `5` (the subsequence `[3, 2, 2, 2, 3]`).

> "Subsequence means you can skip elements. You're not restricted to contiguous runs."

### Mauricio's Attempt

He tried to track a running `max`/`min` while traversing and append the current element to a `current` list if the difference equaled 1. The approach broke down on the first few values because:

- Only tracking `max` and `min` against the current element loses the previous values.
- The array is **not sorted** (contradicting his initial assumption).
- A harmonious subsequence is really a count of **how many times each value and its neighbor (value ± 1) appear**.

### Coach Feedback

> "You want to return a number, not necessarily an array. Maybe you want to keep count of what would go in the array without actually creating the array. That's a different mindset."

> "Test along the way. You got all of this code written, and when we traced the first few values, it broke down after a few iterations. Testing earlier would have caught it before you moved too far."

### Topic Tags As Hints

LeetCode listed the problem's tags as **Hash Table, Sliding Window, Sorting, Counting**.

> "Hash table is a big clue. Sliding window can be a clue. Sorting is in there. Counting — you were going to count it anyway."

### The Hash Table Approach (Coach's Working Solution)

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

### Sliding Window Variant

Sliding window **can** work, but only if you first sort the array to make the "harmonious" values adjacent — sacrificing time to sorting for logical simplicity.

> "There are a few different versions of the sliding window. It's kind of a misnomer — it's more like sliding windowS."

---

## Easy vs Hard Labeling

> "This is not an easy problem to me. It's easy when you know how to do it. An acceptance rate of 64% on an 'easy' is a good indication that it shouldn't necessarily be an easy problem. I wouldn't give you a problem like this for the technical interview — but it's a good one to add to your tool belt."

---

## Takeaways

- **Merge sort's merge step** solves "combine two sorted arrays" problems cleanly. Don't forget the leftovers.
- Use **`.extend()`** for remaining slices; `.append()` nests them.
- **Hash tables / frequency counts** unlock a whole class of "count occurrences with a relationship" problems — harmonious subsequences included.
- **Pseudo code and pen-and-paper tracing** are worth the up-front time on tricky problems. Don't jump straight to code under pressure.
- When your idea isn't working after a few iterations, **stop and re-trace with real values** before writing more code.
- If you hard-code against a constraint as a sentinel, flag it and clean it up later — it's a real-world "sloppy first draft" move.


---

# Ruby Solutions Deep Dive — November 12, 2025

Deep dive on LeetCode's **Repeated Substring Pattern** (Easy), including assumption-testing methodology, Mauricio's O(n²) solution, and a discussion on "patterns vs templates" in interview prep.

---

## LeetCode vs HackerRank Setup

A participant asked about LeetCode's mandatory `class Solution:` wrapper vs writing standalone functions. Verdict:

> "You do have to keep the class. When they run test cases, they create an object from the `Solution` class and call the function as a method. You can still write and test anything you want inside the function — the class just has to stay there."

> "LeetCode makes you find edge cases. HackerRank gives you more info up front. HackerRank is definitely better for beginners."

---

## Problem: Repeated Substring Pattern

> Given a string `s`, check if it can be constructed by taking a substring of it and appending multiple copies of the substring together.

### Examples

- `"abab"` → `true` (`"ab"` × 2)
- `"aba"` → `false` (no substring tiles the whole string)
- `"abcabcabcabc"` → `true` (`"abc"` × 4)

### Constraints

- `1 <= s.length <= 10^4`
- `s` consists only of lowercase English letters.

---

## Assumption-Testing Methodology

The coach demonstrated how to use LeetCode's custom test case box as an **assumption laboratory** before writing any real code:

### Assumption 1: Does a single character count?

Test case: `"a"`. Expected output: `false`.

> "A length of 1 is NOT considered repeating."

### Assumption 2: Does a single character repeated count?

Test case: `"aaa"`. Expected output: `true`.

> "A repeated single character IS considered a repeating substring."

### Assumption 3: Does odd vs even length matter?

Initially the coach thought all valid answers would have even length. But `"abcabcabc"` (length 9) is valid. **Length parity doesn't matter.**

> "If you're having a question or assumption about the problem, write it out at the very top. Even if you haven't started developing an approach, get some questions down that you can test or see if the problem answers for you."

### LeetCode vs HackerRank Custom Tests

- **LeetCode** shows you the expected output for custom test cases.
- **HackerRank** lets you add custom test cases but doesn't show expected output — you have to use `assert` or print statements to validate.

---

## Mauricio's Solution

```python
class Solution:
    def repeatedSubstringPattern(self, s: str) -> bool:
        n = len(s)
        for sub in range(1, n):
            if n % sub == 0:
                candidate = s[:sub]
                if candidate * (n // sub) == s:
                    return True
        return False
```

### How It Works

- **`sub`** is the candidate substring length, iterating from 1 up to `n - 1`.
- **`n % sub == 0`** filter — if `sub` doesn't evenly divide the string length, it can't possibly tile the string. Skip it.
- **`s[:sub]`** slices the candidate substring from the start.
- **`candidate * (n // sub)`** repeats the candidate the required number of times.
- **String comparison** `== s` checks whether the reconstruction matches the original.

### Key Insight

> "If a string forms itself by repeating a substring, the substring must fit evenly into the length. So I'm only interested in substrings whose length divides the total length."

---

## Big O Analysis

### Time Complexity: O(n²)

- Outer loop iterates up to `n` candidate lengths.
- Inside each iteration, **string concatenation and comparison are each O(n)** operations — Python has to build the repeated string character-by-character.
- Nested O(n) inside O(n) → **O(n²)** in the worst case.

> "The filter `n % sub == 0` only skips some iterations — it still moves through a linear amount of inputs. At worst it's still O(n²). That doesn't mean it's a bad solution — it just means you should be able to answer this question for the job hunt."

### Coach's Clarification on Mauricio's Confusion

Mauricio objected that as `sub` grows, the number of repetitions `n // sub` shrinks, so the work per iteration shrinks too. True — the total work is closer to `n * H(n)` (harmonic) than `n²`, but for interview discussion, **worst case big O is what matters**, and that's O(n²) when concatenation dominates.

---

## Conceptual Sticking Point (Breakout Room)

A participant (Linda) struggled because she expected **two parameters** — a string and a substring — and the function only gives one. The group walked through:

> "You have to adapt your understanding to what the problem gives you. You're not given the substring. You have to figure out all the possible combinations of what the substring could be, or if no combination works, return false."

### The Brute Force Mental Model

- Start with **window size 1** — take the first character. Repeat it across the full length. Does it equal `s`?
- If no, **window size 2** — take the first two characters. Repeat. Does it equal `s`?
- Continue until you find a match or exhaust options up to `n - 1`.

### Critical Observation

> "The first string that will repeat has to come from the beginning of the string. Whatever's at the front has to also be repeated towards the end. We couldn't say `cab` in the middle — the prefix is what we test."

---

## Using `str.count()` As An Alternative

A participant asked whether Python has a built-in like "tell me if a letter is repeated". Coach's answer:

> "Close — `count` would work. You'd have to save the count to a variable and compare it against the potential length. But yeah, that's basically what we just discussed."

---

## Patterns vs Templates Discussion

Mauricio asked about the "four pillars of problem solving" framework, specifically the "find your template" step. Is that the same as pattern recognition (sliding window, binary search, etc.)?

### Coach's Take

> "I wouldn't call that a template. I'd call it understanding the problem and knowing what to apply — what data structure, what algorithm, what logical approach."

> "When I think of 'template,' I think of starter code. Pasting in even a modified sliding-window template is pasting in most of the work the interviewer expects you to show."

> "An interview isn't just getting the code working. It's showing that you can break down the problem, what assumptions you're making, what questions you're asking, how you're checking your work at each step. Those are all problem-solving skills."

### Mauricio's Counterpoint

> "After doing hundreds of problems, you recognize patterns. A sliding window in its most basic form is an algorithm — that's your starting point, and you adapt it to the problem. You already understand the basic principle, so you use it and tweak it."

### Coach's Resolution

> "Yeah — if you're taking the basic sliding window, writing it out yourself, and then saying 'I'm going to use this approach but modify it to work through this problem,' that's fine. There are problems that specifically require that, like ones that use the **concepts** of binary search without being literal binary search."

---

## Takeaways

- **Write assumptions as comments at the top** of your code and test them against provided examples.
- **Use LeetCode custom test cases as an assumption lab** — change the input, see the expected output.
- **String concatenation is O(n)** — nesting it inside another loop often gives you O(n²) overall.
- **Patterns ≠ templates.** Recognizing a sliding-window problem is valuable; pasting a template is not.
- **Problem-solving visibility matters more than raw correctness** in an interview.
- **Start with the shortest window and grow.** The prefix constraint means any valid repeating substring must begin at index 0.


---

# Ruby Solutions Deep Dive — November 19, 2025

Announcement of schedule changes, introduction of the **Technical Interview Success Rubric**, and a mock interview on **Assign Cookies** (LeetCode Easy).

---

## Schedule Change: Wednesdays Only

Starting after Thanksgiving, there will be **no more Sunday sessions**. Wednesday sessions at 2:00 PM will remain, focused exclusively on **mock interviews** plus coaching discussion.

### Rationale

> "I'm kind of overwhelmed. It aligns with the direction Dr. Emily wants us moving — focusing on core things week to week and helping you advance through to the next phase. And the best way to advance is to practice mock interviews."

- **Homework-style problem breakdowns** are discontinued. The existing session recordings cover that material.
- Mock interviews will be **volunteer-based** or random selection — no mandatory sign-ups.
- **Pseudo code-only mock interviews are allowed** for candidates still building coding confidence.

---

## Technical Interview Success Rubric

The coach has conducted **over 115 technical interviews** and compiled observations into a draft rubric covering four dimensions:

### 1. Communication

**Meeting expectations:**
- Restate the problem in your own words.
- Explain what you think you need to do and what you expect to return.
- Sound out your thoughts while writing pseudo code and coding.
- Confidently answer follow-up questions about your code.

### 2. Technical Knowledge

**Meeting expectations:**
- Comfortable with **Mod 2** data structures and algorithms.
- Understand function parameters, input/output types, and test cases.
- Can read library/method documentation and apply it correctly.

### 3. Problem Solving

**Meeting expectations:**
- Break the problem into smaller pseudo-code steps.
- Test incrementally with print statements.
- Troubleshoot errors by identifying where they came from.

### 4. Behavior

**Meeting expectations:**
- Read the full problem including examples and constraints.
- Revisit the problem mid-solution to update assumptions.
- Bounce back from errors quickly without spiraling.
- Accept feedback and use it to advance.

### Time Correlation

- **Below expectations** → 20+ minutes, likely fails.
- **Meeting expectations** → around 20 minutes.
- **Exceeding expectations** → 10–15 minutes, ready for job-hunt level interviews.

### Pass Rate Reality

> "Out of the 115 I've run, eventually everyone passes — there's never been someone who didn't make it through unless they left the program or decided coding wasn't for them. The average is **two to three attempts**. Very rarely do people pass on the first try, and that's from nerves and being put on the spot for the first time."

### Common Failure Causes

- **Nerves and pressure.** Skilled candidates right on the cusp sometimes fail two or three times before passing.
- **Going down a spaghetti path.** Coach's remedy: recognize it fast, scrap it, and restart with better understanding.
- **Getting lost in errors.** One candidate said "I had an idea but every time I tried that in the past I hit errors, so I didn't even try it" — that idea was the solution.

> "Errors don't scare me. They're just telling me that something's wrong in my assumptions. The best way to handle them is incremental testing."

### The Incremental Testing Math

> "If you add 10–20 seconds of print-statement testing after each line, that adds up to maybe 2 minutes across the whole problem. If you're moving at a good pace, that's nothing. You can still solve the problem in under 10 minutes. Versus hitting an error with a whole code block written, now having to figure out which line caused it."

### Difficulty Escalation

Each subsequent attempt gets **incrementally harder** within the easy range — never crossing into medium territory.

> "After each time, I do expect you to be practicing and working on mastery. But we never leave the realm of easy. Probably as close to the edge of easy as we can get."

---

## Mock Interview: Assign Cookies (LeetCode Easy)

### Problem

> Assume you are a parent with several children and you want to give them cookies. Each child `i` has a greed factor `g[i]`, which is the minimum size of a cookie that will content them. Each cookie `j` has a size `s[j]`. If `s[j] >= g[i]`, you can assign cookie `j` to child `i` and the child will be content. Your goal is to maximize the number of content children.

### Function Signature

```python
class Solution:
    def findContentChildren(self, g: List[int], s: List[int]) -> int:
```

### John's Initial Confusion

Coming from a JavaScript/TypeScript background, John got tripped up by Python's type annotations:

- `g: List[int]` means `g` is a parameter of type "list of integers" — **not** a variable named `List`.
- `-> int` means the function returns an `int`.
- `int` in the annotation is **not an actionable variable** — it's a type reference. Similar to TypeScript.

> "Only `g` and `s` are actionable variables. The annotation `int` just tells you the expected return type."

### Coach Feedback: Pull the Problem Into Code Comments

John tried to reverse-engineer the problem from the function signature alone, which wasted time.

> "What can we pull from the problem statement into our code comments so that we can quickly at any point know what the goal of the problem is, what the inputs are, and what our expected output is?"

### Coach Feedback: Test Assumptions Early

John used the word "assumption" naturally while talking through his approach but didn't write or test his assumptions until later.

> "The first thing I would do is test an assumption. Eventually you did with a print statement — but not until a little bit later. Move that up in the timeline."

### The Approach Discussion

John asked which array to iterate through — children (`g`) or cookies (`s`). The coach steered him toward understanding:

- **Length of `g`** = number of children.
- **Each integer in `g`** = how much that child needs.
- **Length of `s`** = number of cookies.
- **Each integer in `s`** = size of that cookie.

### Standard Solution Sketch (Greedy)

```python
def findContentChildren(self, g, s):
    g.sort()
    s.sort()
    i = j = 0
    while i < len(g) and j < len(s):
        if s[j] >= g[i]:
            i += 1
        j += 1
    return i
```

- Sort both arrays, then walk through cookies and assign the smallest-sufficient cookie to the hungriest child who can still be satisfied.
- John didn't reach this in 20 minutes but was on the right conceptual path.

---

## John's Flash Cards / Cheat Sheet Technique

John mentioned he'd made **index cards** as flash cards for Python syntax after coming from JavaScript. They contained concept-level snippets — a basic for loop with `n` for length, data structure templates, not full problem solutions.

> "That's a great way to solidify your knowledge and have something to quickly glance at. The challenge is what to put on the flash cards — you don't want to overwhelm yourself."

> "Absolutely these are good templates/resources for the interview. Code samples at the concept level, not full solved problems."

---

## Silent vs Verbal Time Allocation

A participant asked about dynamics — how long a candidate should silently read the problem.

> "There's no limit. I've had people spend 8–15 minutes reading and pseudo-coding and only 2 minutes writing code. Or the opposite. Each person is different."

> "The important part isn't how long each step takes. It's: once you reach a point where you understand the problem enough to explain it, **can you then explain it out loud** as an observer? And at regular intervals, can you recap what you're thinking and doing?"

### What To Avoid

> "Sitting in silence the entire time until the end — whether all your test cases pass or you've hit an error and run out of time. You can pass while silent, but it's not great. Interviewers want to know how you think, not just whether you got there."

### Time Budget Warning

> "If you're spending 15 out of 20 minutes breaking down the problem with no pseudo code and no actual code, that's an indicator you need to shorten that step — not by skipping it, but by honing in on what you're doing."

---

## Takeaways

- Everyone eventually passes — **two to three attempts is the average**.
- **Communication is a first-class interview skill** alongside raw problem-solving.
- **Write your assumptions as comments and test them early** with prints.
- Python type annotations (`List[int]`, `-> int`) are **not variables** — they're declarative hints.
- **Practice under pressure in front of an audience** replicates the real interview more than solo practice ever can.
- **Flash-card style concept sheets** are legitimate interview aids when focused on syntax and data structure basics.


---

# Ruby Solutions Deep Dive — November 26, 2025

Thanksgiving-week session with two back-to-back mock interviews: **Plus One** (Lisa) and **Search Insert Position** (John). Emphasis on verbalizing process over reaching a final solution.

---

## Process Note: Writing vs Speaking

A participant shared that she prefers writing out her thoughts but the interviewer can't see her write. The coach's workarounds:

> "You can still use pen and paper if you need to, then talk about what you're writing. Or open Microsoft Paint, Zoom's built-in whiteboard, or just type pseudo code directly into the code editor as comments. The point is: figure out how to incorporate writing into the digital scope — don't cut it out entirely just because you think you have to talk the whole time."

### Zoom Whiteboard Discovery

Zoom has a built-in whiteboard feature under "More settings" — useful for design meetings, explaining systems in the internship, or mock interview diagramming.

---

## Mock Interview #1: Plus One (Lisa)

### Problem

> You are given a large integer represented as an integer array `digits`, where each `digits[i]` is the i-th digit of the integer. The digits are ordered from most significant to least significant in left-to-right order. The large integer does not contain any leading zeros. Increment the large integer by one and return the resulting array of digits.

### Example

- Input: `digits = [1, 2, 3]` → Output: `[1, 2, 4]`
- Input: `digits = [9]` → Output: `[1, 0]`

### Lisa's Approach — Convert, Add, Convert Back

Lisa had seen this before and remembered the strategy:

1. **Convert the list of digits into a whole integer.**
2. **Add one.**
3. **Convert back into a list of digits.**

### Implementation Sketch

```python
class Solution:
    def plusOne(self, digits: List[int]) -> List[int]:
        # Convert digit list to a single string
        whole = ""
        for digit in digits:
            whole += str(digit)
        # Convert to int, add one
        whole = int(whole) + 1
        # Convert back to a list of ints
        return [int(d) for d in str(whole)]
```

### Coach Feedback: Reading Errors Out Loud

> "I really liked hearing you say 'read the error, read the error.' It's very easy to see that there's an error on this line and think you understand it, but once you actually read — 'oh, this thing doesn't do this thing' — you sit and think about what it means. That's how you work through errors."

### Coach Feedback: Think Out Loud When Stepping Back

> "You started going through the loop, got a little stuck, and said 'let me take a step back, go up to my comments, spell this out.' I liked hearing that thought process and liked that you walked it out in the code comments. That showed me you understood the problem and what you were doing."

### Looking Up Syntax Is OK

> "If you want to look up how a function works, how the syntax goes, or how to do a simple thing — that's totally fine. What we want to avoid is looking up 'how do I take a list of integers and turn them into a number and do math on them,' where it gives you a full code template. Discreet items like `map`, `split`, or type conversion are fine."

### When Nerves Get In The Way

Lisa noted that nerves slowed her down near the end. Coach:

> "The pressure gets to you. That's normal — and that's why we practice."

---

## Mock Interview #2: Search Insert Position (John)

### Problem

> Given a sorted array of distinct integers and a target value, return the index if the target is found. If not, return the index where it would be if it were inserted in order. You must write an algorithm with **O(log n)** runtime complexity.

### Examples

- `nums = [1, 3, 5, 6], target = 5` → `2`
- `nums = [1, 3, 5, 6], target = 2` → `1`
- `nums = [1, 3, 5, 6], target = 7` → `4`

### John's Approach — `list.index()`

John tried to use Python's built-in `list.index(target)` method, which throws a `ValueError` if the target isn't present. When he tested with a missing target, he hit the error and had to pivot.

### Coach Feedback: Silent Thinking Is The Biggest Problem

> "It's hard to know what you think about this problem because you haven't shown us what you think. There was a solid minute or two where no action was being taken, you were clicking in the for loop and back to the index. I could see you were thinking, but we have no idea what you were deliberating."

> "Even if you could solve problems, being able to explain what's going through your process and walk us through your process is a big key for interviews specifically. Not just tech interviews — all interviews, and a lot of work life."

### The Chunking Exercise

The coach walked through how to **chunk the problem** before writing code:

1. **Determine if the target is in the list** — yes or no.
2. **If yes, return the index.**
3. **If no, figure out where the target would be inserted** — return that index.

> "If we had seen those chunks existed before you started working through them, it would have been a reference point. Then as you're thinking, you're not worried about what to do three steps from now — you're focused on the problem in front of you."

### What The Problem Actually Wants: Binary Search

> "This problem is asking you to write a binary search. It's not telling you outright — it says 'write an algorithm with O(log n) runtime complexity.' The binary search algorithm includes the aspect of 'what do you do if you don't find it?' You're always between two indexes, and you change the `return -1` step to return the insertion position instead."

For today's session, the coach was not evaluating whether John wrote binary search specifically — she wanted to see the **process**.

### Alternative: The `bisect` / "insert and sort" Approach

A participant suggested: add the target, sort, find the index. The coach noted that the array is **already sorted and distinct** — "those are both key pieces of information" — so you don't need to sort. You can just increment through it and find the right spot.

### `list.index()` vs Alternatives

- `list.index(target)` — raises `ValueError` if not found.
- You could instead use `try/except` to catch the error.
- Or check membership first with `target in nums` before calling `.index()`.
- Or manually iterate and build your own search (which for this problem should be binary search).

---

## What Is `self` in LeetCode's Function Signature?

A participant asked about the `self` parameter in LeetCode's `class Solution:` wrapper.

> "For the purposes of writing your function, you can ignore it. `self` is the way of tying the function to the class. It's a required parameter as a class member."

### Mental Model

> "LeetCode made a platform for you to write your code in. The `class` stuff is under-the-hood scaffolding that enables you to write in the 'your code here' section. Behind the scenes, they instantiate the class as an object and call your function in a loop over all the test cases, passing `nums` and `target` for each one."

### Comparison to Built-in String Methods

`str.replace(old, new)` under the hood:

```python
class str:
    def replace(self, old, new):
        ...
```

When you call `"hello".replace("h", "j")`, Python is calling the `replace` method on the string object, and the `self` parameter holds the string itself. LeetCode's `Solution` class is the same pattern.

---

## Coaching Philosophy: Speed Drills, No More Homework

> "We're going to keep doing these like speed drills — focus on the process, work through the process, here's a problem, do your steps, get the experience. Through that repeated structure, you're honing your skills and getting the stress and nerves out of performing."

### "Trauma-Brained" Information

> "When you have to look it up in front of an audience and then explain how your code works line by line and why it meets the solution, you're going to have a much easier time holding onto that piece of information because you've kind of trauma-brained it into yourself. Over time it feels less like trauma, I promise."

---

## Takeaways

- **Verbalize your process continuously.** Silent thinking is the #1 reason candidates fail to pass even when their code works.
- **Chunk the problem** into concrete sub-problems before writing code.
- **Reading the error out loud** forces you to actually understand what it's saying.
- **`list.index()` throws `ValueError`** — know the alternatives (`in` check, try/except, manual search).
- **Looking up specific syntax is allowed** in the interview, but builds up in time cost. Use it, but practice reducing reliance.
- **"Sorted and distinct"** in a problem statement is load-bearing — it often replaces the need for sorting logic and enables binary search.
- **Zoom whiteboard** exists under "More settings" — usable as a digital pen-and-paper substitute.


---

# Ruby Solutions Deep Dive — December 3, 2025

Q&A on variable scope and Python basics, followed by a mock interview on **Happy Number** (LeetCode Easy).

---

## Q: Variable Scope For Temporary Lists

> "When you're setting up a temporary list inside a loop to collect values for later comparison, does it have to be initialized outside the loop?"

### Answer: Yes — Variable Scoping

> "If you want the list to persist for the life of the loop, it has to exist before the loop starts. You put it outside the loop and refer to it from inside."

### Scope Refresher

Each kind of enclosure creates its own scope:

- **Global scope** — the module level.
- **Function scope** — variables defined inside a function.
- **Loop scope / if scope** — variables declared inside a `for`, `while`, or `if` block. These may persist to the enclosing function in Python (unlike some other languages), but a list rebuilt inside the loop is reset every iteration unless you assign to an outer variable.

> "This trips people up a lot when they're nervous — they forget where the scope goes."

---

## Q: What Can Go On Flash Cards For The Interview?

> "You can use pseudo code or basic syntax examples — what a for loop looks like, how to convert a string to an int. Nothing where you're actually performing an algorithmic function within it. About the same level of what you would Google."

### Allowed

- `int(num_str)` — convert string to int
- `str(num)` — convert int to string
- Basic for loop syntax
- Dictionary access patterns
- List comprehensions

### Not Allowed

- Full solved problems
- Sliding window or binary search templates
- Any complete algorithmic step

---

## Elementary Python Gotchas

A participant noted that **basic things** trip her up:

### String-to-Int for Addition

```python
num1 = input("Enter first number: ")
num2 = input("Enter second number: ")
# num1 + num2 produces "52" for 5 and 2, not 7
result = int(num1) + int(num2)
```

`input()` returns a **string**. You must cast to `int` before arithmetic.

### Accessing Elements vs Indexes in Loops

```python
# Index-based access
for i in range(len(s)):
    if s[i] == target:  # s[i] is the element at index i
        ...

# Value-based iteration
for char in s:
    if char == target:  # char is the element directly
        ...
```

> "At any given point, what am I accessing? Is it the index, or the actual value? Print that out and make sure you're seeing what you expect."

---

## Career Phase Question: What Comes After This?

Clarification on the phase sequence:

- **Explorer phase** — Trello tickets, ~9-10 tasks. Includes a basic JavaScript app that converts to React, then a Next.js app. Full-stack building practice.
- **Career strategy call with Dr. Emily** — end of the explorer phase.
- **Internship** — after explorer.

The career strategy call does **not** change the explorer phase contents.

### Program Sunset Schedule

- **New signups end in February.**
- **Support continues through November** of the following year for existing members.
- Coach Ruby plans to continue hosting these sessions for the foreseeable future.

---

## Mock Interview: Happy Number (Lisa)

### Problem

> Write an algorithm to determine if a number `n` is happy. A happy number is defined by:
> 1. Starting with any positive integer, replace the number by the sum of the squares of its digits.
> 2. Repeat the process until the number equals 1 (where it will stay), or it loops endlessly in a cycle that does not include 1.
> Return `true` if `n` is a happy number, `false` otherwise.

### Example

`n = 19`:
- `1² + 9² = 1 + 81 = 82`
- `8² + 2² = 64 + 4 = 68`
- `6² + 8² = 36 + 64 = 100`
- `1² + 0² + 0² = 1` → **happy, return true**

### Lisa's Approach

1. Convert `n` to a string to access individual digits.
2. Loop over each character, convert back to int, square, accumulate a sum.
3. Test whether the sum equals 1.
4. If not, repeat the process on the new sum.

### Implementation Sketch

```python
class Solution:
    def isHappy(self, n: int) -> bool:
        seen = set()
        while n != 1 and n not in seen:
            seen.add(n)
            total = 0
            for digit in str(n):
                total += int(digit) ** 2
            n = total
        return n == 1
```

Lisa identified that she needed **another loop** — an outer loop to repeat the sum-of-squares process — but ran out of time before finishing the implementation.

### Coach Feedback: Break Down Before Coding

> "It would have helped to spend more time in pseudo code to think about it. You know you need to break the number into digits, square them, sum them — you jumped right into that. That's a good place to start, but we got stuck on that step. If we'd taken a step back and asked what the overall strategy looks like, that might have saved time."

### Coach Feedback: Read The Two Termination Conditions Early

> "The problem says it either ends at 1 or cycles endlessly. That makes me think I want to walk through a few more steps — if it can cycle endlessly, that's more than one operation, which means a `while` loop from the start. You don't know exactly how you'll use it yet, but you can pull it out as a game plan element."

### The Cycle Detection Problem

The hardest part of Happy Number is **detecting the infinite loop**. Two common approaches:

1. **Seen set** — track every number you've computed; if you hit a repeat, you're in a cycle. Return false.
2. **Floyd's cycle detection** — use two pointers advancing at different speeds. If they meet at a value that isn't 1, you're in a cycle.

---

## Asking For Help The Right Way

> "When you're asking for help, don't just say 'I'm stuck, what do I do?' Say 'Here's what I've done, here's where I'm thinking, does anyone have advice for the exact next step I might consider?'"

---

## Takeaways

- **Initialize collector variables outside the loop** that uses them.
- **Flash cards should mirror what you'd Google** — no full solutions.
- **`input()` returns a string** — cast before arithmetic.
- **Print the value of your loop variable** early to confirm whether you have an index or an element.
- **On problems with two termination conditions**, plan the outer loop before writing the inner logic.
- **Cycle detection via a `seen` set** is the standard trick for Happy Number and similar problems.


---

# Ruby Solutions Deep Dive — December 10, 2025

Mock interview on **Arranging Coins** (LeetCode Easy). Deep coaching on the shift from manual step-by-step reasoning to **programmatic algorithmic thinking**.

---

## Problem: Arranging Coins

> You have `n` coins and you want to build a staircase with them. The staircase consists of `k` rows where the `i`th row has exactly `i` coins. The last row of the staircase may be incomplete. Given `n`, return the number of **complete** rows of the staircase you can build.

### Examples

- `n = 5` → `2` (rows of 1 and 2 coins; the 3rd row needs 3 but only 2 remain)
- `n = 8` → `3` (rows of 1, 2, and 3 coins; the 4th row needs 4 but only 2 remain)

---

## Linda's Journey: Manual Reasoning → Code

Linda understood the problem immediately by working through the examples:

- Row 1 needs 1 coin
- Row 2 needs 2 coins (cumulative: 3)
- Row 3 needs 3 coins (cumulative: 6)
- Stop when the next row can't be filled

### Her Manual Process

For `n = 5`:
- `5 - 1 = 4` (row 1 filled)
- `4 - 2 = 2` (row 2 filled)
- `2 - 3 = -1` (row 3 can't be filled) → return **2**

For `n = 8`:
- `8 - 1 = 7`
- `7 - 2 = 5`
- `5 - 3 = 2`
- `2 - 4 = -2` → return **3**

### The Blocker: Translating To Code

Linda could see the answer manually but couldn't express the iterative process in code. She tried to hard-code each subtraction as an `if/else` ladder before eventually recognizing it needed to be a `while` loop.

---

## The Correct Solution

```python
class Solution:
    def arrangeCoins(self, n: int) -> int:
        row = 1
        count = 0
        while n >= row:
            n -= row
            count += 1
            row += 1
        return count
```

### Walkthrough

- **`row`** tracks how many coins the current row needs.
- **`count`** tracks completed rows.
- **`while n >= row`** — as long as we have enough coins for the next row, continue.
- Subtract the row's cost, increment the counter, bump the row size.

---

## Key Coaching Moment: Updating The Loop Variable

Linda wrote a while loop whose condition depended on `n`, but never actually updated `n` inside the loop body. The coach walked her through it:

> "For your while loop to work, if `n` isn't updating, what's it going to do? It's going to go on forever."

### The Fix

```python
n -= 1  # or n -= row, using the subtraction pattern
```

The subtraction Linda was computing inside the `if` condition produced a number, but she wasn't **assigning** that number back to `n`. The while loop kept checking the same unchanged value.

### Coach's Core Point

> "You're doing a calculation, and the calculation returns a number, but you have to update your variable if you want your while loop to end."

---

## The Bigger Issue: Programmatic Thinking

Linda's struggle wasn't technical — she understood `while`, `if`, and variable manipulation. It was **translating a mental model into step-by-step iterative instructions**.

### Coach's Diagnosis

> "I don't think you have a technical issue or a problem-solving issue. What I'm seeing is that you're having trouble thinking programmatically — putting an algorithmic step into a series of steps. You need to see the whole thing outlined all at once."

> "You're trying to solve every step of the problem before doing anything. You don't want to calculate how you'll do each interaction — that's where the while loop comes in. You focus on one step at a time: what's my first step? What comes after? Give the code instructions, let it do the work for you."

### The Shift

- **Before:** "I'll manually compute `5 - 1 - 2 - 3` and check each one"
- **After:** "I'll tell the code to subtract the current row and bump the row counter, and let the while loop do that repeatedly until it can't"

> "Instead of trying to see the full scale mental model of what the code is doing, ask: how can I say what the code is doing on an algorithmic level, step by step? Give it instruction, it does instruction. Give it a while loop, it does a while loop until a certain action is complete."

---

## Coach's Prescription: Pseudo Code With Raw Numbers, No Code

> "When I do pseudo code, if I'm doing pen and paper, I'm using the raw numbers the problem gives me. First step: `5 - 1 = 4`. Draw a box around that: that's row 1. Row 2: I need to put 2 coins, so `4 - 2 = 2`. I do it that way without any code references or structure."

> "Then I go back and write that into pseudo code. 'I need to do this XYZ step. What does that look like in code? Well, that sounds like a while loop. And that sounds like I'm tracking this variable. And that sounds like I'm returning this variable.'"

---

## The Return Statement As An Anchor

> "I always start by asking: what am I returning? You're returning the count of rows you can fill. So I'd write `return rows` first, then work backward — what am I doing with my `rows` variable at each step?"

---

## Side Tangent: `int object is not iterable`

Rebecca ran into this error. Cause:

```python
for i in 5:  # ERROR: int not iterable
for i in range(5):  # Correct
```

You can't iterate directly over an integer; you need `range(n)`.

---

## Error Reading as a Strength

Linda got praise from observers for reading Python syntax errors carefully and correcting indentation errors as they appeared. The coach agreed this is a key skill:

> "Being able to read through the errors, understand them, and make the correct changes — you've got a lot of the stuff right. It's that first step that's hanging you up."

---

## Scheduling Note

No session during Christmas week or New Year's week. Next session on December 17.

---

## Takeaways

- **Update your loop variable inside the loop body**, not just in the condition.
- **`n -= row`** is how you reassign — a bare subtraction expression does nothing.
- **Pen-and-paper pseudo code with raw numbers** is a legitimate first pass; don't rush to syntax.
- **Anchor on the return statement** — know what you're returning, then work backward.
- **Don't try to visualize all N iterations at once.** Write what happens in one iteration; let the loop handle the rest.
- **`for i in range(n)`**, not `for i in n`.


---

# Ruby Solutions Deep Dive — December 17, 2025

Two mock interviews: **Lilah's Beautiful Days at the Movies** (HackerRank) and **Move Zeroes** (LeetCode). Core lesson: slow down to re-read the problem, and use a `while` loop when a `for` loop's index can't be mutated during iteration.

---

## Q&A: Tech Interview Format

- **Easy problems only.** The tech interview draws exclusively from easies.
- **Some behavioral follow-up** is asked purely for practice — applying your experience to a dev career.
- **No fixed daily practice minimum.** Coach's advice: pick a focus area (breaking problems down, pseudo code, implementation) and practice it deliberately for a bounded window.

---

## Mock Interview #1: Lilah's Beautiful Days (Daniel)

### Problem

> Lilah determines the difference between a number and its reverse. For instance, `12` reversed is `21`, difference `9`. Given a range of days `i` to `j` and a number `k`, return the count of **beautiful days** — days whose value minus its reverse is evenly divisible by `k`.

### Examples

For `i = 20, j = 23, k = 6`:
- Day 20: `|20 - 02| = 18`, `18 / 6 = 3` → beautiful
- Day 21: `|21 - 12| = 9`, `9 / 6 = 1.5` → not beautiful
- Day 22: `|22 - 22| = 0`, `0 / 6 = 0` → beautiful
- Day 23: `|23 - 32| = 9`, `9 / 6 = 1.5` → not beautiful

Answer: **2**.

### Daniel's Approach

Pseudo code:
- Counter for beautiful days, initialized to 0.
- Reverse each day in the range.
- Check if `(day - reversed_day) % k == 0`.
- Increment counter on match.
- Return counter.

### Reverse Logic

```python
reversed_num = int(str(i)[::-1])
```

- Convert int to string.
- Reverse with slice `[::-1]`.
- Convert back to int.

Tested with `120` → `21` (leading zeros dropped) and `210` → `12`. Confirmed the slice handles trailing-zero cases correctly.

### The Scope Bug

Daniel placed the `reversed_num = ...` line **outside** the for loop, in the global/function scope. When the loop iterated, `reversed_num` never updated because the reverse expression only ran once.

### Fix Direction

Move the reverse calculation **inside the for loop**, so each iteration produces its own reversed value against the current `day` variable.

```python
def beautifulDays(i, j, k):
    count = 0
    for day in range(i, j + 1):
        reversed_day = int(str(day)[::-1])
        if (day - reversed_day) % k == 0:
            count += 1
    return count
```

### Coach Feedback: Slow Down, Re-Read The Problem

> "I think your steps were great up until getting stuck. But I think you might be going a little too quickly. You didn't get the chance to read through the full problem, see the explanation, confirm the formula, or walk through the example step-by-step."

When the coach asked Daniel to restate the **formula for a beautiful day**, he initially said "the reverse divided by k." After re-reading the explanation, he corrected: **`(day - reversed) / k` with no remainder**.

### Coach Feedback: Range Inclusivity

> "`range(i, j)` is exclusive on the upper bound — make sure to use `range(i, j + 1)` to include the final day."

### On Googling Syntax

> "Googling 'how to reverse a string' is fine. Googling 'how to solve beautiful days' is not. It's the level of specificity that matters."

---

## Mock Interview #2: Move Zeroes (Ben)

### Problem

> Given an integer array `nums`, move all `0`s to the end while maintaining the relative order of the non-zero elements. Do this **in-place** without making a copy.

### Ben's Brute Force

Loop through the array and append non-zero values to a new array.

```python
new = []
for num in nums:
    if num != 0:
        new.append(num)
```

> "Before worrying about the in-place constraint, I always recommend doing the brute force first to make sure you understand the approach."

### The In-Place Requirement

LeetCode expects you to **modify `nums` directly** and return nothing — the test runner checks the array by reference.

### Ben's Second Attempt: Delete Elements In Place

Ben switched to deleting zeros from `nums` directly using `del nums[i]` inside a `for i in range(len(nums))` loop.

### The Bug: Index Shifting

When you delete an element from a list, **every subsequent element shifts down by one index**. A `for i in range(...)` loop doesn't know about this — it keeps incrementing `i`, so you skip the element that shifted into the deleted slot.

### The Fix: Use A While Loop

> "For loops are kind of tough because those indexes aren't flexible. In cases like this, it's better to use a `while` loop where you can make index-based decisions while also manipulating the index you're using. If I hit a zero, I don't increment `i` — I just remove the element and move on."

```python
def moveZeroes(nums):
    i = 0
    zeros = 0
    while i < len(nums) - zeros:
        if nums[i] == 0:
            nums.append(nums.pop(i))
            zeros += 1
        else:
            i += 1
```

Alternative two-pointer (more idiomatic):

```python
def moveZeroes(nums):
    write = 0
    for read in range(len(nums)):
        if nums[read] != 0:
            nums[write] = nums[read]
            write += 1
    for k in range(write, len(nums)):
        nums[k] = 0
```

### Coach Feedback: Look Up Specific Syntax, Not Solutions

> "Your use of Google here was fine — you looked up 'delete element from list Python' which is exactly what you'd Google and it gave you exactly the syntax, not a solution. That's a perfect thing. HackerRank doesn't have that luxury, but LeetCode allows it."

### Coach Feedback: Don't Give Up Too Early

Ben wanted to stop when his code wasn't working. The coach encouraged him to push through — "we're in a safe space." Once he moved into the in-place approach, he was on track.

---

## Final Discussion: Pattern Recognition vs Structure

One participant observed:

> "If I do a certain kind of problem over and over, I start to recognize the structure. It's easier to build a template from that. It's like a pattern."

### Coach's Reframe

> "I'm really glad you're saying 'structure' because you know how I feel about 'patterns'. When I think of patterns, I'm really thinking, no, you're just mastering the fundamentals and seeing how those data structures apply in new and interesting ways."

### Reflection After Each Attempt

> "How are you reviewing and improving after each attempt? What did I learn? Did I get it passing? How many attempts did I take? How can I apply those steps to my next problem? That reflection step is important."

---

## Takeaways

- **Slow down to re-read the problem**, especially the explanation section for examples.
- **`range(i, j + 1)`** if you need the upper bound included.
- **String reversal idiom:** `str(num)[::-1]` then cast back to int.
- **Scope matters** — calculations inside a loop must be written inside the loop body, not at global scope.
- **Deleting while iterating a for loop causes index-skip bugs.** Use `while` with manual index control, or use a two-pointer write/read pattern.
- **Brute force first** — then refine to in-place or optimized.
- **Structure is a better word than pattern** — fundamentals applied to new problems, not a cookie-cutter template.


---

# Ruby Solutions Deep Dive — January 7, 2026

Group walkthrough of **Plus One** (LeetCode Easy) with the coach as mock interviewer and participants contributing approaches. Emphasis on verbalizing during problem analysis and handling edge cases with trailing 9s.

---

## Q&A: When Can You Stay Silent At The Start?

A participant asked about the pressure to start talking immediately during an interview.

> "There's never too soon, but there is a little bit of a too late. If you start talking when you've already figured out the problem and say 'here's what I'm going to do,' you might pass all the test cases, but I don't have a good understanding of your process — how you're thinking through problems, breaking them down, asking and answering questions, getting stuck, moving past obstacles."

### The Advice

> "Be afraid, be scared, and then do it anyway. Talk yourself out of it. Mumble to yourself. Write it down and then read what you wrote aloud. A third of the process is trying to understand the problem — I want to hear that."

> "If we get to the end of 20 minutes and you haven't said anything I can latch onto, I can't coach you on how to improve."

---

## Q&A: Getting Back Into It After A Long Pause

> "Review problems you've worked on before. Clear out your code right away — you'll be familiar enough to have a vague recollection. Focus on rebuilding your routine: how do I break the problem into steps? How do I get pseudo code down? How do I start writing code? Focus on the process piece, not the solving piece."

---

## Problem: Plus One

> You are given a large integer represented as an integer array `digits`, where each `digits[i]` is the `i`-th digit of the integer. The digits are ordered from most significant to least significant in left-to-right order. Increment the large integer by one and return the resulting array of digits.

### Examples

- `[1, 2, 3]` → `[1, 2, 4]`
- `[4, 3, 2, 1]` → `[4, 3, 2, 2]`
- `[9]` → `[1, 0]`

### Constraints

- `1 <= digits.length <= 100`
- `0 <= digits[i] <= 9`
- No leading zeros.

---

## Approach 1: Last Index + 1 (Fails On 9)

Linda proposed: just grab the last index, add 1, return. Works for most cases. Fails when the last digit is 9 because you'd get `[1, 2, 3, 10]`, not `[1, 2, 4, 0]`.

---

## Approach 2: Convert To Int, Add, Convert Back

Coach sketched a cleaner alternative:

```python
def plusOne(digits):
    num = int("".join(str(d) for d in digits)) + 1
    return [int(d) for d in str(num)]
```

- **Join** digits into a string, convert to int, add 1, convert back, split into a list of ints.
- Avoids the carry-propagation mess entirely.

---

## Approach 3: Reverse For Loop + Carry Propagation (Chosen)

The group chose to implement the carry-propagation approach because it exercises more Python concepts.

### The `range` Function For Reverse Iteration

```python
for i in range(len(digits) - 1, -1, -1):
    # i goes from last index down to 0
```

- **Start:** `len(digits) - 1` (the last valid index)
- **Stop:** `-1` (exclusive — iterates down through 0)
- **Step:** `-1` (decrement)

> "When reversing, you actually have to include all three parameters. The normal shorthand only works when you accept the defaults of start=0 and step=1."

### Side Note: `range` Requires Integers, Not Collections

- `for i in range(len(digits))` → iterates indexes (0, 1, 2…)
- `for digit in digits` → iterates values directly
- You need indexes here because you're modifying the array in place.

### Initial Carry Logic

```python
def plusOne(digits):
    for i in range(len(digits) - 1, -1, -1):
        if digits[i] != 9:
            digits[i] += 1
            return digits
        else:
            digits[i] = 0
    return digits
```

Walks through `[1, 2, 9]`:
- `i = 2`, value is 9 → set to 0, keep going
- `i = 1`, value is 2 → add 1, become 3, return `[1, 3, 0]`

### Edge Case: All 9s

`[9, 9, 9]`:
- `i = 2`, 9 → 0
- `i = 1`, 9 → 0
- `i = 0`, 9 → 0
- Loop ends with `[0, 0, 0]` — **wrong**. The expected output is `[1, 0, 0, 0]`.

### The Fix: Insert A Leading 1

If we fall through the whole loop without returning, it means every digit was 9 and we need to prepend a 1:

```python
def plusOne(digits):
    for i in range(len(digits) - 1, -1, -1):
        if digits[i] != 9:
            digits[i] += 1
            return digits
        else:
            digits[i] = 0
    digits.insert(0, 1)
    return digits
```

### `list.insert(index, value)`

- Inserts `value` at `index`, shifting everything else right.
- `digits.insert(0, 1)` prepends a 1 to the front.
- Official Python docs say this is **O(n)** because of the shifting.

---

## Big O Analysis

- **For loop:** O(n)
- **If/else inside loop:** O(1) per iteration
- **`insert(0, 1)`** at the end: O(n)
- **Total:** O(n) + O(n) = **O(n)**

### Performance Result

Passed all 112 test cases at 0ms runtime. Memory usage was higher than expected — likely due to the `insert` at the front requiring internal array reallocation.

---

## The Math Parallel

> "This is how I learned addition. `1 2 9 9 9 + 1`: 9 + 1 = 10, put zero, carry the 1. 9 + 1 = 0, carry the 1. Etc. That's exactly what the formula does: if it's not a 9, add 1 and done. If it is a 9, set to 0 and carry to the next index."

The `insert(0, 1)` at the end is the "carry out of the top" case — when the carry needs a new digit because the number grew in length.

---

## Approach Comparison

| Approach | Time | Space | Complexity |
|---|---|---|---|
| Last index + handle 9 (incomplete) | O(1) avg | O(1) | Edge cases get ugly |
| int ↔ list conversion | O(n) | O(n) | Very clean, uses language features |
| Reverse loop + carry + insert | O(n) | O(1) in-place | Explicit, teaches array indexing |

---

## Session Takeaways

- **Verbalize even when you don't fully understand the problem yet.** That's the phase the coach wants to hear the most.
- **`range(start, stop, step)` with negative step** for reverse iteration in Python.
- **Always include the edge cases as your own test cases** — `[9, 9, 9]` would have been skipped without Rebecca bringing it up.
- **Pen and paper is fine mid-interview.** Return to it when your approach breaks on a new edge case.
- **`list.insert(0, x)` is O(n)**, not O(1), because it shifts every subsequent element.
- **Carry propagation** translates directly from pencil-and-paper addition to code.
- **Googling "how to add an index to the front of a list"** is an acceptable interview lookup because it's specific syntax, not a full solution.


---

# Ruby Solutions Deep Dive — January 21, 2026

Group mock interview on **Find if Digit Game Can Be Won** (LeetCode Easy). Experiment with collaborative pseudo code — the group acts as a sounding board during planning, then goes silent during the coding phase.

---

## Experimental Format

> "The volunteer leads their own mock interview. During pseudo code, use the group as a sounding board — ask us questions, see what we think, but you're the main stakeholder. Once you're ready to code, we all go silent."

Rationale: if the pre-code phase is a blocker, this collaborative mode lets candidates practice it with support. If it's not a blocker, they can skip straight to coding.

---

## Problem: Find if Digit Game Can Be Won

> You are given an array of positive integers `nums`. Alice and Bob are playing a game. In the game, Alice can choose either all single-digit numbers or all double-digit numbers from `nums`, and the rest of the numbers are given to Bob. Alice wins if the sum of her numbers is **strictly greater than** the sum of Bob's numbers. Return `true` if Alice can win, `false` otherwise.

### Examples

- `[1, 2, 3, 4, 10]` → `false` (singles sum to 10, doubles sum to 10 — a tie)
- `[1, 2, 3, 4, 5, 14]` → `true` (singles sum to 15 > 14)
- `[5, 5, 5, 25]` → `true` (doubles sum to 25 > 15)

### Constraints

- `1 <= nums.length <= 100`
- `1 <= nums[i] <= 99` (no triple digits)

---

## Lisa's Pseudo Code

- Return `true` or `false`.
- Sum the single-digit numbers → **Alice**.
- Sum the double-digit numbers → **Bob**.
- Compare: return `true` if Alice's sum > Bob's sum OR Bob's sum > Alice's sum. Return `false` if equal.

### Key Assumption Made

> "Equal is a tie — she can't win. The only thing we really need to test for is if they're equal."

### Single vs Double Digit Check

Lisa proposed: `if num < 10, add to Alice; else add to Bob`.

---

## Side Question: Does Example With One Double Digit Matter?

A participant asked whether the examples guarantee only one double digit per input. Coach's response:

> "That's an assumption. Ask it, write it down. Look at the phrasing of the problem statement. If that's not clear, look at the constraints. If that's still unclear, run tests or build the check into your pseudo code."

Verdict: you should **assume multiple double digits are possible** because the constraints don't forbid it. The sum logic handles both cases naturally anyway.

---

## First Implementation (With Lists)

```python
class Solution:
    def canAliceWin(self, nums: List[int]) -> bool:
        alice = []
        bob = []
        for num in nums:
            if num < 10:
                alice.append(num)
            else:
                bob.append(num)
        alice_sum = sum(alice)
        bob_sum = sum(bob)
        return alice_sum != bob_sum
```

### Why Only `!=` Works

The question is: can Alice win by choosing **one** of the two groups? She always picks the winning group. So as long as the two sums aren't equal, she can win by picking the larger one. **Equality is the only loss condition.**

---

## Coach Feedback: Do You Need The Lists At All?

> "You're using a pretty intense data structure — a list — to store and then sum values. But if you already know the contents are being properly separated, do you need to store them in a list, or can you just sum them?"

### Refactor: Sum In Place

```python
class Solution:
    def canAliceWin(self, nums: List[int]) -> bool:
        alice = 0
        bob = 0
        for num in nums:
            if num < 10:
                alice += num
            else:
                bob += num
        return alice != bob
```

- **Constant space instead of O(n)** — no list allocations.
- Two accumulator ints (`alice = 0`, `bob = 0`).
- `alice += num` or `bob += num` as you iterate.
- Same comparison at the end.

### Performance Note

Lisa's first submission was in the upper end of runtime percentile because of the list allocations. Sum-in-place is meaningfully faster even at small input sizes because it skips the list construction entirely.

---

## The "Can I Do This Without A List?" Question

Lisa tried to find the Python feature for "sum with a condition" and got stuck.

> "You can sum them in place. Alice starts at 0, Bob starts at 0. If it's a single digit, add to Alice. If it's double, add to Bob. Keep track of their sums separately."

For reference, more concise alternatives exist using generator expressions:

```python
alice = sum(n for n in nums if n < 10)
bob = sum(n for n in nums if n >= 10)
```

But the explicit accumulator loop is just as correct and clearer when you're still building fluency.

---

## Key Interview Skills Demonstrated

1. **Restating the goal:** "Determine if Alice can win the game" — clear and concise.
2. **Confirming assumptions with the group** before coding (ties = loss, multiple doubles possible).
3. **Writing pseudo code before touching real code.**
4. **Being willing to refactor** when the coach suggested the list was unnecessary.

---

## Takeaways

- **Accumulate sums in integer variables, not lists**, when you don't need the individual values later.
- **`a != b` is equivalent to `a > b or b > a`** when one side always wins — simpler and more intuitive.
- **Assumptions about input variety should default to "anything the constraints allow."** Don't assume single double-digit numbers just because the examples only show one.
- **Group pseudo-coding** can be a useful hybrid practice format before going silent for the coding phase.
- **Two accumulators in one pass is O(n) time and O(1) space** — optimal for this problem.


---

# Ruby Solutions Deep Dive — January 28, 2026

Group mock interview on **Baseball Game** (LeetCode Easy, problem 682). Extended lesson on why restating each operation in your own words before pseudo coding saves time on problems with many rules.

---

## Problem: Baseball Game (LeetCode 682)

> You are keeping the scores for a baseball game with strange rules. Given a list of strings `operations`, apply each operation to the record and return the sum of all scores after all operations. Each operation is one of:
>
> - **Integer `x`** — record a new score of `x`
> - **`"+"`** — record a new score that is the sum of the **previous two** scores
> - **`"D"`** — record a new score that is **double** the previous score
> - **`"C"`** — **invalidate** the previous score, removing it from the record

### Examples

**Example 1:** `["5", "2", "C", "D", "+"]` → `30`
- `5` → record: `[5]`
- `2` → record: `[5, 2]`
- `C` → invalidate last: `[5]`
- `D` → double previous: `[5, 10]`
- `+` → sum of last two: `[5, 10, 15]`
- Total: `5 + 10 + 15 = 30`

**Example 2:** `["5", "-2", "4", "C", "D", "9", "+", "+"]` → `27`

### Constraints

- `1 <= operations.length <= 1000`
- Integer operations are strings representing values in `[-3*10^4, 3*10^4]`
- For `+`, there will always be at least **two previous scores**
- For `C` and `D`, there will always be at least **one previous score**

---

## Linda's Pseudo Code Walkthrough

Linda tried to write pseudo code directly without first restating each operation in her own words. This became the central lesson of the session.

### Initial Sketch

```python
def calPoints(operations):
    score = []
    total_sum = []  # Linda's initial approach
    for element in operations:
        if element is an integer:
            total_sum.append(element)
        if element == "+":
            # record sum of previous two
            ...
        if element == "D":
            # record double of previous
            score.append(score * 2)
        if element == "C":
            # delete previous
            score.pop()
    return total_sum
```

---

## Key Confusion: What Does "Previous" Mean For Each Operation?

Linda mixed up two different interpretations of "previous":

1. **`+`** — sum of the **previous two** scores (both remain in the record)
2. **`D`** — **double** the **single previous** score (the previous score remains in the record)
3. **`C`** — **invalidate and remove** the **single previous** score

### Coach Feedback: `D` Does Not Replace

When Linda wrote `score = [10]` after `D` on a starting `[5]`, the coach corrected:

> "Look at the example. After the `D` on `[5]`, the record becomes `[5, 10]`, not `[10]`. You're supposed to record a **new** score that is double the previous — the previous one stays."

### Coach Feedback: Which Value Do You Double?

When the coach gave Linda a hypothetical `score = [5, 3, 2, 4]` and asked "what does `D` produce?", Linda initially tried to pick a value at random. The correct answer: **the last element**, which is `4`. So `D` produces `8` and the new record is `[5, 3, 2, 4, 8]`.

> "How are you going to grab that value?" → Linda: "I'd pop it off and multiply by two." Close — but `pop` **removes** the element. For `D`, you want `score[-1] * 2` (read without removing) and append the result.

### Correct `D` Operation

```python
if element == "D":
    score.append(score[-1] * 2)
```

---

## Why String vs Int Matters

`operations` is a list of **strings**, not a mix of strings and ints. `"5"` and `"-2"` are strings. When Linda tried to append `element` directly to `score` for an integer case, the coach pointed out the eventual need to cast.

```python
if element not in ("+", "D", "C"):
    score.append(int(element))
```

Check for non-operation strings first (everything that isn't `+`, `D`, or `C` is an integer string). Cast with `int()` before appending.

---

## The Correct Solution

```python
class Solution:
    def calPoints(self, operations: List[str]) -> int:
        record = []
        for op in operations:
            if op == "+":
                record.append(record[-1] + record[-2])
            elif op == "D":
                record.append(record[-1] * 2)
            elif op == "C":
                record.pop()
            else:
                record.append(int(op))
        return sum(record)
```

### Key Details

- **`record[-1]`** — last element, Python's idiomatic way to access "previous"
- **`record[-1] + record[-2]`** — sum of the last two, for `+`
- **`record.pop()`** — remove and discard the last score, for `C`
- **`sum(record)`** — final total, returned as an int
- Only cast strings to int in the `else` branch when you know it's a numeric string

---

## The Core Lesson: Restate Operations In Your Own Words First

Linda skipped the step of writing each operation in plain English and tried to jump straight into pseudo code. This caused her to repeatedly jump back to the problem to re-read what each letter meant.

### Coach's Prescription

> "Take the parts of the problem and put them in your own words in the comments. Line by line: 'You get X — it's an integer, track it in an array. You get plus — it takes the previous two and sums them and keeps them all. You get D — it doubles the last and adds it. You get C — it removes the last.' That's in words, not pseudo code."

> "Then you compare that against the examples to make sure what you've written matches. If it's not, course-correct before writing code."

### Why Skipping That Step Cost Time

> "We kept going back — wait, what does `+` mean again? What does `D` do? If we had that in our own words at the top of the function, we wouldn't have to jump around as much."

### The Universal Rule

> "Even if you feel you know a problem backwards and forwards, I'm still going to do that step. I don't skip steps ever. That's the whole point of having a good list of steps — you take them every time. You don't change your habits. You don't get lost. The steps are there to help you."

---

## Session Duration Reflection

The full pseudo code phase took about 40 minutes. The coach's target:

> "That process needs to take 10 minutes, not 40. Once you got to the end, you had something ready to turn into code — but the **time to get there** is what's blocking you from scheduling your tech interview. Follow your steps every time, and your time will decrease."

Linda explicitly said this matched what Claude had told her about "put it in your own words before you do anything."

---

## Takeaways

- **`record[-1]`** and **`record[-2]`** are the idiomatic way to access "previous" and "previous-previous" in a Python list.
- **`list.pop()`** removes **and returns** the last element. Use it for `C`, but not for `D` (where you want to keep the previous score).
- **`list.append(list[-1] * 2)`** for "double the previous."
- **Cast strings to int** in the numeric-element branch only.
- **Sum in the final step** with `sum(record)`.
- **Restate each rule of the problem in plain English** before writing any pseudo code. This is non-negotiable on multi-rule problems.
- **Follow your own process steps every time**, even on problems you think you understand. Skipping steps causes backtracking.


---

# Ruby Solutions Deep Dive — February 4, 2026

Mock interview on **Richest Customer Wealth** (LeetCode Easy). Textbook clean execution in under 15 minutes — a reference example of a well-run mock.

---

## Problem: Richest Customer Wealth

> You are given an `m x n` integer grid `accounts` where `accounts[i][j]` is the amount of money the `i`-th customer has in the `j`-th bank. Return the wealth that the **richest customer** has.
> A customer's wealth is the amount of money they have in all their bank accounts. The richest customer is the one with the **maximum total wealth**.

### Example

```
accounts = [[1, 2, 3],
            [3, 2, 1]]
```

- Customer 1 wealth: `1 + 2 + 3 = 6`
- Customer 2 wealth: `3 + 2 + 1 = 6`
- Output: `6`

### Constraints

- `1 <= m, n <= 50`
- `1 <= accounts[i][j] <= 100`

---

## Russell's Solution

```python
class Solution:
    def maximumWealth(self, accounts: List[List[int]]) -> int:
        greatest = 0
        for i in range(len(accounts)):
            current = sum(accounts[i])
            if current > greatest:
                greatest = current
        return greatest
```

### Process Highlights

1. **Read the problem carefully.** Understood that each sub-array represents a customer's accounts.
2. **Verified `sum()` works on a Python list** before relying on it — ran a quick test returning `sum(accounts[0])` to confirm.
3. **Initialized `greatest = 0`** as the max tracker.
4. **Single-pass comparison** — `if current > greatest: greatest = current`.
5. **Returned the final max.**

### Idiomatic Pythonic Variant

```python
return max(sum(customer) for customer in accounts)
```

Russell's explicit version is clearer for an interview; the one-liner shows language fluency once you're comfortable.

---

## Constraints Check

Coach asked whether the constraints changed the approach:

> "Not really. `m` and `n` are between 1 and 50, values between 1 and 100. The only thing that could affect my approach is if an array could have zero values — then I'd need an error check before the loop."

The constraint `1 <= m, n` guarantees every customer has at least one account and at least one customer exists. **No defensive check needed.**

---

## Coach Feedback

> "You followed pretty much everything we usually recommend. Reading through the problem, getting baseline assumptions, typing out comments of your understanding, quickly prototyping, taking a step out to test the `sum` piece individually, then putting it back. That was all great. You're definitely ready — whenever you want to sign up for the tech interview, go ahead."

---

## Why This Mock Was Exemplary

- **Assumed nothing, tested everything.** Russell explicitly verified `sum()` on a list worked before relying on it.
- **Talked through his logic at each step**, naming the variables and their purpose.
- **Summarized the problem in his own words** at the start and again at the coach's request after finishing.
- **Checked constraints** and articulated which ones mattered and which didn't.
- **Kept code clean** — no dead code, no speculative variables. Each line had a purpose.
- **Finished well under the 20-minute limit**, leaving room for discussion.

---

## Resource Pointer

The coach shared the **tech interview rubric** pinned in the Discord `#hackerrank` channel. It's a comprehensive breakdown of:

- **Communication** — how you verbalize during the interview
- **Technical Knowledge** — Mods 1 and 2 concepts
- **Problem-Solving Process** — breaking problems down, pseudo code, testing
- **Behavior** — mindset and habits

The rubric also lists every concept that could appear on the tech interview.

---

## Takeaways

- **Initializing `max_so_far = 0` and updating** is a standard pattern for "find the maximum of something" problems.
- **`sum(list)`** just works on any list of numerics in Python.
- **Prototype individual pieces** (like `sum(accounts[0])`) before integrating them into the full solution.
- **Constraints often eliminate defensive code** — check them before adding edge-case handling.
- **Clean verbalization + a simple iteration** is often all a tech interview easy problem requires.


---

# Ruby Solutions Deep Dive — February 11, 2026

Mock interview on **Check if a String Is an Acronym of Words** — actually **Type of Triangle** (LeetCode Easy). Long walkthrough on the importance of enumerating all return conditions before coding, plus a sorting-based shortcut for the triangle inequality check.

---

## Problem: Type of Triangle

> Given a 0-indexed integer array `nums` of size 3, representing the sides of a triangle, return a string representing the type:
> - `"equilateral"` — all three sides equal
> - `"isosceles"` — exactly two sides equal
> - `"scalene"` — all sides different
> - `"none"` — if the three numbers cannot form a triangle

### Examples

- `[3, 3, 3]` → `"equilateral"`
- `[3, 4, 5]` → `"scalene"` (the sum of any two sides exceeds the third)
- `[3, 4, 15]` → `"none"` (`3 + 4 = 7` is not greater than `15`)

### Constraints

- `nums.length == 3`
- `1 <= nums[i] <= 100`

---

## The Triangle Inequality Theorem

> "The sum of two sides of a triangle is always greater than the third side — for **all three combinations** of sides. If even one combination fails, the three lengths cannot form a triangle."

### Combinations to check

For sides `a`, `b`, `c`:
1. `a + b > c`
2. `a + c > b`
3. `b + c > a`

If all three hold, it's a triangle. Otherwise, it's `"none"`.

---

## Linda's Initial Struggle

Linda missed the `"none"` case on her first read and thought there were only three return conditions. She got **equilateral** working quickly with `if nums[0] == nums[1] == nums[2]`, then hit an `int object is not iterable` error when she tried `sum(nums[0], nums[1])`.

### The Bug: Misusing `sum()`

```python
sum(nums[0], nums[1])  # ERROR - sum() takes an iterable
```

`sum()` expects an **iterable** as its first argument, not individual numbers. The correct usage is `sum([nums[0], nums[1]])` or simply `nums[0] + nums[1]`.

### Coach's Debug Process

> "When you see `int object is not iterable`, look at the `sum()` call. Check Python docs or W3Schools — `sum()` requires a sequence, not two separate ints."

---

## The Core Lesson: Enumerate All Return Conditions First

The coach restarted the session by walking through the problem from the top:

### Step 1: Identify All Possible Returns

```
- equilateral (all three sides equal)
- isosceles  (two sides equal)
- scalene    (all sides different)
- none       (not a triangle)
```

### Step 2: Under What Conditions Does Each Apply?

- **Equilateral** — all three sides equal. **Always a triangle.**
- **Isosceles** — two sides equal. **Triangle check still required.** (E.g., `[3, 3, 15]` is isosceles by side equality but not a triangle.)
- **Scalene** — all three sides different. **Triangle check still required.**
- **None** — triangle inequality fails.

### Step 3: Order The Checks

```
1. Is it equilateral? (always a triangle if yes)
2. Is it a triangle? (if no → return "none")
3. Is it isosceles or scalene?
```

This flips the naive ordering and avoids redundant work.

---

## Lisa's Insight: Sort First

Lisa suggested sorting the array as a preprocessing step. This unlocks multiple simplifications:

### Benefit 1: Simpler Isosceles vs Scalene

After sorting, the two smallest values are adjacent. If `nums[0] == nums[1]`, the result (given it's already not equilateral) is isosceles. Otherwise scalene. Only one comparison needed.

### Benefit 2: Simpler Triangle Check

With a sorted array `[a, b, c]` where `a <= b <= c`, the triangle inequality reduces to **one check**: `a + b > c`. The other two combinations (`a + c > b`, `b + c > a`) are automatically satisfied when `c` is the largest.

---

## The Clean Solution

```python
class Solution:
    def triangleType(self, nums: List[int]) -> str:
        nums.sort()
        # Triangle inequality check (only need smallest two vs largest)
        if nums[0] + nums[1] <= nums[2]:
            return "none"
        if nums[0] == nums[1] == nums[2]:
            return "equilateral"
        if nums[0] == nums[1] or nums[1] == nums[2]:
            return "isosceles"
        return "scalene"
```

### Walkthrough On `[3, 4, 15]`

- Sorted: `[3, 4, 15]`
- `3 + 4 = 7`, `7 <= 15` → return `"none"` ✓

### Walkthrough On `[3, 3, 5]`

- Sorted: `[3, 3, 5]`
- `3 + 3 = 6 > 5` → is a triangle
- Not all three equal → not equilateral
- `nums[0] == nums[1]` → return `"isosceles"` ✓

---

## Russell's Naming Tip

> "Trying to work directly with `nums[0]` vs `nums[1]` is hard for my brain to visualize. As soon as I write six of those on a line I lose it. Even though it's an extra step, I assign them to their own named variables so I can compare `a` and `b` and `c` rather than `nums[0]` and `nums[1]` and `nums[2]`."

```python
a, b, c = sorted(nums)  # Python tuple unpacking after sort
```

The coach endorsed this strongly:

> "Variable names are very important. When you confidently know there are only going to be three every time, `a`, `b`, `c` or `side1`, `side2`, `side3` make the code far more readable."

---

## Coach Feedback: Don't Jump To Code Before Understanding All Conditions

> "Jumping ahead to say 'oh, I know how I'd solve part one of three, but I don't know the full three-part process yet' — that's shortcutting your progress. Understand all the conditions upfront so you can code with them in mind, instead of hitting obstacles and going backwards."

### The Value of Re-Reading Confusing Sections

> "It's fine to read something for the first time and think 'I don't know what this means.' But once you understand the rest of the problem, go back and try to make sense of the piece you didn't understand. Why are they telling you this? Why does it matter? That's when you see 'oh, there's a none option — is that going to help me determine it?'"

---

## Method: Enumerate Return Values First

Russell summarized the key realization:

> "There are four possible returns. What test do we need to do to return each one? And potentially, what order do we test them in so we can eliminate cases?"

### Coach's Recommended Opening

1. Print `nums` (confirm your parameters match the test cases).
2. Identify the return type — here, a string.
3. List the possible return values — `equilateral`, `isosceles`, `scalene`, `none`.
4. Under what conditions does each apply?
5. In what order should the checks happen to eliminate efficiently?
6. Only then start writing logic.

---

## Takeaways

- **Enumerate all possible return values** at the top of your pseudo code before coding any logic.
- **Triangle inequality:** `a + b > c` for **all** combinations — but sorting reduces it to **one** check.
- **`sum(iterable)`** takes an iterable, not individual numbers. Use `a + b` instead for two-number sums.
- **`nums.sort()`** and tuple unpacking `a, b, c = sorted(nums)` simplify readability.
- **Named variables beat indexed access** for small fixed-size arrays.
- **Re-read confusing sections** of the problem after you understand the rest.
- **"None" as a fourth return condition** is easy to miss on the first read — scan for it explicitly.


---

# Ruby Solutions Deep Dive — February 25, 2026

Coach Ruby does her own mock interview on **Number of Changing Keys**, then Lisa takes a mock on **Sum Multiples**. Lesson: test your core assumption (the math operator) **before** building logic around it.

---

## Coach's Self Mock: Number of Changing Keys

### Problem

> You are given a 0-indexed string `s` typed by a user. Changing a key is defined as using a key different from the last used key. `s = "ab"` has a key change; `s = "bB"` does not (shift/caps lock are ignored). Return the number of times the user had to change the key.

### Examples

- `"aAbBcC"` → `2` (`a→b` and `b→c`)
- `"AaAaAaaA"` → `0`

### Constraints

- `1 <= s.length <= 100`

---

## Coach's Approach

### Assumption Test First

Before writing any logic, she verified in the console that:
- `'a' == 'A'` → **False**
- `'A' == 'A'` → **True**

So case matters for Python string equality. Need to normalize first.

### Normalization With `str.lower()`

```python
>>> "aAbBcC".lower()
"aabbcc"
>>> original = "aAbBcC"
>>> original.lower()
"aabbcc"
>>> original
"aAbBcC"  # unchanged - lower() returns a new string
```

`str.lower()` does **not mutate** the original. It returns a new lowercase string. Assign the result to a variable.

---

## The Solution

```python
class Solution:
    def countKeyChanges(self, s: str) -> int:
        s_lower = s.lower()
        count = 0
        for i in range(1, len(s_lower)):
            if s_lower[i] != s_lower[i - 1]:
                count += 1
        return count
```

### Key Details

- **Normalize first** — `s.lower()` converts the whole string once.
- **Start the loop at index 1** — you need a previous character to compare against.
- **Compare `s_lower[i]` to `s_lower[i - 1]`** — increment count on mismatch.
- **No special edge-case handling** — constraints guarantee `len >= 1`, and the loop naturally handles length-1 strings (no iterations, returns 0).

### Self-Reflection

> "16 minutes on an easy problem — not my personal best. I did a lot of chattering at the beginning. No weird edge cases. Memory usage was high probably because of storing a second lowered string and the count. I'd be curious what other approaches avoided allocating the new string."

### Alternative: In-Place Comparison Without Lowering

```python
def countKeyChanges(self, s):
    count = 0
    for i in range(1, len(s)):
        if s[i].lower() != s[i - 1].lower():
            count += 1
    return count
```

This avoids allocating a full-length copy by lowering just one character at a time per comparison. Slightly more CPU work, less memory.

---

## Mock Interview: Sum Multiples (Lisa)

### Problem

> Given a positive integer `n`, find the sum of all integers in the range `[1, n]` inclusive that are divisible by `3`, `5`, or `7`. Return that sum.

### Example

- `n = 7` → `3 + 5 + 6 + 7 = 21`

---

## Lisa's Approach

Standard accumulator with a for loop over `range(1, n + 1)`:

```python
def sumOfMultiples(n):
    total = 0
    for i in range(1, n + 1):
        if divisible_by_3_5_or_7(i):
            total += i
    return total
```

### The Bug: Wrong Division Operator

Lisa initially wrote her divisibility check as:

```python
if i // 3 == 0:  # BUG: `//` is integer division, not modulo
```

`//` is **floor division** (returns the integer part of the quotient). For divisibility, you need `%` (modulo), which returns the **remainder**.

| Expression | Meaning | `3 // 3` | `3 % 3` |
|---|---|---|---|
| `//` | integer quotient | `1` | - |
| `%` | remainder | - | `0` |

### Testing Exposed The Bug

Lisa added print statements inside the loop and noticed `total` was updating on iteration `i = 1`, which shouldn't happen if the check were correct. `1 // 3 == 0` is True (integer quotient of 1/3 is 0), triggering the false positive.

### The Fix

```python
if i % 3 == 0 or i % 5 == 0 or i % 7 == 0:
    total += i
```

- `%` returns the remainder.
- If the remainder is 0, `i` is evenly divisible.
- Chain with `or` for the three divisors.

### Correct Final Solution

```python
class Solution:
    def sumOfMultiples(self, n: int) -> int:
        total = 0
        for i in range(1, n + 1):
            if i % 3 == 0 or i % 5 == 0 or i % 7 == 0:
                total += i
        return total
```

---

## Coach Feedback: Test The Math Before Building Around It

> "You did a great job breaking down the problem — understood what was required, the expected output, the general approach was right. But your basic assumption about the math piece needed more testing. I would have liked to see you test that `i // 3 == 0` logic against a few quick integers like 6 and 15 upfront to make sure it applied across the board."

### Consequence Of Not Testing

Lisa built lots of scaffolding around the broken divisibility check — extra `if n > 2` conditions, guards, special cases — trying to paper over the real problem.

> "There was a lot of little pieces there that maybe we could have skipped. Once we switched to modulus, pretty much everything worked out from there."

---

## The Lesson: Test Your Core Operator First

Whenever your solution hinges on a single arithmetic or logical operator, **verify the operator does what you expect** with a tiny test case before building the rest of the solution:

```python
print(3 % 3)  # should be 0
print(5 % 3)  # should be 2
print(6 % 3)  # should be 0
```

30 seconds of verification saves minutes of confused debugging.

---

## Takeaways

- **`str.lower()` returns a new string** — assign to a variable; doesn't mutate.
- **Start index-based loops at 1** when you need a "previous" reference.
- **`%` is modulo, `//` is floor division** — don't confuse them for divisibility checks.
- **Test your core operator with known values** before building logic around it.
- **`i % k == 0`** is the canonical divisibility-by-`k` test.
- **Normalization (like `lower()`) upfront** is often simpler than per-comparison handling, but costs memory.


---

# Ruby Solutions Deep Dive — March 11, 2026

Mock interview on **Number of Employees Who Met the Target** (LeetCode Easy) with Dan. Focus on establishing a **pre-coding checklist template** to paste into the editor as a repeatable process.

---

## Pre-Session Discussion: Optimization vs Brute Force Under Time Pressure

Dan shared that he's good at optimizing code, but optimizing **within a 15-20 minute window** is the challenge.

### Coach's Clarification

> "You don't have to be at the optimization level for the tech interview here. Getting something ugly out — something brute force that just solves the problem — is the starting point. You can continue honing it as you build skills. Optimization comes with practice."

---

## Problem: Number of Employees Who Met the Target

> There are `n` employees in a company numbered `0` to `n-1`. Each employee `i` has worked `hours[i]` hours. The company requires each employee to work at least `target` hours. Return the number of employees who met or exceeded the target.

### Example

- `hours = [0, 1, 2, 3, 4]`, `target = 2` → `3` (employees 2, 3, 4 met the target)
- `hours = [5, 1, 4, 2, 2]`, `target = 6` → `0`

### Constraints

- `1 <= n == hours.length <= 50`
- `0 <= hours[i], target <= 10^5`

---

## Key Observations From Constraints

- **Both `hours[i]` and `target` can be zero.** If `target = 0`, every employee meets the target (even those with 0 hours).
- **`n >= 1`** — there's always at least one employee, so no empty-array edge case.

---

## Standard Solution

```python
class Solution:
    def numberOfEmployeesWhoMetTarget(self, hours: List[int], target: int) -> int:
        count = 0
        for h in hours:
            if h >= target:
                count += 1
        return count
```

### Pythonic One-Liner

```python
return sum(1 for h in hours if h >= target)
```

Or using the boolean-as-int trick:

```python
return sum(h >= target for h in hours)
```

`True` is `1` and `False` is `0` when summed.

---

## Coach's Best-Practices Template (Checklist)

Dan said having a reusable checklist template to paste at the top of every problem would keep him focused and prevent skipping steps. The coach endorsed this strongly and summarized her recommended template:

```python
# ============================
# Pre-coding checklist:
# 1. Print parameters to confirm
# 2. Pull key info from problem in your own words
# 3. Pull key info from constraints in your own words
# 4. State what you're returning and its type
# 5. Pseudo code before coding
# 6. Read errors to understand, Google what they mean
# ============================
```

### Coach Quotes

> "I always start with printing out the parameters and pulling out the key information from the problem. These are what the parameters mean in **my own words** — in your own words is important."

> "Once I understand the information I pulled from the problem in my own words, I can use that instead of using the problem text."

> "Take the step to write pseudo code even on simpler problems where you may not need it. Always a great step. Don't skip the step — use it as practice so you apply it to every problem."

> "Always read your errors and read to understand. Even if you have to Google what it means, I'd rather you Google than keep trying to brute force through an error or swap variables randomly."

---

## Key Insight For Dan: Comments First, Then Code

Dan realized mid-session that writing comments in the code section itself — instead of eyeballing the problem pane back and forth — forces him to process and lock in the information.

> "It kind of forces you to process the information and get it set up as a set of requirements for your code when you do that."

Coach: "That's a best practice."

---

## Session Meta

The coach's recording had paused unexpectedly, losing 20 minutes of the session. The core material was reconstructed verbally: print parameters, pull key info in your own words, understand edge-case constraints, pseudo code first, read errors.

---

## `self` In LeetCode Class Methods

Dan was initially thrown by the `self` parameter. Coach:

> "Ignore `self` pretty much always for LeetCode problems. It's referring to the class, but you don't need to use it."

---

## Life Advice: Use Your Resources

> "Write out your assumptions, get the answers. Don't make up your own answers. If you can get a resource for it — whether that's Google or whether that's these meetings — use your resources. Another great coding tip that also just kind of applies to life."

---

## Takeaways

- **Establish a reusable pre-coding checklist template** to paste at the top of every problem.
- **Write problem understanding as comments in the code**, not in your head or the problem pane.
- **Brute force first**, optimize later. Especially within a 20-minute window.
- **`sum(bool_expression for x in iterable)`** is a Pythonic shortcut for counting matches.
- **Ignore `self`** in LeetCode class method signatures.
- **Read errors to understand**, don't just keep mashing variables around hoping for success.


---

# Ruby Solutions Deep Dive — March 18, 2026

Mock interview on **Summary Ranges** (LeetCode Easy). Long lesson on mindset, self-coaching through problem understanding, and how to decode an unusual problem specification.

---

## Pre-Session: Dan's Notepad++ Demo

Dan shared his in-progress demonstration of Python data types — a script showcasing `type()`, lists containing mixed data types, list indexing, negative index access, and string escape sequences. Material for his peer programming sessions where attendees get homework.

---

## Problem: Summary Ranges

> You are given a sorted unique integer array `nums`. A range `[a, b]` is the set of all integers from `a` to `b` (inclusive). Return the **smallest** sorted list of ranges that cover all the numbers in the array exactly. That is, each element of `nums` is covered by exactly one of the ranges, and there is no integer `x` such that `x` is in one of the ranges but not in `nums`.
>
> Each range `[a, b]` in the list should be output as:
> - `"a->b"` if `a != b`
> - `"a"` if `a == b`

### Examples

- `[0, 1, 2, 4, 5, 7]` → `["0->2", "4->5", "7"]`
- `[0, 2, 3, 4, 6, 8, 9]` → `["0", "2->4", "6", "8->9"]`

### Constraints

- `0 <= nums.length <= 20`
- `-2^31 <= nums[i] <= 2^31 - 1`
- All values are unique.
- `nums` is sorted in ascending order.

---

## Stephen's Confusion

Stephen got stuck on the phrase *"each element of nums is covered by exactly one of the ranges"* and couldn't understand why `1` and `3` seemed to be "missing" from the output when they weren't even in the input arrays.

### The Core Misunderstanding

The examples actually don't skip numbers — they represent **consecutive runs**. In `[0, 1, 2, 4, 5, 7]`:
- `0, 1, 2` are consecutive → range `"0->2"`
- `4, 5` are consecutive → range `"4->5"`
- `7` is alone → single element `"7"`

The key insight: **a range in this problem is a maximal run of consecutive integers present in the array.**

---

## The Coach's Nudge Toward Python's `range()`

> "So if you think about the Python `range` function — you can set a start and a stop. When you have a start and a stop, do you need to include all the numbers in between?"
> Stephen: "No."
> "Does that sound familiar to this problem?"

Connecting the problem's "range" to Python's `range(start, stop)` function unlocked the concept.

---

## The Solution

```python
class Solution:
    def summaryRanges(self, nums: List[int]) -> List[str]:
        ranges = []
        if not nums:
            return ranges

        start = nums[0]
        for i in range(1, len(nums)):
            if nums[i] != nums[i - 1] + 1:
                # End of a consecutive run
                end = nums[i - 1]
                if start == end:
                    ranges.append(str(start))
                else:
                    ranges.append(f"{start}->{end}")
                start = nums[i]

        # Flush the final run
        end = nums[-1]
        if start == end:
            ranges.append(str(start))
        else:
            ranges.append(f"{start}->{end}")

        return ranges
```

### Walkthrough On `[0, 1, 2, 4, 5, 7]`

- `start = 0`
- `i = 1`: `1 == 0 + 1`, continue
- `i = 2`: `2 == 1 + 1`, continue
- `i = 3`: `4 != 2 + 1`, close range `"0->2"`, `start = 4`
- `i = 4`: `5 == 4 + 1`, continue
- `i = 5`: `7 != 5 + 1`, close range `"4->5"`, `start = 7`
- Loop ends, flush final: `7 == 7`, append `"7"`
- Result: `["0->2", "4->5", "7"]` ✓

### The Two Output Formats

```python
if start == end:
    ranges.append(str(start))       # single element
else:
    ranges.append(f"{start}->{end}") # multi-element range
```

This matches the problem's `A->B if A != B, A if A == B` specification.

---

## Coach Feedback: Mindset As The Real Blocker

> "You were saying that you were struggling and stuck and didn't understand it, but you did explain the problem really well. You called out exactly what it was doing. It is converting ranges to strings. You acknowledged that it's skipping numbers and highlighted how it's going `0->2` then `4->5` then `7`. You understood almost everything about this problem."

> "I think with just a little bit of a mindset shift, you could have hit that breakthrough. The only way to get to those breakthroughs on your own is: one, your mindset. Are you defeatist and giving up, or are you saying 'what do I know about this problem? What can I do next to understand it?'"

### The Meta-Lesson

> "No amount of tips or guidance or someone else chiming in is going to help you make that breakthrough on your own. You have to build the habit of asking yourself questions and testing theories."

---

## Linda's Contribution: Pattern Recognition From Examples

> "The thing that put me on the right path was being able to recognize a pattern from the examples — what worked, what didn't. When you had consecutives you had the dash-zero thing. When you had a skip you had an individual number."

### Coach's Response

> "That's great, but not everyone can immediately see the same pattern. The only way around that is by asking a bunch of questions — what is the range? How are they defining these ranges? What does it mean in the context of this problem?"

### What Examples Are For

> "Examples give you an outline and some edge cases. LeetCode will give you minimal examples to force you to find the edge cases yourself. A better example here would have been one where the range skipped a lot of numbers. You have to build out your own test cases, or submit something partial to unlock the hidden test cases LeetCode shows you on failure."

---

## Michelle's Question: Does A Range Always Not Skip?

> "A range is context-dependent. For this problem, they're defining a range as a series of consecutive numbers represented as a start and a stop. `0 1 2 3 4` become `"0->4"`. That definition is specific to this problem."

---

## Constraint-Based Assumption: Starting Index Doesn't Matter

Stephen initially wondered if the range always started at zero. The coach pushed back:

- `nums[i]` ranges from `-2^31` to `2^31 - 1` — so values can be **negative**, not necessarily starting at zero.
- The **order** is sorted, so positional index 0 is whichever value is smallest.
- The insight: **starting index zero does NOT matter because the array is sorted** — we just walk through looking for gaps.

---

## Dan's Old-School Flowchart Analogy

> "Back in the day we used to write flowcharts. We'd create the if statements and conditional statements — not exactly writing code but going to where the intersection point is or the decision point. What do you do from that decision point?"

Coach: "Putting it into a data-structure form helps you figure out the flowchart piece."

---

## Takeaways

- **A "range" in this problem is a maximal run of consecutive integers present in the array.** Not every integer in the range's interval is necessarily present in the source — but every integer in the run must be consecutive.
- **Link unfamiliar problem terminology to Python built-ins** — "range" → `range(start, stop)`.
- **Track `start` outside the loop**, update it when the consecutive run breaks, and flush the final range after the loop.
- **`f"{start}->{end}"`** for f-string formatting of the output.
- **Examples in LeetCode are minimal** — build your own test cases or submit partial code to reveal hidden ones.
- **Mindset breakthroughs can't be coached** — you have to build the habit of asking yourself questions and testing theories instead of giving up.
- **Flowchart thinking** (decision points and branches) translates directly to if/else code structures.


---

# Ruby Solutions Deep Dive — March 25, 2026

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
