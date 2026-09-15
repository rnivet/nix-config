#!/usr/bin/env bash
# Lay the tab template from tabs.conf into a freshly created herdr workspace.
#
# Run from the workspace.created event hook and from the "Apply default tabs"
# action. Both entry points are best effort: a failure here must never take the
# workspace with it, so the script logs and exits 0 rather than propagating.
set -uo pipefail

HERDR="${HERDR_BIN_PATH:-herdr}"
PLUGIN_ROOT="${HERDR_PLUGIN_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"
STATE_DIR="${HERDR_PLUGIN_STATE_DIR:-${TMPDIR:-/tmp}}"

# shellcheck source=lib.sh
source "$PLUGIN_ROOT/lib.sh"

# A failure here must not take the workspace with it, so give up quietly.
die() { log "$*"; exit 0; }

JQ=$(find_bin jq) || die "jq not found, cannot read herdr API output"

# ---------------------------------------------------------------------------
# Template
# ---------------------------------------------------------------------------

# tabs.conf calls `tab` once per tab; each call appends one \x1f-separated
# record. \x1f keeps commands free to contain any printable character.
TAB_SPECS=()
tab() {
  local label="$1" command="" if_git=0
  shift
  while [ $# -gt 0 ]; do
    case "$1" in
      --command) command="${2:-}"; shift 2 ;;
      --if-git) if_git=1; shift ;;
      *) log "ignoring unknown option '$1' for tab '$label'"; shift ;;
    esac
  done
  TAB_SPECS+=("${label}"$'\x1f'"${command}"$'\x1f'"${if_git}")
}

# A tabs.conf in the plugin config dir wins over the one shipped in the repo,
# so the template can be changed without a rebuild.
TABS_CONF="$PLUGIN_ROOT/tabs.conf"
[ -r "${HERDR_PLUGIN_CONFIG_DIR:-}/tabs.conf" ] && TABS_CONF="$HERDR_PLUGIN_CONFIG_DIR/tabs.conf"
[ -r "$TABS_CONF" ] || die "no readable tabs.conf (looked at $TABS_CONF)"
# shellcheck source=tabs.conf
source "$TABS_CONF"
[ ${#TAB_SPECS[@]} -gt 0 ] || die "$TABS_CONF declares no tabs"

# ---------------------------------------------------------------------------
# Target workspace
# ---------------------------------------------------------------------------

workspace="${HERDR_WORKSPACE_ID:-}"
if [ -z "$workspace" ] && [ -n "${HERDR_PLUGIN_EVENT_JSON:-}" ]; then
  # Event payloads nest the id differently per event, so take the first
  # workspace_id anywhere in the object.
  workspace=$(printf '%s' "$HERDR_PLUGIN_EVENT_JSON" |
    "$JQ" -r 'first(.. | objects | select(has("workspace_id")) | .workspace_id) // empty' 2>/dev/null)
fi
[ -n "$workspace" ] || die "no workspace id in environment or event payload"

# Serialize the event hook against a manual invoke on the same workspace.
lock="$STATE_DIR/lock-$workspace"
mkdir -p "$STATE_DIR" 2>/dev/null
if ! mkdir "$lock" 2>/dev/null; then
  log "workspace $workspace is already being laid out, skipping"
  exit 0
fi
trap 'rmdir "$lock" 2>/dev/null' EXIT

api() { "$HERDR" "$@" 2>/dev/null; }

ws_json=$(api workspace get "$workspace")
[ -n "$ws_json" ] || die "workspace $workspace not found"

read -r tab_count pane_count ws_label < <(
  printf '%s' "$ws_json" |
    "$JQ" -r '.result.workspace | "\(.tab_count) \(.pane_count) \(.label)"'
)

# Only touch a workspace that nothing has been done to yet: one tab, one pane,
# and herdr's placeholder tab label (a bare number). Anything else is someone's
# working space, template or not.
first_tab=$(api tab list --workspace "$workspace" |
  "$JQ" -r '[.result.tabs[] | select(.workspace_id == "'"$workspace"'")] | sort_by(.number) | .[0] // empty | @json')
[ -n "$first_tab" ] || die "workspace $workspace has no tabs"
first_tab_id=$(printf '%s' "$first_tab" | "$JQ" -r '.tab_id')
first_tab_label=$(printf '%s' "$first_tab" | "$JQ" -r '.label')

if [ "$tab_count" != "1" ] || [ "$pane_count" != "1" ] ||
   ! [[ "$first_tab_label" =~ ^[0-9]+$ ]]; then
  log "workspace $workspace ('$ws_label') is not a fresh workspace, leaving it alone"
  exit 0
fi

first_pane=$(api pane list --workspace "$workspace" |
  "$JQ" -r 'first(.result.panes[] | select(.tab_id == "'"$first_tab_id"'")) | .pane_id // empty')
[ -n "$first_pane" ] || die "no pane found in $first_tab_id"

# Every tab opens on the workspace's own directory rather than wherever the
# herdr server happens to be running.
cwd=$(api pane list --workspace "$workspace" |
  "$JQ" -r 'first(.result.panes[] | select(.pane_id == "'"$first_pane"'")) | .cwd // empty')
[ -n "$cwd" ] || cwd="$HOME"

is_git_repo=0
git -C "$cwd" rev-parse --is-inside-work-tree >/dev/null 2>&1 && is_git_repo=1

# ---------------------------------------------------------------------------
# Apply
# ---------------------------------------------------------------------------

run_in_pane() {
  local pane="$1" command="$2" if_git="$3"
  [ -n "$command" ] || return 0
  if [ "$if_git" = "1" ] && [ "$is_git_repo" != "1" ]; then
    log "$cwd is not a git work tree, leaving '$command' unstarted"
    return 0
  fi
  # A pane exists before its shell has drawn a prompt; typing into it too early
  # loses the keystrokes. Wait for a prompt, but send anyway on timeout — the
  # shell is usually just slow, not broken.
  api pane wait-output "$pane" --regex '[❯$%#>]' --lines 4 --timeout 5000 >/dev/null
  api pane send-text "$pane" "$command" && api pane send-keys "$pane" enter
}

applied=0
for spec in "${TAB_SPECS[@]}"; do
  IFS=$'\x1f' read -r label command if_git <<<"$spec"

  if [ "$applied" -eq 0 ]; then
    # The first template tab reuses the workspace's existing tab; creating a
    # new one would leave the placeholder behind.
    api tab rename "$first_tab_id" "$label" >/dev/null || log "could not rename $first_tab_id"
    pane="$first_pane"
  else
    created=$(api tab create --workspace "$workspace" --label "$label" --cwd "$cwd" --no-focus)
    pane=$(printf '%s' "$created" | "$JQ" -r '.result.root_pane.pane_id // empty')
    if [ -z "$pane" ]; then
      log "could not create tab '$label'"
      continue
    fi
  fi

  run_in_pane "$pane" "$command" "$if_git"
  applied=$((applied + 1))
done

# Creating with --no-focus leaves the active tab wherever it was; make it the
# first template tab explicitly so a new workspace always opens on it.
api tab focus "$first_tab_id" >/dev/null

log "applied $applied tabs to workspace $workspace ('$ws_label')"
