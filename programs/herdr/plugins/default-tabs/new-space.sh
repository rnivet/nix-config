#!/usr/bin/env bash
# Pick a directory, then open a workspace on it.
#
# Meant for a `type = "popup"` keybinding: herdr's own new-workspace command
# always inherits the current directory, so this asks first. Creating the
# workspace fires workspace.created, which is what lays the tabs out — this
# script never touches tabs itself.
set -uo pipefail

PLUGIN_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
source "$PLUGIN_ROOT/lib.sh"

# The popup closes the moment this exits, so anything worth reading has to
# linger on screen for a beat.
die() { log "$*"; sleep 2; exit 1; }

HERDR="${HERDR_BIN_PATH:-$(find_bin herdr)}"
[ -n "$HERDR" ] || die "herdr binary not found"
FZF=$(find_bin fzf) || die "fzf not found"
JQ=$(find_bin jq) || die "jq not found"
ZOXIDE=$(find_bin zoxide) || ZOXIDE=""

# Same directory herdr puts worktrees in; see worktrees.directory in config.toml.
PROJECTS="${HERDR_PROJECTS_DIR:-$HOME/projects}"

# ---------------------------------------------------------------------------
# Candidates
# ---------------------------------------------------------------------------

# Projects first so a fresh checkout is reachable before it has any zoxide
# history, then whatever else you actually visit.
candidates() {
  [ -d "$PROJECTS" ] && find "$PROJECTS" -mindepth 1 -maxdepth 1 -type d -print 2>/dev/null | sort
  [ -n "$ZOXIDE" ] && "$ZOXIDE" query --list 2>/dev/null
  # Never fail the pipeline just because one source is missing.
  return 0
}

# Drop paths that no longer exist, deduplicate keeping first appearance, and
# show $HOME as ~ so the list stays readable in a narrow popup.
choice=$(
  candidates |
    sed 's|/*$||' |
    awk '!seen[$0]++' |
    while IFS= read -r dir; do [ -d "$dir" ] && printf '%s\n' "$dir"; done |
    sed "s|^$HOME/|~/|; s|^$HOME\$|~|" |
    "$FZF" --prompt 'new space ❯ ' --height 100% --no-multi --print-query \
           --header 'enter opens a space here · any path can be typed' |
    tail -1
)
status=$?

# fzf exits 1 when nothing matched, which is fine: --print-query means the
# typed path is still on stdout. 130 is Escape.
[ "$status" -eq 0 ] || [ "$status" -eq 1 ] || exit 0
[ -n "$choice" ] || exit 0

case "$choice" in
  "~") choice="$HOME" ;;
  "~/"*) choice="$HOME/${choice#\~/}" ;;
esac

target=$(cd "$choice" 2>/dev/null && pwd) || die "no such directory: $choice"

# ---------------------------------------------------------------------------
# Create or focus
# ---------------------------------------------------------------------------

# A space already sitting in that directory is almost always the one you meant,
# so focus it rather than opening a second copy.
existing=$("$HERDR" pane list 2>/dev/null |
  "$JQ" -r --arg cwd "$target" 'first(.result.panes[] | select(.cwd == $cwd)) | .workspace_id // empty')

if [ -n "$existing" ]; then
  "$HERDR" workspace focus "$existing" >/dev/null 2>&1 || die "could not focus $existing"
  exit 0
fi

"$HERDR" workspace create --cwd "$target" --label "$(basename "$target")" --focus >/dev/null 2>&1 ||
  die "could not create a workspace on $target"
