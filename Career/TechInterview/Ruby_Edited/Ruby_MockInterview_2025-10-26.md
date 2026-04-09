# Ruby Mock Interview — October 26, 2025
Source: https://youtu.be/P60M5VIEBQY

*Nailing the Tech Interview — Sunday session*

## Homework Recap: Reimplementing `count` and `replace`

Mauricio completed the homework of reimplementing Python's `str.count()` and `str.replace()` without using the built-in methods and posted his solutions to the HackerRank Discord channel. He even wrapped them in a class to mimic the built-in interface.

### What he ran into

- **`replace` was harder than `count`** — the sticking point was **updating the string as you find matches**. At first he was only replacing the first or the last occurrence.
- **Strings are immutable** — each replacement creates a new string, which you then have to reassign before the next iteration.
- **Once `replace` worked, `count` was trivial** — it's essentially a shortened version of the same traversal logic without the modification step.

### Why Ruby chose these two problems

- `find`, `count`, and `replace` all share the same **traversal + comparison base** but have different side effects:
  - `find` returns an index.
  - `count` returns a total count.
  - `replace` modifies (returns a new) string.

---

## Mock Interview: Mauricio on "Minimum Time to Make Rope Colorful" (LeetCode medium)

### Problem statement

You have a rope of balloons represented as a string `colors`. You also have an integer array `neededTime` where `neededTime[i]` is the time to remove balloon `i`. Bob wants the rope to be **"colorful"** — meaning **no two consecutive balloons have the same color**. Return the **minimum time** Bob needs to make the rope colorful.

### Examples

```
colors = "abaac",   neededTime = [1, 2, 3, 4, 5]  ->  3
  Remove balloon at index 3 (time 4)? No — actually remove index 2 (time 3).
  Result: "abac" — no consecutive duplicates.

colors = "abc",     neededTime = [1, 2, 3]        ->  0
  Already colorful, nothing to remove.

colors = "aabaa",   neededTime = [1, 2, 3, 4, 1]  ->  2
  Remove first 'a' (time 1) and last 'a' (time 1) -> "aba". Total: 2.
```

### Constraints

- `colors.length == neededTime.length == n`
- `1 <= n <= 10^5`
- `1 <= neededTime[i] <= 10^4`
- `colors` consists of lowercase English letters.

### Mauricio's verbal problem breakdown

> "The goal is to remove any consecutive balloons of the same color. Among the two, I should remove the cheapest one. So I need to find consecutive duplicates, then add the minimum of the two times to a running sum."

### Approach (pair-by-pair with `step=2`)

Initial plan: iterate `colors` in steps of 2, compare `colors[i]` to `colors[i+1]`, and if they match, add the minimum of the two times to a running sum.

```python
def minCost(colors, neededTime):
    total = 0
    for i in range(0, len(colors) - 1, 2):
        if colors[i] == colors[i + 1]:
            total += min(neededTime[i], neededTime[i + 1])
    return total
```

### The bug: step=2 skips odd-indexed comparisons

With step 2, you compare (0,1), (2,3), (4,5)... but you **miss** comparing (1,2), (3,4), etc. This fails cases where consecutive duplicates straddle the step boundary.

### The debugging hiccup

- Mauricio added print statements but **nothing printed**. He thought the `if` condition was the problem.
- **Actual cause:** the `range(..., step=2)` was skipping past the matching pairs, so the `if` was never true.
- **Lesson:** he should have added a print statement **right after the `for` loop** to confirm the loop was iterating over the expected indexes — **before** writing any inner logic.

### Ruby's coaching point

> "As soon as you wrote your for loop, I would have tested to make sure it was doing what you expected. It seems simple — why would I need to test my for loop? I've written it a million times. This is exactly why I do it every single week."

**Always print right after writing a loop.** You reduce the possible sources of error from "is it my for loop, my if, my sum, my index arithmetic, or my variable name?" down to just "the for loop." Debug the smallest surface area at a time.

### Fixing step=2 → step=1

Removing the step argument got the code running:

```python
for i in range(len(colors) - 1):
    if colors[i] == colors[i + 1]:
        total += min(neededTime[i], neededTime[i + 1])
```

Result: **33% of test cases passing** (only about 28%).

### Why `len(colors) - 1` (the safety offset)

Because we access `colors[i + 1]` inside the loop, we must stop at the second-to-last index or we'll hit an **index out of range** error. `range(len(colors) - 1)` gives indexes `0` through `n - 2`, and `i + 1` will then be at most `n - 1`.

### The remaining bug: three-or-more consecutive duplicates

With `colors = "aaabbbc"` and `neededTime = [3, 5, 10, 7, 5, 3, 5]`, the pair-by-pair logic starts **double-counting**:

- Comparing `(0,1)`: both `a`, add min(3, 5) = 3.
- Comparing `(1,2)`: both `a`, add min(5, 10) = 5. ← now we've added costs for balloon 1 twice
- Comparing `(2,3)`: `a` ≠ `b`, skip.
- Comparing `(3,4)`: both `b`, add min(7, 5) = 5.
- Comparing `(4,5)`: both `b`, add min(5, 3) = 3. ← same issue, balloon 4 counted twice

The correct approach for a run of `k` same-colored balloons is: **remove all but the most expensive one**. That is, `sum(group) - max(group)`.

### Strategy for the next attempt

Mauricio suggested switching to a **`while` loop** to walk through runs of same-color balloons until the color changes, then sum the group and subtract the max. Ruby suggested first **walking through the failing test case by hand** before rewriting.

> "Before I just start switching variables or conditions, what do I need to know about this problem? What do I need to consider?"

### Ruby's hint

> "I think that hint might even be example three in their problem statement." — pointing to the `"aabaa"` example where removing the two cheap end-a's is the right move. Generalize: always **keep the most expensive balloon** in each consecutive-color group.

### Correct canonical solution (implied, not coded in session)

```python
def minCost(colors, neededTime):
    total = 0
    i = 0
    while i < len(colors):
        j = i
        group_sum = 0
        group_max = 0
        while j < len(colors) and colors[j] == colors[i]:
            group_sum += neededTime[j]
            group_max = max(group_max, neededTime[j])
            j += 1
        total += group_sum - group_max
        i = j
    return total
```

- **Time:** O(n)
- **Space:** O(1)

---

## Linda's Clarifying Questions (Great Interview Practice)

Linda joined late and asked Mauricio to explain his code in plain English. Ruby noted this is **exactly** the kind of conversation you'd have in an interview — being able to explain your logic while the interviewer probes your reasoning.

Questions Mauricio fielded well:

- **Why `- 1` on line 4?** → "It's a safety thing. We stop one before the end because we look at `color + 1` inside."
- **Why `color + 1`?** → "Because I want to compare two consecutive balloons. The next index is one forward."
- **What does `min` do here?** → "Among the two consecutive duplicates, I want the cheapest to remove, because the problem wants minimum total time."
- **What if we did `+ 2` instead?** → "Then I'd compare non-consecutive balloons, which breaks the problem's definition of 'consecutive.'"

> "It's always good to think about the problem and explain your code this way, especially for a technical interview. The interviewer wants to hear how you're thinking about the problem."

---

## Closing Recommendations

### Pen and paper for tricky test cases

When code passes some tests but not all and you can't see where it's breaking down mentally, **draw it out**. Especially for problems with visual setups like this one (balloons on a rope).

> "I'm always a fan of pen and paper. Make it visual if you need to."

### Session cadence reminder (for newcomers)

- **Sundays:** new problems, mock interviews, fresh content.
- **Wednesdays:** exploring the problems from Sunday in more depth, alternative approaches, efficiency discussions.

---

## Key Takeaways

- **Homework insight:** `replace` requires reassigning the string after every match because strings are immutable. `count` is a simpler traversal with no modification.
- **Always debug your for loop immediately after writing it.** Print indexes or values before adding any inner logic — reduces debugging surface area.
- **`range(..., step=2)` silently skips pairs** like (1,2), (3,4). If your problem cares about "every consecutive pair," use `step=1`.
- **`for i in range(len(x) - 1)`** is the safe pattern when you need `x[i + 1]` inside the loop.
- **Pair-by-pair comparison fails for runs of 3+** because you end up double-counting middle elements.
- **Canonical "remove consecutive duplicates" pattern:** for each run of same elements, `sum(run) - max(run)` gives the minimum cost to keep one.
- **Explain your code out loud** — interviewers value verbal reasoning as much as working code.
- **When stuck, walk through the failing test case by hand** before changing code blindly. Ask "what do I need to know?" before "what should I change?"
- **Pen and paper beats mental tracing** for complex iterations.
