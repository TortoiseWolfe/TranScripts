# Mock Interview — Birthday Cake Candles & Container With Most Water (2025-06-01)

Nailing the Tech Interview session. New Sunday format: Q&A, high-level walkthrough of an easy problem with pseudo code, then a volunteer mock interview. Wednesday sessions take problems to full solutions.

---

## Q&A

### Can you use Google or notes during Joy of Coding tech interviews?

- **Allowed:** syntax lookups (e.g., "how to set up the `count` method"), handwritten concept notes on stacks/queues/linked lists.
- **Not allowed:** full or partial solutions, ChatGPT / AI assistants, Googling things like "how to reverse an integer."

### Getting stuck transferring pseudo code into real code

Common pattern: student understands the problem, can write pseudo code, but freezes when it's time to write actual code.

Fix: don't try to jump to a final solution. Get **something** on the screen, then iterate.

- Write a template: empty `if`, empty `for` loop — just to have code to edit.
- Add `print` statements.
- Make an **assumption** ("I expect this to do X") and test it by running and observing.
- Make incremental progress from that point.

Referenced framework: **Dr. Emily's four problem-solving pillars** (review in prior sessions).

### Can you Google the Big-O cost of built-in methods?

Yes — that's what the coach does too.

- Search pattern: "big O of [method] in [language]" (e.g., "big O of max in Python").
- Python wiki has an official [TimeComplexity page](https://wiki.python.org/moin/TimeComplexity) listing most list operations.
- **`max` / `min`**: O(n).
- **`len`**: O(1).
- **Index get/set** (`list[i]`): O(1).
- Tool mentioned: **bigocalc / bigocount** — paste code and it computes the complexity.

> Big-O explanation is **not required** for Joy of Coding tech interviews, but it comes up in real job interviews.

### How to actually understand Big-O

- Find code examples that illustrate each Big-O class.
- O(1) — declaring a variable, dict lookup by key, returning `array[0]` regardless of array size.
- O(n) — single loop through an array.
- O(log n) — phone-book bisection: cut the search space in half repeatedly.
- O(n²) — nested loop where the inner loop re-traverses the array for each outer element.
- **Two separate sequential loops over the same array = O(2n), not O(n²).** O(n²) is specifically nested traversal.
- Cumulative rule: if any section is O(n), the function is at least O(n). If any section is O(n²), it's at least O(n²).

### Do harder HackerRank problems expect more edge cases?

Yes. Higher difficulty → more test cases, more "gotcha" edge cases. Reading the **constraints** up front helps predict edge cases. It's also acceptable in a real interview to write draft code, run it, and catch edge cases iteratively — as long as you can explain what came up and how you handled it.

---

## Problem 1: Birthday Cake Candles (walkthrough)

**Source:** HackerRank easy.

**Prompt:** Given an array of candle heights, return the count of candles equal to the tallest height.

### Pulling the problem apart

- **Input:** integer array of candle heights.
- **Output:** integer — count of tallest candles.
- **Example:** `[3, 2, 1, 3]` → `2` (two candles at height 3).
- **Constraints:** array length 1 → 10⁵ (100,000). Values 1 → 10⁷ (10,000,000).

### Strip the metaphor

Restated plainly: *find the maximum value in the array, then count how many elements equal that maximum.*

### Strategy

Two things needed:

1. Max value in the array.
2. Count of elements equal to that max.

### Two approaches

- **Built-in:** `max(candles)` then count matches.
- **Manual loop:** loop once tracking max, then second loop counting matches (or track both in a single pass for efficiency).

> When starting out, go for the most verbose method. Don't worry about being DRY or efficient — just get the test cases passing first.

### Tip: blank return to unlock test cases

> HackerRank/LeetCode sometimes throws fake errors from their submission wrapper before your code runs. Add a stub `return 0` (or `return []` / `return False` depending on expected type) just to reveal the real test cases.

---

## Problem 2: Container With Most Water (mock interview — medium)

**Volunteer:** Jenny.

**Prompt:** Given an integer array `height`, each index is a vertical line. Pick two lines that together with the x-axis form a container holding the most water. Return the max area. Lines cannot slant.

### What Jenny did well

- Wrote out key phrases from the problem in comments.
- Initialized a variable (`waterVolume = 0`).
- Started a `for` loop to iterate.
- Ran the code partway through to see output.
- Flagged assumptions ("I think this means this") — a great habit.

### Where she got stuck

- Jumped into code before fully understanding the problem.
- Kept trying to **add** heights together (got 44 for the example — but expected 49).
- Didn't recognize that "area" implies **multiplication**, not addition.

### The coach's guided breakthrough

**Key question:** *"When you think area, what operation do you use?"*

Answer: multiplication (width × height).

- **Width** = distance along the x-axis between the two chosen lines.
- **Height** = the **shorter** of the two chosen lines (water can't rise above the shorter wall).

**Worked example** for `[1,8,6,2,5,4,8,3,7]`:

- The two tallest lines are at indices 1 and 8 (heights 8 and 7). Distance = 7. Min height = 7. Area = **7 × 7 = 49.** ✓
- Using the two 8s (indices 1 and 6): distance = 5, min height = 8, area = 40. Smaller.
- This is why it's **not** just "pick the tallest two" — distance matters too.

### Decoding the confusing wording

> "There are n vertical lines drawn such that the two end points of the iᵗʰ line are (i, 0) and (i, height[i])."

Translation: at each index `i`, the line runs from `(i, 0)` at the bottom to `(i, height[i])` at the top. You don't need to fully parse this sentence to solve the problem — the picture and the word "area" give enough to work from.

### Interview lessons from this mock

- **Test assumptions immediately** — print, run, compare to expected output.
- **Don't rush into code** before understanding the problem enough to know what you're testing.
- Brute force first, optimize later.
- Medium problems are **stacked easy problems** — same skills, more layers of assumption-testing.

### Efficiency hint (two-pointer approach)

One participant suggested: start with two pointers at opposite ends of the array and move inward. This is the named efficient algorithm for this problem (two-pointer technique). Brute-force a working solution first, then reverse-engineer the two-pointer optimization.

---

## General Guidance

- Practice harder than you play. Medium problems build the same fundamentals as easy problems, stacked.
- Reading the **example explanation** carefully often gives the breakthrough — they use words like "area" deliberately.
- The problem text is sometimes worded to confuse you (e.g., "water in a container" implies volume, but the problem is 2D area).
- `max_area` function signature and class structure in HackerRank/LeetCode starter code **must** be preserved — that's what the test harness calls. You can add helper functions inside, but don't rename the entry point.

[REVIEW: one participant speculated a linked-list approach would help — coach corrected that linked lists aren't the right tool here; the two-pointer technique on the array is.]


---

# Mock Interview — Two Sum & Three Sum (2025-06-08)

Sunday session: pseudo code walkthrough + mock interview. This week covers **Two Sum** (easy) and **Three Sum** (medium), both perennial tech-interview favorites.

---

## Q&A

### Using AI assistants during practice

Walter shared that he was using GPT to reorder lines and suggest syntax alternatives.

- If AI is fixing parentheses or small syntax, that's one thing.
- If AI is restructuring logic, **that's problem solving** — letting it do that shortcuts your own learning.

### Writing pseudo code without knowing exact syntax

You don't need to know the exact method name while writing pseudo code.

- Write out the intent in plain sentences.
- When you need something like "count method" or "max method," just note it — look up the syntax later when you write the real code.
- Iterate: write pseudo code → write real code → test assumptions → rewrite pseudo code if needed.

### What does the Joy of Coding tech interview look like?

- 30-minute session.
- 20 minutes on a HackerRank easy-level question.
- Followed by code questions and behavioral questions.
- Coach makes a recommendation for what to work on next, whether pass or fail.
- **New:** follow-up notes are now sent after the session so students don't forget feedback.

---

## Problem 1: Two Sum (pseudo code walkthrough)

**Prompt:** Given array `nums` and integer `target`, return the **indices** of two numbers that add up to `target`. Exactly one solution exists. Cannot use the same element twice.

### Pull out the key pieces

- **Input:** array of integers + a target integer.
- **Output:** two index positions whose values sum to target. Order of indices doesn't matter.
- **Assumption:** exactly one solution always exists → will never return an empty array.
- **"Cannot use same element twice"** means cannot use the **same index** twice. Values can repeat (e.g., `[3,3]` with target 6 → `[0,1]`).

### Constraints

- `nums.length`: 2 to 10⁴.
- Values: −10⁹ to 10⁹ (**can be negative**).
- Target: negative or positive.

> **Important consequence of negative values:** you can't eliminate values that are larger than the target, because a negative plus a positive could still equal the target. E.g., target 15 could come from `−5 + 20`.

### The follow-up hint

> "Can you come up with an algorithm that is less than O(n²) time complexity?"

This tells you:

- Brute-force solution is expected to be **O(n²)**.
- A more efficient solution exists.

### Brute force approach

- Outer loop through each index.
- Inner (nested) loop through remaining indices.
- Check whether outer + inner equal target.
- Return indices when found.

This is **O(n²)**. Will it time out? Depends on the test cases and the language — sometimes brute force squeaks by, sometimes it doesn't.

### Improved approach (Eric's suggestion)

- Loop through the array once.
- For each value, compute the **complement** (`target − current`).
- Search the remaining array for that complement.

Efficiency depends on the search method:

- Unsorted array with linear search → still roughly O(n²).
- Sorted array with binary search → O(n log n).
- With a hash map lookup → O(n). *(This is the standard optimal answer, not covered in detail today.)*

### Big-O clarification

A nested loop where the inner loop only looks at greater indices (`j = i+1`) **is still O(n²)**. It's reduced, but not meaningfully — the class doesn't change.

**O(n) does not mean "loop through every element exactly once."** It means the work scales **linearly** with input size. Looking at 3 of 5 inputs, 30 of 100, 300 of 1000 — that's still O(n) because the ratio is constant.

---

## Problem 2: Three Sum (mock interview)

**Volunteer:** Walter.

**Prompt:** Given integer array `nums`, return **all triplets** `[nums[i], nums[j], nums[k]]` such that `i ≠ j ≠ k` and `nums[i] + nums[j] + nums[k] == 0`. Solution must not contain duplicate triplets.

### What Walter did well

- Recognized it would need multiple nested loops (three pointers: `i`, `j`, `k`).
- Identified the core task: find all groups of three that sum to zero.
- Understood the relationship to Two Sum.

### Key clarification that tripped the group up

The phrase "`i ≠ j ≠ k`" refers to **index positions**, not values.

- `[-1, -1, 2]` is valid if there are two `−1`s at **different indices** in the array.
- You can reuse the same **value** across triplets, but not the same **index** within a single triplet.

### Additional constraints

- **Return shape:** a 2D array of all valid triplets (not index positions — unlike Two Sum, which returns indices).
- **No duplicate triplets:** if `[−1, −1, 2]` has already been found, you cannot add another `[−1, −1, 2]` even if it came from different indices.
- **The same value/index CAN be reused across different triplets** (just not within one triplet, and not forming a duplicate triplet).
- **Order within answer arrays doesn't matter.**
- **There may be no valid triplets** — unlike Two Sum, it's possible an entire array has no solution. Always default to returning an empty array.

### Approach

Brute force is three nested loops (O(n³)) checking all `i,j,k` combinations.

- Unlike Two Sum, Three Sum has **no dramatically better solution** — you can optimize the brute force a smidge (sort first, use two-pointer inside a single loop → O(n²)), but that's about it.

### Strategy: break it into steps

1. First, just find **one** valid triplet. Don't worry about finding all of them.
2. Then figure out how to find **multiple** triplets.
3. Then figure out the dedup condition to avoid repeating triplets already in the answer set.

Each step may take several iterations to get right.

---

## Why These Two Problems Matter

- **Two Sum** and **Three Sum** are still actively used in real job-hunt technical interviews today.
- Often seen together: interviewers start with Two Sum, then add conditions until it becomes Three Sum.
- Rankings (easy/medium) are a little skewed — they're popular enough that expect them to come up.

---

## General Advice

- Try these problems on your own before Wednesday's deep-dive session.
- When stuck, break the problem into the smallest possible step. Don't try to solve "find all triplets with dedup" in one shot — find one triplet first.
- Always add a stub return value (empty array, `False`, `0`) to unlock real test case output when starting.

[REVIEW: coach mentioned moving to Spain and cancelling sessions for one week — scheduling note, not technical content, but kept for completeness.]


---

# Mock Interview — Missing Numbers (2025-06-29)

Sunday session: pseudo code walkthrough of HackerRank's Missing Numbers problem. No volunteer mock interview today — discussion ran long.

---

## Problem: Missing Numbers

Given two arrays of integers, find which elements in the **second** (longer/original) array are missing from the **first** (shortened) array.

### Examples

- `arr = [7,2,5,3,5,3]`, `brr = [7,2,5,4,6,3,5,3]` → missing `[4, 6]`.
- Frequency matters: if `3` appears twice in `brr` and once in `arr`, then `3` is missing.
- But only include each missing number **once** even if its frequency difference is more than one.

### Constraints worth noting

- `n ≤ m` — the shortened array is always at most as long as the original.
- The difference between max and min values in the original list is ≤ 100. *(Hint at an O(1)-space frequency-array approach using offset indexing.)*
- Return must be a **sorted array**.

---

## Pulling Statements From the Problem

- Given two lists, find missing numbers from the smaller (`arr`).
- Frequency of a number matters — could count as missing.
- If a number occurs multiple times, only include it as missing **once**.
- Return a sorted array of missing numbers.

### Assumptions to test

- **Same length implies identical arrays / no missing numbers** — possibly false. Could be all `[203, 203, ...]` vs `[201, 202, 203, ...]` of the same length. Worth verifying with test cases.
- **Both arrays will be in the same general sort order** — not stated explicitly. If true, you can do an index-by-index walk. If false, you need a more complicated search per element.

---

## Approach: Index-Walk (assumes sorted order)

```python
tracking = []
offset = 0
for i in range(len(brr)):
    if brr[i] != arr[i - offset]:
        tracking.append(brr[i])
        offset += 1
return sorted(tracking)
```

### How it works

- Walk `brr` (the longer original) one element at a time.
- Compare against the corresponding index in `arr` (the shortened), with an **offset** to skip past missing values.
- When `brr[i]` doesn't match `arr[i - offset]`, that's a missing number — append it to `tracking` and bump the offset.
- Sort the result before returning.

### Why offset?

When you find a missing number, the indices in `arr` don't advance — but `brr` does. The offset keeps the comparison aligned.

### If the assumption is wrong

If the arrays aren't sorted, you'd need to search the entire `arr` for each `brr` element, bumping complexity from **O(n)** to **O(n²)**.

> Working with assumptions: list them explicitly at the top of your pseudo code so you know which ones to revisit if the approach breaks.

---

## Translating Pseudo Code Into Real Code

A common stuck point: "I have an idea, but I don't know how to convert it into Python syntax."

### Coach's advice

- Write your pseudo code as **discrete steps** (initialize array, loop, conditional, append).
- For each step, ask: "What's the syntax I need? Do I know it, or do I need to look it up?"
- **Looking up syntax is fair game** in tech interviews — Google `Python range` to confirm parameters; that's not cheating.
- What's **not** OK: looking up "how to solve missing numbers in Python" or pasting a full or partial solution.

### Python `range()` recap

- `range(stop)` → 0 to stop-1, increment by 1.
- `range(start, stop)` → start to stop-1.
- `range(start, stop, step)` → custom increment.
- Returns an iterable sequence; commonly used in `for i in range(...)`.

---

## Iterative Testing

After writing each step, **run it and print intermediate values** before adding the next step:

```python
for i in range(len(brr)):
    print(i, brr[i])
```

This catches off-by-one errors and assumption failures one step at a time. If you write all the code at once and then run it, you have to debug from scratch.

---

## Q&A: How to Track Time During Practice

Question: "I have trouble realizing where I am within the time limit. How should I keep an eye on time while practicing?"

### Coach's answer

- **Don't race the clock** while practicing. Take the time you need to do each step properly.
- Use a stopwatch (count-up) to **measure** how long it took, then look at the result. Don't pre-set a 20-minute deadline that pressures you.
- Over time, your speed naturally improves by doing the steps correctly.
- Once you're consistently under 20 minutes, **then** start using a countdown timer to simulate the real interview pressure.
- There's no single "correct" time split between pseudo code and coding. Some people take 3 minutes on pseudo code and 10 on code. Others take 10 on pseudo code and 2 on code. Both work.

### Tools

- Built-in stopwatch/timer apps on Windows or your phone.
- Keep the timer visible on screen if it helps, but don't let it distract from the work.

---

## Time Window Goal

- **Target:** 15–20 minutes per easy problem.
- **For practice:** start with 20-minute targets, then tighten as you get faster.
- **Joy of Coding interview:** 20 minutes for one easy HackerRank problem.

[REVIEW: extended discussion about Spanish keyboard quirks and missing `#` / `{}` keys — kept as context for why the coach paused mid-coding multiple times.]


---

# Mock Interview — Ice Cream Parlor (2025-07-06)

Sunday session: pseudo code walkthrough of HackerRank's Ice Cream Parlor (a Two Sum variant). No volunteer mock interview today — login issues for the volunteer.

---

## Problem: Ice Cream Parlor

Two friends pool money to buy ice cream. They always pick **two distinct flavors** and spend **all their money**. Given the budget `m` and a list of flavor `costs`, return the **one-based indices** of the two flavors that exactly add up to `m`.

### Example

- Budget: `m = 6`
- Costs: `[1, 3, 4, 5, 6]`
- Output: `[1, 4]` (cost[0]=1, cost[3]=5, sum=6, but using **1-based** indexing → 1 and 4)

### Constraints

- Number of trips: 1 to 50 (multiple test cases per submission).
- Money `m`: 2 to 10⁴.
- Number of flavors `n`: 2 to 10⁴.
- Costs: 1 to 10⁴, may include duplicates.
- **There will always be a unique solution** → always exactly two indices to return.

---

## HackerRank gotcha: multi-test-case input format

The "Sample Input" shows a long block:

```
2          # number of trips (test cases)
4          # money for trip 1
5          # length of cost array for trip 1
1 4 5 3 2  # costs for trip 1
4          # money for trip 2
4          # length of cost array for trip 2
2 2 4 3    # costs for trip 2
```

> **Don't be confused by the input format.** Behind the scenes, HackerRank calls `iceCreamParlor(m, cost)` **once per test case**. You only need to write the function for a single trip — the harness handles iterating over the test cases.

### The empty-return trick

If you see `_FptrName_join(...)` errors before your code runs, that's HackerRank's submission wrapper failing because you're not returning the expected type. Fix: add a stub return matching the expected type:

```python
return []  # for an integer array return
```

This silences the wrapper error and lets you see the real test case input.

---

## Pulling Statements From the Problem

- Given `m` (money to spend) and `cost` (potential ice cream flavors).
- Return the **two indices** representing the chosen flavors.
- **Always expect to return two values.**
- **Use one-based indexing** (not Python's default zero-based).
- Cost array will always have at least two flavors.
- Values may repeat; values are between 1 and n.

### Goal in plain words

Given `m`, find two values in the `cost` array that sum to `m`, and return their **one-based** indices.

---

## Python `enumerate` with custom start

```python
for index, value in enumerate(cost, 1):
    print(index, value)
```

- `enumerate(iterable, start=N)` lets you set the starting index.
- Default is 0, but for this problem we want 1.
- This is much cleaner than `for i in range(len(cost))` followed by `cost[i]`.

> **Using `enumerate(cost, 1)` directly handles the one-based indexing requirement** — no off-by-one bugs from manual `i + 1` arithmetic.

---

## Approaches

### 1. Brute Force (nested loop)

```python
for i, val_i in enumerate(cost, 1):
    for j, val_j in enumerate(cost, 1):
        if i < j and val_i + val_j == m:
            return [i, j]
```

- **Complexity:** O(n²)
- Always works. May be slow on large inputs.

### 2. List comprehension

Conceptually equivalent to the nested loop. Same O(n²) complexity. List comprehension is **not** automatically faster — it just looks more compact. It also creates an intermediate list, which uses more memory than a plain loop.

### 3. Complement search

For each value, compute `complement = m - value` and search the rest of the array for the complement.

- With **linear search:** still O(n²) overall.
- With **binary search:** O(n log n), but requires sorting first → sorting also loses original indices.

### 4. Hashmap (dictionary)

```python
seen = {}
for i, val in enumerate(cost, 1):
    complement = m - val
    if complement in seen:
        return [seen[complement], i]
    seen[val] = i
```

- **Time:** O(n)
- **Space:** O(n)
- **Optimal** — same approach that solved Two Sum.

> "Since we know that we have the value that we're looking for, this is a perfect setup for the same techniques we used in Two Sum."

---

## Decoding Math Notation in Constraints

The constraint `cost[i] ∈ {1...n}` (with the "for all" upside-down A symbol) just means: every value in `cost` is an integer between 1 and n inclusive.

- **∀** = "for all" / universal quantifier.
- **∈** = "is an element of" / set membership.

You can usually safely **ignore** these symbols if they don't directly help you choose an approach. They're just describing the input domain.

---

## Q&A: Data Annotation Company

A few participants asked about Data Annotation as a freelance opportunity.

- **Process:** sign up, take an assessment. The assessment is timed and not trivial.
- **What to brush up on before applying:**
  - Big-O complexity analysis
  - Reading code for efficiency
  - Python syntax and application
- **Take-home assignment** is part of the assessment for some tracks.
- They hire in waves, not always actively recruiting.
- Recommendation: try after **end of Mod 2** and after you're comfortable with HackerRank time limits.

---

## Brian's Maximum Product Subarray result

Brian solved last Wednesday's Max Product Subarray problem using **traversing left-to-right and right-to-left**. Took ~2 hours but passed all test cases. For a medium problem with 35% acceptance rate, that's a strong result.

> "Better than 65% of people who took on the challenge."


---

# Mock Interview — Maximum Average Subarray & Search in Rotated Sorted Array (2025-07-13)

Sunday session: pseudo code on Maximum Average Subarray (easy, sliding window intro), then a mock interview on Search in Rotated Sorted Array (medium, binary search). Volunteer: Daniel.

---

## Problem 1: Maximum Average Subarray I (easy)

Given an integer array `nums` of length `n` and an integer `k`, find a **contiguous subarray of length k** with the **maximum average value** and return that value.

### Example

- `nums = [1, 12, -5, -6, 50, 3]`, `k = 4`
- Output: `12.75`
- Reasoning: subarray `[12, -5, -6, 50]` sums to 51, divided by 4 = 12.75.

### Constraints

- `nums.length` (n): 1 to 10⁵
- `k`: 1 to n (always have enough elements for at least one subarray of size k)
- Values: -10⁴ to 10⁴

---

## Pulling From the Problem

- `nums` = array given to find subarray average in.
- `k` = size of the subarray to calculate an average for.
- `nums.length` is always ≥ k → we can always compute at least one valid average. No empty-array edge cases.

---

## Approaches

### 1. Brute Force (nested loop)

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

### 2. Sliding Window (the optimal approach)

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

### Sliding Window keywords (when to use it)

- **Given K** or a fixed window size to track.
- Looking for a **sum, product, or average**.
- Working with **contiguous** subarrays.

> "Having the window size defined really helps you get that O(n) done pretty quickly. Maximum Average Subarray is a great intro to sliding window because the window size is given."

### Bonus: prefix sum approach (mentioned but not fleshed out)

Build a prefix-sum array where `prefix[i]` = sum of `nums[0..i]`. Then any window sum = `prefix[i + k] - prefix[i]`. Same O(n) complexity, different mechanism.

---

## Problem 2: Search in Rotated Sorted Array (medium) — mock interview

**Volunteer:** Daniel.

### Problem statement

You're given a sorted (ascending) integer array `nums` with **distinct values** that has been rotated at some unknown pivot index `k` (so the array becomes `nums[k:] + nums[:k]`). Given a target value, return its index in the rotated array, or `-1` if not found.

**Critical constraint:** "You must write an algorithm with **O(log n)** runtime complexity."

### Why it's a medium problem

The O(log n) requirement immediately rules out brute-force linear search (O(n)). You're expected to know **binary search** and adapt it to the rotated case.

---

## Daniel's session

### What Daniel did well

- Read the problem and pulled out the goal: find target, return its index, or return -1.
- Identified two potential approaches: brute force loop, or sorting first.
- Wrote out comments before code.
- Iterated when stuck, with the coach prompting.

### Where he got stuck

- **Variable name conflict:** used `target` as the loop variable in `for target in range(...)`, which shadowed the `target` parameter passed to the function.
- **Indexing confusion:** wasn't sure whether `i` was an index or a value. Coach prompted using `print(nums[i])` to verify.
- **Indentation error:** the code block was at the same level as the function definition, not inside it.

### The fix progression

1. Print the loop variable: `print(i)` → confirmed `i` was the index.
2. Print the array value at that index: `print(nums[i])` → confirmed access works.
3. Add the comparison: `if nums[i] == target: return i`.
4. Return `-1` after the loop ends.

This brute-force solution works but is **O(n)**, which fails the O(log n) requirement.

---

## The Iterative Testing Habit

> "Make sure you're taking iterative steps. What am I getting in my for loop? Is it printing an index? A value? How can I make sure I'm hitting all those steps before I write down a full several lines of code?"

**Key advice:** before adding logic, verify the building blocks are working.

- Print the loop variable.
- Print the value you're accessing.
- Compare against expected output by hand.
- Then add the next layer.

This avoids the trap of writing 30 lines, hitting an error, and not knowing which line is wrong.

---

## Binary Search on a Rotated Array (group discussion)

### Standard binary search recap

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

### The rotation challenge

A rotated array is **two sorted segments stitched together**. At any midpoint, **one half is still sorted** and the other half contains the rotation pivot.

### Modified binary search idea

- Compute `mid`.
- Determine which half (left or right of `mid`) is fully sorted.
- Check if the target falls within the sorted half's range. If yes, binary search in that half. If no, search the other half.
- Continue until found or `left > right`.

> "It's almost like you have two sorted lists within a single list and you have to figure out which sorted list you want to start binary searching through as you move through."

This will be explored in depth on Wednesday.

---

## Big-O Reminder

| Big-O | Description | Example |
|---|---|---|
| O(1) | Constant | Array index access |
| O(log n) | Logarithmic | Binary search |
| O(n) | Linear | Single loop through array |
| O(n log n) | Linearithmic | Most sorts |
| O(n²) | Quadratic | Nested loops over the same array |

The medium problem here demands O(log n) — only a tiny step above O(1). That's why the interviewer is essentially requiring the binary search algorithm.

---

## Recommendation: Always Get Brute Force First

Even when the problem demands a specific complexity (like O(log n) here):

1. Get a brute force solution working first to confirm you understand the problem.
2. Make sure you're accessing values correctly, comparing correctly, returning the right type.
3. **Then** optimize toward the required complexity.

> "For brute force of just getting how can I approach this problem and get some test cases passing — totally great. Then we make the next step of saying what do I know about potential approaches to get this to that desired runtime."


---

# Mock Interview — Insert Interval (2025-07-20)

Sunday session: deep pseudo-code session on LeetCode's Insert Interval (medium, 43% acceptance). No coding today — entire session spent on understanding, decomposing, and game-planning.

---

## Problem: Insert Interval

You're given an array of **non-overlapping intervals** sorted in ascending order by start. You're also given a single **new interval**. Insert the new interval into the array such that it remains sorted and non-overlapping. Merge overlapping intervals if necessary. Return the resulting interval array.

### Example 1

- Intervals: `[[1, 3], [6, 9]]`
- New interval: `[2, 5]`
- Output: `[[1, 5], [6, 9]]`

The new interval `[2, 5]` overlaps with `[1, 3]` (at 2 and 3), so they merge into `[1, 5]`.

### Example 2

- Intervals: `[[1, 2], [3, 5], [6, 7], [8, 10], [12, 16]]`
- New interval: `[4, 8]`
- Output: `[[1, 2], [3, 10], [12, 16]]`

The new interval `[4, 8]` overlaps with `[3, 5]`, `[6, 7]`, and `[8, 10]` — all three merge into `[3, 10]`.

### Critical insight

> "An interval represents **all the numbers in between**, not just the endpoints. `[3, 5]` means 3, 4, 5. That's why `[4, 8]` overlaps with it — 4 is inside that range."

---

## Why This Problem Is Mind-Bending

The wording uses "intervals" so many times in one paragraph that it's hard to track what's being referred to. The coach's tactic: **rewrite the problem in your own words** as you read it.

### Coach's restatement

- We are given **intervals** = a list of `[start, end]` pairs (the coach calls them "i-j pairs").
- The pairs **do not overlap** with each other.
- They are sorted by start.
- We are given a **single new interval** to insert.
- The new interval may overlap with one or more existing intervals.
- Return a new list with the new interval inserted (or merged if needed), still sorted, still non-overlapping.

### Inclusive vs exclusive

The intervals use square brackets `[...]`, which means **inclusive** of the endpoints. If they used parentheses `(...)`, that would be exclusive. Pay attention to bracket notation when dealing with ranges.

---

## Decomposing Into Two Test Case Difficulties

### Easy version (modify the example)

- Intervals: `[[1, 3], [6, 9]]`
- New interval: `[4, 5]`
- Output: `[[1, 3], [4, 5], [6, 9]]`

No overlap → just slot it in. **Tackle this first** as a simpler subset of the full problem.

### Hard version (original example 2)

- Multi-interval merging required.
- Build the easy solution first, then extend.

> **LeetCode test case trick:** you can edit the test case input fields directly, and LeetCode will compute the expected output for your custom inputs. HackerRank doesn't generate expected output for custom cases.

---

## Approach: Two-Step Game Plan

For the **easy** version (no merging):

### Step 0: Initialize a new array to hold the result

(Don't modify the original — the problem note explicitly allows returning a new array.)

### Step 1: Loop through the intervals

For each existing interval, **check if the new interval's start is contained within it**.

### Step 2: Determine the sort placement

For each interval, check whether the new interval is **less than** or **greater than** the current interval (using start values).

### Decision logic

- If no overlap **and** new interval is less than current → add new interval to king array, then add current.
- If no overlap **and** new interval is greater than current → add current to king array, continue iterating.
- Continue this until you've placed the new interval and finished iterating.

### Example walk-through (`[1, 3]`, `[6, 9]` + `[4, 5]`)

1. Index 0 = `[1, 3]`. Is `4` between 1 and 3? No. Is `[4, 5]` greater than `[1, 3]`? Yes. Add `[1, 3]` to result. Continue.
2. Index 1 = `[6, 9]`. Is `4` between 6 and 9? No. Is `[4, 5]` less than `[6, 9]`? Yes. Add `[4, 5]` to result, then add `[6, 9]`.
3. Result: `[[1, 3], [4, 5], [6, 9]]` ✓

---

## Useful Python Index Notation

Brian's tip:

```python
intervals[i][0]   # start of interval i
intervals[i][1]   # end of interval i
new_interval[0]   # start of new interval
new_interval[1]   # end of new interval
```

Alternatively, since each interval is just a 2-element list, you can also use `[-1]` for the end and `[0]` for the start. Both work.

---

## Other Approaches Considered

### Mindy's dictionary idea

Store intervals as dictionary entries with the start as the key and the rest of the values as the value. Concept is interesting but complicates the merge logic. Not pursued, but the **idea** of using a different data structure to organize the intervals is worth keeping in mind.

### Brian's list-of-lists loop with index notation

Instead of explicit `[0]` / `[1]` access, use Python's list-of-lists semantics directly. Same approach, cleaner notation.

---

## The Big Lesson: Stay In Pseudo Code Longer

> "I've gone through and rewritten this portion several times. I added a new step at the beginning. I rewrote this part two or three times. I rewrote this part twice. Now I have a game plan I've been able to modify very quickly. Whereas if this was code, I'd be worried about syntax, implementation, correct order of operations."

### Why it matters

- Once you're in code, you're locked into "I have to make this code work" mode.
- Pseudo code is **cheap to edit** — you can rewrite an approach in 30 seconds.
- Rewriting code takes minutes.
- Spending 80% of an interview in comments is fine **as long as** you're confident the resulting code will run when you finally write it.

### When to start over vs tweak

- A few small bugs in code → debug and tweak.
- Realized the whole approach was wrong → wipe it, go back to pseudo code, start over.
- The longer you spend tweaking a bad approach, the more time you waste.

### What the coach has seen

- 10 minutes of pseudo code → 2 minutes of code → all test cases pass.
- 5 minutes of pseudo code → 5 minutes of code → all pass.
- 0 minutes of pseudo code → 30+ minutes of debugging → still failing.

---

## The Easy → Hard Strategy

When a problem has an "easy" base case and a "hard" extension (like the merging here):

1. Build a working solution for the easy case first.
2. Get test cases passing for the easy case.
3. **Then** extend the working code to handle the hard case.
4. Do not try to solve both at once on your first pass.

---

## Brute Force First, Always

Even though Insert Interval has elegant solutions, the coach is OK with starting with the worst-performing brute force as long as it works:

> "If your brute force solution that gets all the test cases passing is the worst performance, both time and space — through the charts awful — I could care less as long as it passes all the test cases. The next step is coming back and saying, 'How can I make that better?'"


---

# Mock Interview — Contains Duplicate (2025-07-27b)

Sunday session: pseudo code walkthrough of LeetCode's **Contains Duplicate** (easy). New rule going forward: **mock interviews will be pseudo-code only — no coding** until further notice.

---

## Q&A

### Ice Cream Parlor felt harder than "easy"

Rebecca timed herself reading the Ice Cream Parlor problem and it took 15 minutes just to digest it — and the goal for an easy problem in the interview is to **finish in 15 minutes**.

- The coach agreed — Ice Cream Parlor is borderline medium even though HackerRank labels it easy.
- This is the same problem as Two Sum, just dressed up with new framing.
- Spending 15 minutes reading + 5 pseudo code + 10–15 coding is a totally fine pace when you're just starting out.
- Important: did you understand it by the end of those 15 minutes? If yes, you're on the right path even if it took longer than the official time limit.

---

## New Mock Interview Format

> "I want to remove the barrier of jumping into code. We all have this tendency to just dive into the editor. For mock interviews going forward, I want everyone to focus exclusively on **pseudo code only** — no real code at all."

### What this means

- Read and digest the problem.
- Pull out what we can — observations, assumptions, constraints.
- Write pseudo code: explain the problem, present your understanding, lay out steps.
- **Stop** at the point where you would normally start writing code.

### Why

- Practice the underused skill of decomposing problems before coding.
- Avoid the trap of "I'm in code now, I have to make this work."
- Improve presentation and explanation skills.

---

## Problem: Contains Duplicate

Given an integer array `nums`, return `True` if any value appears at least twice, `False` if all elements are distinct.

### Examples

- `[1, 2, 3, 1]` → `True` (1 appears at indices 0 and 3)
- `[1, 2, 3, 4]` → `False` (all distinct)
- `[1, 1, 1, 3, 3, 4, 3, 2, 4, 2]` → `True` (multiple repeats)

### Constraints

- `nums.length`: 1 to 10⁵ (100,000)
- Values: -10⁹ to 10⁹

---

## Pulling From the Problem

- **Input:** integer array.
- **Goal:** find the **frequency** of any given number in the array.
- **Return:** `True` if any number repeats, `False` if all numbers are unique.
- We don't need to return indices, counts, or which number is duplicated — just a boolean.

---

## Approach 1: Loop With Count (Brian's idea)

```python
for i in range(len(nums)):
    if nums.count(nums[i]) > 1:
        return True
return False
```

### How it works

- For each value in the array, count how many times it appears in the full array.
- If the count is greater than 1, return `True` immediately.
- After the loop, if no duplicates were found, return `False`.

### Big-O

- **Time:** O(n²) — `list.count(x)` is O(n), and we call it n times.
- **Space:** O(1)

### Tradeoff

Simple, easy to write, but inefficient. Brute force.

---

## Approach 2: Set / Hashmap (the optimal answer)

The classic solution to this kind of problem is to use a **set** to track values seen so far.

```python
seen = set()
for num in nums:
    if num in seen:
        return True
    seen.add(num)
return False
```

- **Time:** O(n) — single pass; set lookup and insert are O(1).
- **Space:** O(n) — the set can grow up to n elements.

Even simpler:

```python
return len(set(nums)) != len(nums)
```

If the set version of the array has fewer elements than the original, there were duplicates.

---

## Why This Problem Is Easy

- One condition to check.
- One pass through the data is sufficient with the right data structure.
- The optimal solution is just a few lines.

The challenge for someone new to LeetCode is **knowing the set/hashmap pattern**. Once you've seen it once, it's reusable across many problems.

---

## What To Practice

> "Today's mock interview is going to focus on this exact same skill: read the problem, pull out what you can, write some pseudo code, present your understanding, and stop there. No coding. Just the thinking part."

[REVIEW: this transcript ends mid-discussion at line 268, so the actual mock interview portion is not included. The session continues in `Ruby_MockInterview_2025-07-27c.txt`.]


---

# Mock Interview — Top K Frequent Elements (2025-07-27c)

Continuation of the Sunday session. After Contains Duplicate, the group does a pseudo-code-only mock interview on **Top K Frequent Elements** (medium). Volunteer: Rebecca.

---

## Contains Duplicate — Final Approaches Discussed

Three different approaches surfaced for the warm-up problem:

### Approach 1: Nested Loop with Count

```python
for i in range(len(nums)):
    if nums.count(nums[i]) > 1:
        return True
return False
```

- **Time:** O(n²)
- Brute force, simple to write.

### Approach 2: Hashmap / Set (Mindy's suggestion)

```python
seen = set()
for num in nums:
    if num in seen:
        return True
    seen.add(num)
return False
```

- **Time:** O(n)
- **Space:** O(n)
- **Optimal.** Single loop, set lookup is O(1).

### Approach 3: Sort + Adjacent Comparison

```python
nums.sort()
for i in range(len(nums) - 1):
    if nums[i] == nums[i + 1]:
        return True
return False
```

- **Time:** O(n log n) — dominated by the sort.
- **Space:** O(1) (or O(n) depending on the sort's implementation).
- Worse than the hashmap, but better than brute force.

### Big-O comparison

- Brute force: O(n²) ❌
- Sort + check: O(n log n) ⚠️
- Hashmap: O(n) ✅

### A note on "shortcutting" by digit range

One participant suggested: "Since digits 0-9 are limited, can we exploit that?" The coach pointed out: **values can be -10⁹ to 10⁹**, so this isn't a finite digit set. The example uses small numbers, but the constraints allow much larger values. Always check the constraints before assuming a shortcut.

---

## Problem 2: Top K Frequent Elements (Medium)

### Problem statement

Given an integer array `nums` and an integer `k`, return the **k most frequent elements**. You may return the answer in any order.

### Examples

- `nums = [1, 1, 1, 2, 2, 3]`, `k = 2` → `[1, 2]`
- `nums = [1]`, `k = 1` → `[1]`

### Critical clarification (Rebecca initially missed)

`k` is **not** how many numbers are duplicated. `k` is the **count of the most frequent values you should return**.

- `k = 2` means "return the 2 most frequent values."
- For `[1, 1, 1, 2, 2, 3]`: 1 appears 3 times, 2 appears 2 times, 3 appears once. The top 2 most frequent are 1 and 2.
- Rebecca initially thought `k = 2` meant "two values appeared more than once," which would be a totally different problem.

### Walking through a harder example

If the input were `[1, 1, 1, 2, 2, 3, 4, 4, 4, 4, 4]` with `k = 2`:

- Frequencies: `{1: 3, 2: 2, 3: 1, 4: 5}`
- Top 2 most frequent: **4 and 1** (4 has 5 occurrences, 1 has 3).
- Output: `[1, 4]` or `[4, 1]` (order doesn't matter).

> The key word is **frequency**, not **value**. Sort the unique values by their frequency, then take the top k.

---

## Rebecca's Pseudo Code Approach

### Step 1: Restate the problem in your own words

```
nums = array of integers
k = how many of the most frequent numbers to return
output = the k values that occur most often
```

### Step 2: Identify the data structure

- Build a **dictionary (hashmap)** mapping each unique value to its frequency count.
- Iterate through `nums`, increment the count for each value in the dictionary.

### Step 3: Find the top k

- After building the frequency dictionary, find the k entries with the highest counts.
- Return those k keys.

### Step 4: Pseudo code

```
loop through nums to find duplicate numbers
create dictionary
when you find a duplicate, increment count in dictionary
loop through dictionary to find the k highest counts
return those k values
```

This is exactly the right shape for the optimal solution. The remaining work is just translating it to actual Python.

---

## Implementing Top K Frequent (next steps for Rebecca)

### Step 1: Build the frequency dictionary

```python
from collections import Counter
freq = Counter(nums)  # or build manually with a dict
```

### Step 2: Sort or select the top k

Several Python options:

- `sorted(freq, key=freq.get, reverse=True)[:k]`
- `freq.most_common(k)` — returns list of `(value, count)` tuples
- Heap-based approach for O(n log k) instead of O(n log n)

### Big-O for the optimal hashmap + sort approach

- **Time:** O(n log n) (the sort dominates)
- **Space:** O(n) (the dictionary)

A heap-based approach can get this down to O(n log k), which matters when k is much smaller than n.

---

## The New Mock Interview Format Worked

> Mindy: "I think this was a really effective session."
>
> Coach: "I agree. Thank you for the suggestion, Mindy."

### Why pseudo-code-only is better (for now)

- **Removes the freeze-up trap.** Rebecca admitted she "couldn't even think of the word 'loop' for a minute" when put on the spot. Without the pressure of code, she could keep thinking.
- **Builds the planning muscle** that students under-practice.
- **Builds presentation confidence** without the secondary pressure of syntax errors.
- Once participants are confident at this level, they can graduate to coding mock interviews.

### Rebecca's success

Even though she froze briefly, she:

- Restated the problem in her own words.
- Realized her initial assumption about `k` was wrong (with a hint).
- Pivoted her approach from "just find duplicates" to "count frequencies and return top k."
- Identified a dictionary as the right data structure.
- Outlined the next steps clearly.

That's exactly what a good interviewer wants to see — adaptability and clear thinking under pressure.

---

## Q&A: Test Plan + Print Statements in the Real Interview

**Q:** "For the technical interview, do I still need to print things out and write a plan first?"

**A:** Not required, but **highly recommended**.

- Following your steps as you practice builds the muscle so it becomes natural.
- Print statements save more time than they cost — you catch bugs immediately instead of after writing 30 lines.
- The 15–20 minute time limit feels short, but if you've been practicing the full process, you'll fit within it.

**Q:** "It took me 15 minutes just to read an easy problem. Will I get faster?"

**A:** Yes, but reading time also depends on the problem itself. Some problems are intentionally tricky and confusing — no amount of practice makes them faster to digest. What you can practice is **pulling out actionable information** quickly: what's the input, what's the output, what are the constraints, what's the goal in one sentence.

> "If they want to make it tricky and confusing, it's going to be tricky and confusing. There's no amount of practice that can make the problem itself easier to digest."

---

## Recap: 15-Minute Interview Time

- Joy of Coding tech interview: **15–20 minutes** for one easy HackerRank problem.
- Practice within that window, but don't sacrifice quality steps to chase speed.
- Speed comes from **practiced steps**, not from rushing.


---

# Ruby Mock Interview — August 3, 2025

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


---

# Ruby Mock Interview — August 10, 2025

*Nailing the Tech Interview — Sunday session*

## HackerRank Certifications: Worth It?

Extended discussion on whether HackerRank certifications are worth pursuing.

### TLDR

- **Most interviewers and companies don't pay much attention to them.**
- They're **fun** and don't hurt to have on a resume or LinkedIn, but they rarely move the needle.
- For **development roles** there is no real equivalent to, say, PMP certification in project management.

> "I don't think companies really care about them too much. Not having them won't hurt you."

### Available HackerRank certification tracks

- **Software Engineer Intern** — Problem Solving + SQL.
- **Software Engineer** — Problem Solving + SQL + REST API.
- **Frontend Developer (React)** — 1–2 multiple choice + 2 mini project-based questions.
- **Frontend Developer (Angular)** — similar format.
- **JavaScript** — Basic, Intermediate (Advanced cert isn't actually offered even though it shows in the dropdown).
- **Python** — Basic, Intermediate.
- **Problem Solving** — Basic, Intermediate, Advanced.
- **PowerShell**, **Selenium**, **Tech Communication**, etc.

### What the Problem Solving levels correspond to

- **Basic** — roughly easy-level HackerRank problems.
- **Intermediate** — hashmaps, stacks, queues, Dijkstra, optimal solutions (medium level).
- **Advanced** — trees, graph traversal, shortest path, dynamic programming (hard level).

### Python intermediate cert topic list

- Closures, decorators
- Advanced object-oriented programming
- Collections, exceptions, context managers
- Regular expressions
- Concurrent programming
- File operations, unit testing, logging, deployment

> "That would basically be like a really good summary of everything you learn in mod 2, scaled into one certification. I imagine it might be kind of tricky to do within an hour."

### When certifications *might* help

- If you've worked in a niche area (e.g., **Selenium** for QA automation) and are applying for a role that specifically asks for that skill, the cert might give a slight edge.
- If everything else is equal between two candidates, certs could tip the scales.

> "I'm a certified data scientist, but companies do not really pay attention to that." — Brian

---

## Q&A: Practicing for Certification Exams

**Mina asked** about sites where you can pay a membership and take mock certification exams repeatedly until the real exam.

- HackerRank has mock exam content in its practice sections.
- Look at the **subskill breakdown** of a target certification (e.g., Software Engineer cert includes Problem Solving, SQL, communication) and practice each subskill individually.

---

## Tech Interview Structure (Joy of Coding)

- Joy of Coding's technical interview uses **HackerRank only**, not LeetCode.
- HackerRank problems at **easy level** give you all the info you need. LeetCode intentionally leaves info out, forcing more assumption-checking — good practice, but harder.
- **Readiness signal:** You can solve roughly **3 easy problems in a row under a 20-minute time limit**.
- The **Problem Solving track** on HackerRank covers everything from Joy of Coding mods 1 and 2.

### Topics that may appear on the tech interview

- Arrays and lists
- Dictionaries
- Searching and sorting
- Linked lists
- Stacks and queues
- Hashmaps
- Sliding window / basic algorithms
- (File I/O is listed in mod 2 but will **not** be tested.)

### Recommended readiness benchmark

Complete mod 2 through **projects 2 or 3**, then you're ready to try a mock interview.

---

## Mock Interview: Jumping on the Clouds (Lisa)

Lisa volunteered for a pseudo-code mock interview on the HackerRank **Jumping on the Clouds** problem.

### Problem summary

You're given an array of 0s and 1s representing clouds:

- `0` = safe (cumulus)
- `1` = unsafe (thundercloud)

Starting at index 0, you can jump **+1 or +2** each move. Find the **minimum number of jumps** to reach the last index.

### Constraints

- `2 <= n <= 100` where `n` is the array length
- `c[i]` is `0` or `1`
- `c[0] == 0` and `c[n-1] == 0` — **first and last are always safe**
- It is always possible to win the game

### Key insight from the constraints

> "It is always possible to win the game."

Because the starting and ending positions are always `0`, and you can always jump `+1` or `+2` from any safe cell, **you never need to track history or backtrack**. No edge case where "I jumped two before, now I'm stuck."

### Assumptions you can safely make

- First index is always `0` (safe).
- Last index is always `0` (safe) — you'll always land on it.
- Minimum array length is 2, so at least one jump is possible.

### Game plan (pseudo code)

```
# Given: c = array of 0s and 1s, starting at index 0
# Return: minimum jumps to reach the last index

i = 0
steps = 0
while i < len(c) - 1:
    # Prefer the +2 jump (fewer total jumps)
    if i + 2 < len(c) and c[i + 2] == 0:
        i += 2
    else:
        i += 1
    steps += 1
return steps
```

### Coaching feedback for Lisa

- **"Least number of jumps" implies a preference** for the `+2` jump whenever it's safe and in range. Always check the `+2` option first, then fall back to `+1`.
- When your index progression is **not fixed** (jumping 1 or 2), a **`while` loop** is usually cleaner than `for i in range(...)`. You can technically manipulate `i` inside a for loop, but it hurts readability.
- Watch for **out-of-range errors** when checking `i + 2` — guard with `i + 2 < len(c)`.
- Good job summarizing the problem in your own words and pulling out constraints before coding.

> "I like that re-summarization of the problem — it makes it easier to say 'all right, you're given an array of 0 or 1, you can land on a zero, one is not safe, and we want the least amount of jumps.'"

### How to classify this problem

- **Not** a specific algorithmic pattern — no sliding window, no DP trick, no formula.
- Just **linear iteration with index manipulation**. Straightforward loop + conditionals.
- Classified as early mod 1 / mod 2 fundamentals. Index manipulation, iterating a list, loop mechanics.

---

## Closing Notes

- Ruby is **running thin on new problems** to pose, since the group has covered arrays, dictionaries, searching/sorting, linked lists, stacks, queues, hashmaps, and sliding window extensively.
- Going forward, Sundays will focus more on **mock interviews** rather than lengthy explanation segments, to conserve problems.
- **Trees** are the one major data structure not yet covered. They're outside the Joy of Coding scope, but Ruby may introduce them if time permits.
- Brian will plan to do a mock interview **next week**.

---

## Key Takeaways

- **HackerRank certifications are mostly for fun** — they rarely affect hiring decisions for dev roles.
- **HackerRank > LeetCode at easy level** for tech interview prep because HackerRank includes all necessary context.
- Readiness benchmark: **3 easy problems solved in 20 minutes each, in a row**.
- **Read the constraints first.** Phrases like "it is always possible to win" eliminate whole categories of edge cases.
- For problems with variable step size (jumping 1 or 2), **prefer `while` over `for i in range`** — cleaner index control.
- **"Least jumps" = prefer the bigger step** when it's safe and in range.
- Always resummarize the problem in your own words before jumping into code.


---

# Ruby Mock Interview — August 24, 2025

*Nailing the Tech Interview — Sunday session*

## Q&A: The Low-Code Internship

A student asked about the **low-code internship** option at Joy of Coding.

- Created by Sam (former student turned coach) who had experience building and managing **WordPress** sites for clients.
- Called "low-code" because WordPress site creation requires **a lot of domain and technical experience** but not deep full-stack coding.
- Aimed at people who:
  - Made it to the **Explorer** phase or past **mod 2** and want to start earning while still learning, OR
  - Find full-stack coding too difficult but want to stay in the web/tech domain.
- Currently has one active project (the **Inclusive IQ** project), near completion.
- Future of the program is **in flux** — may or may not be permanent going forward.

---

## Q&A: Problems That Require Outside Research (Magic Square)

**Mauricio** worked on the **Magic Square** medium problem and discovered that solving it optimally requires knowing specific domain knowledge that isn't in the problem statement.

### What he found

- A 3x3 magic square has rows, columns, and diagonals all summing to **15**.
- There are **only 8 possible 3x3 magic squares** in total.
- The only way to guarantee a minimum-cost transformation is to **compare against all 8** magic squares, either by hardcoding them or generating all permutations of 1–9 and filtering.
- Attempts to build a general algorithm without this knowledge led to spaghetti code with no guarantee of finding the minimum.

### Coaching response

- **Medium and hard problems sometimes require specific prior knowledge** — popular algorithms, math theorems, well-known patterns.
- This is more common at **FAANG-level interviews** (Google, Amazon, Facebook) than at typical job-hunt interviews.
- Most problems you'll face **can be worked through to *a* solution** (even if not the most efficient) without specific foreknowledge.
- **You will NOT see this kind of research-gated problem in the Joy of Coding technical interview.**
- The **Blind 75 LeetCode list** has some of these harder patterns — worth knowing because they're popular enough that background is readily available.

> "What value would there be in interviewing a candidate to try and stump them? It doesn't make a lot of sense. That's not going to be the vast majority of situations you run into."

### Can you research during an interview?

- Generally **no** — looking up an approach during an interview counts as looking up the solution.
- Mauricio learned the relevant constraint *through research after the fact*, which is fine for learning but wouldn't be allowed live.

---

## Problem Walkthrough: Best Time to Buy and Sell Stock

Easy-level problem from LeetCode.

### Problem statement

Given an array `prices` where `prices[i]` is the stock price on day `i`, pick a **single day to buy** and a **different day in the future to sell** to maximize profit. Return the maximum profit, or `0` if no profit is possible.

### Examples

```
prices = [7, 1, 5, 3, 6, 4]  ->  5  (buy on day 2 at 1, sell on day 5 at 6)
prices = [7, 6, 4, 3, 1]     ->  0  (monotonically decreasing, no profit)
```

**Key constraint:** You **cannot sell before you buy** — no time machine.

### Restating the problem

> "Find the greatest difference between any two indices `i` and `j` where `i < j` and `prices[i] < prices[j]`."

Or in plain language: "Find the **lowest** I can buy, and the **highest** I can sell after that index."

### Two subproblems

1. Find two indices satisfying `i < j`.
2. Among those, find the pair with the **greatest difference**.

---

### Approach 1: Brute Force — O(n²)

**Mauricio's idea:** Nested loop. Outer loop over each starting index `i`; inner loop over `j` from `i + 1` to the end. Track the max profit seen.

```python
def maxProfit(prices):
    max_profit = 0
    for i in range(len(prices)):
        for j in range(i + 1, len(prices)):
            if prices[j] - prices[i] > max_profit:
                max_profit = prices[j] - prices[i]
    return max_profit
```

- **Time:** O(n²)
- **Space:** O(1)

> "Always work towards getting a working solution first, then think about how to improve it."

---

### Approach 2: Track Minimum Price in a Single Pass — O(n)

**Mindy's solution** (she had solved it before and been practicing).

Core idea: track the **minimum price seen so far** as you iterate, and at each step compute the current price minus that minimum as the candidate profit.

```python
def maxProfit(prices):
    if len(prices) < 2:
        return 0
    min_price = 10001            # higher than any possible price in constraints
    best_diff = 0
    for p in prices:
        min_price = p if p < min_price else min_price
        diff = p - min_price
        best_diff = diff if diff > best_diff else best_diff
    return best_diff
```

- **Time:** O(n)
- **Space:** O(1)

### Why initialize `min_price` to something huge?

Counterintuitive but necessary: we need a sentinel value **higher than any possible input** so the very first real price always replaces it. The problem constraints say prices go up to `10^4`, so `10001` or `float('inf')` both work.

### Walking through the algorithm on `[7, 1, 5, 3, 6, 4]`

| p | min_price | diff = p - min_price | best_diff |
|---|-----------|----------------------|-----------|
| 7 | 7         | 0                    | 0         |
| 1 | 1         | 0                    | 0         |
| 5 | 1         | 4                    | 4         |
| 3 | 1         | 2                    | 4         |
| 6 | 1         | 5                    | 5         |
| 4 | 1         | 3                    | 5         |

Return **5**. Correct.

### Why this works even when the global min doesn't give the best profit

Ruby tried to break the algorithm by constructing arrays like `[3, 2, 1, 5, 6, ...]` where the global minimum appears mid-array. It still works because **`min_price` is updated *before* the difference is computed** at each step. By the time you reach a potential sell price, `min_price` holds the minimum *up to that point* — which is exactly what you need (you can only sell after you buy).

> "That's pretty sleek. And that's why we set those values outside of the loop first, so that we have something to compare against."

### Style feedback

- Very Pythonic — three lines inside a `for` loop. Concise.
- Ternary-style assignment (`x = a if cond else b`) is idiomatic, but for readability some would prefer a plain `if` statement:

```python
if p < min_price:
    min_price = p
```

> "Pythonic ways favor one-liners, but it's more human-friendly to break it out as a usual if statement."

---

### Approach 3: Sliding Window / Two Pointers (Attempted)

Ruby tried a **two-pointer / sliding window** approach working from both ends inward:

```python
start = 0
end = len(prices) - 1
while start < end:
    diff = prices[end] - prices[start]
    best_diff = diff if diff > best_diff else best_diff
    if prices[start] > prices[end]:
        start += 1
    else:
        end -= 1
```

- Worked on some test cases, **failed on others**.
- Ran out of time debugging.
- Ruby's initial implementation confused index vs. value in the comparison (`if start > end` should be `if prices[start] > prices[end]`).

### Takeaway on sliding window here

- Same O(n) complexity as the min-tracking approach.
- Doesn't obviously improve over it.
- The min-tracking approach is already optimal for this problem — you can't do better than O(n) because you must examine every price at least once.

---

## Key Takeaways

- **Start with brute force** to get *a* working solution, then optimize. Do not stall trying to find the perfect solution first.
- **Single-pass "running minimum/maximum"** is a key pattern for array problems that ask about pairs with constraints like `i < j`.
- **Initialize sentinel values outside the bounds** of the input data (`float('inf')`, `float('-inf')`, or values beyond the constraint limits).
- **Update state *before* computing derived values** in a single pass — this is why `min_price` must be updated before computing `diff`.
- **Well-named variables** (`min_price`, `best_diff`, `diff`) make code self-documenting.
- **Python one-liners vs. readability:** concise is idiomatic, but readable wins when reviewing.
- **O(n) is optimal** for problems where you must examine each element at least once — don't waste time looking for O(log n) that doesn't exist.
- **Research during an interview is not allowed.** Problems requiring deep prior knowledge are rare outside FAANG-level interviews and will not appear in Joy of Coding's technical interview.


---

# Ruby Mock Interview — August 31, 2025

*Nailing the Tech Interview — Sunday session*

## Q&A: When Are You Ready for the Technical Interview?

### The "three in a row" guideline

- General benchmark: solve **3 easy problems consecutively within 15–20 minutes each**, closer to **15 minutes** being the stronger signal.
- Also make sure you're getting practice with **medium problems**.
- "Three in a row" doesn't mean three at a single sitting — it means a consistent streak however you practice (one per day, multiple per week, etc.).

> "It's a good indicator that you *might* be ready. It's hard to say whether someone's ready until they actually take it."

### Extra practice before signing up

- **Peer mentor office hours** are a good place to get additional timed practice with feedback before the real interview.
- You can sign up for the real technical interview at any time, then use peer mentor sessions as warm-ups before your scheduled slot.
- Rebecca runs peer mentor office hours Mondays 9–10 AM and will either work through a problem the student brings or pick one together.

### Why aim for 15 minutes if 20 passes?

- Nerves and pressure during the real interview slow people down.
- A 15-minute self-pace leaves buffer for interview pressure.

### What happens if you fail the technical interview?

- You won't be permanently denied.
- After a failed attempt, Ruby will:
  1. Discuss your performance.
  2. Ask follow-up questions.
  3. Make **specific recommendations** (mod 1/2 concept review, problem-solving tips, etc.).
- Once you've worked through those recommendations and are still consistently hitting the 15–20 minute benchmark, you can schedule again.

### Handling "curveball" problems you get stuck on

- It's okay to hit a curveball occasionally and still sign up.
- When stuck past 20 minutes: **don't immediately look up the solution**. Instead:
  1. Come back on a different day and try fresh.
  2. If still stuck, research the approach, then walk through the solution **line by line** to understand the reasoning.
  3. Give it a few days, then try again from memory without looking at the solution.
- **Don't stick with a broken path for hours.** That's counterproductive.

> "When I find myself coding just to pass the next test and not generalizing the problem, I feel like I'm going down the wrong rabbit hole."

### The "too many if conditions" smell

- One or two (maybe three) `if` conditions is normal — even binary search has about three.
- If you're piling on `if` conditions **to catch specific edge cases one by one**, that's a signal to stop and think of a more **general** approach.
- Mauricio: "That's when I know I'm not generalizing enough."

---

## Breakout Room Experiment: Pseudo Code for "Can Place Flowers"

Ruby ran an experiment using Zoom breakout rooms. Everyone got 10 minutes alone with the problem to produce **pseudo code only** — no real coding unless you finished pseudo code early.

### Problem: Can Place Flowers (LeetCode easy)

> Given an integer array `flowerbed` containing 0s and 1s (0 = empty, 1 = planted), and an integer `n`, return `true` if you can plant `n` new flowers **without any two adjacent flowers**.

### Examples

```
flowerbed = [1,0,0,0,1], n = 1  ->  true
flowerbed = [1,0,0,0,1], n = 2  ->  false
```

### Constraints

- `1 <= flowerbed.length <= 2 * 10^4`
- `flowerbed[i]` is `0` or `1`
- **There are no adjacent flowers in `flowerbed`** — the input will never violate the rule itself.
- `0 <= n <= flowerbed.length`

### Clarification on `n`

- Normally in LeetCode constraints, `n` refers to the **length of the array**.
- **In this problem**, `n` is a separate input variable — the number of flowers you want to plant. Always read the problem statement to confirm.

### Key assumption pulled from constraints

Because the input is guaranteed to follow the no-adjacent rule, you don't need to defend against malformed input. You can trust that if you check "current spot is 0 and neighbors are 0," you'll be safe.

---

## Mauricio's Pseudo Code

Written **above** the function (clean style, like a docstring):

```
# Traverse the flowerbed array
# Identify zeros with zeros on both sides (available spots)
# Edge cases:
#   - First index: only check i + 1
#   - Last index: only check i - 1
# Count occurrences of plantable spots
# Return true if count >= n, else false
```

Partial code attempt (cut short by breakout room disconnect):

```python
for i in range(len(flowerbed)):
    if flowerbed[i] == 0 and flowerbed[i + 1] == 0:
        count += 1
    # handling for length - 1 edge case
```

---

## Ruby's Pseudo Code

Written **in the function** using countdown-style logic:

```
# Given: list of "plots" (0 = empty, 1 = planted)
# Given: n = number of spots we need to plant
# If a spot equals 1, cannot plant at index-1 or index+1 either
# Assumption: the test cases will not violate the no-adjacent rule

# Use n as a countdown — every time we plant, n -= 1
# Iterate through flowerbed one at a time
# Check either side for flowers
# If spot is 0 AND left neighbor is 0 AND right neighbor is 0:
#   plant here (set flowerbed[i] = 1, n -= 1)
# After one iteration:
#   if n <= 0: return true
#   else: return false
# Big O: O(N)
```

### Why iterate only once?

- The problem is **linear** — each spot only depends on its immediate neighbors.
- No need for nested loops or backtracking.
- **O(n)** is the floor because you must look at each plot at least once.

---

## Coaching Feedback

### On writing pseudo code above vs. inside the function

- **Above the function:** cleaner, matches real-world docstring style.
- **Inside the function:** kept closer to where the logic lives, good for interview flow.
- In production, you'd never have pseudo code inside a function — but in an interview, either works.

### Always include the return condition in pseudo code

Ruby initially didn't see a return condition in Mauricio's pseudo code and flagged it — it turned out he'd written it, just phrased differently ("return true if count >= n"). **Always make the return statement explicit.**

### The three parts of a technical interview performance

1. **Read and understand the problem** (~20% of evaluation)
2. **Resummarize and pseudo code** (~20% of evaluation)
3. **Code a working solution that passes all test cases** (~60% of evaluation)

> "You can come up with a solution that passes all the test cases, but if you can't explain what you did or why, that's not going to show you work well with a team."

The first two matter for interviewer impressions because they show:

- Problem decomposition skills
- Clear communication
- Ability to think out loud
- Team/pair-programming readiness

---

## Key Takeaways

- **Readiness benchmark:** 3 consecutive easy problems solved in ~15 minutes each, plus exposure to mediums.
- **Don't reset to zero after a failure** — you'll get specific recommendations and can try again after addressing them.
- **Step away from problems you've been stuck on for more than ~20 minutes.** Coming back fresh beats brute-forcing for hours.
- **Too many if-conditions is a code smell** — generalize your approach instead of patching edge cases.
- Read problem statements **twice**: first for rough understanding, second to confirm assumptions and constraints.
- **Always write the return statement** in pseudo code, even if the logic is simple.
- **Trust the constraints.** "No adjacent flowers in input" saves you from defensive edge cases.
- **Interviewers evaluate communication as well as code.** Think out loud, resummarize the problem, explain tradeoffs.


---

# Ruby Mock Interview — September 7, 2025

*Nailing the Tech Interview — Sunday session*

## Q&A: Not Every Practice Session Has to Hit the Time Target

- It's okay if you don't hit the 15–20 minute target every single time.
- What matters is that **on average** you consistently hit it.
- Even simple-looking problems can stump you on first read — everyone has that experience.

> "Sometimes you take the wrong path to the solution that gets you tangled in a mess that ends up consuming lots of time." — Mauricio

### When to scrap and restart

- If you've gone down a bad path, **it's always okay to scratch it and start from scratch**.
- Often starting over is *faster* than trying to rescue a tangled approach.
- You can still hit the time goal even after restarting.

---

## Warm-Up Problem: Array Partition I (LeetCode easy)

### Problem statement

Given an integer array `nums` of `2n` integers, group them into `n` pairs `(a1, b1), (a2, b2), ...` such that the sum of `min(ai, bi)` for all `i` is **maximized**. Return the maximized sum.

### Examples

```
nums = [1, 4, 3, 2]     -> 4
  Pair: (1, 2), (3, 4) -> min(1,2) + min(3,4) = 1 + 3 = 4

nums = [6, 2, 6, 5, 1, 2] -> 9
  Pair: (1, 2), (2, 5), (6, 6) -> 1 + 2 + 6 = 9
```

### Constraints

- `1 <= n <= 10^4`
- `nums.length == 2 * n` — **always even length**
- `-10^4 <= nums[i] <= 10^4` — **can be negative**

### Problem restated

> "Find the best combination of pairs so that the sum of the min of each two-value pair provides the highest output."

### Key phrase: "all possible pairings"

This phrase in the explanation suggests brute force is possible, but it's actually **two levels of brute force**:

1. Generate all possible pairings of elements.
2. For each pairing, compute the sum of mins.

This explodes to factorial complexity very quickly.

### A partial optimization idea

- Greedily find the best pair first (highest possible min), remove those two elements, then repeat on the remaining set.
- Gets you closer to O(n²) rather than O(n!).
- **Not discussed yet:** the actually-optimal solution, which is to **sort and take every other element**. This is covered in the Wednesday deep-dive.

### Coaching note

This is marked "easy" on LeetCode, but easy problems vary in difficulty. If a particular easy stumps you, don't panic — it happens.

---

## Mock Interview: Mauricio on "Minimum Number of Arrows to Burst Balloons"

### Problem statement

You're given a 2D wall with balloons. Each balloon is represented as `[xstart, xend]` (its horizontal diameter). You can shoot arrows vertically from the x-axis that travel infinitely upward, popping all balloons they pass through.

**Return the minimum number of arrows needed to burst all balloons.**

### Constraint quirk

One constraint Mauricio found confusing: `points[i].length == 2`. This just means each balloon is a 2-element sub-array (2D array with inner length 2), not a constraint on the outer array length.

> "Ah, it means it has two elements. I'm kind of slow today."

The other constraints:

- `1 <= points.length <= 10^5`
- `-2^31 <= xstart < xend <= 2^31 - 1` — values can be **negative**

### Mauricio's game plan

- **Find intersections** between balloon diameters.
- One arrow can pop multiple balloons if their x-ranges overlap.
- Compare each balloon against the others to find overlapping groups, then count how many distinct groups you need.
- Acknowledged this is **O(n²)** nested-loop brute force — he wanted to get an idea down fast rather than find an optimal approach.

### Partial pseudo code

```
# For each balloon, compare its [xstart, xend] against every other balloon
# If xstart1 <= xend2 AND xstart2 <= xend1: they intersect
# Track groups of overlapping balloons
# Count distinct arrows needed = number of groups

start1 = points[i][0]
end1 = points[i][1]
start2 = points[j][0]
end2 = points[j][1]
# check intersection
```

### Coaching feedback

- Good job thinking it through clearly and picking a starting approach even knowing it wasn't optimal.
- Medium problems have a **40-minute to 1-hour** time budget. Spending 20–25 minutes on pseudo code still leaves ample time to code and debug.
- **Two-level brute force tends to balloon into complexity traps** — if you catch yourself saying "compare each with all others" without a tracking mechanism, pause and think about sorting first.

### The actually good approach (hinted)

- **Sort balloons by their end coordinate.**
- Walk through and greedily count: if the current balloon starts *after* the last arrow's position, shoot a new arrow at its end.
- O(n log n) from sorting, O(1) extra space. Covered in more depth on Wednesday.

---

## Group Breakout Session

Ruby split the group into pairs for 20 minutes on the Burst Balloons problem while Mauricio stayed in the main room for his mock interview.

### Group 1 — Chris (solo, possibly muted the whole time)

Chris attempted to code a solution iterating `for i in range(len(points))`, treating each `points[i]` as `[start, end]`, and tracking arrows.

**Bugs/syntax issues found:**

- Used `i` before declaring it properly (`point.Z` typo for `points[i]`).
- Didn't account for the **negative coordinate range** in the constraints (`-2^31`). Coming from a CAD/Revit background, he was used to coordinates starting at zero.

> "A lot of times with CAD blueprints, your coordinate system starts at zero. We don't ever think about going in the negative range." — Chris

Not a bad starting approach — just needs constraint awareness.

### Group 2 — Lisa and Rebecca

Worked on pseudo code only.

**Their approach:**

- Visualize balloons on a horizontal x-axis at different positions.
- Shooting an arrow vertically can pop multiple balloons if their x-ranges overlap.
- **Overlap check:** if `min(balloon1.end, balloon2.end) >= max(balloon1.start, balloon2.start)`, they overlap.
- Considered **sorting the points** to make the comparison easier.
- Planned a `for` loop through each balloon with `if` statements checking overlap, then a counter for arrows needed.

### Rebecca's confusion with nested arrays

Rebecca understood the problem visually but wasn't sure **how to "tell the computer"** to compare the minimum of one inner array against the maximum of the next.

**Ruby's recommendation:**

- Review the **two-dimensional arrays** section in mod 2.
- The mental framework for accessing nested values (`points[i][0]`, `points[i][1]`) is the missing piece, not the logic.

> "The first part is getting the mental framework around it, then the second part is getting the coding framework around it."

---

## On Going Back Through Old Material

Rebecca asked whether she should redo all of mod 2.

- Going back through mod 1 or mod 2 is **not horrible**, but usually not necessary.
- **The second time through is much faster** — you absorb new nuggets you missed the first time.
- Better strategy: when you see a problem, identify the concept it's testing, and revisit just that section.

> "Dr. Emily really knows what she's talking about — who would have thought?" — Mindy, rewatching mod 2 videos

---

## Time Targets Recap

| Difficulty | Target time |
|------------|-------------|
| Easy       | 15–20 minutes |
| Medium     | 40 minutes to 1 hour |

- Array Partition I → easy → 15–20 minute target
- Minimum Arrows to Burst Balloons → medium → 40–60 minute target

Consistently hitting easy targets is the main readiness signal. Medium problems are for stretching and exposure, not for the readiness benchmark.

---

## Key Takeaways

- **Consistency matters more than every-time perfection.** Hit the time target on average, not always.
- **Start over when stuck.** A fresh attempt is often faster than debugging a tangled approach.
- **"All possible pairings" is a brute force red flag** — look for sort-based or greedy optimizations.
- **Pseudo code first, code second**, especially on mediums where you have an hour budget.
- **Check constraint ranges** for negative values and unusual bounds (`-2^31`, `10^5`, etc.) before coding.
- **Nested arrays** need the right mental model — practice `matrix[i][j]` access patterns in mod 2.
- **Review material on a second pass** is dramatically more efficient than the first.
- **O(n²) brute force is fine as a starting point.** Get something working, then think about optimizing.


---

# Ruby Mock Interview — September 21, 2025

*Nailing the Tech Interview — Sunday session*

## Warm-Up: Valid Anagram (LeetCode easy)

### Problem statement

Given two strings `s` and `t`, return `true` if `t` is an **anagram** of `s`, else `false`.

> "An anagram is a word or phrase formed by rearranging the letters of a different word or phrase using all of the original letters exactly once."

**Key pull-out:** uses all the original letters **exactly once** — same letters, same counts.

### Examples

```
s = "anagram", t = "nagaram" -> true
s = "rat",     t = "car"     -> false
```

### Constraints

- `1 <= s.length, t.length <= 5 * 10^4`
- `s` and `t` consist of **lowercase English letters** only.
- **Follow-up:** what if the inputs contain Unicode characters?

### Reading comma-separated constraint lists

`1 <= s.length, t.length <= 5 * 10^4` is shorthand for two independent bounds — both strings are between 1 and `5 * 10^4`. It does **not** imply `s.length < t.length`. Contrast this with problems that use `<` explicitly between variables (e.g., last week's constraint showed ordering).

### Immediate easy check

```python
if len(s) != len(t):
    return False
```

Two anagrams must be the same length — fail fast on mismatched lengths.

---

## Solution Brainstorm (Multiple Approaches)

### Approach 1 — Sort both strings and compare

```python
return sorted(s) == sorted(t)
```

- **Time:** O(n log n) (sorting dominates)
- **Space:** O(n) for the sorted copies
- Chris's submitted runtime: beat only ~15% — works but slow.

### Approach 2 — Two dictionaries (count characters)

Build a frequency dictionary for each string and compare them.

```python
def isAnagram(s, t):
    if len(s) != len(t):
        return False
    count_s, count_t = {}, {}
    for i in range(len(s)):
        count_s[s[i]] = count_s.get(s[i], 0) + 1
        count_t[t[i]] = count_t.get(t[i], 0) + 1
    return count_s == count_t
```

- **Time:** O(n) to build dictionaries + O(n) to compare
- **Space:** O(n) for two dictionaries
- Comparing two dicts isn't O(1) — it's O(n) in the number of keys.

### Approach 3 — One dictionary, count up then count down (Kai's idea)

Loop over `s` and add counts. Loop over `t` and subtract. Remove keys when they hit zero. If the dictionary is empty at the end, they're anagrams.

```python
def isAnagram(s, t):
    if len(s) != len(t):
        return False
    count = {}
    for ch in s:
        count[ch] = count.get(ch, 0) + 1
    for ch in t:
        if ch not in count:
            return False
        count[ch] -= 1
        if count[ch] == 0:
            del count[ch]
    return len(count) == 0
```

- **Time:** O(n)
- **Space:** O(n) for **one** dictionary (better than Approach 2)
- **Best memory efficiency** of the bunch.

### Approach 4 — Mauricio's brute force using `count()`

```python
def isAnagram(s, t):
    for letter in t:
        if letter in s and s.count(letter) == t.count(letter):
            continue
        else:
            return False
    return True
```

- `letter in s` on a **string** is **O(n)** (not O(1) like dict/set lookup).
- `s.count(letter)` is also **O(n)**.
- Nested inside a loop over `t`, total is **O(n²)** in the average/best case, potentially worse.
- **Passed all test cases anyway**, in under 2 minutes of coding.

> "This is why I advocate for brute force. You came up with the solution, tried it, and it worked. That's awesome." — Ruby

### Efficiency summary

| Approach | Time | Space |
|----------|------|-------|
| Sort + compare | O(n log n) | O(n) |
| Two dictionaries | O(n) | O(n) |
| One dictionary (count up/down) | O(n) | O(n) (single dict) |
| `count()` brute force | O(n²) | O(1) |

---

## Coaching Debate: Brute Force First vs. Consider Alternatives

### Mauricio's take

> "I have the experience that burning out the time sometimes thinking about a sophisticated solution. So the method in your mind should be: just hit brute force, and if it doesn't work, go back to sophistication."

### Ruby's take (holding two slightly conflicting ideas)

- **Yes, brute force first** if it's the first thing that comes to mind and you can implement it quickly.
- **But also take 1–2 minutes** to consider an alternative before committing.
- Don't think about efficiency first — think about **which approach you can confidently implement without getting stuck on details**.
- Sometimes brute force is obvious and quick. Sometimes brute force for a particular problem is actually a messy multi-step nightmare, in which case a smarter approach is both faster to write *and* runs better.
- Having a **Plan B in the wings** costs very little and saves you if Plan A fails.

> "Don't be afraid of the brute force. If it's going to work, it's going to work. But also take a few minutes to consider alternatives — it's never a waste of time."

---

## Mock Interview: Mauricio on "Group Anagrams" (LeetCode medium)

### Problem statement

Given an array of strings `strs`, **group the anagrams together**. Return a list of lists.

### Constraints

- `1 <= strs.length <= 10^4`
- `0 <= strs[i].length <= 100`
- `strs[i]` consists of lowercase English letters.

### Mauricio's approach (under 15-minute time pressure)

Brute force: traverse the array, compare each string to the others, and group those that are anagrams. Considered using a dictionary keyed by **something anagram-identifying** (sorted string as key), with the value being a list of anagrams.

Partial pseudo code:

```python
def groupAnagrams(strs):
    groups = {}
    for i in range(len(strs)):
        # Compare strs[i] against all others
        # Use sorted string as the dictionary key
        # Append to groups[key]
    # Traverse dictionary by key and build output list of lists
    return output
```

### The bug in the first draft

Mauricio used the **length** of the string as the dictionary key, which would collide across non-anagram words of the same length (e.g., `"bat"` and `"nat"` would both key to `3` even though only `"nat"` and `"tan"` are anagrams).

**Fix:** key by the **sorted string** itself — e.g., `"".join(sorted("eat"))` = `"aet"` — so that all anagrams of the same word collide on the exact same key.

```python
def groupAnagrams(strs):
    groups = {}
    for s in strs:
        key = "".join(sorted(s))
        if key not in groups:
            groups[key] = []
        groups[key].append(s)
    return list(groups.values())
```

### Second bug: iteration variable naming

Mauricio wrote `for string in range(len(strings))`, which makes `string` an **integer index**, not a string object. Then his `string.sort` call would fail because integers don't have `.sort()`.

**Fix:** use subscript access: `strs[i].sort` → or better, iterate directly `for s in strs`.

### Coaching feedback

- **Great job breaking down the steps:** check anagram, group them, format output.
- **Add print statements along the way** when developing — catch index-vs-value confusion early.
- Don't expect everything to work on the first run. **Rewrite and debug is normal**, even in the real world.
- Mauricio already knew what he'd do next: replace the faulty length-based grouping with a proper list-of-lists append pattern.

> "Being under the hammer of time really hurts me." — Mauricio

### Practice recommendation

Use **peer mentors** for live-coding pressure practice:

> "Hey, can you just watch me? I need the peer review pressure of coding live. If you have feedback at the end, great. If not, that's fine — I just need the practice."

Ruby tells peer mentors to expect these requests.

---

## Closing Thoughts

### Why spend so much time on multiple approaches to an easy problem?

- It's a **thought experiment**. You don't have to catalog every possible solution on every real problem.
- But once you've solved a problem, it's valuable to **revisit and ask "what else could I have done?"**
- This builds a bigger toolkit for **medium problems**, where efficiency matters more and O(n²) often won't pass.

> "At the medium level, efficiency matters a lot more. An O(n²) solution probably isn't going to work there."

---

## Key Takeaways

- **Comma-separated constraints** (`1 <= s.length, t.length <= N`) describe independent bounds, not ordering.
- **Length mismatch is an instant false** for anagram problems — fail fast.
- **Sort + compare** is O(n log n); **dictionary counting** is O(n); they're both valid but the dict version is the better interview answer.
- **`s.count()` and `in` on a string are O(n)**, not O(1). Watch out for this when analyzing brute-force solutions that look "simple."
- For **Group Anagrams**, the canonical trick is **sorted-string-as-dict-key** — all anagrams of a word collide on the same key.
- **Print statements during development** catch index-vs-value and type errors before they compound.
- **Brute force first**, but don't skip a 1–2 minute pause to consider an alternative before you commit.
- **Debugging is normal.** Don't expect first-run success; expect 2–3 iterations.
- **Peer mentor sessions** are the best place to practice under live-coding pressure.


---

# Ruby Mock Interview — September 28, 2025

*Nailing the Tech Interview — Sunday session*

## Extended Q&A: How Long to Stay Stuck Before Looking Up a Solution?

**Mauricio asked:** when you're stuck on a problem and can't pass test cases, how long should you stay with it before looking up a solution?

### Ruby's framework: identify which phase you're stuck in

There are multiple phases of working through a LeetCode/HackerRank problem, and **what you should do depends on which phase you're stuck in**:

1. **Reading and understanding the problem**
2. **Understanding requirements, constraints, inputs, and outputs**
3. **Explaining the problem in your own words and writing assumptions**
4. **Writing pseudo code to translate the solution into steps**
5. **Writing code and testing assumptions (from problem and pseudo code)**
6. **Debugging / problem solving** — what are errors telling me, what is my code doing, what do I want it to do?

These phases aren't strictly linear — you often bounce between them. And you can collapse several into one for simple problems you've seen before.

### General time guidelines

- **Easy problems:** if you've spent **over an hour** and haven't gotten two-thirds of test cases passing, look up resources.
- **Medium problems:** maybe **an hour or so**, then **walk away** and come back a day or two later and start fresh rather than looking it up immediately.
- Goal: **get at least two-thirds of test cases passing** before looking up the full solution.

### What to do based on where you're stuck

**Stuck understanding the problem:**

- Focus on the information given: constraints, inputs, outputs.
- Rewrite the problem in your own simplest words.
- Draw visual diagrams if you're a visual learner.
- Walk through the sample explanation step by step in your own words.

**Stuck on constraints or input/output meaning:**

- Use Google. Look up unfamiliar symbols (like `|s|` for length) or data types.
- Use **print statements** to show what your data actually looks like.
- Read the error messages carefully and look them up if unclear.

**Stuck at pseudo code:**

- Go back to mod 2 and look for similar problems.
- Ask: what data structures might fit? Does it need a loop, a function, a dictionary?
- Look up resources on specific concepts, not solutions.

**Stuck on a working solution (code written but not passing):**

- Problem solve: what assumptions can I test?
- Print everything along the way. Compare expected output vs. actual output.
- If the expected is 5 and you're returning 7, **trace back why** you're returning 7. Maybe an assumption was wrong.

### The "stuck in a loop" problem

Mauricio: "I get stuck in a loop where I keep coding to pass the next test case and not generalizing. I realize the path is wrong but can't see another path to take."

- At that point, **revisit the earlier phases**. Did you fully understand the problem? Did you test your original assumptions?
- Take it to a **peer mentor office hours** or a **Q&A session** and say, "Here's where I'm at. Can you give me pointers?" A good mentor will **ask you questions** rather than hand you the answer, so you still make the connections yourself.

### After looking up a solution

Even after researching, there's still valuable work to do:

- **Code the solution in your own hands** — don't just read it.
- **Come back a week later** and try to solve it from scratch from memory.
- **Try different approaches** that use the same core concept — different data structure, different loop, etc.
- Add the technique to your toolkit so you can apply it to future problems.

> "Instead of having one solution that I had to look up, I have three solutions that I know and I could potentially extrapolate to new problems."

### 80/20 on algorithmic prerequisites

- About **80% of problems** can be solved with just mod 2 fundamentals.
- About **20% of problems** require specialized knowledge (named algorithms, advanced applications of data structures) that you may legitimately need to research.
- **Time-out failures** on otherwise-correct solutions are a signal you need the optimized version — that's a "learn and add to toolkit" moment, not a "beat yourself up" moment.

> "Medium and hard level problems were meant to trip you up. That's how they were made."

---

## The 6 Phases Framework (Reference)

| Phase | What you do |
|-------|-------------|
| 1 | Read and understand the problem |
| 2 | Understand requirements (constraints, inputs, outputs) |
| 3 | Explain problem in your own words, write assumptions |
| 4 | Write pseudo code translating solution into steps |
| 5 | Write code, test assumptions from problem and pseudo code |
| 6 | Debug / problem solve (applies at any phase) |

Phase 6 is a **meta-phase** — what it looks like depends on which of phases 1–5 you're actually stuck in.

---

## Worked Example: Repeated String (HackerRank)

Ruby walked through this problem using the 6-phase framework explicitly.

### Problem statement

There is a string `s` of lowercase English letters that is repeated infinitely many times. Given an integer `n`, find and return the number of letter `'a'`'s in the **first `n` letters** of the infinite string.

### Examples

```
s = "abcac", n = 10   -> 4
  The first 10 chars of "abcacabcac..." are "abcacabcac", containing 4 a's.

s = "aba", n = 10     -> 7
  The first 10 chars of "abaabaabaab" contain 7 a's.

s = "a", n = 1000000000000 -> 1000000000000
  A string of all 'a's, so the count is just n.
```

### Constraints

- `1 <= |s| <= 100` (where `|s|` is the length of s in mathematical notation)
- `1 <= n <= 10^12`
- For 25% of test cases, `n <= 10^6`

### Note on the `|s|` notation

The vertical bars `|s|` in constraints are **absolute value notation** in math, which for a string represents its **length** (number of characters). If you don't know a symbol in constraints, Google it or check Stack Overflow.

### Phase 1: Reading and Understanding

First read of the problem is often confusing. Take a deep breath, read again. Pull out:

- We have a short string `s`.
- It repeats infinitely.
- We care about the first `n` characters.
- Count the `'a'`s in that range.

### Phase 3: Explain in your own words and write assumptions

> "Given `s`, which is the smallest range of characters in an infinitely repeating sequence, and `n`, an integer representing the length I need to construct — return the number of `'a'`s in the constructed string up to length `n`."

**Initial assumption:** `s` will be shorter than `n`.

### Phase 2: Check constraints to test the assumption

- `|s|` can be `1 <= |s| <= 100`
- `n` can be `1 <= n <= 10^12`

These are **independent ranges**. `s` could theoretically be length 100 while `n` is 1. So the assumption **"s will always be shorter than n" is FALSE**.

**Updated pseudo code note:** add a conditional check for whether `s` is shorter or longer than `n` before building.

### Another assumption to check: Is `'a'` always included in `s`?

The problem says `s` is "a string to repeat" — it **doesn't** say `s` must contain the character `'a'`. Nothing in the constraints says so either. So **`'a'` may or may not be in `s`** — handle that case (count could be 0).

### Efficiency warning from constraints

`n` can be as large as `10^12`. Building an actual string of length `10^12` would **blow up memory** (and take forever). This is a **space complexity** concern that will cause a **time-out** failure in practice.

> "Do I need to build that string? It takes up a lot of memory."

### Phase 4: Pseudo code (first draft — naive approach)

```
# Build infinite_string out of s up to length n
infinite_string = s
while len(infinite_string) < n:
    infinite_string += s
# Trim to exactly n if overshoot
infinite_string = infinite_string[:n]
# Count a's
count = 0
for ch in infinite_string:
    if ch == 'a':
        count += 1
return count
```

**Problem:** builds a massive string for large `n`. Will time out on tests where `n >= 10^9` or so.

### Phase 6: Efficiency improvement — skip building the string

Key insight: you **don't need to materialize the string**. You just need arithmetic:

- Count the `'a'`s in one copy of `s`. Call this `a_in_s`.
- Figure out how many full copies of `s` fit in `n`: `full_copies = n // len(s)`.
- The "full copies" contribute `full_copies * a_in_s` a's.
- Then handle the **remainder** — the leftover partial string: `remainder_len = n % len(s)`. Count `'a'`s in `s[:remainder_len]` and add.

### Optimized solution

```python
def repeatedString(s, n):
    len_s = len(s)
    a_in_s = s.count('a')
    full_copies = n // len_s
    remainder = n % len_s
    a_in_remainder = s[:remainder].count('a')
    return full_copies * a_in_s + a_in_remainder
```

- **Time:** O(|s|) — only counts a's in the original short string.
- **Space:** O(1) — no massive string built.
- Handles `n = 10^12` instantly.

### Lisa's question and the key insight

Lisa asked early: "Is there a formula to build out the string — like `string * number`?"

Ruby initially said "hold that thought" because she wasn't done reading the problem. But Lisa's instinct was on the right track: **use math, not construction**. The `full_copies * a_in_s + remainder_count` formula is exactly what you get when you stop thinking about the string and start thinking about the arithmetic.

### Why return an `int`, not a string or list

Always set up your return statement **to match the expected return type** early. The function signature says it returns an integer. If you return the wrong type, you'll get parsing errors. Ruby recommends starting with `return 0` or `return count` as a placeholder so the type is correct from the start.

---

## Status Check: Where Is Everyone?

- **End of mod 2 (through project 5):** reviewing concepts and working on HackerRank practice.
- **Finished mod 2 a month ago**, had some life interruptions, now restarting tech interview prep and revising mod 1/2 material alongside HackerRank.

Ruby: everyone's in a good spot for the practice we're doing.

---

## Key Takeaways

- **Identify which phase you're stuck in** — then take phase-appropriate action. Don't do coding debugging when the real problem is that you don't understand the problem.
- **Goal before looking up:** get 2/3 of test cases passing first. If you can't hit that after an hour on an easy problem, start looking at resources.
- **Walk away from stuck problems** for a day or two before looking up solutions. Fresh eyes help more than grinding.
- **After looking up a solution, code it yourself from memory a week later** and try alternative approaches with the same concept.
- **80/20 rule:** most problems need only mod 2 fundamentals. 20% need specialized algorithms — learn them as they come, don't try to memorize them all up front.
- **Test assumptions explicitly.** "`s` will be shorter than `n`" is a testable assumption — constraints told us it's false.
- **Check if target characters even exist** — "is `'a'` guaranteed to be in `s`?" is an assumption worth verifying.
- **Huge `n` values (10^12) are a red flag** against solutions that materialize data. Think math, not construction.
- **`n // len_s` and `n % len_s`** unlock O(1) space for "first n chars of an infinitely repeating string" problems.
- **Set up the return statement early** with the correct data type as a placeholder.


---

# Ruby Mock Interview — October 12, 2025

*Nailing the Tech Interview — Sunday session*

## Q&A: Do I Need to Learn All the "Patterns"?

Mauricio asked about the anxiety of feeling like there are 20–30 different problem-solving patterns to master for interviews — BFS, DFS, sliding window, two pointers, greedy, dynamic programming, etc.

### For the Joy of Coding technical interview

- **You do NOT need BFS/DFS** — those are for trees and graphs, which aren't in mod 2.
- **Recursion problems**, if given, will be problems that *could* be solved normally and you'll be asked to solve recursively — not problems that *require* recursion.
- Ruby hasn't found an easy-level recursion-only problem in mod 2 topics, so it's unlikely to appear.

### For the job hunt

- Yes, eventually you should practice these patterns, but the actual list is **not that long** — maybe a dozen or so patterns total.
- LeetCode has **curated lists by pattern**: sliding window list, two-pointer list, tree/graph list, etc. Work through them one category at a time.
- You don't need to study this yet — come back to it once you've been in the internship for a while and are comfortable with general coding problems.

### The 80/20 breakdown

- **~80% of problems** can be solved with just mod 2 fundamentals: lists, dictionaries, linked lists, 2D arrays, functions, recursion, stacks, queues.
- **~20% of problems** need specialized knowledge — trees, graphs, specific algorithms.
- Every problem can at least be **brute-forced** with mod 2 concepts (except some tree/graph problems).

> "Don't get hung up on the pattern pieces where you are right now. That's something you come back to when you're really diving into the job hunt."

---

## Main Topic: How to Work with a Looked-Up Solution

Ruby covered her process for when you've tried your best, gotten stuck, looked up a solution, and now need to learn from it. She'd never explicitly walked through this process before.

### Problem used for the walkthrough: Group Anagrams (LeetCode medium)

Given an array of strings, group the anagrams together into a 2D array.

```
Input:  ["eat","tea","tan","ate","nat","bat"]
Output: [["eat","tea","ate"],["tan","nat"],["bat"]]
```

### Constraints

- `1 <= strs.length <= 10^4`
- `0 <= strs[i].length <= 100`
- Lowercase English letters only.

### The pseudo code outline

```
# Given: strings - list of strings that may or may not be anagrams
# Even if a string has no anagram pair, still include it in the output as its own group
# If strings is empty, return an empty 2D array
# Return: 2D array where outer is groups, inner is all strings that are anagrams of each other
```

---

## The Solution (found online)

```python
def groupAnagrams(strs):
    anagram_table = {}
    for string in strs:
        sorted_string = "".join(sorted(string))
        if sorted_string not in anagram_table:
            anagram_table[sorted_string] = []
        anagram_table[sorted_string].append(string)
    return list(anagram_table.values())
```

---

## Ruby's Process for Learning from a Looked-Up Solution

### Step 1: Paste it in and confirm it works

Run the solution against the sample test cases. Confirm it passes. Don't submit yet — you want to learn, not just submit someone else's work.

### Step 2: Step through each line and visualize

Add print statements to understand what each line does:

```python
print(sorted_string)  # "aet" for "eat", "aet" for "tea", etc.
print(anagram_table)  # see the dict build up
```

- **`sorted("eat")`** returns a **list** (`['a', 'e', 't']`), not a string. This is because Python has no built-in sort method for strings.
- **`"".join(sorted("eat"))`** uses the `join` string method to concatenate the sorted list back into a string (`"aet"`).
- **`list(anagram_table.values())`** converts the dictionary's values view into a list of lists.

### Step 3: Write pseudo code for the solution *as if you had written it*

Pretend you wrote this code and are now documenting it in pseudo code:

```
# Create a dictionary to store key-value pairs for anagram groups
# For loop through all strings in the input list
# Use the sorted string as the dictionary key
# If the sorted string doesn't exist in the dictionary:
#   initialize it with an empty list
# Append the unaltered string to the list at that key
# After the loop, convert the dictionary's values into a 2D list and return
```

### Step 4: Take a break

A day, a few days, maybe a week. No code in the editor — only the pseudo code.

### Step 5: Rewrite the solution from your pseudo code

Come back. Only the pseudo code is there. Try to write working code from your pseudo code alone.

### Step 6: Look up **only** the specific things you get stuck on

Don't reference the original solution. Look up things like:

- "How do I sort a string in Python and get a string back?" → learn about `"".join(sorted(s))`.
- "How do I check if a key exists in a dictionary?" → learn `if key in dict` or `.get()` with default.
- "How do I iterate a dictionary's values?" → learn `.values()`, `.items()`, `.keys()`.

---

## Ruby's Rewrite (done during the demo)

```python
def groupAnagrams(strs):
    anagrams = {}
    for string in strs:
        copy = "".join(sorted(string))
        if copy in anagrams:
            anagrams[copy].append(string)
        else:
            anagrams[copy] = [string]
    # Convert dictionary values back into a 2D array
    result = []
    for value in anagrams.values():
        result.append(value)
    return result
```

Slightly different from the original, but still works. The key point: **her version came from her pseudo code, not from memorizing the original solution**.

---

## How Long to Bang Your Head Before Looking Up a Solution

### Mauricio's follow-up question

> "How long should you basically bang your head against the wall before going for the solution?"

### Ruby's answer

- **Easy problem:** ~1 hour. If you can't get 2/3 of test cases passing, walk away.
- **Medium problem:** up to ~1 hour on day 1. Let it marinate. Come back a day or two later.
- **Never look up the solution on day 1** for medium problems.
- After 2/3 test cases pass, spend another **10–20 minutes** trying to get the final third. If that fails, re-read the problem carefully first. **If still stuck after that**, look up the solution.
- **Total time across multiple days:** ~1.5 hours is Ruby's rough budget.

### When to stop for the day

- When you've thought through everything you can.
- When you're going in circles in your own head.
- **Change of scenery helps enormously.** Ruby shared a story of being stuck on a problem for over an hour, going on a 30-minute to 1-hour nature walk, and solving it in 20 minutes when she came back.

> "I've gotten really frustrated, went on a nature walk, came back, and knocked the problem out of the park in 20 minutes. Like it was nothing."

---

## Python Dictionary Method Reference

Useful methods you should get acquainted with:

- **`get(key, default)`** — safely retrieves a key's value, returning `default` if missing.
- **`items()`** — returns a list of `(key, value)` tuples.
- **`keys()`** — returns only the keys.
- **`values()`** — returns only the values.
- **`pop(key)`** — removes and returns a key's value.
- **`setdefault(key, default)`** — returns value if key exists, else inserts default.
- **`update(other_dict)`** — updates keys/values in place.

### When iterating

- `for key in dict:` — iterates keys.
- `for value in dict.values():` — iterates values.
- `for key, value in dict.items():` — iterates key-value pairs.

> "Chris noted this was the first time he'd seen a dictionary's values converted back to a list. Worth getting comfortable with."

---

## Key Takeaways

- **You don't need to master every pattern before the technical interview.** Mod 2 fundamentals are ~80% of what you need.
- **BFS/DFS** are tree/graph topics — not in mod 2, not on the Joy of Coding technical interview.
- **Pattern practice** (sliding window, two pointers, etc.) is for job-hunt prep, not tech interview prep. Come back to it later.
- **Looking up a solution is not cheating** — it's a learning opportunity if handled correctly.
- **The "looked-up solution" process:**
  1. Paste and confirm it works.
  2. Step through with print statements.
  3. Write pseudo code for the solution in your own words.
  4. Take a break (a day to a week).
  5. Rewrite from your pseudo code only.
  6. Look up only the specific pieces you get stuck on, never the full solution again.
- **Day 1: don't look it up.** Take a walk. Come back fresh.
- **`"".join(sorted(s))`** is the canonical Python idiom for getting a sorted string.
- **Group Anagrams canonical approach:** dictionary keyed by sorted string, values are lists of original strings.
- **Know your dictionary methods** — `.values()`, `.items()`, `.keys()`, `.get()` are essential.


---

# Ruby Mock Interview — October 19, 2025

*Nailing the Tech Interview — Sunday session*

## Topic: Reverse-Engineering Python String Methods

Ruby changed up the session format. Instead of a mock interview, she ran a workshop on **reverse-engineering built-in string methods** by breaking them into small reusable micro-challenges.

### Motivation

On Wednesday the group covered **"Find the Index of the First Occurrence in a String"** (LeetCode easy), where:

> Given `needle` and `haystack`, return the first index where `needle` appears in `haystack`, or `-1` if not found.

And discovered that Python's `str.find()` method solves the entire problem in one line:

```python
return haystack.find(needle)
```

Ruby's point: **this is a valid solution for the interview, but it's not great for learning.** If you always reach for built-in methods, you never learn the underlying logic.

> "For learning purposes, I recommend everyone to learn the logic behind the methods they're using."

---

## The Micro-Challenge Framework

Break the problem into small foundational skills you can practice in isolation:

1. Check if two strings are equal — return `True`/`False`.
2. Iterate through a string and print each character.
3. Check if a character exists within a string — print `True`/`False`.
4. Find the index of the first matching character in a string — print the index.
5. Return a slice of a string between two indexes — print the slice.

If you can do each of these, you can compose them to implement `find()` yourself.

---

## Micro-Challenge 1: String Equality

### Equality in value

```python
string_1 = "hello"
string_2 = "hello"
print(string_1 == string_2)   # True
```

### Equality in length (different question)

```python
print(len(string_1) == len(string_2))
```

**Key distinction:** `==` on strings checks that **every character matches**. `len(a) == len(b)` only checks that the lengths match, not the characters.

### The "compressed if" clarification

Chris asked about the one-liner `print(char in haystack)` without an `if` block:

> "I took an if statement and compressed it into one line. Is there a name for that?"

**No — it's not a compressed if.** An `if` statement controls flow; the **statement** (like `char in haystack`) is what evaluates to `True`/`False`. If you only want the boolean result without branching, just print the statement directly. You don't need an `if` at all.

---

## Micro-Challenge 2: Iterate Through a String

```python
haystack = "sadbutsad"
for ch in haystack:
    print(ch)
```

Straightforward. This iterates the characters directly without tracking an index.

---

## Micro-Challenge 3: Check If a Character Exists in a String

```python
character = "s"
haystack = "hello world"
print(character in haystack)   # True
```

The `in` operator is all you need — no loop required.

---

## Micro-Challenge 4: Find Index of First Matching Character

The trick: `for ch in string` iterates **characters**, but you need the **index**. Use `for i in range(len(string))` instead so `i` is an integer index.

```python
character = "s"
haystack = "sadbutsad"

for i in range(len(haystack)):
    if haystack[i] == character:
        print(i)
        break   # stop at first match
```

### On `break` vs `return`

- **`break`** exits the loop but continues with code after it.
- **`return`** exits the entire function immediately.
- Use `break` if you want to find the first occurrence and keep doing work afterwards.
- Use `return` if finding the match means the function is done.

### The trap

Without `break`, the loop would print **every** `s` in `sadbutsad` (indexes 0 and 6). We only want the first. `break` ensures we stop at index 0.

---

## Micro-Challenge 5: Slice a String Between Two Indexes

### The long way (for loop)

```python
index_1 = 3
index_2 = 7
word = ""
for i in range(index_1, index_2):
    word += haystack[i]
print(word)
```

### The Python-idiomatic way (slice notation)

```python
print(haystack[index_1:index_2])   # "lo w"  (inclusive start, exclusive end)
```

- Slice notation: `string[start:end]` — **start inclusive, end exclusive**.
- You can omit start (`[:end]`) or end (`[start:]`).
- Specific to Python; not every language has this.
- **There is no `string.slice()` method in Python** — use bracket notation.

---

## Composing the Micro-Challenges into a Full Solution

Now build `strStr(haystack, needle)` from these building blocks.

### High-level pseudo code

```
# Iterate through haystack
# At each position i, compare a slice of haystack to needle
# If they match, return i
# If we finish the loop without matching, return -1
```

### Bonus edge cases

- **If needle equals haystack**, return 0 immediately.
- **If haystack is shorter than needle**, return -1 immediately.

### Full implementation

```python
def strStr(haystack, needle):
    # Edge cases
    if needle == haystack:
        return 0
    if len(haystack) < len(needle):
        return -1

    n = len(needle)
    for i in range(len(haystack)):
        if needle[0] == haystack[i]:
            # First character matches — compare the full slice
            if needle == haystack[i:i + n]:
                return i
    return -1
```

### Walking through the critical slice

For `haystack = "sadbutsad"`, `needle = "sad"`:

- `i = 0`: `haystack[0] == 's'`, slice `haystack[0:3]` = `"sad"`, matches needle → return 0.

For `haystack = "somethingsomething sad"`, `needle = "sad"`:

- `i = 0`: first char `s` matches, but slice `haystack[0:3]` = `"som"` ≠ `"sad"`.
- `i = 10`: first char `s` matches, but slice ≠ `"sad"`.
- `i = 20` (eventual): slice `haystack[20:23]` = `"sad"` → return 20.

### The subtle bug we hit during the demo

Initial attempt used `haystack[i:n]` instead of `haystack[i:i + n]`. That means "from `i` to `n`" — if `i > n`, you get an empty string. The fix is `i + n` so the endpoint advances with the start.

> "This is why it's always good to print. When you're not sure why you're getting nothing, add more context to your prints."

### Indentation gotcha for the `return -1`

The `return -1` must be **outside** the `for` loop (at the function level), not inside it. If it's at the loop's level, it fires after the first iteration and never finds matches beyond index 0. Kick it one tab further left.

---

## Why Bother With This Exercise?

- These micro-skills (string equality, iteration with index, slicing, character membership) appear in **many** string problems.
- Once you're fluent, you can look at a problem and see "this is iterate + slice + compare + return" without needing to remember a specific built-in method.
- You could use `find()` as a shortcut in a real interview — but knowing the mechanics means you're not helpless when the built-in doesn't quite fit.

> "The trick is to look at a problem and determine what those little mini micro-challenges are." — Ruby

### Example of generalization: email validation

Chris noted this pattern applies to email validation:

- Find the `@` symbol → index search.
- Pull the part before and after → slicing.
- Check for `.com`, `.org`, etc. → substring comparison.

All the same building blocks.

---

## Related String Methods (and Homework)

Ruby pointed out two other common string methods that work similarly:

### `str.count(substring)`

Returns the number of times `substring` appears in the string. We tested this implicitly in the demo by tracking multiple `s` matches in `sadbutsad`.

### `str.replace(old, new, count=...)`

Replaces occurrences of `old` with `new`. Optional `count` parameter limits how many replacements.

```python
text = "one one one"
text.replace("one", "three")       # "three three three"
text.replace("one", "three", 2)    # "three three one"
```

**Note:** `replace` **returns** a new string — strings in Python are immutable, so it can't modify in place.

### Homework

Implement `count` and `replace` **without using the built-in methods**. Use only the micro-challenge building blocks we practiced today.

- Reference: W3Schools Python String Methods.
- Post solutions in the HackerRank Discord channel.

---

## Q&A: Bracket Notation for Indexing

Someone asked: "When you put `needle[0]`, does the bracket notation always mean index?"

**Yes** in Python, for any **iterable with ordered access** (strings, lists, tuples).

- `needle[0]` → first character of the string.
- `needle[2]` → third character.
- Works the same on lists: `my_list[0]`.
- **Strings and lists** are both iterable and indexable.

### Parentheses in return statements

Another clarification: **you don't need parentheses around a `return` value** in Python. You need them for `print()` (which is a function call) but not `return` (which is a keyword).

```python
return i           # correct
return(i)          # also works but unnecessary
```

---

## Key Takeaways

- **Built-in string methods are shortcuts** — useful in interviews, but don't let them rob you of understanding the mechanics.
- **Break problems into micro-challenges** that are reusable across many problems.
- **`for i in range(len(s))`** gives you index access; `for ch in s` gives you characters directly.
- **Slice notation is `[start:end]`** with inclusive start, exclusive end.
- **Python has no `.slice()` method** on strings — use bracket notation.
- **`break` exits one loop; `return` exits the whole function.**
- **Indentation of `return -1` matters** — it must be outside the loop for "not found" logic to work.
- **Strings are immutable** — `replace` returns a new string rather than modifying in place.
- **`[0]`, `[1]`, etc. are indexes** for strings, lists, tuples — all ordered iterables.
- **Print early, print often** when debugging slice/index logic. When you see nothing, add more print context.


---

# Ruby Mock Interview — October 26, 2025

*Nailing the Tech Interview — Sunday session*

## Homework Recap: Reimplementing `count` and `replace`

Mauricio completed the homework of reimplementing Python's `str.count()` and `str.replace()` without using the built-in methods and posted his solutions to the HackerRank Discord channel. He even wrapped them in a class to mimic the built-in interface.

### What he ran into

- **`replace` was harder than `count`** — the sticking point was **updating the string as you find matches**. At first he was only replacing the first or the last occurrence.
- **Strings are immutable** — each replacement creates a new string, which you then have to reassign before the next iteration.
- **Once `replace` worked, `count` was trivial** — it's essentially a shortened version of the same traversal logic without the modification step.

### Why Ruby chose these two problems

- `find`, `count`, and `replace` all share the same **traversal + comparison base** but have different side effects:
  - `find` returns an index.
  - `count` returns a total count.
  - `replace` modifies (returns a new) string.

---

## Mock Interview: Mauricio on "Minimum Time to Make Rope Colorful" (LeetCode medium)

### Problem statement

You have a rope of balloons represented as a string `colors`. You also have an integer array `neededTime` where `neededTime[i]` is the time to remove balloon `i`. Bob wants the rope to be **"colorful"** — meaning **no two consecutive balloons have the same color**. Return the **minimum time** Bob needs to make the rope colorful.

### Examples

```
colors = "abaac",   neededTime = [1, 2, 3, 4, 5]  ->  3
  Remove balloon at index 3 (time 4)? No — actually remove index 2 (time 3).
  Result: "abac" — no consecutive duplicates.

colors = "abc",     neededTime = [1, 2, 3]        ->  0
  Already colorful, nothing to remove.

colors = "aabaa",   neededTime = [1, 2, 3, 4, 1]  ->  2
  Remove first 'a' (time 1) and last 'a' (time 1) -> "aba". Total: 2.
```

### Constraints

- `colors.length == neededTime.length == n`
- `1 <= n <= 10^5`
- `1 <= neededTime[i] <= 10^4`
- `colors` consists of lowercase English letters.

### Mauricio's verbal problem breakdown

> "The goal is to remove any consecutive balloons of the same color. Among the two, I should remove the cheapest one. So I need to find consecutive duplicates, then add the minimum of the two times to a running sum."

### Approach (pair-by-pair with `step=2`)

Initial plan: iterate `colors` in steps of 2, compare `colors[i]` to `colors[i+1]`, and if they match, add the minimum of the two times to a running sum.

```python
def minCost(colors, neededTime):
    total = 0
    for i in range(0, len(colors) - 1, 2):
        if colors[i] == colors[i + 1]:
            total += min(neededTime[i], neededTime[i + 1])
    return total
```

### The bug: step=2 skips odd-indexed comparisons

With step 2, you compare (0,1), (2,3), (4,5)... but you **miss** comparing (1,2), (3,4), etc. This fails cases where consecutive duplicates straddle the step boundary.

### The debugging hiccup

- Mauricio added print statements but **nothing printed**. He thought the `if` condition was the problem.
- **Actual cause:** the `range(..., step=2)` was skipping past the matching pairs, so the `if` was never true.
- **Lesson:** he should have added a print statement **right after the `for` loop** to confirm the loop was iterating over the expected indexes — **before** writing any inner logic.

### Ruby's coaching point

> "As soon as you wrote your for loop, I would have tested to make sure it was doing what you expected. It seems simple — why would I need to test my for loop? I've written it a million times. This is exactly why I do it every single week."

**Always print right after writing a loop.** You reduce the possible sources of error from "is it my for loop, my if, my sum, my index arithmetic, or my variable name?" down to just "the for loop." Debug the smallest surface area at a time.

### Fixing step=2 → step=1

Removing the step argument got the code running:

```python
for i in range(len(colors) - 1):
    if colors[i] == colors[i + 1]:
        total += min(neededTime[i], neededTime[i + 1])
```

Result: **33% of test cases passing** (only about 28%).

### Why `len(colors) - 1` (the safety offset)

Because we access `colors[i + 1]` inside the loop, we must stop at the second-to-last index or we'll hit an **index out of range** error. `range(len(colors) - 1)` gives indexes `0` through `n - 2`, and `i + 1` will then be at most `n - 1`.

### The remaining bug: three-or-more consecutive duplicates

With `colors = "aaabbbc"` and `neededTime = [3, 5, 10, 7, 5, 3, 5]`, the pair-by-pair logic starts **double-counting**:

- Comparing `(0,1)`: both `a`, add min(3, 5) = 3.
- Comparing `(1,2)`: both `a`, add min(5, 10) = 5. ← now we've added costs for balloon 1 twice
- Comparing `(2,3)`: `a` ≠ `b`, skip.
- Comparing `(3,4)`: both `b`, add min(7, 5) = 5.
- Comparing `(4,5)`: both `b`, add min(5, 3) = 3. ← same issue, balloon 4 counted twice

The correct approach for a run of `k` same-colored balloons is: **remove all but the most expensive one**. That is, `sum(group) - max(group)`.

### Strategy for the next attempt

Mauricio suggested switching to a **`while` loop** to walk through runs of same-color balloons until the color changes, then sum the group and subtract the max. Ruby suggested first **walking through the failing test case by hand** before rewriting.

> "Before I just start switching variables or conditions, what do I need to know about this problem? What do I need to consider?"

### Ruby's hint

> "I think that hint might even be example three in their problem statement." — pointing to the `"aabaa"` example where removing the two cheap end-a's is the right move. Generalize: always **keep the most expensive balloon** in each consecutive-color group.

### Correct canonical solution (implied, not coded in session)

```python
def minCost(colors, neededTime):
    total = 0
    i = 0
    while i < len(colors):
        j = i
        group_sum = 0
        group_max = 0
        while j < len(colors) and colors[j] == colors[i]:
            group_sum += neededTime[j]
            group_max = max(group_max, neededTime[j])
            j += 1
        total += group_sum - group_max
        i = j
    return total
```

- **Time:** O(n)
- **Space:** O(1)

---

## Linda's Clarifying Questions (Great Interview Practice)

Linda joined late and asked Mauricio to explain his code in plain English. Ruby noted this is **exactly** the kind of conversation you'd have in an interview — being able to explain your logic while the interviewer probes your reasoning.

Questions Mauricio fielded well:

- **Why `- 1` on line 4?** → "It's a safety thing. We stop one before the end because we look at `color + 1` inside."
- **Why `color + 1`?** → "Because I want to compare two consecutive balloons. The next index is one forward."
- **What does `min` do here?** → "Among the two consecutive duplicates, I want the cheapest to remove, because the problem wants minimum total time."
- **What if we did `+ 2` instead?** → "Then I'd compare non-consecutive balloons, which breaks the problem's definition of 'consecutive.'"

> "It's always good to think about the problem and explain your code this way, especially for a technical interview. The interviewer wants to hear how you're thinking about the problem."

---

## Closing Recommendations

### Pen and paper for tricky test cases

When code passes some tests but not all and you can't see where it's breaking down mentally, **draw it out**. Especially for problems with visual setups like this one (balloons on a rope).

> "I'm always a fan of pen and paper. Make it visual if you need to."

### Session cadence reminder (for newcomers)

- **Sundays:** new problems, mock interviews, fresh content.
- **Wednesdays:** exploring the problems from Sunday in more depth, alternative approaches, efficiency discussions.

---

## Key Takeaways

- **Homework insight:** `replace` requires reassigning the string after every match because strings are immutable. `count` is a simpler traversal with no modification.
- **Always debug your for loop immediately after writing it.** Print indexes or values before adding any inner logic — reduces debugging surface area.
- **`range(..., step=2)` silently skips pairs** like (1,2), (3,4). If your problem cares about "every consecutive pair," use `step=1`.
- **`for i in range(len(x) - 1)`** is the safe pattern when you need `x[i + 1]` inside the loop.
- **Pair-by-pair comparison fails for runs of 3+** because you end up double-counting middle elements.
- **Canonical "remove consecutive duplicates" pattern:** for each run of same elements, `sum(run) - max(run)` gives the minimum cost to keep one.
- **Explain your code out loud** — interviewers value verbal reasoning as much as working code.
- **When stuck, walk through the failing test case by hand** before changing code blindly. Ask "what do I need to know?" before "what should I change?"
- **Pen and paper beats mental tracing** for complex iterations.


---

# Ruby Mock Interview — November 2, 2025

*Nailing the Tech Interview — Sunday session*

## Q&A: Is There a Quick, Effective Way to Prepare?

Linda asked if there's a quick or effective way to prepare for the technical interview beyond just doing problems repetitively.

### Ruby's answer

- **Not quick, but effective** — absolutely.
- **Repetition alone isn't enough.** What matters is **what you learn after each problem**.
- Use the full session playlist: Sunday sessions introduce new problems, Wednesday sessions explore solutions in depth. That progression has been running since June.
- **Coming to sessions is only part of the battle.** The real challenge is what you do *between* sessions — apply the steps that were showcased, try problems on your own, channel discussion into practice.

> "Not just opening up a random problem and saying 'well, here we go, good luck.' What steps are you taking? How are you channeling what we discuss weekly into your practice?"

---

## Mindy's Alternative Count Implementation

Mindy shared an alternative implementation of `str.count()` that she developed because the **sliding window slicing approach** from Mauricio's version had been tripping her up.

### The "whole-word" version

Instead of matching substrings, she split the string by spaces and compared whole words after stripping punctuation:

```python
def count(string, word, match_whole_word=True):
    if match_whole_word:
        words = string.split()
        count = 0
        for w in words:
            # Strip punctuation
            w_clean = w.strip(".,!?;:\"'")
            if w_clean == word:
                count += 1
        return count
    else:
        # Fall back to sliding window substring approach
        word_length = len(word)
        count = 0
        for i in range(len(string) - word_length + 1):
            if string[i:i + word_length] == word:
                count += 1
        return count
```

### The `+ 1` in the range

Mindy spent time puzzling out why the range is `len(string) - word_length + 1`:

- Without the `+ 1`, you'd cut off before examining the **last possible window position**.
- Example: `string = "abcde"` (length 5), `word = "cd"` (length 2). Valid start indexes are `0, 1, 2, 3` → that's `5 - 2 + 1 = 4` positions.
- **The `+ 1` includes the final viable starting index.**

### The sliding-window comparison

```python
if string[i:i + word_length] == word:
```

- `string[i:i + word_length]` grabs a **chunk** the size of the target word.
- `==` compares the chunk to the full word.
- Increments `i` each iteration → the window slides forward.

### Ruby's critique

Mindy's test case used `apple` as the search term in a string containing `"apples"`:

- With `match_whole_word=True`, she got `0` — correct for whole-word matching.
- With `match_whole_word=False`, she got `3` — matching the substring `"apple"` inside `"apples"`.

**The actual `str.count()` method does substring matching** — it would return `3` for `"apple"` in a string of `"apples"`. Mindy's whole-word version is a **different function**, not a drop-in replacement. Still a valuable exercise — just clarify what you're implementing.

> "Python is all object code. You have us reverse-engineering methods so I can know how it works under the hood, because I can't remember everything."

---

## Ruby's First Hard Problem: Median of Two Sorted Arrays

Ruby solved a LeetCode **hard** problem in under 30 minutes and thought it was mislabeled — the techniques are all things the group had covered in easier problems. She walked through how to build up to it.

### Subproblem 1: Find the Median of a Sorted Array

What information do you need to know?

- **Is the length even or odd?** Determines whether you return the middle element or average the two middle elements.
- **Length** of the array (to locate the middle).
- **Is the array sorted?** If not, sort first — but sorting is O(n log n), which might violate efficiency constraints.
- **Is the array non-empty?** Edge case to handle.
- **Range of values** (sometimes given as a constraint, not strictly needed for logic).

### For an odd-length sorted array

```python
def find_median_odd(arr):
    mid_index = len(arr) // 2   # integer division rounds down
    return arr[mid_index]
```

For `len(arr) == 7`, `7 // 2 == 3`, which is the correct 0-indexed middle position (values at indexes 0,1,2 | **3** | 4,5,6).

### For an even-length sorted array

```python
def find_median_even(arr):
    n = len(arr)
    mid1 = arr[n // 2 - 1]
    mid2 = arr[n // 2]
    return (mid1 + mid2) / 2
```

### Subproblem 2: Merge Two Sorted Arrays in O(n + m)

Information needed:

- Final array must also be sorted.
- The two arrays may have **different lengths**.
- A new array must be created — you can't modify in place easily.
- The combined length is `len(a) + len(b)`.

### Naive approach: concat + sort

```python
merged = nums1 + nums2
merged.sort()
```

This **works** but is **O((n+m) log(n+m))** due to the sort. The problem requires better.

### Proper O(n + m) merge (two pointers)

```python
def merge_sorted(nums1, nums2):
    result = []
    i = j = 0
    while i < len(nums1) and j < len(nums2):
        if nums1[i] < nums2[j]:
            result.append(nums1[i])
            i += 1
        else:
            result.append(nums2[j])
            j += 1
    # Append the remainder of whichever array still has elements
    result.extend(nums1[i:])
    result.extend(nums2[j:])
    return result
```

Each pointer only advances forward → total work is `O(n + m)`.

---

## The Hard Problem: Median of Two Sorted Arrays

> Given two sorted arrays `nums1` and `nums2` of sizes `m` and `n`, return the median of the combined sorted array. **Overall runtime complexity should be O(log(m + n))**.

### Examples

```
nums1 = [1,3],    nums2 = [2]       -> 2.0
nums1 = [1,2],    nums2 = [3,4]     -> 2.5
```

### Ruby's approach

Combine the two subproblems:

1. Merge the two sorted arrays in O(n + m) using the two-pointer technique.
2. Find the median of the resulting array.

**Note:** The problem asks for O(log(m + n)), but the merge-based approach is O(m + n). It still passes on LeetCode and is much easier to implement than the true O(log) binary search approach. Ruby accepted this as her "first hard problem" win even though it wasn't the optimal solution.

> "I kind of feel like this problem is mislabeled. I'll take the win either way."

### Problem-asking exercise

Ruby turned this into a group pseudo-code exercise **without showing the problem first**, just asking "what information would you need?" This is exactly the kind of clarifying-questions exercise you should practice for interviews.

---

## The Blind 75 and Pattern Recognition Debate

Mindy mentioned LeetCode now has a **"Study Plan"** feature for the Blind 75 that categorizes problems by pattern (arrays, sliding window, two pointers, etc.).

### Mindy's position

- Helpful for people who learn by repetition.
- Seeing a bunch of problems that use the same pattern helps build pattern recognition.
- Similar to how math drills taught fundamentals growing up.

### Ruby's position

- For the **Blind 75 specifically**, going in knowing the category **defeats the purpose**. The whole point is to test whether you can recognize patterns *cold* — just like in a real interview.
- **For learning a new concept**, Googling "LeetCode sliding window problems" to get a focused problem set is absolutely valid.
- **For interview-style practice**, pick problems without knowing the pattern in advance so you practice the recognition skill.

> "Are you going to know it's a hashset problem, a linked list problem, a sliding window problem if you don't practice identifying that yourself?"

### Middle ground

- Use categorized problem lists when you're **learning** a concept.
- Use uncategorized practice (blind picks) when you're **interview prepping**.

---

## Q&A: Am I Ready for the Technical Interview?

> "Do you give us an inkling of when we might be ready?"

Ruby: "If you volunteer to do a mock interview, I can give you a read on what you need to work on based on what I see."

---

## Q&A: Is Tech Joy Winding Down?

Linda noticed Discord is quieter and the calendar is shrinking. She asked if Tech Joy is closing.

### Ruby's answer

- **No.** The technical interview is **not going anywhere**, per Dr. Emily.
- The company's strategy is shifting toward bringing in **code-ready people** for internships rather than training from scratch.
- The **technical interview remains the litmus test** — passing it qualifies you for the internship, which is where real job experience comes from.
- For anyone currently in mod 2 heading toward the technical interview: **you're exactly where you need to be**.
- Mod 1 and mod 2 content will remain accessible, and more HackerRank-specific training is being added.

> "I am the end and the beginning."

---

## Q&A: Running Out of Practice Problems

Mauricio: "If I've done all the hacker rank problems and then take the technical interview, I'll be left with only the hardest easy problems. I feel penalized for having done so many."

### Ruby's answer

- **Solved-on-HackerRank problems won't be reused** in your technical interview — the instructors check the leaderboard.
- Ruby is actively working on **new problem sets** drawn from **LeetCode** for students who exhaust the HackerRank pool.
- **General philosophy:** HackerRank is preferred because it gives all the info upfront; LeetCode sometimes leaves info out, forcing you to discover it through failing tests. Ruby will select LeetCode problems that match HackerRank's "everything upfront" style.

### On interview nerves and luck

> "Sometimes it feels like when the stars align, you pass. You got the right problem, you were more relaxed, more focused, and everything aligned. It's just like a real technical interview." — Mauricio

> "You're either perfectly prepared, perfectly unprepared, or somewhere in between. And that last piece is where most of us live." — Ruby

---

## Homework

Solve **Median of Two Sorted Arrays** using the merge + median approach. After this, you'll have "tackled your first hard problem" for the record books.

---

## Key Takeaways

- **Repetition alone isn't enough** — what matters is what you learn *after* each problem.
- **Reverse-engineering built-in methods** (like `str.count`) is a great way to learn string manipulation fundamentals.
- **`len(s) - word_length + 1`** is the correct range upper bound for a sliding window over a string when the window has fixed size.
- **Whole-word matching is different from substring matching** — be clear about which you're implementing.
- **Hard problems often decompose into easier subproblems.** Median of Two Sorted Arrays = Merge Sorted Arrays + Find Median.
- **Merge two sorted arrays in O(m+n)** with the two-pointer technique, not by concatenating and sorting.
- **Integer division (`//`)** gives you safe middle indexes for odd-length arrays.
- **For the Blind 75, go in blind.** For learning a new concept, use categorized problem lists.
- **Solved HackerRank problems won't appear in your technical interview** — instructors check your leaderboard.
- **The technical interview isn't going away** — it's the admissions test for the internship pipeline.
- **Clarifying questions** (sorted? even length? range? non-empty?) are a core interview skill — practice asking them before coding.


---

# Ruby Mock Interview — November 23, 2025

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
