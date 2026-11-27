#!/usr/bin/env bash
# Stop hook: desktop notification when a session finishes its turn,
# so you can leave parallel sessions running and come back when one is done.
title="Claude Code"
msg="Session finished in $(basename "${CLAUDE_PROJECT_DIR:-$PWD}")"

if command -v osascript >/dev/null 2>&1; then
  osascript -e "display notification \"$msg\" with title \"$title\"" >/dev/null 2>&1
elif command -v notify-send >/dev/null 2>&1; then
  notify-send "$title" "$msg"
fi
exit 0
