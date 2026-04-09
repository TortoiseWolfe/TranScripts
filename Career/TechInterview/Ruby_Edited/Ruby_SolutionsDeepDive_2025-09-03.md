# Ruby Solutions Deep Dive — September 3, 2025
Source: https://youtu.be/MG3TELB2nJM

Wednesday session revisiting two problems after breakout room practice: **Can Place Flowers** (easy) and **Jump Game** (medium). Mauricio, Jenny, and the coach each walk through their own solutions to Jump Game, revealing three subtly different implementations of the same greedy insight.

---

## [28:07](https://youtu.be/MG3TELB2nJM?t=1687) Problem: Can Place Flowers

> You have a long flowerbed in which some plots are planted and others are not. However, flowers cannot be planted in adjacent plots. Given an integer array `flowerbed` containing `0`s (empty) and `1`s (not empty), and an integer `n`, return `true` if `n` new flowers can be planted without violating the no-adjacent rule.

### [2:20](https://youtu.be/MG3TELB2nJM?t=140) [approx] Example

- `flowerbed = [1,0,0,0,1], n = 1` → `true` (plant at index 2).
- `flowerbed = [1,0,0,0,1], n = 2` → `false` (can only fit one).

### [28:41](https://youtu.be/MG3TELB2nJM?t=1721) Edge rule

- The positions **outside** the array count as empty — you can plant at index 0 as long as index 1 is empty, and similarly at the last index.

---

## [29:32](https://youtu.be/MG3TELB2nJM?t=1772) Can Place Flowers: Solution

The approach uses `n` as a **countdown** of flowers still to plant, walks the bed once, and checks each empty slot against its neighbors.

```python
def canPlaceFlowers(flowerbed, n):
    for i, val in enumerate(flowerbed):
        pre = flowerbed[i - 1] if i - 1 >= 0 else 0
        post = flowerbed[i + 1] if i + 1 < len(flowerbed) else 0
        if val == 0 and pre == 0 and post == 0:
            flowerbed[i] = 1
            n -= 1
    return n <= 0
```

### [25:30](https://youtu.be/MG3TELB2nJM?t=1530) How it works

- **`pre`** and **`post`** fetch the left and right neighbors, defaulting to `0` when out of bounds (handling the edge rule cleanly).
- If the current slot is empty **and** both neighbors are empty, plant a flower (mutate the array to `1`) and decrement `n`.
- After walking the bed, return `n <= 0` — we either planted everything requested or we didn't.

### [44:34](https://youtu.be/MG3TELB2nJM?t=2674) Why mutate the array

- Setting `flowerbed[i] = 1` prevents the next iteration from planting an adjacent flower.
- Without this step, `[0, 0, 0]` with `n = 2` would incorrectly succeed.

### [14:03](https://youtu.be/MG3TELB2nJM?t=843) [approx] Complexity

- **Time:** O(n) — single pass.
- **Space:** O(1) — in-place mutation.

---

## [31:53](https://youtu.be/MG3TELB2nJM?t=1913) Problem: Jump Game

> You are given an integer array `nums`. You are initially positioned at the first index. Each element represents your **maximum** jump length at that position. Return `true` if you can reach the last index.

### [18:44](https://youtu.be/MG3TELB2nJM?t=1124) [approx] Examples

- `nums = [2,3,1,1,4]` → `true`
- `nums = [3,2,1,0,4]` → `false` (stuck on the `0`)

### [43:12](https://youtu.be/MG3TELB2nJM?t=2592) The sneaky part

> You don't have to jump the full distance. `nums[i] = 3` means you can jump 1, 2, **or** 3 steps. Sometimes the optimal path uses a shorter jump to land on a cell with a larger value.

Example: `[2, 5, 0, 0, 0, 0, 1]` — jumping the full 2 from index 0 lands on the `0` and gets stuck. Jumping only 1 lands on the `5` which reaches the end.

---

## [23:25](https://youtu.be/MG3TELB2nJM?t=1405) [approx] Jump Game: Three Solutions, Same Insight

### [25:46](https://youtu.be/MG3TELB2nJM?t=1546) [approx] Solution 1 — Mauricio (Python): Track `farthest`, Bail on Overshoot

```python
def canJump(nums):
    if len(nums) == 1:
        return True
    farthest = 0
    for i in range(len(nums)):
        if i > farthest:
            return False
        farthest = max(farthest, i + nums[i])
    return True
```

### [26:00](https://youtu.be/MG3TELB2nJM?t=1560) How it works

- **`farthest`** tracks the highest index we've proven reachable so far.
- At each step, if the current index `i` has already passed `farthest`, we can't possibly be standing here — return `False`.
- Otherwise, update `farthest` to the better of its current value or `i + nums[i]` (the furthest we could jump from here).
- If the loop completes without failing, we made it — return `True`.

### [10:11](https://youtu.be/MG3TELB2nJM?t=611) The key insight

> If `i > farthest` is never true during the walk, it means every position up to `len(nums) - 1` was reachable. The single check at the top of each iteration is sufficient — you don't need a separate "did we reach the end?" check.

### [32:48](https://youtu.be/MG3TELB2nJM?t=1968) [approx] Complexity

- **Time:** O(n) — single pass.
- **Space:** O(1).

---

### [35:08](https://youtu.be/MG3TELB2nJM?t=2108) [approx] Solution 2 — Jenny (JavaScript): Same Approach, Early Return on Reach

```javascript
function canJump(nums) {
    let maxReach = 0;
    for (let i = 0; i < nums.length; i++) {
        if (i > maxReach) return false;
        maxReach = Math.max(maxReach, i + nums[i]);
        if (maxReach >= nums.length - 1) return true;
    }
    return true;
}
```

### [25:25](https://youtu.be/MG3TELB2nJM?t=1525) Differences from Mauricio's

- Identical core logic; adds an **early return** when `maxReach` can already reach the last index.
- Slightly faster on inputs where the reachable frontier expands quickly.

---

### [17:25](https://youtu.be/MG3TELB2nJM?t=1045) Solution 3 — Ruby (Coach): Decrementing Fuel

A subtly different mental model: track the remaining "fuel" rather than the furthest reachable index.

```python
def canJump(nums):
    n = len(nums)
    if nums[0] == 0 and n > 1:
        return False
    if n == 1:
        return True

    jump = nums[0]
    for i in range(1, n):
        jump = max(jump - 1, nums[i])  # decrement, but refuel if current cell is better
        if jump == 0:
            return False
        if jump + i >= n - 1:
            return True
    return False
```

### [28:27](https://youtu.be/MG3TELB2nJM?t=1707) How it works

- **`jump`** represents "how many more steps of momentum I currently have".
- At each index, decrement `jump` by 1 (we used a step) but refill to `nums[i]` if that's larger — we just landed on a better launchpad.
- If `jump` ever hits `0` before reaching the end, return `False`.
- Early-exit when `jump + i` can reach the last index.

### [44:38](https://youtu.be/MG3TELB2nJM?t=2678) Why all three work

They're three encodings of the same greedy observation: **the furthest reachable index is monotonically non-decreasing as you walk forward, and you only need to know whether it ever reaches the end**. Whether you track "farthest index" or "remaining fuel" is just a representation choice.

---

## [56:22](https://youtu.be/MG3TELB2nJM?t=3382) The Coach's Bogus First Attempt

Before arriving at the decrementing-fuel solution, the coach first tried "always jump the maximum distance, back up if stuck":

- Jump to `i + nums[i]` immediately.
- If you land on a `0`, go backward looking for an earlier index that could reach the end.
- Added a `circular` flag to break infinite loops when the backward search found another "jump as far as possible" index that looped back.

### [50:03](https://youtu.be/MG3TELB2nJM?t=3003) Why it failed

- The bailout logic kept finding the same position it just came from, creating infinite loops.
- Each new edge case required another flag or condition — accumulating complexity is a red flag.

> When you start adding code for every single nuance you find, that means you're going bad ways. Step away, rethink, come back with a cleaner model.

### [46:17](https://youtu.be/MG3TELB2nJM?t=2777) The discipline

- If you catch yourself stacking more conditions and flags to handle edge cases, **stop**. The problem is probably in your overall approach, not in a missing condition.
- The coach lost ~10 minutes on this attempt, then solved the problem in 15-20 minutes with the fresh approach.

---

## [21:33](https://youtu.be/MG3TELB2nJM?t=1293) When to Use `while` vs `for` — Revisited

Lisa started working on Jump Game with a `while` loop because the step sizes are variable. Both `while` and `for` work here:

- **`for`** works because you only need to **walk** the array checking a condition at each index — the iterator itself isn't doing the jumping; `farthest` or `jump` tracks the state.
- **`while`** would be required if you actually advanced the index by `nums[i]` each iteration, but that greedy strategy is what led the coach's first attempt into infinite loops.

> The trick to greedy jump problems: don't have the loop variable do the jumping. Let it walk every index, and use a separate variable to track the reachable frontier.

---

## [58:19](https://youtu.be/MG3TELB2nJM?t=3499) Tech Interview Cookbook Note

Rebecca asked if she could keep the Mod 1 cookbook open during the tech interview.

- **No for full solutions** — the cookbook shouldn't contain complete problem solutions from previous students.
- **Yes for basic syntax** — your own notes on for-loop syntax, dictionary access, sort methods, etc. are fine.
- **Google is allowed** during the Joy of Coding tech interview for syntax lookups (e.g. "how do I use Python's max method") — when in doubt, ask in the moment.

---

## [28:04](https://youtu.be/MG3TELB2nJM?t=1684) Session Takeaways

- **Can Place Flowers** — mutate the array in place to prevent planting adjacent flowers in the same pass. Use out-of-bounds defaults to handle the edge rule cleanly.
- **Jump Game** — the greedy insight is that the furthest reachable index is monotonic; three different representations (`farthest`, `maxReach`, `jump`) all encode the same idea.
- **Don't have the loop variable do the jumping** — walk every index, track reachability separately.
- **Accumulating flags is a code smell** — when you're stacking special cases, your approach is probably wrong.
- **Three working solutions to the same problem** is great for mental flexibility — recognizing the same insight in different encodings is a skill.
