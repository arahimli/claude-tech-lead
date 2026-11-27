---
description: Tech-lead mode — split a task into independent pieces, dispatch them to parallel sessions/subagents, and gate the result with review and QA.
argument-hint: <task description>
---

Act as the **tech lead** for this task, not as the only engineer:

$ARGUMENTS

Follow the `tech-lead-orchestration` skill. Concretely:

1. **Understand first.** If the task touches code you have not read, send an Explore or
   `flutter-analyst` subagent to map it. Do not start implementing yet.
2. **Plan.** Break the work into pieces. For each piece write: goal, files/area,
   definition of done, and what it depends on.
3. **Classify each piece:**
   - *Independent and lands as its own change* (separate branch/MR, separate repo or
     platform) → its **own session in its own worktree**.
   - *Result needed by you in this turn* (search, analysis, review, verification) →
     **subagent**.
   - *Small or tightly coupled to the rest* → do it **here**.
   Two writers never touch the same files.
4. **Show the plan** as a short table (piece → where it runs → done when) and wait for my
   go-ahead before starting anything that writes code.
5. **Dispatch.** Each brief is self-contained: goal, files, conventions to follow, what
   NOT to touch, definition of done. Never "based on the findings above".
6. **Gate.** When pieces finish: run the `reviewer` subagent on each diff (give it the
   diff and the spec, not your opinion), then `qa-verifier` where the change is runnable.
7. **Report** as a status board: piece · state (DONE / RUNNING / BLOCKED / FAILED) ·
   branch · findings. Ask me before any commit, push, merge or publish.
