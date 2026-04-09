# Mock Interview — Ice Cream Parlor (2025-07-06)
Source: https://youtu.be/h5H7XIse0Bo

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
