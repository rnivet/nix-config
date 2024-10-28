{
  config,
  pkgs,
  ...
}: {
  programs.kitty = {
    enable = true;
    package = config.lib.nixGL.wrap pkgs.kitty;
    font = {
      name = "MesloLGS Nerd Font Mono";
      size = 14.5;
    };
    themeFile = "tokyo_night_storm";
    keybindings = {
      "cmd+right" = "next_tab";
      "cmd+left" = "previous_tab";
    };
    settings = {
      term = "xterm-256color";
      macos_option_as_alt = "left";
      allow_remote_control = "yes";
      active_tab_background = "lightGreen";
      color7 = "#ffffff";
      foreground = "#ffffff";
      hide_window_decorations = "titlebar-only";
      selection_background = "#ffffff";
      selection_foreground = "#414868";
      tab_bar_edge = "top";
      tab_bar_style = "powerline";
      tab_bar_align = "left";
      tab_title_template = "{title}";
      tab_bar_min_tabs = 1;
    };
  };

  programs.zsh.initExtra = ''
    # Update kitty tab name automatically
    kitty_tab_name_update() {
      host=$(hostname)
      if [[ -n $KITTY_PID ]]; then
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
        command nohup kitten @ set-tab-title --match state:focused ''${host%.*}:$tab_name >/dev/null 2>&1
      fi
    }
    kitty_tab_name_update
    chpwd_functions+=(kitty_tab_name_update)
  '';
}
