{...}: {
  home.file.".config/herdr/config.toml".text = ''
    onboarding = false

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
    open_worktree = "alt+g"
    remove_worktree = "alt+shift+g"

    [worktrees]
    directory = "~/projects"

    [ui]
    agent_panel_sort = "priority"
    show_agent_labels_on_pane_borders = true

    [ui.toast]
    delivery = "off"

    [ui.sidebar.spaces]
    row_gap = 1

    [experimental]
    kitty_graphics = true
  '';
}
