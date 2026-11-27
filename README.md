# tech-lead-kit

**Run Claude Code like a tech lead, not a senior engineer.**
Instead of having one chat write everything in sequence, you split the work, hand it to
parallel sessions and subagents, check the results with review and QA, and keep the
decisions (commit, push, merge) for yourself.

```
$ claude agents
● developer   order confirmation flow      BUILDING
● QA          waiting on your approval     BLOCKED
● migration   worktree · 214 files         RUNNING
● reviewer    3 findings to read           DONE
```

## Install

At the prompt of a Claude Code terminal session:

```
/plugin install tech-lead-kit --marketplace arahimli/claude-tech-lead
```

Answer `y` to add the marketplace, then pick a scope (`user` = every project).

From a shell:

```bash
claude plugin install tech-lead-kit --marketplace arahimli/claude-tech-lead
```

Update: `claude plugin update tech-lead-kit`, then `/reload-plugins` in the session.

Local development (without installing): `claude --plugin-dir /path/to/claude-tech-lead`

## What's inside

| Type | Name | Role |
|---|---|---|
| Subagent | `flutter-analyst` | Reads a Flutter screen and writes a complete spec (read-only) |
| Subagent | `platform-porter` | Ports to one platform (iOS **or** Android) — the "developer" |
| Subagent | `reviewer` | Independent review: correctness, parity, conventions (read-only) |
| Subagent | `qa-verifier` | Build, run, screenshot, compare; reports `BLOCKED` before irreversible steps |
| Command | `/orchestrate <task>` | Tech-lead mode: split → dispatch → review → QA → status board |
| Command | `/migrate-screen <path> [ios\|android\|both]` | analyst → two porters in parallel → reviewer → QA |
| Command | `/review-gate [branch\|path\|staged]` | Review gate before commit or merge |
| Skill | `tech-lead-orchestration` | Rules for session vs subagent vs worktree, brief template |
| Skill | `flutter-to-native-migration` | Flutter → SwiftUI / Compose mapping and parity checklist |
| Template | `templates/settings.json` | Permissions and hook wiring |
| Template | `templates/hooks/guard-protected-branches.sh` | Blocks commit/push on `main`/`master`/`develop` |
| Template | `templates/hooks/notify-done.sh` | Desktop notification when a session finishes |
| Template | `templates/CLAUDE.md.example` | Project rules template |

Commands are namespaced by the plugin, e.g. `/tech-lead-kit:review-gate`.

Agents, commands and skills are active as soon as the plugin is installed.
Templates are not wired up automatically — copy them into a project yourself:

```bash
mkdir -p .claude/hooks
cp ~/path/to/claude-tech-lead/templates/hooks/*.sh .claude/hooks/
cp ~/path/to/claude-tech-lead/templates/settings.json .claude/settings.json
cp ~/path/to/claude-tech-lead/templates/CLAUDE.md.example CLAUDE.md
```

(If the project already has `.claude/settings.json`, don't overwrite it — merge the
`hooks` and `permissions` sections.)

## Playbook

The full workflow: [docs/PLAYBOOK.md](docs/PLAYBOOK.md)

In short:

1. **Plan here** — you and the main session.
2. **Independent work → its own session + worktree** (e.g. iOS and Android in parallel).
3. **Search / analysis / review / QA → subagent** (the result comes back to you).
4. **Two writers never touch the same file.**
5. **Commit, push, merge — always your call.**

## License

MIT
