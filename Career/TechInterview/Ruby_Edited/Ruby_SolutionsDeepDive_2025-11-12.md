# Ruby Solutions Deep Dive — November 12, 2025
Source: https://youtu.be/o9QJY4aS--4

Deep dive on LeetCode's **Repeated Substring Pattern** (Easy), including assumption-testing methodology, Mauricio's O(n²) solution, and a discussion on "patterns vs templates" in interview prep.

---

## [0:00](https://youtu.be/o9QJY4aS--4?t=0) [approx] LeetCode vs HackerRank Setup

A participant asked about LeetCode's mandatory `class Solution:` wrapper vs writing standalone functions. Verdict:

> "You do have to keep the class. When they run test cases, they create an object from the `Solution` class and call the function as a method. You can still write and test anything you want inside the function — the class just has to stay there."

> "LeetCode makes you find edge cases. HackerRank gives you more info up front. HackerRank is definitely better for beginners."

---

## [7:53](https://youtu.be/o9QJY4aS--4?t=473) Problem: Repeated Substring Pattern

> Given a string `s`, check if it can be constructed by taking a substring of it and appending multiple copies of the substring together.

### [5:37](https://youtu.be/o9QJY4aS--4?t=337) [approx] Examples

- `"abab"` → `true` (`"ab"` × 2)
- `"aba"` → `false` (no substring tiles the whole string)
- `"abcabcabcabc"` → `true` (`"abc"` × 4)

### [8:25](https://youtu.be/o9QJY4aS--4?t=505) [approx] Constraints

- `1 <= s.length <= 10^4`
- `s` consists only of lowercase English letters.

---

## [10:03](https://youtu.be/o9QJY4aS--4?t=603) Assumption-Testing Methodology

The coach demonstrated how to use LeetCode's custom test case box as an **assumption laboratory** before writing any real code:

### [36:05](https://youtu.be/o9QJY4aS--4?t=2165) Assumption 1: Does a single character count?

Test case: `"a"`. Expected output: `false`.

> "A length of 1 is NOT considered repeating."

### [36:05](https://youtu.be/o9QJY4aS--4?t=2165) Assumption 2: Does a single character repeated count?

Test case: `"aaa"`. Expected output: `true`.

> "A repeated single character IS considered a repeating substring."

### [1:04:14](https://youtu.be/o9QJY4aS--4?t=3854) Assumption 3: Does odd vs even length matter?

Initially the coach thought all valid answers would have even length. But `"abcabcabc"` (length 9) is valid. **Length parity doesn't matter.**

> "If you're having a question or assumption about the problem, write it out at the very top. Even if you haven't started developing an approach, get some questions down that you can test or see if the problem answers for you."

### [14:52](https://youtu.be/o9QJY4aS--4?t=892) LeetCode vs HackerRank Custom Tests

- **LeetCode** shows you the expected output for custom test cases.
- **HackerRank** lets you add custom test cases but doesn't show expected output — you have to use `assert` or print statements to validate.

---

## [25:16](https://youtu.be/o9QJY4aS--4?t=1516) [approx] Mauricio's Solution

```python
class Solution:
    def repeatedSubstringPattern(self, s: str) -> bool:
        n = len(s)
        for sub in range(1, n):
            if n % sub == 0:
                candidate = s[:sub]
                if candidate * (n // sub) == s:
                    return True
        return False
```

### [3:54](https://youtu.be/o9QJY4aS--4?t=234) How It Works

- **`sub`** is the candidate substring length, iterating from 1 up to `n - 1`.
- **`n % sub == 0`** filter — if `sub` doesn't evenly divide the string length, it can't possibly tile the string. Skip it.
- **`s[:sub]`** slices the candidate substring from the start.
- **`candidate * (n // sub)`** repeats the candidate the required number of times.
- **String comparison** `== s` checks whether the reconstruction matches the original.

### [38:43](https://youtu.be/o9QJY4aS--4?t=2323) Key Insight

> "If a string forms itself by repeating a substring, the substring must fit evenly into the length. So I'm only interested in substrings whose length divides the total length."

---

## [33:42](https://youtu.be/o9QJY4aS--4?t=2022) [approx] Big O Analysis

### [36:30](https://youtu.be/o9QJY4aS--4?t=2190) [approx] Time Complexity: O(n²)

- Outer loop iterates up to `n` candidate lengths.
- Inside each iteration, **string concatenation and comparison are each O(n)** operations — Python has to build the repeated string character-by-character.
- Nested O(n) inside O(n) → **O(n²)** in the worst case.

> "The filter `n % sub == 0` only skips some iterations — it still moves through a linear amount of inputs. At worst it's still O(n²). That doesn't mean it's a bad solution — it just means you should be able to answer this question for the job hunt."

### [0:35](https://youtu.be/o9QJY4aS--4?t=35) Coach's Clarification on Mauricio's Confusion

Mauricio objected that as `sub` grows, the number of repetitions `n // sub` shrinks, so the work per iteration shrinks too. True — the total work is closer to `n * H(n)` (harmonic) than `n²`, but for interview discussion, **worst case big O is what matters**, and that's O(n²) when concatenation dominates.

---

## [8:22](https://youtu.be/o9QJY4aS--4?t=502) Conceptual Sticking Point (Breakout Room)

A participant (Linda) struggled because she expected **two parameters** — a string and a substring — and the function only gives one. The group walked through:

> "You have to adapt your understanding to what the problem gives you. You're not given the substring. You have to figure out all the possible combinations of what the substring could be, or if no combination works, return false."

### [49:47](https://youtu.be/o9QJY4aS--4?t=2987) The Brute Force Mental Model

- Start with **window size 1** — take the first character. Repeat it across the full length. Does it equal `s`?
- If no, **window size 2** — take the first two characters. Repeat. Does it equal `s`?
- Continue until you find a match or exhaust options up to `n - 1`.

### [48:29](https://youtu.be/o9QJY4aS--4?t=2909) Critical Observation

> "The first string that will repeat has to come from the beginning of the string. Whatever's at the front has to also be repeated towards the end. We couldn't say `cab` in the middle — the prefix is what we test."

---

## [1:03:53](https://youtu.be/o9QJY4aS--4?t=3833) Using `str.count()` As An Alternative

A participant asked whether Python has a built-in like "tell me if a letter is repeated". Coach's answer:

> "Close — `count` would work. You'd have to save the count to a variable and compare it against the potential length. But yeah, that's basically what we just discussed."

---

## [56:03](https://youtu.be/o9QJY4aS--4?t=3363) Patterns vs Templates Discussion

Mauricio asked about the "four pillars of problem solving" framework, specifically the "find your template" step. Is that the same as pattern recognition (sliding window, binary search, etc.)?

### [1:02:17](https://youtu.be/o9QJY4aS--4?t=3737) Coach's Take

> "I wouldn't call that a template. I'd call it understanding the problem and knowing what to apply — what data structure, what algorithm, what logical approach."

> "When I think of 'template,' I think of starter code. Pasting in even a modified sliding-window template is pasting in most of the work the interviewer expects you to show."

> "An interview isn't just getting the code working. It's showing that you can break down the problem, what assumptions you're making, what questions you're asking, how you're checking your work at each step. Those are all problem-solving skills."

### [57:22](https://youtu.be/o9QJY4aS--4?t=3442) Mauricio's Counterpoint

> "After doing hundreds of problems, you recognize patterns. A sliding window in its most basic form is an algorithm — that's your starting point, and you adapt it to the problem. You already understand the basic principle, so you use it and tweak it."

### [1:01:38](https://youtu.be/o9QJY4aS--4?t=3698) Coach's Resolution

> "Yeah — if you're taking the basic sliding window, writing it out yourself, and then saying 'I'm going to use this approach but modify it to work through this problem,' that's fine. There are problems that specifically require that, like ones that use the **concepts** of binary search without being literal binary search."

---

## [18:38](https://youtu.be/o9QJY4aS--4?t=1118) Takeaways

- **Write assumptions as comments at the top** of your code and test them against provided examples.
- **Use LeetCode custom test cases as an assumption lab** — change the input, see the expected output.
- **String concatenation is O(n)** — nesting it inside another loop often gives you O(n²) overall.
- **Patterns ≠ templates.** Recognizing a sliding-window problem is valuable; pasting a template is not.
- **Problem-solving visibility matters more than raw correctness** in an interview.
- **Start with the shortest window and grow.** The prefix constraint means any valid repeating substring must begin at index 0.
