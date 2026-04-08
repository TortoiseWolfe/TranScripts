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
