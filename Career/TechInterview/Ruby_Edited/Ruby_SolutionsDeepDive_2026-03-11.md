# Ruby Solutions Deep Dive — March 11, 2026
Source: https://youtu.be/Y5MNKdxSOnk

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
