# Tech-lead playbook

## The idea

A senior engineer writes the code. A tech lead **splits the work, gives each piece to the
right person, checks the result and makes the call**. In Claude Code, the "people" are:

| "Team member" | In Claude Code | When |
|---|---|---|
| Another developer | **Session** (with its own worktree) | Independent work that lands as its own branch/MR |
| A colleague helping out | **Subagent** | Work whose result you need now: search, analysis, review, QA |
| You | **Main session** | Plan, briefs, review decisions, approvals |

These are built-in Claude Code features (CLI, desktop app, web) — this plugin adds ready
**roles, commands and rules** on top of them.

## Decision tree

```
Will this land as its own commit/MR and not depend on the other pieces?
├─ Yes → does it touch the same files as another piece?
│   ├─ Yes → do them in sequence (or in separate worktrees, then merge)
│   └─ No  → OWN SESSION + WORKTREE
└─ No → do I need the result right now (search / analysis / review / QA)?
    ├─ Yes → SUBAGENT
    └─ No / a few tool calls of work → DO IT HERE
```

## Typical scenario: porting one screen to iOS + Android

```
/tech-lead-kit:migrate-screen lib/features/order/order_confirmation_page.dart both
```

1. `flutter-analyst` → `docs/migration-specs/order-confirmation.md` (both porters read the same document)
2. If there are open questions — you answer them
3. iOS porter ‖ Android porter — in parallel, separate repos/worktrees
4. `reviewer` × 2 (per platform) + 1 (parity)
5. `qa-verifier` × 2 — screenshot comparison
6. Fix loop — a finding goes back to the porter that owns the file (not a new session)
7. Status board → you decide on commit/MR

## What a good brief looks like

Bad:
> Do the Android side too, based on what we found above.

Good:
> **Goal:** implement the `docs/migration-specs/order-confirmation.md` spec 1:1 in Android Compose.
> **Where:** `android/feature/order/` — use the existing `OrderListScreen.kt` as the pattern.
> **Rules:** read `CLAUDE.md` first; use design-system components; strings via localization.
> **Don't touch:** `core/network`, the iOS folder. Don't commit.
> **Done when:** `./gradlew assembleDebug` passes; all 4 states from the spec are implemented; report lists changed files and any spec items not implemented.

## Status board

After each step Claude reports like this:

```
developer   iOS order confirmation      DONE      feature/ios-order-confirm
migration   Android order confirmation  RUNNING   worktree · 14 files
qa          iOS                         BLOCKED   real-device test — waiting on your approval
reviewer    iOS                         DONE      3 findings to read
```

## Golden rules

1. **Analysis first, code second.** No porter starts without a spec.
2. **Two writers never touch the same file.**
3. **Give the reviewer the code, not your opinion** — otherwise the review just confirms your opinion.
4. **A worker's report is a claim, not proof** — look at the diff and the build yourself.
5. **Irreversible steps (commit, push, merge, publish, real payments/data) — only on your "yes".**
6. **When in doubt, don't spawn.** Every agent costs tokens; do small work yourself.
