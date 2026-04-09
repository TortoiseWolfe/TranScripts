# Ruby Solutions Deep Dive — January 28, 2026
Source: https://youtu.be/y_BGi1xOHe8

Group mock interview on **Baseball Game** (LeetCode Easy, problem 682). Extended lesson on why restating each operation in your own words before pseudo coding saves time on problems with many rules.

---

## Problem: Baseball Game (LeetCode 682)

> You are keeping the scores for a baseball game with strange rules. Given a list of strings `operations`, apply each operation to the record and return the sum of all scores after all operations. Each operation is one of:
>
> - **Integer `x`** — record a new score of `x`
> - **`"+"`** — record a new score that is the sum of the **previous two** scores
> - **`"D"`** — record a new score that is **double** the previous score
> - **`"C"`** — **invalidate** the previous score, removing it from the record

### Examples

**Example 1:** `["5", "2", "C", "D", "+"]` → `30`
- `5` → record: `[5]`
- `2` → record: `[5, 2]`
- `C` → invalidate last: `[5]`
- `D` → double previous: `[5, 10]`
- `+` → sum of last two: `[5, 10, 15]`
- Total: `5 + 10 + 15 = 30`

**Example 2:** `["5", "-2", "4", "C", "D", "9", "+", "+"]` → `27`

### Constraints

- `1 <= operations.length <= 1000`
- Integer operations are strings representing values in `[-3*10^4, 3*10^4]`
- For `+`, there will always be at least **two previous scores**
- For `C` and `D`, there will always be at least **one previous score**

---

## Linda's Pseudo Code Walkthrough

Linda tried to write pseudo code directly without first restating each operation in her own words. This became the central lesson of the session.

### Initial Sketch

```python
def calPoints(operations):
    score = []
    total_sum = []  # Linda's initial approach
    for element in operations:
        if element is an integer:
            total_sum.append(element)
        if element == "+":
            # record sum of previous two
            ...
        if element == "D":
            # record double of previous
            score.append(score * 2)
        if element == "C":
            # delete previous
            score.pop()
    return total_sum
```

---

## Key Confusion: What Does "Previous" Mean For Each Operation?

Linda mixed up two different interpretations of "previous":

1. **`+`** — sum of the **previous two** scores (both remain in the record)
2. **`D`** — **double** the **single previous** score (the previous score remains in the record)
3. **`C`** — **invalidate and remove** the **single previous** score

### Coach Feedback: `D` Does Not Replace

When Linda wrote `score = [10]` after `D` on a starting `[5]`, the coach corrected:

> "Look at the example. After the `D` on `[5]`, the record becomes `[5, 10]`, not `[10]`. You're supposed to record a **new** score that is double the previous — the previous one stays."

### Coach Feedback: Which Value Do You Double?

When the coach gave Linda a hypothetical `score = [5, 3, 2, 4]` and asked "what does `D` produce?", Linda initially tried to pick a value at random. The correct answer: **the last element**, which is `4`. So `D` produces `8` and the new record is `[5, 3, 2, 4, 8]`.

> "How are you going to grab that value?" → Linda: "I'd pop it off and multiply by two." Close — but `pop` **removes** the element. For `D`, you want `score[-1] * 2` (read without removing) and append the result.

### Correct `D` Operation

```python
if element == "D":
    score.append(score[-1] * 2)
```

---

## Why String vs Int Matters

`operations` is a list of **strings**, not a mix of strings and ints. `"5"` and `"-2"` are strings. When Linda tried to append `element` directly to `score` for an integer case, the coach pointed out the eventual need to cast.

```python
if element not in ("+", "D", "C"):
    score.append(int(element))
```

Check for non-operation strings first (everything that isn't `+`, `D`, or `C` is an integer string). Cast with `int()` before appending.

---

## The Correct Solution

```python
class Solution:
    def calPoints(self, operations: List[str]) -> int:
        record = []
        for op in operations:
            if op == "+":
                record.append(record[-1] + record[-2])
            elif op == "D":
                record.append(record[-1] * 2)
            elif op == "C":
                record.pop()
            else:
                record.append(int(op))
        return sum(record)
```

### Key Details

- **`record[-1]`** — last element, Python's idiomatic way to access "previous"
- **`record[-1] + record[-2]`** — sum of the last two, for `+`
- **`record.pop()`** — remove and discard the last score, for `C`
- **`sum(record)`** — final total, returned as an int
- Only cast strings to int in the `else` branch when you know it's a numeric string

---

## The Core Lesson: Restate Operations In Your Own Words First

Linda skipped the step of writing each operation in plain English and tried to jump straight into pseudo code. This caused her to repeatedly jump back to the problem to re-read what each letter meant.

### Coach's Prescription

> "Take the parts of the problem and put them in your own words in the comments. Line by line: 'You get X — it's an integer, track it in an array. You get plus — it takes the previous two and sums them and keeps them all. You get D — it doubles the last and adds it. You get C — it removes the last.' That's in words, not pseudo code."

> "Then you compare that against the examples to make sure what you've written matches. If it's not, course-correct before writing code."

### Why Skipping That Step Cost Time

> "We kept going back — wait, what does `+` mean again? What does `D` do? If we had that in our own words at the top of the function, we wouldn't have to jump around as much."

### The Universal Rule

> "Even if you feel you know a problem backwards and forwards, I'm still going to do that step. I don't skip steps ever. That's the whole point of having a good list of steps — you take them every time. You don't change your habits. You don't get lost. The steps are there to help you."

---

## Session Duration Reflection

The full pseudo code phase took about 40 minutes. The coach's target:

> "That process needs to take 10 minutes, not 40. Once you got to the end, you had something ready to turn into code — but the **time to get there** is what's blocking you from scheduling your tech interview. Follow your steps every time, and your time will decrease."

Linda explicitly said this matched what Claude had told her about "put it in your own words before you do anything."

---

## Takeaways

- **`record[-1]`** and **`record[-2]`** are the idiomatic way to access "previous" and "previous-previous" in a Python list.
- **`list.pop()`** removes **and returns** the last element. Use it for `C`, but not for `D` (where you want to keep the previous score).
- **`list.append(list[-1] * 2)`** for "double the previous."
- **Cast strings to int** in the numeric-element branch only.
- **Sum in the final step** with `sum(record)`.
- **Restate each rule of the problem in plain English** before writing any pseudo code. This is non-negotiable on multi-rule problems.
- **Follow your own process steps every time**, even on problems you think you understand. Skipping steps causes backtracking.
