{...}: {
  home.file.".config/herdr/plugins/config/herdr-focus-notify/.env".text = ''
    HERDR_FOCUS_NOTIFY_ACTIVATE_APP=Ghostty
  '';

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

    [ui]
    agent_panel_sort = "priority"

    [ui.toast]
    delivery = "system"

    [ui.sidebar.spaces]
    row_gap = 1

    [experimental]
    kitty_graphics = true
  '';
}
