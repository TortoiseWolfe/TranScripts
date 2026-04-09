# Ruby Mock Interview — August 24, 2025
Source: https://youtu.be/E2fdp5mDZkE

*Nailing the Tech Interview — Sunday session*

## [0:08](https://youtu.be/E2fdp5mDZkE?t=8) Q&A: The Low-Code Internship

A student asked about the **low-code internship** option at Joy of Coding.

- Created by Sam (former student turned coach) who had experience building and managing **WordPress** sites for clients.
- Called "low-code" because WordPress site creation requires **a lot of domain and technical experience** but not deep full-stack coding.
- Aimed at people who:
  - Made it to the **Explorer** phase or past **mod 2** and want to start earning while still learning, OR
  - Find full-stack coding too difficult but want to stay in the web/tech domain.
- Currently has one active project (the **Inclusive IQ** project), near completion.
- Future of the program is **in flux** — may or may not be permanent going forward.

---

## [4:59](https://youtu.be/E2fdp5mDZkE?t=299) Q&A: Problems That Require Outside Research (Magic Square)

**Mauricio** worked on the **Magic Square** medium problem and discovered that solving it optimally requires knowing specific domain knowledge that isn't in the problem statement.

### [3:46](https://youtu.be/E2fdp5mDZkE?t=226) What he found

- A 3x3 magic square has rows, columns, and diagonals all summing to **15**.
- There are **only 8 possible 3x3 magic squares** in total.
- The only way to guarantee a minimum-cost transformation is to **compare against all 8** magic squares, either by hardcoding them or generating all permutations of 1–9 and filtering.
- Attempts to build a general algorithm without this knowledge led to spaghetti code with no guarantee of finding the minimum.

### [8:01](https://youtu.be/E2fdp5mDZkE?t=481) Coaching response

- **Medium and hard problems sometimes require specific prior knowledge** — popular algorithms, math theorems, well-known patterns.
- This is more common at **FAANG-level interviews** (Google, Amazon, Facebook) than at typical job-hunt interviews.
- Most problems you'll face **can be worked through to *a* solution** (even if not the most efficient) without specific foreknowledge.
- **You will NOT see this kind of research-gated problem in the Joy of Coding technical interview.**
- The **Blind 75 LeetCode list** has some of these harder patterns — worth knowing because they're popular enough that background is readily available.

> "What value would there be in interviewing a candidate to try and stump them? It doesn't make a lot of sense. That's not going to be the vast majority of situations you run into."

### [9:10](https://youtu.be/E2fdp5mDZkE?t=550) Can you research during an interview?

- Generally **no** — looking up an approach during an interview counts as looking up the solution.
- Mauricio learned the relevant constraint *through research after the fact*, which is fine for learning but wouldn't be allowed live.

---

## [14:06](https://youtu.be/E2fdp5mDZkE?t=846) [approx] Problem Walkthrough: Best Time to Buy and Sell Stock

Easy-level problem from LeetCode.

### [15:31](https://youtu.be/E2fdp5mDZkE?t=931) Problem statement

Given an array `prices` where `prices[i]` is the stock price on day `i`, pick a **single day to buy** and a **different day in the future to sell** to maximize profit. Return the maximum profit, or `0` if no profit is possible.

### [16:13](https://youtu.be/E2fdp5mDZkE?t=973) Examples

```
prices = [7, 1, 5, 3, 6, 4]  ->  5  (buy on day 2 at 1, sell on day 5 at 6)
prices = [7, 6, 4, 3, 1]     ->  0  (monotonically decreasing, no profit)
```

**Key constraint:** You **cannot sell before you buy** — no time machine.

### [19:01](https://youtu.be/E2fdp5mDZkE?t=1141) Restating the problem

> "Find the greatest difference between any two indices `i` and `j` where `i < j` and `prices[i] < prices[j]`."

Or in plain language: "Find the **lowest** I can buy, and the **highest** I can sell after that index."

### [19:04](https://youtu.be/E2fdp5mDZkE?t=1144) Two subproblems

1. Find two indices satisfying `i < j`.
2. Among those, find the pair with the **greatest difference**.

---

### [41:03](https://youtu.be/E2fdp5mDZkE?t=2463) Approach 1: Brute Force — O(n²)

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

### [18:53](https://youtu.be/E2fdp5mDZkE?t=1133) Approach 2: Track Minimum Price in a Single Pass — O(n)

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

### [19:04](https://youtu.be/E2fdp5mDZkE?t=1144) Why initialize `min_price` to something huge?

Counterintuitive but necessary: we need a sentinel value **higher than any possible input** so the very first real price always replaces it. The problem constraints say prices go up to `10^4`, so `10001` or `float('inf')` both work.

### [43:42](https://youtu.be/E2fdp5mDZkE?t=2622) Walking through the algorithm on `[7, 1, 5, 3, 6, 4]`

| p | min_price | diff = p - min_price | best_diff |
|---|-----------|----------------------|-----------|
| 7 | 7         | 0                    | 0         |
| 1 | 1         | 0                    | 0         |
| 5 | 1         | 4                    | 4         |
| 3 | 1         | 2                    | 4         |
| 6 | 1         | 5                    | 5         |
| 4 | 1         | 3                    | 5         |

Return **5**. Correct.

### [4:36](https://youtu.be/E2fdp5mDZkE?t=276) Why this works even when the global min doesn't give the best profit

Ruby tried to break the algorithm by constructing arrays like `[3, 2, 1, 5, 6, ...]` where the global minimum appears mid-array. It still works because **`min_price` is updated *before* the difference is computed** at each step. By the time you reach a potential sell price, `min_price` holds the minimum *up to that point* — which is exactly what you need (you can only sell after you buy).

> "That's pretty sleek. And that's why we set those values outside of the loop first, so that we have something to compare against."

### [28:56](https://youtu.be/E2fdp5mDZkE?t=1736) Style feedback

- Very Pythonic — three lines inside a `for` loop. Concise.
- Ternary-style assignment (`x = a if cond else b`) is idiomatic, but for readability some would prefer a plain `if` statement:

```python
if p < min_price:
    min_price = p
```

> "Pythonic ways favor one-liners, but it's more human-friendly to break it out as a usual if statement."

---

### [43:47](https://youtu.be/E2fdp5mDZkE?t=2627) Approach 3: Sliding Window / Two Pointers (Attempted)

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

### [21:02](https://youtu.be/E2fdp5mDZkE?t=1262) Takeaway on sliding window here

- Same O(n) complexity as the min-tracking approach.
- Doesn't obviously improve over it.
- The min-tracking approach is already optimal for this problem — you can't do better than O(n) because you must examine every price at least once.

---

## [10:17](https://youtu.be/E2fdp5mDZkE?t=617) Key Takeaways

- **Start with brute force** to get *a* working solution, then optimize. Do not stall trying to find the perfect solution first.
- **Single-pass "running minimum/maximum"** is a key pattern for array problems that ask about pairs with constraints like `i < j`.
- **Initialize sentinel values outside the bounds** of the input data (`float('inf')`, `float('-inf')`, or values beyond the constraint limits).
- **Update state *before* computing derived values** in a single pass — this is why `min_price` must be updated before computing `diff`.
- **Well-named variables** (`min_price`, `best_diff`, `diff`) make code self-documenting.
- **Python one-liners vs. readability:** concise is idiomatic, but readable wins when reviewing.
- **O(n) is optimal** for problems where you must examine each element at least once — don't waste time looking for O(log n) that doesn't exist.
- **Research during an interview is not allowed.** Problems requiring deep prior knowledge are rare outside FAANG-level interviews and will not appear in Joy of Coding's technical interview.
