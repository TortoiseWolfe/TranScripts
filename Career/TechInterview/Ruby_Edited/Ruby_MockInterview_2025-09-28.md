# Ruby Mock Interview — September 28, 2025

*Nailing the Tech Interview — Sunday session*

## Extended Q&A: How Long to Stay Stuck Before Looking Up a Solution?

**Mauricio asked:** when you're stuck on a problem and can't pass test cases, how long should you stay with it before looking up a solution?

### Ruby's framework: identify which phase you're stuck in

There are multiple phases of working through a LeetCode/HackerRank problem, and **what you should do depends on which phase you're stuck in**:

1. **Reading and understanding the problem**
2. **Understanding requirements, constraints, inputs, and outputs**
3. **Explaining the problem in your own words and writing assumptions**
4. **Writing pseudo code to translate the solution into steps**
5. **Writing code and testing assumptions (from problem and pseudo code)**
6. **Debugging / problem solving** — what are errors telling me, what is my code doing, what do I want it to do?

These phases aren't strictly linear — you often bounce between them. And you can collapse several into one for simple problems you've seen before.

### General time guidelines

- **Easy problems:** if you've spent **over an hour** and haven't gotten two-thirds of test cases passing, look up resources.
- **Medium problems:** maybe **an hour or so**, then **walk away** and come back a day or two later and start fresh rather than looking it up immediately.
- Goal: **get at least two-thirds of test cases passing** before looking up the full solution.

### What to do based on where you're stuck

**Stuck understanding the problem:**

- Focus on the information given: constraints, inputs, outputs.
- Rewrite the problem in your own simplest words.
- Draw visual diagrams if you're a visual learner.
- Walk through the sample explanation step by step in your own words.

**Stuck on constraints or input/output meaning:**

- Use Google. Look up unfamiliar symbols (like `|s|` for length) or data types.
- Use **print statements** to show what your data actually looks like.
- Read the error messages carefully and look them up if unclear.

**Stuck at pseudo code:**

- Go back to mod 2 and look for similar problems.
- Ask: what data structures might fit? Does it need a loop, a function, a dictionary?
- Look up resources on specific concepts, not solutions.

**Stuck on a working solution (code written but not passing):**

- Problem solve: what assumptions can I test?
- Print everything along the way. Compare expected output vs. actual output.
- If the expected is 5 and you're returning 7, **trace back why** you're returning 7. Maybe an assumption was wrong.

### The "stuck in a loop" problem

Mauricio: "I get stuck in a loop where I keep coding to pass the next test case and not generalizing. I realize the path is wrong but can't see another path to take."

- At that point, **revisit the earlier phases**. Did you fully understand the problem? Did you test your original assumptions?
- Take it to a **peer mentor office hours** or a **Q&A session** and say, "Here's where I'm at. Can you give me pointers?" A good mentor will **ask you questions** rather than hand you the answer, so you still make the connections yourself.

### After looking up a solution

Even after researching, there's still valuable work to do:

- **Code the solution in your own hands** — don't just read it.
- **Come back a week later** and try to solve it from scratch from memory.
- **Try different approaches** that use the same core concept — different data structure, different loop, etc.
- Add the technique to your toolkit so you can apply it to future problems.

> "Instead of having one solution that I had to look up, I have three solutions that I know and I could potentially extrapolate to new problems."

### 80/20 on algorithmic prerequisites

- About **80% of problems** can be solved with just mod 2 fundamentals.
- About **20% of problems** require specialized knowledge (named algorithms, advanced applications of data structures) that you may legitimately need to research.
- **Time-out failures** on otherwise-correct solutions are a signal you need the optimized version — that's a "learn and add to toolkit" moment, not a "beat yourself up" moment.

> "Medium and hard level problems were meant to trip you up. That's how they were made."

---

## The 6 Phases Framework (Reference)

| Phase | What you do |
|-------|-------------|
| 1 | Read and understand the problem |
| 2 | Understand requirements (constraints, inputs, outputs) |
| 3 | Explain problem in your own words, write assumptions |
| 4 | Write pseudo code translating solution into steps |
| 5 | Write code, test assumptions from problem and pseudo code |
| 6 | Debug / problem solve (applies at any phase) |

Phase 6 is a **meta-phase** — what it looks like depends on which of phases 1–5 you're actually stuck in.

---

## Worked Example: Repeated String (HackerRank)

Ruby walked through this problem using the 6-phase framework explicitly.

### Problem statement

There is a string `s` of lowercase English letters that is repeated infinitely many times. Given an integer `n`, find and return the number of letter `'a'`'s in the **first `n` letters** of the infinite string.

### Examples

```
s = "abcac", n = 10   -> 4
  The first 10 chars of "abcacabcac..." are "abcacabcac", containing 4 a's.

s = "aba", n = 10     -> 7
  The first 10 chars of "abaabaabaab" contain 7 a's.

s = "a", n = 1000000000000 -> 1000000000000
  A string of all 'a's, so the count is just n.
```

### Constraints

- `1 <= |s| <= 100` (where `|s|` is the length of s in mathematical notation)
- `1 <= n <= 10^12`
- For 25% of test cases, `n <= 10^6`

### Note on the `|s|` notation

The vertical bars `|s|` in constraints are **absolute value notation** in math, which for a string represents its **length** (number of characters). If you don't know a symbol in constraints, Google it or check Stack Overflow.

### Phase 1: Reading and Understanding

First read of the problem is often confusing. Take a deep breath, read again. Pull out:

- We have a short string `s`.
- It repeats infinitely.
- We care about the first `n` characters.
- Count the `'a'`s in that range.

### Phase 3: Explain in your own words and write assumptions

> "Given `s`, which is the smallest range of characters in an infinitely repeating sequence, and `n`, an integer representing the length I need to construct — return the number of `'a'`s in the constructed string up to length `n`."

**Initial assumption:** `s` will be shorter than `n`.

### Phase 2: Check constraints to test the assumption

- `|s|` can be `1 <= |s| <= 100`
- `n` can be `1 <= n <= 10^12`

These are **independent ranges**. `s` could theoretically be length 100 while `n` is 1. So the assumption **"s will always be shorter than n" is FALSE**.

**Updated pseudo code note:** add a conditional check for whether `s` is shorter or longer than `n` before building.

### Another assumption to check: Is `'a'` always included in `s`?

The problem says `s` is "a string to repeat" — it **doesn't** say `s` must contain the character `'a'`. Nothing in the constraints says so either. So **`'a'` may or may not be in `s`** — handle that case (count could be 0).

### Efficiency warning from constraints

`n` can be as large as `10^12`. Building an actual string of length `10^12` would **blow up memory** (and take forever). This is a **space complexity** concern that will cause a **time-out** failure in practice.

> "Do I need to build that string? It takes up a lot of memory."

### Phase 4: Pseudo code (first draft — naive approach)

```
# Build infinite_string out of s up to length n
infinite_string = s
while len(infinite_string) < n:
    infinite_string += s
# Trim to exactly n if overshoot
infinite_string = infinite_string[:n]
# Count a's
count = 0
for ch in infinite_string:
    if ch == 'a':
        count += 1
return count
```

**Problem:** builds a massive string for large `n`. Will time out on tests where `n >= 10^9` or so.

### Phase 6: Efficiency improvement — skip building the string

Key insight: you **don't need to materialize the string**. You just need arithmetic:

- Count the `'a'`s in one copy of `s`. Call this `a_in_s`.
- Figure out how many full copies of `s` fit in `n`: `full_copies = n // len(s)`.
- The "full copies" contribute `full_copies * a_in_s` a's.
- Then handle the **remainder** — the leftover partial string: `remainder_len = n % len(s)`. Count `'a'`s in `s[:remainder_len]` and add.

### Optimized solution

```python
def repeatedString(s, n):
    len_s = len(s)
    a_in_s = s.count('a')
    full_copies = n // len_s
    remainder = n % len_s
    a_in_remainder = s[:remainder].count('a')
    return full_copies * a_in_s + a_in_remainder
```

- **Time:** O(|s|) — only counts a's in the original short string.
- **Space:** O(1) — no massive string built.
- Handles `n = 10^12` instantly.

### Lisa's question and the key insight

Lisa asked early: "Is there a formula to build out the string — like `string * number`?"

Ruby initially said "hold that thought" because she wasn't done reading the problem. But Lisa's instinct was on the right track: **use math, not construction**. The `full_copies * a_in_s + remainder_count` formula is exactly what you get when you stop thinking about the string and start thinking about the arithmetic.

### Why return an `int`, not a string or list

Always set up your return statement **to match the expected return type** early. The function signature says it returns an integer. If you return the wrong type, you'll get parsing errors. Ruby recommends starting with `return 0` or `return count` as a placeholder so the type is correct from the start.

---

## Status Check: Where Is Everyone?

- **End of mod 2 (through project 5):** reviewing concepts and working on HackerRank practice.
- **Finished mod 2 a month ago**, had some life interruptions, now restarting tech interview prep and revising mod 1/2 material alongside HackerRank.

Ruby: everyone's in a good spot for the practice we're doing.

---

## Key Takeaways

- **Identify which phase you're stuck in** — then take phase-appropriate action. Don't do coding debugging when the real problem is that you don't understand the problem.
- **Goal before looking up:** get 2/3 of test cases passing first. If you can't hit that after an hour on an easy problem, start looking at resources.
- **Walk away from stuck problems** for a day or two before looking up solutions. Fresh eyes help more than grinding.
- **After looking up a solution, code it yourself from memory a week later** and try alternative approaches with the same concept.
- **80/20 rule:** most problems need only mod 2 fundamentals. 20% need specialized algorithms — learn them as they come, don't try to memorize them all up front.
- **Test assumptions explicitly.** "`s` will be shorter than `n`" is a testable assumption — constraints told us it's false.
- **Check if target characters even exist** — "is `'a'` guaranteed to be in `s`?" is an assumption worth verifying.
- **Huge `n` values (10^12) are a red flag** against solutions that materialize data. Think math, not construction.
- **`n // len_s` and `n % len_s`** unlock O(1) space for "first n chars of an infinitely repeating string" problems.
- **Set up the return statement early** with the correct data type as a placeholder.
