# Ruby Solutions Deep Dive — February 4, 2026
Source: https://youtu.be/SR9qqxnrmTQ

Mock interview on **Richest Customer Wealth** (LeetCode Easy). Textbook clean execution in under 15 minutes — a reference example of a well-run mock.

---

## [5:00](https://youtu.be/SR9qqxnrmTQ?t=300) Problem: Richest Customer Wealth

> You are given an `m x n` integer grid `accounts` where `accounts[i][j]` is the amount of money the `i`-th customer has in the `j`-th bank. Return the wealth that the **richest customer** has.
> A customer's wealth is the amount of money they have in all their bank accounts. The richest customer is the one with the **maximum total wealth**.

### [2:03](https://youtu.be/SR9qqxnrmTQ?t=123) [approx] Example

```
accounts = [[1, 2, 3],
            [3, 2, 1]]
```

- Customer 1 wealth: `1 + 2 + 3 = 6`
- Customer 2 wealth: `3 + 2 + 1 = 6`
- Output: `6`

### [4:07](https://youtu.be/SR9qqxnrmTQ?t=247) [approx] Constraints

- `1 <= m, n <= 50`
- `1 <= accounts[i][j] <= 100`

---

## [6:11](https://youtu.be/SR9qqxnrmTQ?t=371) [approx] Russell's Solution

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

### [4:24](https://youtu.be/SR9qqxnrmTQ?t=264) Process Highlights

1. **Read the problem carefully.** Understood that each sub-array represents a customer's accounts.
2. **Verified `sum()` works on a Python list** before relying on it — ran a quick test returning `sum(accounts[0])` to confirm.
3. **Initialized `greatest = 0`** as the max tracker.
4. **Single-pass comparison** — `if current > greatest: greatest = current`.
5. **Returned the final max.**

### [7:29](https://youtu.be/SR9qqxnrmTQ?t=449) Idiomatic Pythonic Variant

```python
return max(sum(customer) for customer in accounts)
```

Russell's explicit version is clearer for an interview; the one-liner shows language fluency once you're comfortable.

---

## [4:28](https://youtu.be/SR9qqxnrmTQ?t=268) Constraints Check

Coach asked whether the constraints changed the approach:

> "Not really. `m` and `n` are between 1 and 50, values between 1 and 100. The only thing that could affect my approach is if an array could have zero values — then I'd need an error check before the loop."

The constraint `1 <= m, n` guarantees every customer has at least one account and at least one customer exists. **No defensive check needed.**

---

## [15:48](https://youtu.be/SR9qqxnrmTQ?t=948) Coach Feedback

> "You followed pretty much everything we usually recommend. Reading through the problem, getting baseline assumptions, typing out comments of your understanding, quickly prototyping, taking a step out to test the `sum` piece individually, then putting it back. That was all great. You're definitely ready — whenever you want to sign up for the tech interview, go ahead."

---

## [16:30](https://youtu.be/SR9qqxnrmTQ?t=990) [approx] Why This Mock Was Exemplary

- **Assumed nothing, tested everything.** Russell explicitly verified `sum()` on a list worked before relying on it.
- **Talked through his logic at each step**, naming the variables and their purpose.
- **Summarized the problem in his own words** at the start and again at the coach's request after finishing.
- **Checked constraints** and articulated which ones mattered and which didn't.
- **Kept code clean** — no dead code, no speculative variables. Each line had a purpose.
- **Finished well under the 20-minute limit**, leaving room for discussion.

---

## [21:15](https://youtu.be/SR9qqxnrmTQ?t=1275) Resource Pointer

The coach shared the **tech interview rubric** pinned in the Discord `#hackerrank` channel. It's a comprehensive breakdown of:

- **Communication** — how you verbalize during the interview
- **Technical Knowledge** — Mods 1 and 2 concepts
- **Problem-Solving Process** — breaking problems down, pseudo code, testing
- **Behavior** — mindset and habits

The rubric also lists every concept that could appear on the tech interview.

---

## [20:37](https://youtu.be/SR9qqxnrmTQ?t=1237) [approx] Takeaways

- **Initializing `max_so_far = 0` and updating** is a standard pattern for "find the maximum of something" problems.
- **`sum(list)`** just works on any list of numerics in Python.
- **Prototype individual pieces** (like `sum(accounts[0])`) before integrating them into the full solution.
- **Constraints often eliminate defensive code** — check them before adding edge-case handling.
- **Clean verbalization + a simple iteration** is often all a tech interview easy problem requires.
