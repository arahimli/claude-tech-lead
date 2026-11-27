#!/usr/bin/env bash
# PreToolUse hook (matcher: Bash).
# Blocks `git commit` / `git push` while the current branch is a protected one.
# Exit code 2 = block the tool call; stderr is shown to Claude as the reason.
#
# Edit PROTECTED to match your repo.
PROTECTED="main master develop"

input="$(cat)"

# Only react to git commit / git push commands.
if ! printf '%s' "$input" | grep -Eq '"command"[[:space:]]*:[[:space:]]*"[^"]*git[^"]*[[:space:]](commit|push)'; then
  exit 0
fi

branch="$(git symbolic-ref --short -q HEAD 2>/dev/null)"
for p in $PROTECTED; do
  if [ "$branch" = "$p" ]; then
    echo "Blocked by guard-protected-branches: commit/push on protected branch '$branch'. Create a feature branch first or ask the user." >&2
    exit 2
  fi
done

exit 0
