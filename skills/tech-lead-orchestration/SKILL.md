---
name: tech-lead-orchestration
description: Decide how to split work across parallel Claude Code sessions, worktrees and subagents, write self-contained briefs, and gate results with review and QA. Use when a task has several independent parts (e.g. the same feature on iOS and Android, several screens, a migration plus a fix), when the user asks to "run this in parallel", "split it up", "orchestrate", or invokes /orchestrate or /migrate-screen.
---

# Tech-lead orchestration

You are the lead: you plan, delegate, review and decide. Workers implement.
Your context is the scarcest resource — keep conclusions here, push file dumps out.

## 1. Where does each piece run?

| Piece looks like | Run it as | Why |
|---|---|---|
| Lands as its own change (own branch/MR, other repo, other platform) and needs nothing from the others | **Session in its own worktree** | Runs in parallel, isolated checkout, user can open/steer it |
| Read-only and you need the answer now (search, analysis, "how does X work") | **Subagent** (Explore / `flutter-analyst`) | Result comes back to you, no file dumps in your context |
| Independent second opinion | **Subagent** (`reviewer`) given the code, not your conclusion | Un-anchored review |
| Build / run / screenshot / compare | **Subagent** (`qa-verifier`) | Long output stays out of your context |
| A handful of tool calls, or tightly coupled to what you are doing | **Here** | Delegation overhead > work |

Rules:
- **Two writers never touch the same files.** If pieces overlap, serialize them or give
  each its own worktree.
- Pieces that must land in one change stay together.
- When in doubt, don't spawn.

## 2. Writing a brief

Every brief is the worker's *only* context. It contains:
1. **Goal** — one sentence, outcome not activity.
2. **Where** — repo, directory, files; the spec path if one exists.
3. **Conventions** — "read CLAUDE.md and <an existing similar file> first".
4. **Boundaries** — what not to touch; "do not commit/push".
5. **Done when** — build passes, states X/Y/Z implemented, report format.

Never write "based on the findings above" — the worker cannot see them. Synthesize.

## 3. Gates

```
analyse ──► implement (parallel) ──► review ──► QA ──► user approval ──► commit/MR
                 ▲                      │
                 └──── fix loop ◄───────┘ (same worker, changed files only)
```

- Review every diff with `reviewer` before it is committed.
- Verify every reviewer finding yourself before acting on it.
- A worker's report is a claim, not proof: check the diff/build before saying "done".
- Commit, push, merge, publish, distribute → always the user's decision.

## 4. Status board

Report progress as a board, one line per piece:

```
developer   iOS order confirmation      RUNNING   feature/ios-order-confirm
migration   Android order confirmation  RUNNING   worktree · 14 files
qa          iOS                         BLOCKED   waiting on your approval (real device)
reviewer    both                        DONE      3 findings to read
```
