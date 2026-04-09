# Ruby Solutions Deep Dive — September 17, 2025
Source: https://youtu.be/0YgXnEU5wls

Mock interview session on the HackerRank **Number Line Jumps** (Kangaroo) problem, with coach feedback on problem-solving process, reading constraints, and pseudo code discipline.

---

## [2:59](https://youtu.be/0YgXnEU5wls?t=179) Session Format

The coach opened by offering breakout rooms or a mock interview. With only four attendees, the group stayed together and **John** volunteered as the candidate. He filtered HackerRank Algorithms by **status: unsolved** and **difficulty: easy**, selecting **Number Line Jumps**.

> Typical steps: restate the problem, pull useful information into pseudo code, write comments about your assumptions, sound out your thinking, and explain yourself as you code.

---

## [51:00](https://youtu.be/0YgXnEU5wls?t=3060) Problem: Number Line Jumps (Kangaroo)

Two kangaroos start at positions `x1` and `x2` on a number line and jump with velocities `v1` and `v2` respectively. Determine whether they will ever land on the same position **at the same jump**. Return the string `"YES"` or `"NO"`.

### [35:16](https://youtu.be/0YgXnEU5wls?t=2116) Inputs

- `x1` — starting location of kangaroo 1
- `v1` — jump velocity (meters per jump) of kangaroo 1
- `x2` — starting location of kangaroo 2
- `v2` — jump velocity of kangaroo 2

### [35:16](https://youtu.be/0YgXnEU5wls?t=2116) Key Insight the Candidate Missed Initially

Both kangaroos jump **simultaneously**. After each jump, kangaroo 1 is at `x1 + v1` and kangaroo 2 is at `x2 + v2`. They either meet on a shared jump or they never do.

> "It's the fourth dimension" — the candidate realized the jumps happen in lockstep, not independently.

---

## [15:42](https://youtu.be/0YgXnEU5wls?t=942) [approx] Candidate's Initial Attempt

John renamed `x1, v1, x2, v2` to more readable names like `kang_one_location`, `kang_one_velocity`, etc. He then tried a `while` loop but ran into an **infinite loop / timeout** on the test run.

```python
# Rough shape of the first attempt
def kangaroo(x1, v1, x2, v2):
    answer = False
    while kang_one != kang_two:
        if (kang_one + kang_one_velocity) == (kang_two + kang_two_velocity):
            answer = True
    return answer
```

### [34:39](https://youtu.be/0YgXnEU5wls?t=2079) Bugs the Coach Flagged

- **Positions never updated inside the loop.** The candidate computed `kang_one + velocity` each iteration but never reassigned `kang_one += velocity`, so the comparison evaluated the same values forever.
- **Return type mismatch.** The function signature expects a **string** (`"YES"` / `"NO"`), not a boolean. HackerRank's `if __name__ == "__main__":` block parses the return value and will error on a bool.
- **Chained assignment + comparison.** An attempt like `kang_one += v1 == kang_two += v2` is not valid Python.
- **No loop termination condition** for the case where the kangaroos can never meet.

---

## [52:41](https://youtu.be/0YgXnEU5wls?t=3161) Coach Feedback: Reading the Constraints

The coach pushed the candidate to re-read the **Constraints** section of the problem, where it states `1 <= x1 < x2 <= 10000`. The strict `<` between `x1` and `x2` is load-bearing:

- `x1` can **never** equal `x2` at the start, so the answer safely initializes to `false`.
- You do **not** need a defensive equality check on starting positions.
- `x2` is always further right than `x1`, which shapes the termination logic: if kangaroo 2 is ahead and moves at least as fast as kangaroo 1, they can never meet.

> "Sometimes the constraints don't give you anything, but it's a good practice to always check. More often than not they help eliminate assumptions or give you hints."

### [27:29](https://youtu.be/0YgXnEU5wls?t=1649) [approx] Velocity Constraints

`1 <= v1, v2 <= 10000`. The problem does **not** tell you whether `v1` is greater than, less than, or equal to `v2` — you must handle all three cases in your logic.

---

## [32:15](https://youtu.be/0YgXnEU5wls?t=1935) Coach Feedback: Assumptions in Comments

The coach pointed out that John verbalized several good observations while reading the problem ("they can jump forever", "x2 starts ahead") but never wrote them down, and then contradicted them in code.

> "If you're saying something out loud or having an assumption while you're reading the problem, literally write it in the comments. That way you're keeping those things in mind when you're thinking about your code."

---

## [40:05](https://youtu.be/0YgXnEU5wls?t=2405) Coach Feedback: Pseudo Code First

> "Getting some preliminary code out can help you think, but always take a step back and ask: what is the overall system this problem is asking me to implement? What requirements, outputs, and assumptions do I need to consider? Dealing with those at the front end saves time because you're not mitigating errors along the way."

---

## [42:47](https://youtu.be/0YgXnEU5wls?t=2567) Language Notes

The candidate's Python carried **JavaScript/TypeScript accent** — braces where colons belonged, missing indentation cues. The coach confirmed HackerRank allows any supported language; Python is used in the course because Mod 2 teaches Python, but candidates may use JavaScript, TypeScript, or others in their real interview.

- **TypeScript** enforces types as you go (helpful, but can slow you down).
- **JavaScript / Python** are more permissive — you must be mindful of types yourself.

---

## [43:25](https://youtu.be/0YgXnEU5wls?t=2605) Side Discussion: Example Walkthrough

A participant (Mauricio) asked why the example shows `x1 + v1 = 2 + 1`. The coach clarified:

- `x1 = 2` is the starting coordinate.
- `v1 = 1` is **meters per jump**.
- After one jump: `2 + 1 = 3`, so kangaroo 1 is at position 3.
- Kangaroo 2 starts at `x2` and moves `v2` per jump simultaneously.

The velocities are applied at the same time each iteration; that simultaneity is what makes the meeting condition solvable with a single check per jump.

---

## [53:37](https://youtu.be/0YgXnEU5wls?t=3217) Side Discussion: React Practice on HackerRank

John noted HackerRank's **Get Certified → Front End Developer** track has **React** problems. The coach confirmed these exist and are not too difficult, and also noted that candidates will get significant React practice during the Explorer phase and internship.

---

## [49:26](https://youtu.be/0YgXnEU5wls?t=2966) Takeaways

- **Read constraints first** — they often eliminate entire branches of defensive code.
- **Write your verbal assumptions into comments** before writing code.
- **Match the return type** the problem signature demands (string vs. bool vs. int).
- **Update loop state** inside the loop, or your `while` will never terminate.
- A **well-structured pseudo code pass** is cheaper than debugging an infinite loop under time pressure.
