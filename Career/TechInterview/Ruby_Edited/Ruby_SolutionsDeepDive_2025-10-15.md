# Ruby Solutions Deep Dive — October 15, 2025

Walkthrough of **Find the Index of the First Occurrence in a String** with an emphasis on reading constraints, translating problems into your own words, and the role of library methods versus from-scratch implementation. Also: how to effectively reverse-engineer a lookup solution for learning.

---

## Opening: Reverse-Engineering Solutions When You're Stuck

Recap of the prior Sunday's session on using other people's solutions as a learning tool when you've exhausted your own attempts.

### The Process

1. **Exhaust your own effort first.** Debug, break down, understand your failing test cases. Don't jump to the solution at the first sign of struggle.
2. **Look up the solution** when you've genuinely done your due diligence.
3. **Read it line by line.** Add print statements, ask questions, use the debugger until you fully understand how it works.
4. **Write pseudo code for it in your own words** — reverse engineer your understanding.
5. **Delete the solution** and set the pseudo code aside.
6. **Come back in a day or two.** Rewrite the code from your pseudo code, Googling specific syntax questions (like how to insert into a dictionary) as they come up — that's normal developer work.

> "You're learning the solution, you're learning to reverse engineer it, you're learning what good pseudo code looks like, and you're learning not to rely on pasting in a solution but actually applying the knowledge you just gained."

### Bonus Benefit: Reading Other People's Code

> "That's huge. Even when you get to the internship, you'll be thrown into situations where you need to fix code, and you need to know what it says. Reverse engineering is practice reading unfamiliar code."

---

## Chat GPT & Learning

Side discussion sparked by a participant in the low-code internship. Coach's take on AI assistants during learning:

> "Chat GPT is great for when you already know what you want to do — it's helping you, it's assisting you. But if you're using it because you're not sure how to make the next step, that's when you want to pause and ask: is this actually helping me learn, or is it doing the learning and I'm just floating through?"

If your goal is to go to the full-stack or front-end internship, **put Chat GPT on pause until later**. If your goal is to stay in low code, become an expert prompter — either way, know which you're choosing.

---

## Problem: Find the Index of the First Occurrence in a String

> Given two strings `needle` and `haystack`, return the index of the first occurrence of `needle` in `haystack`, or `-1` if `needle` is not part of `haystack`.

### Example 1

- `haystack = "sadbutsad"`, `needle = "sad"` → `0`
- `"sad"` occurs at indices `0` and `6`; first occurrence is at `0`.

### Example 2

- `haystack = "leetcode"`, `needle = "leeto"` → `-1`

---

## Translating the Problem Into Your Own Words

> "It's very important to write it in your own words. Make the translation of what they're telling you into how you are understanding it."

```
Given string `needle`, find exact string match as a substring within `haystack`.
If we find a string match (e.g. "sad" in "sadbutsad"), return the index position
of the first character of the first occurrence.
Return an int representing a valid index position.
If no match, return -1.
```

### The `-1` Sentinel Convention

> "Returning `-1` is very common — you'll see it a lot in library methods. Binary search returns `-1` if nothing matches. It's a standard way to signal 'not found' for anything that normally returns an integer."

---

## Reading the Constraints

```
1 <= haystack.length, needle.length <= 10^4
haystack and needle consist of only lowercase English characters.
```

### What the Constraints Do NOT Tell Us

The constraints give bounds on **each** length independently, but they do **not** say that `needle.length <= haystack.length`. So `needle` could in theory be **larger** than `haystack`.

> "It's not specifically telling me those implementation details, so I have to account for both possibilities — that's what you get from the constraint."

### What the Constraints DO Tell Us

- Both strings are **non-empty** (length >= 1).
- Only **lowercase English characters** — no whitespace, unicode, or special characters to parse out. Exact string matches work.

### Resulting Pseudo Code Addition

```
Check that haystack.length >= needle.length.
Otherwise return -1.
Then search for needle inside haystack...
```

> "We're not assuming needle is smaller than haystack. We're assuming it's possible that it is. Since the problem doesn't promise otherwise, we're almost guaranteed to see a test case where needle > haystack."

---

## First Approach Attempt: `in` Operator

A participant defaulted to a `for` loop. The coach nudged toward a simpler first check:

```python
print("sad" in "sadbutsad")  # True
```

The `in` operator tests substring containment and returns a bool. That's a useful confirmation but it **only tells you if the match exists** — it does not give you the index.

> "An `if` statement is testing a condition that returns true or false. But you don't actually need the `if` to test the condition — you can write the condition directly."

---

## Second Approach: `str.find()`

Googling "how to get the index of a character in a string" surfaces two Python string methods:

### `str.find(substring)`

- Returns the **first index** where `substring` occurs.
- Returns **`-1`** if not found.
- **This matches the problem signature exactly.**

### `str.index(substring)`

- Same as `find()` on success.
- **Raises `ValueError`** if not found.

### Why the Two Variants Exist

> "In production, maybe you're checking an API response or a data exchange, and if the thing isn't there you need to throw an error and surface it on the front end. Instead of checking for `-1` and writing the error yourself, `index` does it for you."

### Final Solution

```python
class Solution:
    def strStr(self, haystack: str, needle: str) -> int:
        return haystack.find(needle)
```

**One line.** Beats high percentile on runtime. The coach contrasted with a participant's working for-loop solution that also beat 100%.

---

## Is the One-Liner "Preferred"?

A participant asked whether using the library method counts as cheating or is preferred in an interview.

> "It wouldn't matter to me. You knew the method, you learned it, you applied it, we solved all the test cases. The purpose of the technical interview isn't to confirm you can code from scratch — that's just a muscle you build over your career."

> "'There is no intellectual work other than knowing that the function exists.' — That IS intellectual work. Knowing `find` exists, knowing what it takes and returns, knowing how to implement it to solve a problem — that is knowledge."

**Use library methods.** Both in the Joy of Coding interview and in real-world interviews. But also understand **how** they work under the hood so you can solve problems in environments where the method doesn't exist.

---

## The Challenge: Reverse-Engineer `find`

The coach's homework: solve this problem **without** any library method. Research how `find` works behind the scenes, write pseudo code from that explanation, delete the reference, and implement it from scratch.

### Why Bother?

> "All the little sub-parts — the if condition, the for loop, checking for a specific index, returning the index — show up in almost every problem. If you can master doing that part from scratch, you're expanding your ability to solve a wider variety of problems where `find` isn't available."

> "Mod 2 teaches you the bare bones — the foundation — so you could solve any problem without needing a library method. The library methods are shortcuts. You should learn them, but learning the from-scratch version makes you a much stronger developer."

---

## Key Takeaways

- **Read constraints, then determine which assumptions the constraints resolve for you.** Write less code by relying on what the problem guarantees.
- **Write the problem in your own words** before coding.
- **Test a quick idea** (like `"sad" in haystack`) to confirm feasibility before committing to a full approach.
- **Add `find` and `index` to your string methods toolkit.** They differ only in how they signal "not found".
- **`-1` is the standard sentinel** for integer-returning functions when a result isn't available.
