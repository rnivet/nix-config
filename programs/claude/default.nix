{
  pkgs,
  pkgs-unstable,
  ...
}: let
  herdrAgentStateHook = pkgs.writeShellScript "herdr-agent-state" (builtins.readFile ./herdr-agent-state.sh);
  cmuxNotifyHook = pkgs.writeShellScript "cmux-notify" ''
    EVENT=$(cat)
    EVENT_TYPE=$(printf '%s' "$EVENT" | ${pkgs.jq}/bin/jq -r '.hook_event_name')

    case "$EVENT_TYPE" in
      Notification)
        MSG=$(printf '%s' "$EVENT" | ${pkgs.jq}/bin/jq -r '.message // "Claude needs attention"')
        cmux notify --title "Claude Code" --body "$MSG"
        ;;
      Stop)
        cmux notify --title "Claude Code" --body "Waiting for input"
        ;;
    esac
  '';
in {
  programs.claude-code = {
    enable = true;
    package = pkgs-unstable.claude-code;
    settings = {
      autoMode = {};
      skipAutoPermissionPrompt = true;
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
      hooks = {
        Notification = [
          {
            hooks = [
              {
                type = "command";
                command = toString cmuxNotifyHook;
                async = true;
              }
            ];
          }
        ];
        Stop = [
          {
            hooks = [
              {
                type = "command";
                command = toString cmuxNotifyHook;
                async = true;
              }
            ];
          }
        ];
        SessionStart = [
          {
            hooks = [
              {
                type = "command";
                command = "${herdrAgentStateHook} session";
                async = true;
              }
            ];
          }
        ];
        PreToolUse = [
          {
            hooks = [
              {
                type = "command";
                command = "${herdrAgentStateHook} session";
                async = true;
              }
            ];
          }
        ];
      };
      permissions = {
        defaultMode = "auto";
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
    context = ''
      # Global Instructions

      ## Shell

      Always use `/usr/bin/make` instead of `make` in Bash commands. The user's zsh has `make` defined as an autoloaded function for tab-completion that shadows the binary and can fail in non-interactive subshells.

      ## Git

      NEVER commit changes yourself unless I explicitely ask you to. I'm using git diff to review your work before commiting
    '';
  };

  home.packages = with pkgs; [
    (writeShellScriptBin "ccstatusline" ''
      exec npx ccstatusline@latest "$@"
    '')
  ];

  home.file = {
    ".config/ccstatusline/settings.json".source = ./ccstatusline.json;
    ".claude/hooks/herdr-agent-state.sh" = {
      source = herdrAgentStateHook;
      executable = true;
    };
  };
}
