# Mock Interview — Birthday Cake Candles & Container With Most Water (2025-06-01)
Source: https://youtu.be/iL-qgwYVJBE

Nailing the Tech Interview session. New Sunday format: Q&A, high-level walkthrough of an easy problem with pseudo code, then a volunteer mock interview. Wednesday sessions take problems to full solutions.

---

## [9:04](https://youtu.be/iL-qgwYVJBE?t=544) Q&A

### [9:04](https://youtu.be/iL-qgwYVJBE?t=544) Can you use Google or notes during Joy of Coding tech interviews?

- **Allowed:** syntax lookups (e.g., "how to set up the `count` method"), handwritten concept notes on stacks/queues/linked lists.
- **Not allowed:** full or partial solutions, ChatGPT / AI assistants, Googling things like "how to reverse an integer."

### [48:14](https://youtu.be/iL-qgwYVJBE?t=2894) Getting stuck transferring pseudo code into real code

Common pattern: student understands the problem, can write pseudo code, but freezes when it's time to write actual code.

Fix: don't try to jump to a final solution. Get **something** on the screen, then iterate.

- Write a template: empty `if`, empty `for` loop — just to have code to edit.
- Add `print` statements.
- Make an **assumption** ("I expect this to do X") and test it by running and observing.
- Make incremental progress from that point.

Referenced framework: **Dr. Emily's four problem-solving pillars** (review in prior sessions).

### [10:30](https://youtu.be/iL-qgwYVJBE?t=630) [approx] Can you Google the Big-O cost of built-in methods?

Yes — that's what the coach does too.

- Search pattern: "big O of [method] in [language]" (e.g., "big O of max in Python").
- Python wiki has an official [TimeComplexity page](https://wiki.python.org/moin/TimeComplexity) listing most list operations.
- **`max` / `min`**: O(n).
- **`len`**: O(1).
- **Index get/set** (`list[i]`): O(1).
- Tool mentioned: **bigocalc / bigocount** — paste code and it computes the complexity.

> Big-O explanation is **not required** for Joy of Coding tech interviews, but it comes up in real job interviews.

### [32:56](https://youtu.be/iL-qgwYVJBE?t=1976) How to actually understand Big-O

- Find code examples that illustrate each Big-O class.
- O(1) — declaring a variable, dict lookup by key, returning `array[0]` regardless of array size.
- O(n) — single loop through an array.
- O(log n) — phone-book bisection: cut the search space in half repeatedly.
- O(n²) — nested loop where the inner loop re-traverses the array for each outer element.
- **Two separate sequential loops over the same array = O(2n), not O(n²).** O(n²) is specifically nested traversal.
- Cumulative rule: if any section is O(n), the function is at least O(n). If any section is O(n²), it's at least O(n²).

### [26:52](https://youtu.be/iL-qgwYVJBE?t=1612) Do harder HackerRank problems expect more edge cases?

Yes. Higher difficulty → more test cases, more "gotcha" edge cases. Reading the **constraints** up front helps predict edge cases. It's also acceptable in a real interview to write draft code, run it, and catch edge cases iteratively — as long as you can explain what came up and how you handled it.

---

## [21:01](https://youtu.be/iL-qgwYVJBE?t=1261) [approx] Problem 1: Birthday Cake Candles (walkthrough)

**Source:** HackerRank easy.

**Prompt:** Given an array of candle heights, return the count of candles equal to the tallest height.

### [8:57](https://youtu.be/iL-qgwYVJBE?t=537) Pulling the problem apart

- **Input:** integer array of candle heights.
- **Output:** integer — count of tallest candles.
- **Example:** `[3, 2, 1, 3]` → `2` (two candles at height 3).
- **Constraints:** array length 1 → 10⁵ (100,000). Values 1 → 10⁷ (10,000,000).

### [13:36](https://youtu.be/iL-qgwYVJBE?t=816) Strip the metaphor

Restated plainly: *find the maximum value in the array, then count how many elements equal that maximum.*

### [31:31](https://youtu.be/iL-qgwYVJBE?t=1891) [approx] Strategy

Two things needed:

1. Max value in the array.
2. Count of elements equal to that max.

### [9:04](https://youtu.be/iL-qgwYVJBE?t=544) Two approaches

- **Built-in:** `max(candles)` then count matches.
- **Manual loop:** loop once tracking max, then second loop counting matches (or track both in a single pass for efficiency).

> When starting out, go for the most verbose method. Don't worry about being DRY or efficient — just get the test cases passing first.

### [13:30](https://youtu.be/iL-qgwYVJBE?t=810) Tip: blank return to unlock test cases

> HackerRank/LeetCode sometimes throws fake errors from their submission wrapper before your code runs. Add a stub `return 0` (or `return []` / `return False` depending on expected type) just to reveal the real test cases.

---

## [42:02](https://youtu.be/iL-qgwYVJBE?t=2522) [approx] Problem 2: Container With Most Water (mock interview — medium)

**Volunteer:** Jenny.

**Prompt:** Given an integer array `height`, each index is a vertical line. Pick two lines that together with the x-axis form a container holding the most water. Return the max area. Lines cannot slant.

### [45:32](https://youtu.be/iL-qgwYVJBE?t=2732) [approx] What Jenny did well

- Wrote out key phrases from the problem in comments.
- Initialized a variable (`waterVolume = 0`).
- Started a `for` loop to iterate.
- Ran the code partway through to see output.
- Flagged assumptions ("I think this means this") — a great habit.

### [48:08](https://youtu.be/iL-qgwYVJBE?t=2888) Where she got stuck

- Jumped into code before fully understanding the problem.
- Kept trying to **add** heights together (got 44 for the example — but expected 49).
- Didn't recognize that "area" implies **multiplication**, not addition.

### [52:30](https://youtu.be/iL-qgwYVJBE?t=3150) The coach's guided breakthrough

**Key question:** *"When you think area, what operation do you use?"*

Answer: multiplication (width × height).

- **Width** = distance along the x-axis between the two chosen lines.
- **Height** = the **shorter** of the two chosen lines (water can't rise above the shorter wall).

**Worked example** for `[1,8,6,2,5,4,8,3,7]`:

- The two tallest lines are at indices 1 and 8 (heights 8 and 7). Distance = 7. Min height = 7. Area = **7 × 7 = 49.** ✓
- Using the two 8s (indices 1 and 6): distance = 5, min height = 8, area = 40. Smaller.
- This is why it's **not** just "pick the tallest two" — distance matters too.

### [31:31](https://youtu.be/iL-qgwYVJBE?t=1891) Decoding the confusing wording

> "There are n vertical lines drawn such that the two end points of the iᵗʰ line are (i, 0) and (i, height[i])."

Translation: at each index `i`, the line runs from `(i, 0)` at the bottom to `(i, height[i])` at the top. You don't need to fully parse this sentence to solve the problem — the picture and the word "area" give enough to work from.

### [1:03:36](https://youtu.be/iL-qgwYVJBE?t=3816) Interview lessons from this mock

- **Test assumptions immediately** — print, run, compare to expected output.
- **Don't rush into code** before understanding the problem enough to know what you're testing.
- Brute force first, optimize later.
- Medium problems are **stacked easy problems** — same skills, more layers of assumption-testing.

### [37:38](https://youtu.be/iL-qgwYVJBE?t=2258) Efficiency hint (two-pointer approach)

One participant suggested: start with two pointers at opposite ends of the array and move inward. This is the named efficient algorithm for this problem (two-pointer technique). Brute-force a working solution first, then reverse-engineer the two-pointer optimization.

---

## [1:02:22](https://youtu.be/iL-qgwYVJBE?t=3742) General Guidance

- Practice harder than you play. Medium problems build the same fundamentals as easy problems, stacked.
- Reading the **example explanation** carefully often gives the breakthrough — they use words like "area" deliberately.
- The problem text is sometimes worded to confuse you (e.g., "water in a container" implies volume, but the problem is 2D area).
- `max_area` function signature and class structure in HackerRank/LeetCode starter code **must** be preserved — that's what the test harness calls. You can add helper functions inside, but don't rename the entry point.

[REVIEW: one participant speculated a linked-list approach would help — coach corrected that linked lists aren't the right tool here; the two-pointer technique on the array is.]
