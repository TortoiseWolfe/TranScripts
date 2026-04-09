# Ruby Mock Interview — September 21, 2025
Source: https://youtu.be/l2XMSmCPWrM

*Nailing the Tech Interview — Sunday session*

## Warm-Up: Valid Anagram (LeetCode easy)

### Problem statement

Given two strings `s` and `t`, return `true` if `t` is an **anagram** of `s`, else `false`.

> "An anagram is a word or phrase formed by rearranging the letters of a different word or phrase using all of the original letters exactly once."

**Key pull-out:** uses all the original letters **exactly once** — same letters, same counts.

### Examples

```
s = "anagram", t = "nagaram" -> true
s = "rat",     t = "car"     -> false
```

### Constraints

- `1 <= s.length, t.length <= 5 * 10^4`
- `s` and `t` consist of **lowercase English letters** only.
- **Follow-up:** what if the inputs contain Unicode characters?

### Reading comma-separated constraint lists

`1 <= s.length, t.length <= 5 * 10^4` is shorthand for two independent bounds — both strings are between 1 and `5 * 10^4`. It does **not** imply `s.length < t.length`. Contrast this with problems that use `<` explicitly between variables (e.g., last week's constraint showed ordering).

### Immediate easy check

```python
if len(s) != len(t):
    return False
```

Two anagrams must be the same length — fail fast on mismatched lengths.

---

## Solution Brainstorm (Multiple Approaches)

### Approach 1 — Sort both strings and compare

```python
return sorted(s) == sorted(t)
```

- **Time:** O(n log n) (sorting dominates)
- **Space:** O(n) for the sorted copies
- Chris's submitted runtime: beat only ~15% — works but slow.

### Approach 2 — Two dictionaries (count characters)

Build a frequency dictionary for each string and compare them.

```python
def isAnagram(s, t):
    if len(s) != len(t):
        return False
    count_s, count_t = {}, {}
    for i in range(len(s)):
        count_s[s[i]] = count_s.get(s[i], 0) + 1
        count_t[t[i]] = count_t.get(t[i], 0) + 1
    return count_s == count_t
```

- **Time:** O(n) to build dictionaries + O(n) to compare
- **Space:** O(n) for two dictionaries
- Comparing two dicts isn't O(1) — it's O(n) in the number of keys.

### Approach 3 — One dictionary, count up then count down (Kai's idea)

Loop over `s` and add counts. Loop over `t` and subtract. Remove keys when they hit zero. If the dictionary is empty at the end, they're anagrams.

```python
def isAnagram(s, t):
    if len(s) != len(t):
        return False
    count = {}
    for ch in s:
        count[ch] = count.get(ch, 0) + 1
    for ch in t:
        if ch not in count:
            return False
        count[ch] -= 1
        if count[ch] == 0:
            del count[ch]
    return len(count) == 0
```

- **Time:** O(n)
- **Space:** O(n) for **one** dictionary (better than Approach 2)
- **Best memory efficiency** of the bunch.

### Approach 4 — Mauricio's brute force using `count()`

```python
def isAnagram(s, t):
    for letter in t:
        if letter in s and s.count(letter) == t.count(letter):
            continue
        else:
            return False
    return True
```

- `letter in s` on a **string** is **O(n)** (not O(1) like dict/set lookup).
- `s.count(letter)` is also **O(n)**.
- Nested inside a loop over `t`, total is **O(n²)** in the average/best case, potentially worse.
- **Passed all test cases anyway**, in under 2 minutes of coding.

> "This is why I advocate for brute force. You came up with the solution, tried it, and it worked. That's awesome." — Ruby

### Efficiency summary

| Approach | Time | Space |
|----------|------|-------|
| Sort + compare | O(n log n) | O(n) |
| Two dictionaries | O(n) | O(n) |
| One dictionary (count up/down) | O(n) | O(n) (single dict) |
| `count()` brute force | O(n²) | O(1) |

---

## Coaching Debate: Brute Force First vs. Consider Alternatives

### Mauricio's take

> "I have the experience that burning out the time sometimes thinking about a sophisticated solution. So the method in your mind should be: just hit brute force, and if it doesn't work, go back to sophistication."

### Ruby's take (holding two slightly conflicting ideas)

- **Yes, brute force first** if it's the first thing that comes to mind and you can implement it quickly.
- **But also take 1–2 minutes** to consider an alternative before committing.
- Don't think about efficiency first — think about **which approach you can confidently implement without getting stuck on details**.
- Sometimes brute force is obvious and quick. Sometimes brute force for a particular problem is actually a messy multi-step nightmare, in which case a smarter approach is both faster to write *and* runs better.
- Having a **Plan B in the wings** costs very little and saves you if Plan A fails.

> "Don't be afraid of the brute force. If it's going to work, it's going to work. But also take a few minutes to consider alternatives — it's never a waste of time."

---

## Mock Interview: Mauricio on "Group Anagrams" (LeetCode medium)

### Problem statement

Given an array of strings `strs`, **group the anagrams together**. Return a list of lists.

### Constraints

- `1 <= strs.length <= 10^4`
- `0 <= strs[i].length <= 100`
- `strs[i]` consists of lowercase English letters.

### Mauricio's approach (under 15-minute time pressure)

Brute force: traverse the array, compare each string to the others, and group those that are anagrams. Considered using a dictionary keyed by **something anagram-identifying** (sorted string as key), with the value being a list of anagrams.

Partial pseudo code:

```python
def groupAnagrams(strs):
    groups = {}
    for i in range(len(strs)):
        # Compare strs[i] against all others
        # Use sorted string as the dictionary key
        # Append to groups[key]
    # Traverse dictionary by key and build output list of lists
    return output
```

### The bug in the first draft

Mauricio used the **length** of the string as the dictionary key, which would collide across non-anagram words of the same length (e.g., `"bat"` and `"nat"` would both key to `3` even though only `"nat"` and `"tan"` are anagrams).

**Fix:** key by the **sorted string** itself — e.g., `"".join(sorted("eat"))` = `"aet"` — so that all anagrams of the same word collide on the exact same key.

```python
def groupAnagrams(strs):
    groups = {}
    for s in strs:
        key = "".join(sorted(s))
        if key not in groups:
            groups[key] = []
        groups[key].append(s)
    return list(groups.values())
```

### Second bug: iteration variable naming

Mauricio wrote `for string in range(len(strings))`, which makes `string` an **integer index**, not a string object. Then his `string.sort` call would fail because integers don't have `.sort()`.

**Fix:** use subscript access: `strs[i].sort` → or better, iterate directly `for s in strs`.

### Coaching feedback

- **Great job breaking down the steps:** check anagram, group them, format output.
- **Add print statements along the way** when developing — catch index-vs-value confusion early.
- Don't expect everything to work on the first run. **Rewrite and debug is normal**, even in the real world.
- Mauricio already knew what he'd do next: replace the faulty length-based grouping with a proper list-of-lists append pattern.

> "Being under the hammer of time really hurts me." — Mauricio

### Practice recommendation

Use **peer mentors** for live-coding pressure practice:

> "Hey, can you just watch me? I need the peer review pressure of coding live. If you have feedback at the end, great. If not, that's fine — I just need the practice."

Ruby tells peer mentors to expect these requests.

---

## Closing Thoughts

### Why spend so much time on multiple approaches to an easy problem?

- It's a **thought experiment**. You don't have to catalog every possible solution on every real problem.
- But once you've solved a problem, it's valuable to **revisit and ask "what else could I have done?"**
- This builds a bigger toolkit for **medium problems**, where efficiency matters more and O(n²) often won't pass.

> "At the medium level, efficiency matters a lot more. An O(n²) solution probably isn't going to work there."

---

## Key Takeaways

- **Comma-separated constraints** (`1 <= s.length, t.length <= N`) describe independent bounds, not ordering.
- **Length mismatch is an instant false** for anagram problems — fail fast.
- **Sort + compare** is O(n log n); **dictionary counting** is O(n); they're both valid but the dict version is the better interview answer.
- **`s.count()` and `in` on a string are O(n)**, not O(1). Watch out for this when analyzing brute-force solutions that look "simple."
- For **Group Anagrams**, the canonical trick is **sorted-string-as-dict-key** — all anagrams of a word collide on the same key.
- **Print statements during development** catch index-vs-value and type errors before they compound.
- **Brute force first**, but don't skip a 1–2 minute pause to consider an alternative before you commit.
- **Debugging is normal.** Don't expect first-run success; expect 2–3 iterations.
- **Peer mentor sessions** are the best place to practice under live-coding pressure.
