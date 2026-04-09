# Ruby Mock Interview — October 12, 2025
Source: https://youtu.be/vWcH6g62B-E

*Nailing the Tech Interview — Sunday session*

## Q&A: Do I Need to Learn All the "Patterns"?

Mauricio asked about the anxiety of feeling like there are 20–30 different problem-solving patterns to master for interviews — BFS, DFS, sliding window, two pointers, greedy, dynamic programming, etc.

### For the Joy of Coding technical interview

- **You do NOT need BFS/DFS** — those are for trees and graphs, which aren't in mod 2.
- **Recursion problems**, if given, will be problems that *could* be solved normally and you'll be asked to solve recursively — not problems that *require* recursion.
- Ruby hasn't found an easy-level recursion-only problem in mod 2 topics, so it's unlikely to appear.

### For the job hunt

- Yes, eventually you should practice these patterns, but the actual list is **not that long** — maybe a dozen or so patterns total.
- LeetCode has **curated lists by pattern**: sliding window list, two-pointer list, tree/graph list, etc. Work through them one category at a time.
- You don't need to study this yet — come back to it once you've been in the internship for a while and are comfortable with general coding problems.

### The 80/20 breakdown

- **~80% of problems** can be solved with just mod 2 fundamentals: lists, dictionaries, linked lists, 2D arrays, functions, recursion, stacks, queues.
- **~20% of problems** need specialized knowledge — trees, graphs, specific algorithms.
- Every problem can at least be **brute-forced** with mod 2 concepts (except some tree/graph problems).

> "Don't get hung up on the pattern pieces where you are right now. That's something you come back to when you're really diving into the job hunt."

---

## Main Topic: How to Work with a Looked-Up Solution

Ruby covered her process for when you've tried your best, gotten stuck, looked up a solution, and now need to learn from it. She'd never explicitly walked through this process before.

### Problem used for the walkthrough: Group Anagrams (LeetCode medium)

Given an array of strings, group the anagrams together into a 2D array.

```
Input:  ["eat","tea","tan","ate","nat","bat"]
Output: [["eat","tea","ate"],["tan","nat"],["bat"]]
```

### Constraints

- `1 <= strs.length <= 10^4`
- `0 <= strs[i].length <= 100`
- Lowercase English letters only.

### The pseudo code outline

```
# Given: strings - list of strings that may or may not be anagrams
# Even if a string has no anagram pair, still include it in the output as its own group
# If strings is empty, return an empty 2D array
# Return: 2D array where outer is groups, inner is all strings that are anagrams of each other
```

---

## The Solution (found online)

```python
def groupAnagrams(strs):
    anagram_table = {}
    for string in strs:
        sorted_string = "".join(sorted(string))
        if sorted_string not in anagram_table:
            anagram_table[sorted_string] = []
        anagram_table[sorted_string].append(string)
    return list(anagram_table.values())
```

---

## Ruby's Process for Learning from a Looked-Up Solution

### Step 1: Paste it in and confirm it works

Run the solution against the sample test cases. Confirm it passes. Don't submit yet — you want to learn, not just submit someone else's work.

### Step 2: Step through each line and visualize

Add print statements to understand what each line does:

```python
print(sorted_string)  # "aet" for "eat", "aet" for "tea", etc.
print(anagram_table)  # see the dict build up
```

- **`sorted("eat")`** returns a **list** (`['a', 'e', 't']`), not a string. This is because Python has no built-in sort method for strings.
- **`"".join(sorted("eat"))`** uses the `join` string method to concatenate the sorted list back into a string (`"aet"`).
- **`list(anagram_table.values())`** converts the dictionary's values view into a list of lists.

### Step 3: Write pseudo code for the solution *as if you had written it*

Pretend you wrote this code and are now documenting it in pseudo code:

```
# Create a dictionary to store key-value pairs for anagram groups
# For loop through all strings in the input list
# Use the sorted string as the dictionary key
# If the sorted string doesn't exist in the dictionary:
#   initialize it with an empty list
# Append the unaltered string to the list at that key
# After the loop, convert the dictionary's values into a 2D list and return
```

### Step 4: Take a break

A day, a few days, maybe a week. No code in the editor — only the pseudo code.

### Step 5: Rewrite the solution from your pseudo code

Come back. Only the pseudo code is there. Try to write working code from your pseudo code alone.

### Step 6: Look up **only** the specific things you get stuck on

Don't reference the original solution. Look up things like:

- "How do I sort a string in Python and get a string back?" → learn about `"".join(sorted(s))`.
- "How do I check if a key exists in a dictionary?" → learn `if key in dict` or `.get()` with default.
- "How do I iterate a dictionary's values?" → learn `.values()`, `.items()`, `.keys()`.

---

## Ruby's Rewrite (done during the demo)

```python
def groupAnagrams(strs):
    anagrams = {}
    for string in strs:
        copy = "".join(sorted(string))
        if copy in anagrams:
            anagrams[copy].append(string)
        else:
            anagrams[copy] = [string]
    # Convert dictionary values back into a 2D array
    result = []
    for value in anagrams.values():
        result.append(value)
    return result
```

Slightly different from the original, but still works. The key point: **her version came from her pseudo code, not from memorizing the original solution**.

---

## How Long to Bang Your Head Before Looking Up a Solution

### Mauricio's follow-up question

> "How long should you basically bang your head against the wall before going for the solution?"

### Ruby's answer

- **Easy problem:** ~1 hour. If you can't get 2/3 of test cases passing, walk away.
- **Medium problem:** up to ~1 hour on day 1. Let it marinate. Come back a day or two later.
- **Never look up the solution on day 1** for medium problems.
- After 2/3 test cases pass, spend another **10–20 minutes** trying to get the final third. If that fails, re-read the problem carefully first. **If still stuck after that**, look up the solution.
- **Total time across multiple days:** ~1.5 hours is Ruby's rough budget.

### When to stop for the day

- When you've thought through everything you can.
- When you're going in circles in your own head.
- **Change of scenery helps enormously.** Ruby shared a story of being stuck on a problem for over an hour, going on a 30-minute to 1-hour nature walk, and solving it in 20 minutes when she came back.

> "I've gotten really frustrated, went on a nature walk, came back, and knocked the problem out of the park in 20 minutes. Like it was nothing."

---

## Python Dictionary Method Reference

Useful methods you should get acquainted with:

- **`get(key, default)`** — safely retrieves a key's value, returning `default` if missing.
- **`items()`** — returns a list of `(key, value)` tuples.
- **`keys()`** — returns only the keys.
- **`values()`** — returns only the values.
- **`pop(key)`** — removes and returns a key's value.
- **`setdefault(key, default)`** — returns value if key exists, else inserts default.
- **`update(other_dict)`** — updates keys/values in place.

### When iterating

- `for key in dict:` — iterates keys.
- `for value in dict.values():` — iterates values.
- `for key, value in dict.items():` — iterates key-value pairs.

> "Chris noted this was the first time he'd seen a dictionary's values converted back to a list. Worth getting comfortable with."

---

## Key Takeaways

- **You don't need to master every pattern before the technical interview.** Mod 2 fundamentals are ~80% of what you need.
- **BFS/DFS** are tree/graph topics — not in mod 2, not on the Joy of Coding technical interview.
- **Pattern practice** (sliding window, two pointers, etc.) is for job-hunt prep, not tech interview prep. Come back to it later.
- **Looking up a solution is not cheating** — it's a learning opportunity if handled correctly.
- **The "looked-up solution" process:**
  1. Paste and confirm it works.
  2. Step through with print statements.
  3. Write pseudo code for the solution in your own words.
  4. Take a break (a day to a week).
  5. Rewrite from your pseudo code only.
  6. Look up only the specific pieces you get stuck on, never the full solution again.
- **Day 1: don't look it up.** Take a walk. Come back fresh.
- **`"".join(sorted(s))`** is the canonical Python idiom for getting a sorted string.
- **Group Anagrams canonical approach:** dictionary keyed by sorted string, values are lists of original strings.
- **Know your dictionary methods** — `.values()`, `.items()`, `.keys()`, `.get()` are essential.
