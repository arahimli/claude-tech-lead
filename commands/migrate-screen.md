---
description: Port one Flutter screen to iOS (SwiftUI) and Android (Compose) in parallel — analyst → two porters → reviewer → QA.
argument-hint: <path to Flutter screen or feature> [ios|android|both]
---

Migrate this Flutter screen/feature to native: **$ARGUMENTS**
(Platforms default to `both` when not given.)

Use the `flutter-to-native-migration` skill for mapping rules and the
`tech-lead-orchestration` skill for how to split the work.

## Pipeline

1. **Analyse** — run the `flutter-analyst` subagent on the given path. Save its spec to
   `docs/migration-specs/<screen-name>.md` in the working repo so every worker reads the
   same document. Show me the *Open questions* section and wait if it is not empty.
2. **Port in parallel** — one `platform-porter` per platform. If the iOS and Android
   code live in different repos or would touch overlapping files, give each its own
   session/worktree. Each brief names: the spec file, the target repo/directory, the
   project's CLAUDE.md, "build after each change", "do not commit".
3. **Review** — when both porters report, run the `reviewer` subagent once per
   platform with that platform's diff + the spec, and once across both for parity.
4. **QA** — run `qa-verifier` per platform; compare screenshots against the Flutter
   reference.
5. **Fix loop** — send blocker/major findings back to the porter that owns the file
   (same session, not a new one). Repeat review on the changed files only.
6. **Report** a status board per platform (DONE/RUNNING/BLOCKED/FAILED, branch, open
   findings) and ask before committing or opening merge requests.
