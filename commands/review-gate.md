---
description: Run an independent review gate on the current diff (or a given branch/path) before commit or merge.
argument-hint: [branch | path | "staged"]
---

Run a review gate on: **$ARGUMENTS** (default: all uncommitted changes in this repo).

1. Collect the diff (`git diff`, `git diff --staged`, or `git diff <base>...<branch>`).
   If a spec exists under `docs/migration-specs/`, include the relevant one.
2. Launch the `reviewer` subagent with the diff and the spec only — do not include your
   own assessment, so the review is not anchored on it.
3. Check every finding yourself against the code. Drop the ones that do not hold and say
   why in one line each.
4. Output:
   - **Verdict**: `PASS` (no blocker/major) or `CHANGES NEEDED`.
   - Verified findings, most severe first, `file:line` + one-line fix.
   - Files that must not be committed (debug hacks, secrets, temp logs), if any.
5. Do not fix anything unless I say so.
