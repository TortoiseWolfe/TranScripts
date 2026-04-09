# Solutions Deep Dive — Maximum Product Subarray (2025-07-02)
Source: https://youtu.be/zB8f0KW9VzU

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
