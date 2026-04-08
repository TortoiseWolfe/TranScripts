# Ruby Solutions Deep Dive — September 24, 2025

Walkthrough of **Valid Anagram** with three solutions at different complexities (O(n²), O(n log n), O(n)), plus discussion of scaling considerations leading into **Group Anagrams**.

---

## Opening Question: Is More Practice The Only Way To Improve?

> "The simple answer is yes — if you're taking the right practice steps. Are you breaking the problem down? Testing along the way? Reviewing what you get stuck on and applying that to new problems? If you're doing everything right and just not hitting the time limit, then yes, the only way to improve is practice. That's the same with any sport or task. And resting. Taking breaks."

---

## Problem: Valid Anagram

Given two strings `s` and `t`, return `true` if `t` is an anagram of `s`.

### Approach 1 — O(n²) Nested Membership + Count

```python
def isAnagram(s, t):
    if len(s) != len(t):
        return False
    for letter in s:
        if letter not in t or s.count(letter) != t.count(letter):
            return False
    return True
```

- **Complexity:** O(n²). For each letter in `s`, `in t` is O(n) and `.count()` is O(n).
- **Runtime observed:** ~2.8 seconds on LeetCode's 53 test cases — passes, but beats only ~5%.
- **Lines of code:** small, which is nice, but scales poorly.

---

### Approach 2 — O(n log n) Sort and Compare

```python
def isAnagram(s, t):
    return sorted(s) == sorted(t)
```

- **Complexity:** O(n log n) dominated by the sort.
- **Runtime observed:** ~15 ms — beats ~82%.
- **Insight:** If both strings contain the same letters with the same frequencies, sorting them produces identical sequences.

> "On the Big O graph, O(n²) and O(n log n) aren't very far apart, but this is a huge improvement in practice — also with only a few lines of code."

---

### Approach 3a — O(n) Two Dictionaries

Build a frequency dictionary for each string, then compare key/value pairs.

```python
def isAnagram(s, t):
    if len(s) != len(t):
        return False
    d1, d2 = {}, {}
    for i in range(len(s)):
        d1[s[i]] = d1.get(s[i], 0) + 1
        d2[t[i]] = d2.get(t[i], 0) + 1
    for key in d1:
        if key not in d2 or d1[key] != d2[key]:
            return False
    return True
```

- **Complexity:** O(n) time, O(n) space.
- **Key check `key in dict` is O(1)** (hash lookup), versus `letter in string` which is O(n).
- Trade-off: **uses more memory** — two dictionary objects.

---

### Approach 3b — O(n) One Dictionary (Decrement Pattern)

Chris's contributed solution (with help from a friend):

```python
def isAnagram(s, t):
    if len(s) != len(t):
        return False
    count = {}
    for i in s:
        count[i] = count.get(i, 0) + 1
    for i in t:
        if i not in count or count[i] == 0:
            return False
        count[i] -= 1
    return all(c == 0 for c in count.values())
```

- **`dict.get(key, 0)`** returns the default `0` if the key doesn't exist, collapsing an if/else into one line. You must know this method exists.
- **Second loop decrements** instead of building a second dictionary — halves the memory footprint.
- The **final `all(...)` check** catches the edge case where one string has extra counts of a letter that the other doesn't.

> "This is a little bit more optimized. Even though both O(n) versions do the same thing, this one scales slightly better on memory."

---

## Coach's Nerdy Probability Aside

The coach wondered whether the final `all(count == 0)` check is strictly necessary for **real English words**. For two real words with the same letters and same length but differing frequencies (e.g., `racecar` vs a hypothetical `carrera` with matching letter sets but different counts), the probability is vanishingly low. For arbitrary random strings in test cases, though, it **is** reachable, so the check stays.

---

## Why Scalability Matters (Lead-in to Group Anagrams)

> "If this were production code loading a web page, and the page sits while the server groups millions of anagrams, the user is staring at a blank screen. Even a really efficient website can struggle at scale with millions of users and millions of rows. How efficiently your code runs is one of the main ways you deal with that."

**Group Anagrams** is the harder follow-up: determine which strings in a list are anagrams of each other and return them grouped. The efficient one-dictionary pattern above is the building block.

### Question: Two Dictionaries for Group Anagrams?

A participant asked whether to use two dictionaries for the group version. Coach's answer:

> "You could follow a very similar technique — create one dictionary per string, and for each new string do the key/count comparison. You'd do a bit more work because you're comparing across multiple strings, but it works."

---

## Space vs. Time Trade-off Summary

| Approach | Time | Space | LoC |
|---|---|---|---|
| Nested `in` + `count` | O(n²) | O(1) | ~5 |
| `sorted(s) == sorted(t)` | O(n log n) | O(n) for the sort buffer | 1 |
| Two dictionaries | O(n) | O(n) ×2 | ~10 |
| One dictionary + decrement | O(n) | O(n) | ~8 |

- **Space and time complexity go hand in hand** — improving one often costs the other.
- At small scale (n ≤ 50,000), the O(n log n) and O(n) versions look nearly identical. At 5M+ inputs the O(n) solutions pull ahead clearly.

---

## Review Habit Recommendation

> "Go back through problems, break down the elements so you understand them, then in a week delete it all and try to implement it from scratch. That way the knowledge really cements."
