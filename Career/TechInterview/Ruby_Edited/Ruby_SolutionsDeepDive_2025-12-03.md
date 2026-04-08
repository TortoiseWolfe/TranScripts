# Ruby Solutions Deep Dive — December 3, 2025

Q&A on variable scope and Python basics, followed by a mock interview on **Happy Number** (LeetCode Easy).

---

## Q: Variable Scope For Temporary Lists

> "When you're setting up a temporary list inside a loop to collect values for later comparison, does it have to be initialized outside the loop?"

### Answer: Yes — Variable Scoping

> "If you want the list to persist for the life of the loop, it has to exist before the loop starts. You put it outside the loop and refer to it from inside."

### Scope Refresher

Each kind of enclosure creates its own scope:

- **Global scope** — the module level.
- **Function scope** — variables defined inside a function.
- **Loop scope / if scope** — variables declared inside a `for`, `while`, or `if` block. These may persist to the enclosing function in Python (unlike some other languages), but a list rebuilt inside the loop is reset every iteration unless you assign to an outer variable.

> "This trips people up a lot when they're nervous — they forget where the scope goes."

---

## Q: What Can Go On Flash Cards For The Interview?

> "You can use pseudo code or basic syntax examples — what a for loop looks like, how to convert a string to an int. Nothing where you're actually performing an algorithmic function within it. About the same level of what you would Google."

### Allowed

- `int(num_str)` — convert string to int
- `str(num)` — convert int to string
- Basic for loop syntax
- Dictionary access patterns
- List comprehensions

### Not Allowed

- Full solved problems
- Sliding window or binary search templates
- Any complete algorithmic step

---

## Elementary Python Gotchas

A participant noted that **basic things** trip her up:

### String-to-Int for Addition

```python
num1 = input("Enter first number: ")
num2 = input("Enter second number: ")
# num1 + num2 produces "52" for 5 and 2, not 7
result = int(num1) + int(num2)
```

`input()` returns a **string**. You must cast to `int` before arithmetic.

### Accessing Elements vs Indexes in Loops

```python
# Index-based access
for i in range(len(s)):
    if s[i] == target:  # s[i] is the element at index i
        ...

# Value-based iteration
for char in s:
    if char == target:  # char is the element directly
        ...
```

> "At any given point, what am I accessing? Is it the index, or the actual value? Print that out and make sure you're seeing what you expect."

---

## Career Phase Question: What Comes After This?

Clarification on the phase sequence:

- **Explorer phase** — Trello tickets, ~9-10 tasks. Includes a basic JavaScript app that converts to React, then a Next.js app. Full-stack building practice.
- **Career strategy call with Dr. Emily** — end of the explorer phase.
- **Internship** — after explorer.

The career strategy call does **not** change the explorer phase contents.

### Program Sunset Schedule

- **New signups end in February.**
- **Support continues through November** of the following year for existing members.
- Coach Ruby plans to continue hosting these sessions for the foreseeable future.

---

## Mock Interview: Happy Number (Lisa)

### Problem

> Write an algorithm to determine if a number `n` is happy. A happy number is defined by:
> 1. Starting with any positive integer, replace the number by the sum of the squares of its digits.
> 2. Repeat the process until the number equals 1 (where it will stay), or it loops endlessly in a cycle that does not include 1.
> Return `true` if `n` is a happy number, `false` otherwise.

### Example

`n = 19`:
- `1² + 9² = 1 + 81 = 82`
- `8² + 2² = 64 + 4 = 68`
- `6² + 8² = 36 + 64 = 100`
- `1² + 0² + 0² = 1` → **happy, return true**

### Lisa's Approach

1. Convert `n` to a string to access individual digits.
2. Loop over each character, convert back to int, square, accumulate a sum.
3. Test whether the sum equals 1.
4. If not, repeat the process on the new sum.

### Implementation Sketch

```python
class Solution:
    def isHappy(self, n: int) -> bool:
        seen = set()
        while n != 1 and n not in seen:
            seen.add(n)
            total = 0
            for digit in str(n):
                total += int(digit) ** 2
            n = total
        return n == 1
```

Lisa identified that she needed **another loop** — an outer loop to repeat the sum-of-squares process — but ran out of time before finishing the implementation.

### Coach Feedback: Break Down Before Coding

> "It would have helped to spend more time in pseudo code to think about it. You know you need to break the number into digits, square them, sum them — you jumped right into that. That's a good place to start, but we got stuck on that step. If we'd taken a step back and asked what the overall strategy looks like, that might have saved time."

### Coach Feedback: Read The Two Termination Conditions Early

> "The problem says it either ends at 1 or cycles endlessly. That makes me think I want to walk through a few more steps — if it can cycle endlessly, that's more than one operation, which means a `while` loop from the start. You don't know exactly how you'll use it yet, but you can pull it out as a game plan element."

### The Cycle Detection Problem

The hardest part of Happy Number is **detecting the infinite loop**. Two common approaches:

1. **Seen set** — track every number you've computed; if you hit a repeat, you're in a cycle. Return false.
2. **Floyd's cycle detection** — use two pointers advancing at different speeds. If they meet at a value that isn't 1, you're in a cycle.

---

## Asking For Help The Right Way

> "When you're asking for help, don't just say 'I'm stuck, what do I do?' Say 'Here's what I've done, here's where I'm thinking, does anyone have advice for the exact next step I might consider?'"

---

## Takeaways

- **Initialize collector variables outside the loop** that uses them.
- **Flash cards should mirror what you'd Google** — no full solutions.
- **`input()` returns a string** — cast before arithmetic.
- **Print the value of your loop variable** early to confirm whether you have an index or an element.
- **On problems with two termination conditions**, plan the outer loop before writing the inner logic.
- **Cycle detection via a `seen` set** is the standard trick for Happy Number and similar problems.
