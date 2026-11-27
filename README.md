# tech-lead-kit

**Claude Code-u senior engineer kimi yox, tech lead kimi işlət.**
Bir chat-də hər şeyi ardıcıl yazdırmaq əvəzinə işi bölürsən, paralel session/subagent-lərə
paylayırsan, nəticəni review + QA ilə yoxlayırsan, qərarları (commit, push, merge) özün verirsən.

```
$ claude agents
● developer   order confirmation flow      BUILDING
● QA          waiting on your approval     BLOCKED
● migration   worktree · 214 files         RUNNING
● reviewer    3 findings to read           DONE
```

## Quraşdırma

Claude Code terminal session-ında:

```
/plugin install tech-lead-kit --marketplace arahimli/claude-tech-lead
```

`y` — marketplace-i əlavə etmək üçün, sonra scope seç (user = bütün layihələrdə).

Shell-dən:

```bash
claude plugin install tech-lead-kit --marketplace arahimli/claude-tech-lead
```

Yeniləmə: `claude plugin update tech-lead-kit`, sonra session-da `/reload-plugins`.

Lokal inkişaf üçün (quraşdırmadan): `claude --plugin-dir /path/to/claude-tech-lead`

## İçində nə var

| Növ | Ad | Rolu |
|---|---|---|
| Subagent | `flutter-analyst` | Flutter ekranını oxuyur, tam spec çıxarır (read-only) |
| Subagent | `platform-porter` | Bir platformaya (iOS **və ya** Android) port edir — "developer" |
| Subagent | `reviewer` | Müstəqil review: correctness, parity, konvensiya (read-only) |
| Subagent | `qa-verifier` | Build + run + screenshot + müqayisə; geri dönməz addımda `BLOCKED` |
| Command | `/orchestrate <task>` | Tech-lead rejimi: böl → payla → review → QA → status board |
| Command | `/migrate-screen <path> [ios\|android\|both]` | analyst → 2 porter paralel → reviewer → QA |
| Command | `/review-gate [branch\|path\|staged]` | Commit/merge-dən əvvəl review qapısı |
| Skill | `tech-lead-orchestration` | Session vs subagent vs worktree qərar qaydaları, brief şablonu |
| Skill | `flutter-to-native-migration` | Flutter → SwiftUI / Compose xəritəsi + parity checklist |
| Şablon | `templates/settings.json` | İcazələr + hook qoşulması |
| Şablon | `templates/hooks/guard-protected-branches.sh` | `main`/`master`/`develop`-də commit/push-u bloklayır |
| Şablon | `templates/hooks/notify-done.sh` | Session bitəndə desktop bildirişi |
| Şablon | `templates/CLAUDE.md.example` | Layihə qaydaları şablonu |

Plugin-dən gələn agent/command/skill-lər quraşdırılan kimi aktivdir.
Şablonlar avtomatik qoşulmur — layihəyə öz istəyinlə kopyalayırsan:

```bash
mkdir -p .claude/hooks
cp ~/path/to/claude-tech-lead/templates/hooks/*.sh .claude/hooks/
cp ~/path/to/claude-tech-lead/templates/settings.json .claude/settings.json
cp ~/path/to/claude-tech-lead/templates/CLAUDE.md.example CLAUDE.md
```

(Mövcud `.claude/settings.json` varsa üzərinə yazma — `hooks` və `permissions` bölmələrini birləşdir.)

## Playbook

İş axınının tam izahı: [docs/PLAYBOOK.md](docs/PLAYBOOK.md)

Qısaca:

1. **Plan burada** — sən və baş session.
2. **Müstəqil iş → ayrı session + worktree** (məs. iOS və Android paralel).
3. **Axtarış / analiz / review / QA → subagent** (nəticə sənə qayıdır).
4. **İki writer eyni fayla toxunmur.**
5. **Commit, push, merge — həmişə sənin qərarın.**
