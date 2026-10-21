# Per-feature multi-repo workspaces: one folder per feature under
# $FEATURES_DIR, holding a git worktree of every repo the feature touches, all
# on a branch named after the folder. Packaged with writeShellApplication, which
# supplies the shebang, `set -euo pipefail` and git on PATH.

PROJECTS="${FEATURE_WS_PROJECTS:-$HOME/projects}"
FEATURES_DIR="${FEATURE_WS_DIR:-$PROJECTS/features}"

usage() {
  cat <<EOF
usage: feature-ws <command> [args]

  new [name] [repo...]  create $FEATURES_DIR/<name>, add the repos, and open
                        a herdr workspace on it (prompts for the name if omitted)
  add <repo>...         from inside a feature folder, add worktrees of
                        $PROJECTS/<repo> on the feature branch
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
  local name src dest base
  name=$(basename "$root")
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
  else
    base=$(default_branch "$src") || die "$repo: cannot find origin's default branch"
    git -C "$src" worktree add --no-track -b "$name" "$dest" "$base"
  fi
  copy_env_files "$src" "$dest"
}

cmd_new() {
  local name="${1:-}"
  if [ -z "$name" ]; then
    read -r -p 'feature name (e.g. OVW-612-asset-tags): ' name
    [ -n "$name" ] || exit 0
  else
    shift
  fi
  git check-ref-format --branch "$name" >/dev/null 2>&1 || die "'$name' is not a valid branch name"
  case "$name" in */*) die "'$name' must not contain '/'" ;; esac

  local root="$FEATURES_DIR/$name"
  mkdir -p "$root"
  [ -e "$root/FEATURE.md" ] || printf '# %s\n\n## Goal\n\n## Repos\n\n## Notes\n' "$name" >"$root/FEATURE.md"

  local repo
  for repo in "$@"; do add_repo "$root" "$repo"; done

  local herdr="${HERDR_BIN_PATH:-$(command -v herdr || echo /opt/homebrew/bin/herdr)}"
  if [ -x "$herdr" ]; then
    "$herdr" workspace create --cwd "$root" --label "$name" --focus >/dev/null 2>&1 ||
      say "could not open a herdr workspace; $root is ready"
  else
    printf '%s\n' "$root"
  fi
}

cmd_add() {
  [ $# -gt 0 ] || die "usage: feature-ws add <repo>..."
  local root
  root=$(feature_root) || die "run this from inside a feature folder under $FEATURES_DIR"
  local repo
  for repo in "$@"; do add_repo "$root" "$repo"; done
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
  rm -f "$root/FEATURE.md"
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
