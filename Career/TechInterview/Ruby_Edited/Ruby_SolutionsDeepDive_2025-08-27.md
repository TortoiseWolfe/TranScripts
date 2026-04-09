# Ruby Solutions Deep Dive — August 27, 2025
Source: https://youtu.be/jJSryNGi6Io

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
