#!/usr/bin/env bash
# cmux-import-tmux.sh — replicate local tmux sessions/windows as cmux workspaces/tabs.
#
#   tmux session -> cmux workspace (same name)
#   tmux window  -> cmux tab in that workspace (same name, same order, same cwd)
#
# Only the first pane of each window is used. No commands are started; every
# tab opens a plain shell. tmux itself is not touched.
#
# Must run from a terminal inside cmux (the cmux socket rejects other callers).
#
# Usage:
#   cmux-import-tmux.sh [--dry-run] [session ...]
#     --dry-run   print the cmux commands instead of running them
#     session     import only these tmux sessions (default: all)
#
# Idempotent: a session whose workspace name already exists in cmux is skipped.

set -u

DRY=0
ONLY=()
for a in "$@"; do
  case "$a" in
    --dry-run|-n) DRY=1 ;;
    -h|--help) sed -n '2,18p' "$0"; exit 0 ;;
    *) ONLY+=("$a") ;;
  esac
done

command -v tmux >/dev/null || { echo "tmux not found" >&2; exit 1; }
command -v cmux >/dev/null || { echo "cmux CLI not found" >&2; exit 1; }
if [ "$DRY" -eq 0 ] && [ -z "${CMUX_WORKSPACE_ID:-}" ]; then
  echo "Run this from a terminal inside cmux (or use --dry-run)." >&2
  exit 1
fi
tmux has-session 2>/dev/null || { echo "no tmux server running" >&2; exit 1; }

# Print a command in copy-pasteable form.
show() { printf '  '; printf '%q ' "$@"; printf '\n'; }

# Run (or print) a cmux command; echo its stdout.
run() {
  if [ "$DRY" -eq 1 ]; then show "$@"; return 0; fi
  "$@"
}

existing=""
[ "$DRY" -eq 0 ] && existing=$(cmux list-workspaces 2>/dev/null)

wanted() {
  [ ${#ONLY[@]} -eq 0 ] && return 0
  local s; for s in "${ONLY[@]}"; do [ "$s" = "$1" ] && return 0; done
  return 1
}

created=0; skipped=0; tabs=0
while IFS= read -r session; do
  wanted "$session" || continue

  if [ -n "$existing" ] && printf '%s\n' "$existing" | grep -qF -- "$session"; then
    echo "skip  $session (a workspace with this name already exists)"
    skipped=$((skipped+1)); continue
  fi

  echo "== $session"
  first=1; ws=""
  # Window list: index, name, first pane's cwd. Tab-separated; names may have spaces.
  while IFS=$'\t' read -r idx name cwd; do
    [ -d "$cwd" ] || cwd="$HOME"
    if [ "$first" -eq 1 ]; then
      out=$(run cmux new-workspace --name "$session" --cwd "$cwd" --focus false) || { echo "  new-workspace failed: $out" >&2; continue 2; }
      if [ "$DRY" -eq 1 ]; then echo "$out"; ws="workspace:<new>"
      else
        ws=$(printf '%s' "$out" | grep -oE 'workspace:[0-9]+' | head -1)
        [ -n "$ws" ] || { echo "  could not parse workspace ref from: $out" >&2; exit 1; }
      fi
      # The new workspace's only tab is its focused tab.
      r=$(run cmux rename-tab --workspace "$ws" -- "$name"); [ "$DRY" -eq 1 ] && echo "$r"
      first=0
    else
      out=$(run cmux new-surface --workspace "$ws" --working-directory "$cwd" --focus false) || { echo "  new-surface failed for $name: $out" >&2; continue; }
      if [ "$DRY" -eq 1 ]; then echo "$out"; sf="surface:<new>"
      else
        sf=$(printf '%s' "$out" | grep -oE 'surface:[0-9]+' | head -1)
        [ -n "$sf" ] || { echo "  could not parse surface ref from: $out" >&2; continue; }
      fi
      r=$(run cmux rename-tab --workspace "$ws" --surface "$sf" -- "$name"); [ "$DRY" -eq 1 ] && echo "$r"
    fi
    tabs=$((tabs+1))
    [ "$DRY" -eq 0 ] && echo "  + tab $idx: $name  ($cwd)"
  done < <(
    # cmux inserts each new tab right after the first one, so add tabs 2..N in
    # reverse to end up with tmux order.
    tmux list-windows -t "=$session" -F $'#{window_index}\t#{window_name}\t#{pane_current_path}' 2>/dev/null \
      | sort -n | { IFS= read -r head; printf '%s\n' "$head"; tail -r 2>/dev/null || tac; }
  )
  created=$((created+1))
done < <(tmux list-sessions -F '#{session_name}' | tail -r 2>/dev/null)  # cmux puts new workspaces on top; create last-first

echo
[ "$DRY" -eq 1 ] && echo "(dry run, nothing changed)"
echo "workspaces: $created created, $skipped skipped; tabs: $tabs"
