{pkgs, ...}: {
  home.packages = [
    pkgs.oh-my-posh
    (pkgs.nerdfonts.override {fonts = ["Meslo"];})
  ];

  home.file = {
    ".config/oh-my-posh/config.yml".source = ./oh-my-posh.yml;
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    initExtra = ''
      # Start oh-my-posh
      eval "$(oh-my-posh init zsh --config $HOME/.config/oh-my-posh/config.yml)"

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
    oh-my-zsh = {
      enable = true;
      extraConfig = ''
        zstyle :omz:update mode auto
        zstyle :omz:plugins:ssh-agent agent-forwarding yes
      '';
      plugins = [
        "ssh-agent"
        "git"
        "docker"
        "docker-compose"
      ];
    };
  };

  programs.atuin = {
    enable = true;
    flags = ["--disable-up-arrow"];
    settings = {
      filter_mode_shell_up_key_binding = "session";
      enter_accept = true;
    };
  };

  programs.zellij = {
    enable = true;
    enableZshIntegration = false;
    settings = {
      theme = "tokyo-night";
    };
  };
}
