{pkgs, ...}: {
  home.packages = [
    pkgs.oh-my-posh
    pkgs.nerd-fonts.meslo-lg
  ];

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    shellAliases = {
      ld = "lazydocker";
      llt = "eza -lr -snew";
    };
    initContent = ''
      # Update zellij tab name automatically
      zellij_tab_name_update() {
        if [[ -n $ZELLIJ ]]; then
          tab_name=""
          if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
            tab_name+=$(basename "$(git rev-parse --show-toplevel)")/
            tab_name=''${tab_name%/}
          else
            tab_name=$PWD
            if [[ $tab_name == $HOME ]]; then
              tab_name="~"
            else
              tab_name=''${tab_name##*/}
            fi
          fi
          command nohup zellij action rename-tab $tab_name >/dev/null 2>&1
        fi
      }
      zellij_tab_name_update
      chpwd_functions+=(zellij_tab_name_update)
    '';
    prezto = {
      enable = true;
      pmodules = [
        "environment"
        "terminal"
        "editor"
        "history"
        "directory"
        "spectrum"
        "git"
        "utility"
        "completion"
        "prompt"
        "ssh"
        "docker"
      ];
      terminal.autoTitle = null;
    };
  };

  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = true;
    configFile = ./oh-my-posh.yml;
  };

  programs.atuin = {
    enable = true;
    settings = {
      filter_mode_shell_up_key_binding = "session";
      enter_accept = true;
      search_mode = "fulltext";
    };
  };

  programs.zellij = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      theme = "tokyo-night";
      pane_frames = true;
      default_layout = "compact";
      keybinds.normal.unbind = "Ctrl b";
      keybinds.locked."bind \"Ctrl g\"".SwitchToMode = "Normal";
      keybinds.tab."bind \"Ctrl t\"".SwitchToMode = "Normal";
      keybinds."shared_except \"locked\""."bind \"Alt t\""."NewTab" = "";
      ui.pane_frames.hide_session_name = true;
    };
  };
}
