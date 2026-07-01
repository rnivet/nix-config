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
      llt = "eza -l -snew";
    };
    initContent = ''
      # Auto-start herdr only in Ghostty, skip if already inside a herdr session
      if [[ "$TERM_PROGRAM" == "ghostty" && -z "$HERDR_PANE_ID" ]]; then
        exec herdr
      fi


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
    enable = false;
    enableZshIntegration = false;
    attachExistingSession = true;
    exitShellOnExit = false;
    settings = {
      theme = "tokyo-night";
      pane_frames = true;
      default_layout = "compact";
      ui.pane_frames.hide_session_name = true;
    };
    extraConfig = ''
      keybinds {
        locked {
          bind "Ctrl g" { SwitchToMode "Normal"; }
        }
        normal {
          unbind "Ctrl b"
        }
        shared_except "locked" {
          bind "Alt f" { ToggleFocusFullscreen; }
          bind "Alt t" { NewTab; }
        }
        tab {
          bind "Ctrl t" { SwitchToMode "Normal"; }
        }
      }
    '';
  };
}
