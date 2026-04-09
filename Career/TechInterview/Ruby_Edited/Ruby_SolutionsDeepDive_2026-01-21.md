# Ruby Solutions Deep Dive — January 21, 2026
Source: https://youtu.be/ayvXEbzZpNY

Group mock interview on **Find if Digit Game Can Be Won** (LeetCode Easy). Experiment with collaborative pseudo code — the group acts as a sounding board during planning, then goes silent during the coding phase.

---

## [1:41](https://youtu.be/ayvXEbzZpNY?t=101) Experimental Format

> "The volunteer leads their own mock interview. During pseudo code, use the group as a sounding board — ask us questions, see what we think, but you're the main stakeholder. Once you're ready to code, we all go silent."

Rationale: if the pre-code phase is a blocker, this collaborative mode lets candidates practice it with support. If it's not a blocker, they can skip straight to coding.

---

## [4:38](https://youtu.be/ayvXEbzZpNY?t=278) Problem: Find if Digit Game Can Be Won

> You are given an array of positive integers `nums`. Alice and Bob are playing a game. In the game, Alice can choose either all single-digit numbers or all double-digit numbers from `nums`, and the rest of the numbers are given to Bob. Alice wins if the sum of her numbers is **strictly greater than** the sum of Bob's numbers. Return `true` if Alice can win, `false` otherwise.

### [16:14](https://youtu.be/ayvXEbzZpNY?t=974) Examples

- `[1, 2, 3, 4, 10]` → `false` (singles sum to 10, doubles sum to 10 — a tie)
- `[1, 2, 3, 4, 5, 14]` → `true` (singles sum to 15 > 14)
- `[5, 5, 5, 25]` → `true` (doubles sum to 25 > 15)

### [7:18](https://youtu.be/ayvXEbzZpNY?t=438) [approx] Constraints

- `1 <= nums.length <= 100`
- `1 <= nums[i] <= 99` (no triple digits)

---

## [9:44](https://youtu.be/ayvXEbzZpNY?t=584) [approx] Lisa's Pseudo Code

- Return `true` or `false`.
- Sum the single-digit numbers → **Alice**.
- Sum the double-digit numbers → **Bob**.
- Compare: return `true` if Alice's sum > Bob's sum OR Bob's sum > Alice's sum. Return `false` if equal.

### [10:31](https://youtu.be/ayvXEbzZpNY?t=631) Key Assumption Made

> "Equal is a tie — she can't win. The only thing we really need to test for is if they're equal."

### [18:26](https://youtu.be/ayvXEbzZpNY?t=1106) Single vs Double Digit Check

Lisa proposed: `if num < 10, add to Alice; else add to Bob`.

---

## [23:59](https://youtu.be/ayvXEbzZpNY?t=1439) Side Question: Does Example With One Double Digit Matter?

A participant asked whether the examples guarantee only one double digit per input. Coach's response:

> "That's an assumption. Ask it, write it down. Look at the phrasing of the problem statement. If that's not clear, look at the constraints. If that's still unclear, run tests or build the check into your pseudo code."

Verdict: you should **assume multiple double digits are possible** because the constraints don't forbid it. The sum logic handles both cases naturally anyway.

---

## [19:29](https://youtu.be/ayvXEbzZpNY?t=1169) [approx] First Implementation (With Lists)

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

### [5:22](https://youtu.be/ayvXEbzZpNY?t=322) Why Only `!=` Works

The question is: can Alice win by choosing **one** of the two groups? She always picks the winning group. So as long as the two sums aren't equal, she can win by picking the larger one. **Equality is the only loss condition.**

---

## [33:35](https://youtu.be/ayvXEbzZpNY?t=2015) Coach Feedback: Do You Need The Lists At All?

> "You're using a pretty intense data structure — a list — to store and then sum values. But if you already know the contents are being properly separated, do you need to store them in a list, or can you just sum them?"

### [26:48](https://youtu.be/ayvXEbzZpNY?t=1608) [approx] Refactor: Sum In Place

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

### [31:50](https://youtu.be/ayvXEbzZpNY?t=1910) Performance Note

Lisa's first submission was in the upper end of runtime percentile because of the list allocations. Sum-in-place is meaningfully faster even at small input sizes because it skips the list construction entirely.

---

## [18:34](https://youtu.be/ayvXEbzZpNY?t=1114) The "Can I Do This Without A List?" Question

Lisa tried to find the Python feature for "sum with a condition" and got stuck.

> "You can sum them in place. Alice starts at 0, Bob starts at 0. If it's a single digit, add to Alice. If it's double, add to Bob. Keep track of their sums separately."

For reference, more concise alternatives exist using generator expressions:

```python
alice = sum(n for n in nums if n < 10)
bob = sum(n for n in nums if n >= 10)
```

But the explicit accumulator loop is just as correct and clearer when you're still building fluency.

---

## [8:50](https://youtu.be/ayvXEbzZpNY?t=530) Key Interview Skills Demonstrated

1. **Restating the goal:** "Determine if Alice can win the game" — clear and concise.
2. **Confirming assumptions with the group** before coding (ties = loss, multiple doubles possible).
3. **Writing pseudo code before touching real code.**
4. **Being willing to refactor** when the coach suggested the list was unnecessary.

---

## [36:33](https://youtu.be/ayvXEbzZpNY?t=2193) [approx] Takeaways

- **Accumulate sums in integer variables, not lists**, when you don't need the individual values later.
- **`a != b` is equivalent to `a > b or b > a`** when one side always wins — simpler and more intuitive.
- **Assumptions about input variety should default to "anything the constraints allow."** Don't assume single double-digit numbers just because the examples only show one.
- **Group pseudo-coding** can be a useful hybrid practice format before going silent for the coding phase.
- **Two accumulators in one pass is O(n) time and O(1) space** — optimal for this problem.
