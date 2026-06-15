{...}: {
  home.file.".config/herdr/config.toml".text = ''
    [theme]
    name = "tokyo-night"

    [theme.custom]
    subtext0 = "#DCE1F9"
    overlay0 = "#DCE1F9"
    overlay1 = "#DCE1F9"

    [keys]
    new_tab = "alt+t"
    zoom = "alt+f"
    next_tab = "alt+right"
    previous_tab = "alt+left"
    navigate_workspace_up = "cmd+up"
    navigate_workspace_down = "cmd+down"

    [ui.toast]
    delivery = "system"

    [experimental]
    kitty_graphics = true
  '';
}
