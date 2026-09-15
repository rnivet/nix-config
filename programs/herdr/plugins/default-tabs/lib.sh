# Helpers shared by the default-tabs scripts. Sourced, never executed.

log() { printf 'default-tabs: %s\n' "$*" >&2; }

# Plugin commands and popups are spawned by the herdr server, whose PATH is
# whatever launched the server rather than the login shell's. Resolve tools by
# hand instead of trusting `command -v` alone.
find_bin() {
  local name="$1" candidate
  for candidate in \
    "$(command -v "$name" 2>/dev/null)" \
    "/etc/profiles/per-user/${USER:-$(id -un)}/bin/$name" \
    "/run/current-system/sw/bin/$name" \
    "/opt/homebrew/bin/$name" \
    "/usr/local/bin/$name"; do
    [ -n "$candidate" ] && [ -x "$candidate" ] && { printf '%s' "$candidate"; return 0; }
  done
  return 1
}
