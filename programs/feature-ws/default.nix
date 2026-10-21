{
  lib,
  pkgs,
  ...
}: let
  feature-ws = pkgs.writeShellApplication {
    name = "feature-ws";
    runtimeInputs = with pkgs; [git coreutils findutils gnused];
    text = builtins.readFile ./feature-ws.sh;
  };
in {
  home.packages = [feature-ws];

  # Appended to the template in programs/herdr: an array-of-tables header is
  # valid anywhere in TOML. Store path, because popups run with the herdr
  # server's PATH, not the login shell's.
  home.file.".config/herdr/config.toml".text = lib.mkAfter ''

    [[keys.command]]
    key = "alt+shift+n"
    type = "popup"
    command = "${feature-ws}/bin/feature-ws new"
    width = "60%"
    height = "30%"
    description = "new feature space (multi-repo worktrees)"
  '';

  programs.claude-code = {
    settings.permissions.allow = [
      "Bash(feature-ws add *)"
      "Bash(feature-ws ls*)"
    ];
    # Before the repo map in programs/claude/oversoc.nix (mkOrder 1600).
    context = lib.mkAfter ''

      ## Feature workspaces

      A folder directly under `~/projects/features/` is a feature workspace: it holds one git worktree per repo the feature touches, all on a branch named after the folder, plus a `FEATURE.md`. Repos live in `~/projects/<repo>` (main clones) and are listed in the repo map below.

      When the session starts in a feature workspace:
      1. Read `FEATURE.md` and `feature-ws ls <name>` to see what is already set up.
      2. If the goal is not written down yet, ask for it (or the Jira ticket) and record it in `FEATURE.md`.
      3. Using the repo map, propose the repos the feature needs, with one line on why each, and wait for confirmation like any other change.
      4. Add them with `feature-ws add <repo>...` from the feature folder (connectors: `feature-ws add connectors/<name>`). It fetches, branches off origin's default branch (or reuses an existing feature branch) and copies ignored `.env*` files.
      5. Keep the `## Repos` section of `FEATURE.md` up to date with each repo's role in the feature.

      Rules:
      - Work only inside the worktrees; never edit or switch branches in `~/projects/<repo>` while in a feature workspace.
      - Each worktree is its own git repo: run git commands from inside it, and commit/PR per repo.
      - Each repo's own `CLAUDE.md`/`AGENTS.md` applies inside that repo.
      - Add a repo later if the work turns out to need it, after asking; never remove worktrees yourself (`feature-ws rm` is the user's).
    '';
  };
}
