# Ruby Mock Interview — November 2, 2025

*Nailing the Tech Interview — Sunday session*

## Q&A: Is There a Quick, Effective Way to Prepare?

Linda asked if there's a quick or effective way to prepare for the technical interview beyond just doing problems repetitively.

### Ruby's answer

- **Not quick, but effective** — absolutely.
- **Repetition alone isn't enough.** What matters is **what you learn after each problem**.
- Use the full session playlist: Sunday sessions introduce new problems, Wednesday sessions explore solutions in depth. That progression has been running since June.
- **Coming to sessions is only part of the battle.** The real challenge is what you do *between* sessions — apply the steps that were showcased, try problems on your own, channel discussion into practice.

> "Not just opening up a random problem and saying 'well, here we go, good luck.' What steps are you taking? How are you channeling what we discuss weekly into your practice?"

---

## Mindy's Alternative Count Implementation

Mindy shared an alternative implementation of `str.count()` that she developed because the **sliding window slicing approach** from Mauricio's version had been tripping her up.

### The "whole-word" version

Instead of matching substrings, she split the string by spaces and compared whole words after stripping punctuation:

```python
def count(string, word, match_whole_word=True):
    if match_whole_word:
        words = string.split()
        count = 0
        for w in words:
            # Strip punctuation
            w_clean = w.strip(".,!?;:\"'")
            if w_clean == word:
                count += 1
        return count
    else:
        # Fall back to sliding window substring approach
        word_length = len(word)
        count = 0
        for i in range(len(string) - word_length + 1):
            if string[i:i + word_length] == word:
                count += 1
        return count
```

### The `+ 1` in the range

Mindy spent time puzzling out why the range is `len(string) - word_length + 1`:

- Without the `+ 1`, you'd cut off before examining the **last possible window position**.
- Example: `string = "abcde"` (length 5), `word = "cd"` (length 2). Valid start indexes are `0, 1, 2, 3` → that's `5 - 2 + 1 = 4` positions.
- **The `+ 1` includes the final viable starting index.**

### The sliding-window comparison

```python
if string[i:i + word_length] == word:
```

- `string[i:i + word_length]` grabs a **chunk** the size of the target word.
- `==` compares the chunk to the full word.
- Increments `i` each iteration → the window slides forward.

### Ruby's critique

Mindy's test case used `apple` as the search term in a string containing `"apples"`:

- With `match_whole_word=True`, she got `0` — correct for whole-word matching.
- With `match_whole_word=False`, she got `3` — matching the substring `"apple"` inside `"apples"`.

**The actual `str.count()` method does substring matching** — it would return `3` for `"apple"` in a string of `"apples"`. Mindy's whole-word version is a **different function**, not a drop-in replacement. Still a valuable exercise — just clarify what you're implementing.

> "Python is all object code. You have us reverse-engineering methods so I can know how it works under the hood, because I can't remember everything."

---

## Ruby's First Hard Problem: Median of Two Sorted Arrays

Ruby solved a LeetCode **hard** problem in under 30 minutes and thought it was mislabeled — the techniques are all things the group had covered in easier problems. She walked through how to build up to it.

### Subproblem 1: Find the Median of a Sorted Array

What information do you need to know?

- **Is the length even or odd?** Determines whether you return the middle element or average the two middle elements.
- **Length** of the array (to locate the middle).
- **Is the array sorted?** If not, sort first — but sorting is O(n log n), which might violate efficiency constraints.
- **Is the array non-empty?** Edge case to handle.
- **Range of values** (sometimes given as a constraint, not strictly needed for logic).

### For an odd-length sorted array

```python
def find_median_odd(arr):
    mid_index = len(arr) // 2   # integer division rounds down
    return arr[mid_index]
```

For `len(arr) == 7`, `7 // 2 == 3`, which is the correct 0-indexed middle position (values at indexes 0,1,2 | **3** | 4,5,6).

### For an even-length sorted array

```python
def find_median_even(arr):
    n = len(arr)
    mid1 = arr[n // 2 - 1]
    mid2 = arr[n // 2]
    return (mid1 + mid2) / 2
```

### Subproblem 2: Merge Two Sorted Arrays in O(n + m)

Information needed:

- Final array must also be sorted.
- The two arrays may have **different lengths**.
- A new array must be created — you can't modify in place easily.
- The combined length is `len(a) + len(b)`.

### Naive approach: concat + sort

```python
merged = nums1 + nums2
merged.sort()
```

This **works** but is **O((n+m) log(n+m))** due to the sort. The problem requires better.

### Proper O(n + m) merge (two pointers)

```python
def merge_sorted(nums1, nums2):
    result = []
    i = j = 0
    while i < len(nums1) and j < len(nums2):
        if nums1[i] < nums2[j]:
            result.append(nums1[i])
            i += 1
        else:
            result.append(nums2[j])
            j += 1
    # Append the remainder of whichever array still has elements
    result.extend(nums1[i:])
    result.extend(nums2[j:])
    return result
```

Each pointer only advances forward → total work is `O(n + m)`.

---

## The Hard Problem: Median of Two Sorted Arrays

> Given two sorted arrays `nums1` and `nums2` of sizes `m` and `n`, return the median of the combined sorted array. **Overall runtime complexity should be O(log(m + n))**.

### Examples

```
nums1 = [1,3],    nums2 = [2]       -> 2.0
nums1 = [1,2],    nums2 = [3,4]     -> 2.5
```

### Ruby's approach

Combine the two subproblems:

1. Merge the two sorted arrays in O(n + m) using the two-pointer technique.
2. Find the median of the resulting array.

**Note:** The problem asks for O(log(m + n)), but the merge-based approach is O(m + n). It still passes on LeetCode and is much easier to implement than the true O(log) binary search approach. Ruby accepted this as her "first hard problem" win even though it wasn't the optimal solution.

> "I kind of feel like this problem is mislabeled. I'll take the win either way."

### Problem-asking exercise

Ruby turned this into a group pseudo-code exercise **without showing the problem first**, just asking "what information would you need?" This is exactly the kind of clarifying-questions exercise you should practice for interviews.

---

## The Blind 75 and Pattern Recognition Debate

Mindy mentioned LeetCode now has a **"Study Plan"** feature for the Blind 75 that categorizes problems by pattern (arrays, sliding window, two pointers, etc.).

### Mindy's position

- Helpful for people who learn by repetition.
- Seeing a bunch of problems that use the same pattern helps build pattern recognition.
- Similar to how math drills taught fundamentals growing up.

### Ruby's position

- For the **Blind 75 specifically**, going in knowing the category **defeats the purpose**. The whole point is to test whether you can recognize patterns *cold* — just like in a real interview.
- **For learning a new concept**, Googling "LeetCode sliding window problems" to get a focused problem set is absolutely valid.
- **For interview-style practice**, pick problems without knowing the pattern in advance so you practice the recognition skill.

> "Are you going to know it's a hashset problem, a linked list problem, a sliding window problem if you don't practice identifying that yourself?"

### Middle ground

- Use categorized problem lists when you're **learning** a concept.
- Use uncategorized practice (blind picks) when you're **interview prepping**.

---

## Q&A: Am I Ready for the Technical Interview?

> "Do you give us an inkling of when we might be ready?"

Ruby: "If you volunteer to do a mock interview, I can give you a read on what you need to work on based on what I see."

---

## Q&A: Is Tech Joy Winding Down?

Linda noticed Discord is quieter and the calendar is shrinking. She asked if Tech Joy is closing.

### Ruby's answer

- **No.** The technical interview is **not going anywhere**, per Dr. Emily.
- The company's strategy is shifting toward bringing in **code-ready people** for internships rather than training from scratch.
- The **technical interview remains the litmus test** — passing it qualifies you for the internship, which is where real job experience comes from.
- For anyone currently in mod 2 heading toward the technical interview: **you're exactly where you need to be**.
- Mod 1 and mod 2 content will remain accessible, and more HackerRank-specific training is being added.

> "I am the end and the beginning."

---

## Q&A: Running Out of Practice Problems

Mauricio: "If I've done all the hacker rank problems and then take the technical interview, I'll be left with only the hardest easy problems. I feel penalized for having done so many."

### Ruby's answer

- **Solved-on-HackerRank problems won't be reused** in your technical interview — the instructors check the leaderboard.
- Ruby is actively working on **new problem sets** drawn from **LeetCode** for students who exhaust the HackerRank pool.
- **General philosophy:** HackerRank is preferred because it gives all the info upfront; LeetCode sometimes leaves info out, forcing you to discover it through failing tests. Ruby will select LeetCode problems that match HackerRank's "everything upfront" style.

### On interview nerves and luck

> "Sometimes it feels like when the stars align, you pass. You got the right problem, you were more relaxed, more focused, and everything aligned. It's just like a real technical interview." — Mauricio

> "You're either perfectly prepared, perfectly unprepared, or somewhere in between. And that last piece is where most of us live." — Ruby

---

## Homework

Solve **Median of Two Sorted Arrays** using the merge + median approach. After this, you'll have "tackled your first hard problem" for the record books.

---

## Key Takeaways

- **Repetition alone isn't enough** — what matters is what you learn *after* each problem.
- **Reverse-engineering built-in methods** (like `str.count`) is a great way to learn string manipulation fundamentals.
- **`len(s) - word_length + 1`** is the correct range upper bound for a sliding window over a string when the window has fixed size.
- **Whole-word matching is different from substring matching** — be clear about which you're implementing.
- **Hard problems often decompose into easier subproblems.** Median of Two Sorted Arrays = Merge Sorted Arrays + Find Median.
- **Merge two sorted arrays in O(m+n)** with the two-pointer technique, not by concatenating and sorting.
- **Integer division (`//`)** gives you safe middle indexes for odd-length arrays.
- **For the Blind 75, go in blind.** For learning a new concept, use categorized problem lists.
- **Solved HackerRank problems won't appear in your technical interview** — instructors check your leaderboard.
- **The technical interview isn't going away** — it's the admissions test for the internship pipeline.
- **Clarifying questions** (sorted? even length? range? non-empty?) are a core interview skill — practice asking them before coding.
