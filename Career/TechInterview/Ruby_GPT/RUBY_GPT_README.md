# Ruby GPT — Setup Guide

This directory contains everything needed to build an OpenAI Custom GPT named **Ruby — Interview Coach** from the Joy of Coding Academy mock-interview transcripts.

## What's in this directory

| File | Purpose | Upload to GPT? |
|---|---|---|
| `Ruby_CoachingPhilosophy.md` | Ruby's coaching doctrine — Socratic moves, hint ladder, anti-patterns | ✅ Yes (knowledge file 1) |
| `Ruby_ProblemIndex.md` | Lookup table of every problem Ruby has covered, by name/date/technique, with Source video links | ✅ Yes (knowledge file 2) |
| `Ruby_MockInterviews.md` | Concatenated transcripts of all 20 live mock-interview sessions with clickable YouTube timestamp anchors | ✅ Yes (knowledge file 3) |
| `Ruby_SolutionsDeepDive.md` | Concatenated transcripts of 36 solution deep-dives + make-up sessions with clickable YouTube timestamp anchors | ✅ Yes (knowledge file 4) |
| `RUBY_GPT_SYSTEM_PROMPT.md` | The text to paste into the GPT's "Instructions" field | ❌ No — paste as Instructions |
| `RUBY_GPT_README.md` | This file | ❌ No |

**Free-tier knowledge file cap is 5.** We're using 4 and leaving 1 slot open for future sessions or a pattern cheatsheet.

## How to build the GPT

1. Go to **chat.openai.com/gpts/editor** (you need a ChatGPT account — free tier is fine).
2. Click **Create**.
3. In the **Configure** tab:

   **Name** (copy this into the Name field):

   ```
   Ruby — Interview Coach
   ```

   **Description** (copy this into the Description field):

   ```
   Socratic coding-interview coach trained on the Ruby mock-interview series. Walks you through LeetCode and HackerRank problems without spoiling the answer. Defaults to Python 3; ask for another language anytime.
   ```

   **Instructions:** Open `RUBY_GPT_SYSTEM_PROMPT.md`, copy everything between the `## Begin System Prompt` and `## End System Prompt` markers, paste it into the Instructions field.

   **Conversation starters** (copy each into a separate starter slot):

   ```
   I'm stuck on a LeetCode problem — can you coach me through it?
   ```

   ```
   Help me brute-force this before I optimize.
   ```

   ```
   What should I be saying out loud during a mock interview?
   ```

   ```
   Review my approach — am I missing any edge cases?
   ```

   ```
   Show me where Ruby covered Two Sum — link me to the video.
   ```
   - **Knowledge:** click **Upload files** and upload these 4 files in order:
     1. `Ruby_CoachingPhilosophy.md`
     2. `Ruby_ProblemIndex.md`
     3. `Ruby_MockInterviews.md`
     4. `Ruby_SolutionsDeepDive.md`
   - **Capabilities:**
     - ✅ Web Browsing (so it can fetch LeetCode/HackerRank problem statements from pasted URLs)
     - ✅ Code Interpreter (so it can run the *student's* code to verify behavior — NOT to solve for them)
     - ❌ DALL·E Image Generation
     - ❌ Actions
4. In the **Create** tab (the left pane), you can chat-test as you configure. Run the smoke tests below.
5. Click **Save** → choose visibility (**Only me** is fine for personal use; **Anyone with a link** if you want to share).

## Smoke tests (run after upload)

Paste each of these into the GPT and verify the response matches expectations.

### Test 1: Refuses to give the answer
- **Prompt:** `I'm stuck on Two Sum. Just give me the answer.`
- **Expected:** Warm refusal. Asks what the student has tried. Offers to start at rung 1 of the hint ladder.
- **Red flag:** GPT writes the actual solution code.

### Test 2: Brute-force-first doctrine
- **Prompt:** `What should I do first when I see a new coding problem?`
- **Expected:** Cites the brute-force-first rule. Mentions the two-thirds-of-test-cases threshold. May reference Ruby's actual phrasing ("default to brute force even if it violates the constraints").
- **Red flag:** GPT suggests jumping to the optimized algorithm.

### Test 3: Problem index lookup
- **Prompt:** `Has Ruby covered Move Zeroes?`
- **Expected:** Finds it in the Problem Index, references the 2026-03-25 SolutionsDeepDive session, mentions the two-pointer + in-place technique. Does not spoil the solution.
- **Red flag:** GPT says "no" when the index clearly has it.

### Test 4: Language flexibility
- **Prompt:** `I'm coding in Ruby the language, not Python. Can you still help?`
- **Expected:** Yes. Acknowledges the transcript examples are Python, offers to coach in Ruby.
- **Red flag:** GPT refuses or insists on Python.

### Test 5: Communication coaching
- **Prompt:** `I have a mock interview tomorrow. What should I actually be saying out loud?`
- **Expected:** Walks through the think-aloud pattern: state inputs, state outputs, state assumptions, state first instinct before coding. Mentions narrating as you type.
- **Red flag:** GPT talks only about code correctness.

### Test 6: Anti-pattern detection
- **Prompt:** `Here's my code for Two Sum: def two_sum(nums, target): return 1` (obviously wrong hardcoded return)
- **Expected:** Catches the hardcoded return immediately, explains why coincidental passes are dangerous, asks the student to describe what they're actually trying to do.
- **Red flag:** GPT runs it, reports the failure, and offers a fix without coaching.

## If something goes wrong

- **GPT starts giving answers:** Re-read Hard Rule #1 in the system prompt. Tighten with a more explicit refusal example and re-save.
- **GPT forgets Python default:** Hard Rule #5 needs emphasis. Consider moving it earlier in the prompt.
- **GPT can't find a problem in the index:** Verify `Ruby_ProblemIndex.md` uploaded successfully. OpenAI sometimes silently fails on MD files > 2MB (ours are tiny, should be fine).
- **GPT writes complete brute-force code anyway:** Add to the prompt: "When sketching brute force, use natural language pseudocode only — no runnable Python. The student writes the code."

## Maintenance

When new Ruby sessions are added:
1. Pull the timed transcript with `get_timed_transcript` and save to `Ruby/timed/`.
2. Clean the raw transcript with `/clean-transcript` into `Ruby_Edited/` — this now automatically injects Source URLs and clickable timestamp anchors on section headers.
3. Re-run the concatenation for the affected file (`Ruby_MockInterviews.md` or `Ruby_SolutionsDeepDive.md`).
4. Add the new row to `Ruby_ProblemIndex.md` with the Source video link.
5. Re-upload the updated file to the GPT (OpenAI lets you replace individual knowledge files).

See `memory/feedback_transcript_workflow.md` for the full workflow rules.

The 5th knowledge slot is reserved for if/when the session corpus grows past what fits cleanly in 4 files, or for a pattern cheatsheet you may want to add later.
