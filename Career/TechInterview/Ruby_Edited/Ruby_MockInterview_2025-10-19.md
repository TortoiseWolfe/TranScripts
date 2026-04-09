# Ruby Mock Interview — October 19, 2025
Source: https://youtu.be/zNncK2JEBgU

*Nailing the Tech Interview — Sunday session*

## Topic: Reverse-Engineering Python String Methods

Ruby changed up the session format. Instead of a mock interview, she ran a workshop on **reverse-engineering built-in string methods** by breaking them into small reusable micro-challenges.

### Motivation

On Wednesday the group covered **"Find the Index of the First Occurrence in a String"** (LeetCode easy), where:

> Given `needle` and `haystack`, return the first index where `needle` appears in `haystack`, or `-1` if not found.

And discovered that Python's `str.find()` method solves the entire problem in one line:

```python
return haystack.find(needle)
```

Ruby's point: **this is a valid solution for the interview, but it's not great for learning.** If you always reach for built-in methods, you never learn the underlying logic.

> "For learning purposes, I recommend everyone to learn the logic behind the methods they're using."

---

## The Micro-Challenge Framework

Break the problem into small foundational skills you can practice in isolation:

1. Check if two strings are equal — return `True`/`False`.
2. Iterate through a string and print each character.
3. Check if a character exists within a string — print `True`/`False`.
4. Find the index of the first matching character in a string — print the index.
5. Return a slice of a string between two indexes — print the slice.

If you can do each of these, you can compose them to implement `find()` yourself.

---

## Micro-Challenge 1: String Equality

### Equality in value

```python
string_1 = "hello"
string_2 = "hello"
print(string_1 == string_2)   # True
```

### Equality in length (different question)

```python
print(len(string_1) == len(string_2))
```

**Key distinction:** `==` on strings checks that **every character matches**. `len(a) == len(b)` only checks that the lengths match, not the characters.

### The "compressed if" clarification

Chris asked about the one-liner `print(char in haystack)` without an `if` block:

> "I took an if statement and compressed it into one line. Is there a name for that?"

**No — it's not a compressed if.** An `if` statement controls flow; the **statement** (like `char in haystack`) is what evaluates to `True`/`False`. If you only want the boolean result without branching, just print the statement directly. You don't need an `if` at all.

---

## Micro-Challenge 2: Iterate Through a String

```python
haystack = "sadbutsad"
for ch in haystack:
    print(ch)
```

Straightforward. This iterates the characters directly without tracking an index.

---

## Micro-Challenge 3: Check If a Character Exists in a String

```python
character = "s"
haystack = "hello world"
print(character in haystack)   # True
```

The `in` operator is all you need — no loop required.

---

## Micro-Challenge 4: Find Index of First Matching Character

The trick: `for ch in string` iterates **characters**, but you need the **index**. Use `for i in range(len(string))` instead so `i` is an integer index.

```python
character = "s"
haystack = "sadbutsad"

for i in range(len(haystack)):
    if haystack[i] == character:
        print(i)
        break   # stop at first match
```

### On `break` vs `return`

- **`break`** exits the loop but continues with code after it.
- **`return`** exits the entire function immediately.
- Use `break` if you want to find the first occurrence and keep doing work afterwards.
- Use `return` if finding the match means the function is done.

### The trap

Without `break`, the loop would print **every** `s` in `sadbutsad` (indexes 0 and 6). We only want the first. `break` ensures we stop at index 0.

---

## Micro-Challenge 5: Slice a String Between Two Indexes

### The long way (for loop)

```python
index_1 = 3
index_2 = 7
word = ""
for i in range(index_1, index_2):
    word += haystack[i]
print(word)
```

### The Python-idiomatic way (slice notation)

```python
print(haystack[index_1:index_2])   # "lo w"  (inclusive start, exclusive end)
```

- Slice notation: `string[start:end]` — **start inclusive, end exclusive**.
- You can omit start (`[:end]`) or end (`[start:]`).
- Specific to Python; not every language has this.
- **There is no `string.slice()` method in Python** — use bracket notation.

---

## Composing the Micro-Challenges into a Full Solution

Now build `strStr(haystack, needle)` from these building blocks.

### High-level pseudo code

```
# Iterate through haystack
# At each position i, compare a slice of haystack to needle
# If they match, return i
# If we finish the loop without matching, return -1
```

### Bonus edge cases

- **If needle equals haystack**, return 0 immediately.
- **If haystack is shorter than needle**, return -1 immediately.

### Full implementation

```python
def strStr(haystack, needle):
    # Edge cases
    if needle == haystack:
        return 0
    if len(haystack) < len(needle):
        return -1

    n = len(needle)
    for i in range(len(haystack)):
        if needle[0] == haystack[i]:
            # First character matches — compare the full slice
            if needle == haystack[i:i + n]:
                return i
    return -1
```

### Walking through the critical slice

For `haystack = "sadbutsad"`, `needle = "sad"`:

- `i = 0`: `haystack[0] == 's'`, slice `haystack[0:3]` = `"sad"`, matches needle → return 0.

For `haystack = "somethingsomething sad"`, `needle = "sad"`:

- `i = 0`: first char `s` matches, but slice `haystack[0:3]` = `"som"` ≠ `"sad"`.
- `i = 10`: first char `s` matches, but slice ≠ `"sad"`.
- `i = 20` (eventual): slice `haystack[20:23]` = `"sad"` → return 20.

### The subtle bug we hit during the demo

Initial attempt used `haystack[i:n]` instead of `haystack[i:i + n]`. That means "from `i` to `n`" — if `i > n`, you get an empty string. The fix is `i + n` so the endpoint advances with the start.

> "This is why it's always good to print. When you're not sure why you're getting nothing, add more context to your prints."

### Indentation gotcha for the `return -1`

The `return -1` must be **outside** the `for` loop (at the function level), not inside it. If it's at the loop's level, it fires after the first iteration and never finds matches beyond index 0. Kick it one tab further left.

---

## Why Bother With This Exercise?

- These micro-skills (string equality, iteration with index, slicing, character membership) appear in **many** string problems.
- Once you're fluent, you can look at a problem and see "this is iterate + slice + compare + return" without needing to remember a specific built-in method.
- You could use `find()` as a shortcut in a real interview — but knowing the mechanics means you're not helpless when the built-in doesn't quite fit.

> "The trick is to look at a problem and determine what those little mini micro-challenges are." — Ruby

### Example of generalization: email validation

Chris noted this pattern applies to email validation:

- Find the `@` symbol → index search.
- Pull the part before and after → slicing.
- Check for `.com`, `.org`, etc. → substring comparison.

All the same building blocks.

---

## Related String Methods (and Homework)

Ruby pointed out two other common string methods that work similarly:

### `str.count(substring)`

Returns the number of times `substring` appears in the string. We tested this implicitly in the demo by tracking multiple `s` matches in `sadbutsad`.

### `str.replace(old, new, count=...)`

Replaces occurrences of `old` with `new`. Optional `count` parameter limits how many replacements.

```python
text = "one one one"
text.replace("one", "three")       # "three three three"
text.replace("one", "three", 2)    # "three three one"
```

**Note:** `replace` **returns** a new string — strings in Python are immutable, so it can't modify in place.

### Homework

Implement `count` and `replace` **without using the built-in methods**. Use only the micro-challenge building blocks we practiced today.

- Reference: W3Schools Python String Methods.
- Post solutions in the HackerRank Discord channel.

---

## Q&A: Bracket Notation for Indexing

Someone asked: "When you put `needle[0]`, does the bracket notation always mean index?"

**Yes** in Python, for any **iterable with ordered access** (strings, lists, tuples).

- `needle[0]` → first character of the string.
- `needle[2]` → third character.
- Works the same on lists: `my_list[0]`.
- **Strings and lists** are both iterable and indexable.

### Parentheses in return statements

Another clarification: **you don't need parentheses around a `return` value** in Python. You need them for `print()` (which is a function call) but not `return` (which is a keyword).

```python
return i           # correct
return(i)          # also works but unnecessary
```

---

## Key Takeaways

- **Built-in string methods are shortcuts** — useful in interviews, but don't let them rob you of understanding the mechanics.
- **Break problems into micro-challenges** that are reusable across many problems.
- **`for i in range(len(s))`** gives you index access; `for ch in s` gives you characters directly.
- **Slice notation is `[start:end]`** with inclusive start, exclusive end.
- **Python has no `.slice()` method** on strings — use bracket notation.
- **`break` exits one loop; `return` exits the whole function.**
- **Indentation of `return -1` matters** — it must be outside the loop for "not found" logic to work.
- **Strings are immutable** — `replace` returns a new string rather than modifying in place.
- **`[0]`, `[1]`, etc. are indexes** for strings, lists, tuples — all ordered iterables.
- **Print early, print often** when debugging slice/index logic. When you see nothing, add more print context.
