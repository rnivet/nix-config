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
      tab_bar_edge = "top";
      tab_bar_style = "powerline";
      tab_bar_align = "center";
      tab_title_template = "{tab.active_wd}";
      # foreground = "#ffffff";
      color15 = "#ffffff";
    };
  };
}
