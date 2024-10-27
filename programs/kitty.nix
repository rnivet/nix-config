{
  pkgs,
  hostConf,
  ...
}: {
  programs.kitty = {
    enable = true;
    font = {
      name = "MesloLGS Nerd Font Mono";
      size = 14.5;
    };
    themeFile = "tokyo_night_storm";
    settings = {
      active_tab_background = "lightGreen";
      color7 = "#ffffff";
      foreground = "#ffffff";
      hide_window_decorations = "titlebar-only";
      selection_background = "#ffffff";
      selection_foreground = "#414868";
      tab_bar_edge = "top";
      tab_bar_style = "powerline";
      tab_bar_align = "left";
      tab_title_template = "{tab.active_wd}";
    };
  };
}
