# Ruby Solutions Deep Dive — December 10, 2025
Source: https://youtu.be/VGk_bq8RY_o

Mock interview on **Arranging Coins** (LeetCode Easy). Deep coaching on the shift from manual step-by-step reasoning to **programmatic algorithmic thinking**.

---

## [19:47](https://youtu.be/VGk_bq8RY_o?t=1187) Problem: Arranging Coins

> You have `n` coins and you want to build a staircase with them. The staircase consists of `k` rows where the `i`th row has exactly `i` coins. The last row of the staircase may be incomplete. Given `n`, return the number of **complete** rows of the staircase you can build.

### [46:01](https://youtu.be/VGk_bq8RY_o?t=2761) Examples

- `n = 5` → `2` (rows of 1 and 2 coins; the 3rd row needs 3 but only 2 remain)
- `n = 8` → `3` (rows of 1, 2, and 3 coins; the 4th row needs 4 but only 2 remain)

---

## [51:24](https://youtu.be/VGk_bq8RY_o?t=3084) Linda's Journey: Manual Reasoning → Code

Linda understood the problem immediately by working through the examples:

- Row 1 needs 1 coin
- Row 2 needs 2 coins (cumulative: 3)
- Row 3 needs 3 coins (cumulative: 6)
- Stop when the next row can't be filled

### [16:56](https://youtu.be/VGk_bq8RY_o?t=1016) Her Manual Process

For `n = 5`:
- `5 - 1 = 4` (row 1 filled)
- `4 - 2 = 2` (row 2 filled)
- `2 - 3 = -1` (row 3 can't be filled) → return **2**

For `n = 8`:
- `8 - 1 = 7`
- `7 - 2 = 5`
- `5 - 3 = 2`
- `2 - 4 = -2` → return **3**

### [41:25](https://youtu.be/VGk_bq8RY_o?t=2485) The Blocker: Translating To Code

Linda could see the answer manually but couldn't express the iterative process in code. She tried to hard-code each subtraction as an `if/else` ladder before eventually recognizing it needed to be a `while` loop.

---

## [14:11](https://youtu.be/VGk_bq8RY_o?t=851) [approx] The Correct Solution

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

### [17:01](https://youtu.be/VGk_bq8RY_o?t=1021) [approx] Walkthrough

- **`row`** tracks how many coins the current row needs.
- **`count`** tracks completed rows.
- **`while n >= row`** — as long as we have enough coins for the next row, continue.
- Subtract the row's cost, increment the counter, bump the row size.

---

## [40:51](https://youtu.be/VGk_bq8RY_o?t=2451) Key Coaching Moment: Updating The Loop Variable

Linda wrote a while loop whose condition depended on `n`, but never actually updated `n` inside the loop body. The coach walked her through it:

> "For your while loop to work, if `n` isn't updating, what's it going to do? It's going to go on forever."

### [22:41](https://youtu.be/VGk_bq8RY_o?t=1361) [approx] The Fix

```python
n -= 1  # or n -= row, using the subtraction pattern
```

The subtraction Linda was computing inside the `if` condition produced a number, but she wasn't **assigning** that number back to `n`. The while loop kept checking the same unchanged value.

### [35:30](https://youtu.be/VGk_bq8RY_o?t=2130) Coach's Core Point

> "You're doing a calculation, and the calculation returns a number, but you have to update your variable if you want your while loop to end."

---

## [15:40](https://youtu.be/VGk_bq8RY_o?t=940) The Bigger Issue: Programmatic Thinking

Linda's struggle wasn't technical — she understood `while`, `if`, and variable manipulation. It was **translating a mental model into step-by-step iterative instructions**.

### [39:43](https://youtu.be/VGk_bq8RY_o?t=2383) Coach's Diagnosis

> "I don't think you have a technical issue or a problem-solving issue. What I'm seeing is that you're having trouble thinking programmatically — putting an algorithmic step into a series of steps. You need to see the whole thing outlined all at once."

> "You're trying to solve every step of the problem before doing anything. You don't want to calculate how you'll do each interaction — that's where the while loop comes in. You focus on one step at a time: what's my first step? What comes after? Give the code instructions, let it do the work for you."

### [44:24](https://youtu.be/VGk_bq8RY_o?t=2664) The Shift

- **Before:** "I'll manually compute `5 - 1 - 2 - 3` and check each one"
- **After:** "I'll tell the code to subtract the current row and bump the row counter, and let the while loop do that repeatedly until it can't"

> "Instead of trying to see the full scale mental model of what the code is doing, ask: how can I say what the code is doing on an algorithmic level, step by step? Give it instruction, it does instruction. Give it a while loop, it does a while loop until a certain action is complete."

---

## [49:07](https://youtu.be/VGk_bq8RY_o?t=2947) Coach's Prescription: Pseudo Code With Raw Numbers, No Code

> "When I do pseudo code, if I'm doing pen and paper, I'm using the raw numbers the problem gives me. First step: `5 - 1 = 4`. Draw a box around that: that's row 1. Row 2: I need to put 2 coins, so `4 - 2 = 2`. I do it that way without any code references or structure."

> "Then I go back and write that into pseudo code. 'I need to do this XYZ step. What does that look like in code? Well, that sounds like a while loop. And that sounds like I'm tracking this variable. And that sounds like I'm returning this variable.'"

---

## [46:26](https://youtu.be/VGk_bq8RY_o?t=2786) The Return Statement As An Anchor

> "I always start by asking: what am I returning? You're returning the count of rows you can fill. So I'd write `return rows` first, then work backward — what am I doing with my `rows` variable at each step?"

---

## [42:33](https://youtu.be/VGk_bq8RY_o?t=2553) [approx] Side Tangent: `int object is not iterable`

Rebecca ran into this error. Cause:

```python
for i in 5:  # ERROR: int not iterable
for i in range(5):  # Correct
```

You can't iterate directly over an integer; you need `range(n)`.

---

## [15:47](https://youtu.be/VGk_bq8RY_o?t=947) Error Reading as a Strength

Linda got praise from observers for reading Python syntax errors carefully and correcting indentation errors as they appeared. The coach agreed this is a key skill:

> "Being able to read through the errors, understand them, and make the correct changes — you've got a lot of the stuff right. It's that first step that's hanging you up."

---

## [53:31](https://youtu.be/VGk_bq8RY_o?t=3211) Scheduling Note

No session during Christmas week or New Year's week. Next session on December 17.

---

## [35:36](https://youtu.be/VGk_bq8RY_o?t=2136) Takeaways

- **Update your loop variable inside the loop body**, not just in the condition.
- **`n -= row`** is how you reassign — a bare subtraction expression does nothing.
- **Pen-and-paper pseudo code with raw numbers** is a legitimate first pass; don't rush to syntax.
- **Anchor on the return statement** — know what you're returning, then work backward.
- **Don't try to visualize all N iterations at once.** Write what happens in one iteration; let the loop handle the rest.
- **`for i in range(n)`**, not `for i in n`.
