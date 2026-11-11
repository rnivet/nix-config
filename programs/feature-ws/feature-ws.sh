# Per-feature multi-repo workspaces: one folder per feature under
# $FEATURES_DIR, holding a git worktree of every repo the feature touches, all
# on a branch named after the folder. Packaged with writeShellApplication, which
# supplies the shebang, `set -euo pipefail` and git on PATH.

PROJECTS="${FEATURE_WS_PROJECTS:-$HOME/projects}"
FEATURES_DIR="${FEATURE_WS_DIR:-$PROJECTS/features}"
DEFAULT_BASE=develop
# Per-feature file holding the branch new worktrees are based on.
BASE_FILE=.feature-ws-base

usage() {
  cat <<EOF
usage: feature-ws <command> [args]

  new [-b|--base <branch>] [name] [repo...]
                        create $FEATURES_DIR/<name>, add the repos, and open
                        a herdr workspace on it with a lazygit tab per repo
                        (prompts for the name and base if the name is
                        omitted); new branches start from
                        origin/<branch> (default $DEFAULT_BASE), or origin's
                        default branch in repos that lack it
  add <repo>...         from inside a feature folder, add worktrees of
                        $PROJECTS/<repo> on the feature branch, based on the
                        branch chosen at creation, and add any missing repo
                        tab to the feature's herdr workspace
                        (connectors use their sub-path, e.g. connectors/intune)
  ls [name]             list features, or the worktrees of one feature
  rm <name>             remove a feature's worktrees and folder; refuses if any
                        worktree has uncommitted changes, branches are kept
EOF
}

die() { printf 'feature-ws: %s\n' "$*" >&2; exit 1; }
say() { printf 'feature-ws: %s\n' "$*" >&2; }

# Feature root containing $PWD: the directory directly below $FEATURES_DIR.
feature_root() {
  local dir
  dir=$(pwd -P)
  local base
  base=$(cd "$FEATURES_DIR" 2>/dev/null && pwd -P) || return 1
  case "$dir/" in
    "$base"/*/*) ;;
    *) return 1 ;;
  esac
  local rel="${dir#"$base"/}"
  printf '%s/%s\n' "$base" "${rel%%/*}"
}

# Worktrees of a feature, as paths relative to its root. A worktree has a .git
# file (not directory); connectors sit one level deeper than other repos.
feature_worktrees() {
  local root="$1"
  find "$root" -mindepth 2 -maxdepth 3 -name .git -type f 2>/dev/null |
    sed "s|^$root/||; s|/\.git\$||" | sort
}

# Base branch of a feature; features created before it was recorded use the default.
feature_base() {
  local base=""
  [ -f "$1/$BASE_FILE" ] && base=$(head -n1 "$1/$BASE_FILE")
  printf '%s\n' "${base:-$DEFAULT_BASE}"
}

default_branch() {
  local src="$1" ref
  if ref=$(git -C "$src" symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null); then
    printf '%s\n' "$ref"
    return
  fi
  for ref in origin/main origin/master; do
    git -C "$src" rev-parse --verify --quiet "$ref" >/dev/null && { printf '%s\n' "$ref"; return; }
  done
  return 1
}

# Untracked, ignored .env* files of the main clone, copied so the worktree runs
# the same way. --directory collapses ignored folders such as node_modules, so
# this stays cheap; an .env inside an ignored folder is missed on purpose.
copy_env_files() {
  local src="$1" dest="$2" file
  git -C "$src" ls-files --others --ignored --exclude-standard --directory |
    while IFS= read -r file; do
      case "${file##*/}" in .env*) ;; *) continue ;; esac
      [ -f "$src/$file" ] && [ ! -e "$dest/$file" ] || continue
      mkdir -p "$(dirname "$dest/$file")"
      cp -p "$src/$file" "$dest/$file"
      say "  copied $file"
    done
}

add_repo() {
  local root="$1" repo="${2%/}"
  local name src dest base want
  name=$(basename "$root")
  want=$(feature_base "$root")
  src="$PROJECTS/$repo"
  dest="$root/$repo"

  [ -d "$src" ] || die "no repo at $src"
  git -C "$src" rev-parse --is-inside-work-tree >/dev/null 2>&1 || die "$src is not a git repo"
  # Branch off the main clone, never off another worktree such as overview~OVW-1.
  [ "$(git -C "$src" rev-parse --git-dir)" = "$(git -C "$src" rev-parse --git-common-dir)" ] ||
    die "$src is itself a worktree; use the main clone"
  if [ -e "$dest" ]; then
    say "$repo already in $name, skipping"
    return
  fi

  say "$repo: fetching origin"
  git -C "$src" fetch --quiet origin || die "$repo: fetch failed"

  if git -C "$src" show-ref --verify --quiet "refs/heads/$name"; then
    git -C "$src" worktree add "$dest" "$name"
  elif git -C "$src" show-ref --verify --quiet "refs/remotes/origin/$name"; then
    git -C "$src" worktree add --track -b "$name" "$dest" "origin/$name"
  elif git -C "$src" show-ref --verify --quiet "refs/remotes/origin/$want"; then
    git -C "$src" worktree add --no-track -b "$name" "$dest" "origin/$want"
  else
    base=$(default_branch "$src") || die "$repo: no origin/$want and cannot find origin's default branch"
    say "$repo: no origin/$want, branching off $base"
    git -C "$src" worktree add --no-track -b "$name" "$dest" "$base"
  fi
  copy_env_files "$src" "$dest"
}

# ---------------------------------------------------------------------------
# herdr: one lazygit tab per worktree in the feature's workspace. All of it is
# best effort; without herdr, or without a workspace on the feature, the
# worktrees are simply left without tabs.
# ---------------------------------------------------------------------------

herdr_bin() {
  local bin="${HERDR_BIN_PATH:-$(command -v herdr || true)}"
  [ -n "$bin" ] || bin=/opt/homebrew/bin/herdr
  [ -x "$bin" ] || return 1
  printf '%s\n' "$bin"
}

# Workspace showing a feature: the caller's own one when it sits in the
# feature, else the first one with a pane in it.
feature_space() {
  local herdr="$1" root="$2"
  { "$herdr" pane list 2>/dev/null || true; } |
    jq -r --arg root "$root" --arg own "${HERDR_WORKSPACE_ID:-}" '
      [.result.panes[]? | select((.cwd // "") as $c | $c == $root or ($c | startswith($root + "/")))
       | .workspace_id] | unique as $ws
      | if ($ws | any(. == $own)) then $own else ($ws[0] // empty) end' 2>/dev/null || true
}

# The default-tabs plugin only lays out a workspace that still has its single,
# numbered placeholder tab, so let it finish before adding tabs: wait for the
# placeholder to be renamed, then for the tab count to settle. Gives up after
# 10s, e.g. when the plugin is not linked.
wait_for_layout() {
  local herdr="$1" ws="$2" state count label last="" stable=0
  for _ in $(seq 40); do
    state=$({ "$herdr" tab list --workspace "$ws" 2>/dev/null || true; } |
      jq -r --arg ws "$ws" '[.result.tabs[]? | select(.workspace_id == $ws)] | sort_by(.number)
        | "\(length) \(.[0].label // "")"' 2>/dev/null || true)
    read -r count label <<<"$state" || true
    if [ -n "$label" ] && ! [[ "$label" =~ ^[0-9]+$ ]]; then
      if [ "$count" = "$last" ]; then
        stable=$((stable + 1))
        [ "$stable" -lt 3 ] || return 0
      else
        stable=0
      fi
      last="$count"
    fi
    sleep 0.25
  done
  say "default tabs did not settle, adding repo tabs anyway"
}

# Add a tab running lazygit for every worktree that has none yet, matched by
# label, so this can run again after each `add`.
sync_tabs() {
  local root="$1" ws="${2:-}" herdr labels wt pane
  herdr=$(herdr_bin) || return 0
  root=$(cd "$root" && pwd -P)
  [ -n "$ws" ] || ws=$(feature_space "$herdr" "$root")
  [ -n "$ws" ] || return 0
  labels=$({ "$herdr" tab list --workspace "$ws" 2>/dev/null || true; } |
    jq -r --arg ws "$ws" '.result.tabs[]? | select(.workspace_id == $ws) | .label' 2>/dev/null || true)

  # Lay all tabs out first, then start lazygit once each shell has a prompt.
  local panes=()
  while IFS= read -r wt; do
    grep -qxF -- "$wt" <<<"$labels" && continue
    pane=$({ "$herdr" tab create --workspace "$ws" --label "$wt" --cwd "$root/$wt" --no-focus 2>/dev/null || true; } |
      jq -r '.result.root_pane.pane_id // empty' 2>/dev/null || true)
    if [ -z "$pane" ]; then
      say "could not open a herdr tab for $wt"
      continue
    fi
    panes+=("$pane")
  done < <(feature_worktrees "$root")

  for pane in "${panes[@]}"; do
    "$herdr" pane wait-output "$pane" --regex '[❯$%#>]' --lines 4 --timeout 5000 >/dev/null 2>&1 || true
    { "$herdr" pane send-text "$pane" lazygit && "$herdr" pane send-keys "$pane" enter; } >/dev/null 2>&1 ||
      say "could not start lazygit in $pane"
  done
}

cmd_new() {
  local base=""
  while [ $# -gt 0 ]; do
    case "$1" in
      -b | --base)
        [ $# -ge 2 ] || die "$1 needs a branch name"
        base="$2"
        shift 2
        ;;
      --base=*) base="${1#--base=}"; shift ;;
      --) shift; break ;;
      -*) die "unknown option $1" ;;
      *) break ;;
    esac
  done

  local name="${1:-}"
  if [ -z "$name" ]; then
    read -r -p 'feature name (e.g. OVW-612-asset-tags): ' name
    [ -n "$name" ] || exit 0
    [ -n "$base" ] || read -r -p "base branch [$DEFAULT_BASE]: " base
  else
    shift
  fi
  git check-ref-format --branch "$name" >/dev/null 2>&1 || die "'$name' is not a valid branch name"
  case "$name" in */*) die "'$name' must not contain '/'" ;; esac

  local root="$FEATURES_DIR/$name"
  if [ -n "$base" ]; then
    base="${base#origin/}"
    git check-ref-format --branch "$base" >/dev/null 2>&1 || die "'$base' is not a valid branch name"
    if [ -f "$root/$BASE_FILE" ] && [ "$(feature_base "$root")" != "$base" ]; then
      die "$name already exists with base $(feature_base "$root")"
    fi
  fi
  mkdir -p "$root"
  [ -e "$root/FEATURE.md" ] || printf '# %s\n\n## Goal\n\n## Repos\n\n## Notes\n' "$name" >"$root/FEATURE.md"
  [ -e "$root/$BASE_FILE" ] || printf '%s\n' "${base:-$DEFAULT_BASE}" >"$root/$BASE_FILE"

  root=$(cd "$root" && pwd -P)

  local repo
  for repo in "$@"; do add_repo "$root" "$repo"; done

  local herdr ws
  if ! herdr=$(herdr_bin); then
    printf '%s\n' "$root"
    return
  fi
  ws=$({ "$herdr" workspace create --cwd "$root" --label "$name" --focus 2>/dev/null || true; } |
    jq -r '.result.workspace.workspace_id // empty' 2>/dev/null || true)
  if [ -z "$ws" ]; then
    say "could not open a herdr workspace; $root is ready"
    return
  fi
  wait_for_layout "$herdr" "$ws"
  sync_tabs "$root" "$ws"
}

cmd_add() {
  [ $# -gt 0 ] || die "usage: feature-ws add <repo>..."
  local root
  root=$(feature_root) || die "run this from inside a feature folder under $FEATURES_DIR"
  local repo
  for repo in "$@"; do add_repo "$root" "$repo"; done
  sync_tabs "$root"
}

cmd_ls() {
  local root wt
  if [ $# -gt 0 ]; then
    root="$FEATURES_DIR/$1"
    [ -d "$root" ] || die "no feature $1"
    feature_worktrees "$root" | while IFS= read -r wt; do
      printf '%-40s %s\n' "$wt" "$(git -C "$root/$wt" status --short --branch | head -1)"
    done
    return
  fi
  [ -d "$FEATURES_DIR" ] || return 0
  for root in "$FEATURES_DIR"/*/; do
    [ -d "$root" ] || continue
    root="${root%/}"
    printf '%-40s %s\n' "$(basename "$root")" "$(feature_worktrees "$root" | paste -sd ' ' -)"
  done
}

cmd_rm() {
  [ $# -eq 1 ] || die "usage: feature-ws rm <name>"
  local root="$FEATURES_DIR/$1"
  [ -d "$root" ] || die "no feature $1"

  local wt dirty=()
  local wts=()
  while IFS= read -r wt; do wts+=("$wt"); done < <(feature_worktrees "$root")
  for wt in "${wts[@]}"; do
    [ -z "$(git -C "$root/$wt" status --porcelain)" ] || dirty+=("$wt")
  done
  [ ${#dirty[@]} -eq 0 ] || die "uncommitted changes in: ${dirty[*]}"

  for wt in "${wts[@]}"; do
    git -C "$root/$wt" worktree remove "$root/$wt" || die "could not remove $wt"
    say "removed $wt (branch $1 kept)"
  done
  rm -f "$root/FEATURE.md" "$root/$BASE_FILE"
  find "$root" -depth -type d -empty -delete
  [ ! -e "$root" ] || die "$root still has files, left in place"
}

cmd="${1:-}"
[ $# -gt 0 ] && shift
case "$cmd" in
  new) cmd_new "$@" ;;
  add) cmd_add "$@" ;;
  ls) cmd_ls "$@" ;;
  rm) cmd_rm "$@" ;;
  -h | --help | help | "") usage ;;
  *) usage >&2; exit 1 ;;
esac
