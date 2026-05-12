{
  pkgs,
  pkgs-unstable,
  ...
}: {
  programs.claude-code = {
    enable = true;
    package = pkgs-unstable.claude-code;
    settings = {
      statusLine = {
        type = "command";
        command = "npx -y ccstatusline@latest";
        padding = 0;
      };
      enabledPlugins = {
        "frontend-design@claude-plugins-official" = true;
        "code-simplifier@claude-plugins-official" = true;
        "code-review@claude-plugins-official" = true;
        "skill-creator@claude-plugins-official" = true;
      };
      attribution = {
        "commit" = "";
        "pr" = "";
      };
      spinnerTipsEnabled = false;
      model = "opusplan";
      effortLevel = "high";
      permissions = {
        #defaultMode = "plan";
        deny = [
          "Read(./.env)"
        ];
        ask = [
          "Bash(git commit *)"
        ];
        allow = [
          "Bash(ls *)"
          "Bash(find *)"
          "Bash(grep *)"
          "Bash(uv run mypy:*)"
          "Bash(uv run ruff:*)"
          "Bash(uv run pytest:*)"
          "Bash(npm run *)"
          "Bash(git diff *)"
          "Bash(git log *)"
          "Bash(/usr/bin/make *)"
          "mcp__claude_ai_Atlassian__ListAccessibleResources"
          "mcp__claude_ai_Atlassian__getJiraIssue"
        ];
      };
    };
    memory.text = ''
      # Global Instructions

      ## Shell

      Always use `/usr/bin/make` instead of `make` in Bash commands. The user's zsh has `make` defined as an autoloaded function for tab-completion that shadows the binary and can fail in non-interactive subshells.
    '';
  };

  home.packages = with pkgs; [
    (writeShellScriptBin "ccstatusline" ''
      exec npx ccstatusline@latest "$@"
    '')
  ];

  home.file = {
    ".config/ccstatusline/settings.json".source = ./ccstatusline.json;
  };
}
