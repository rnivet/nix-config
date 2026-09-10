{...}: {
  # herdr-terminal-notifier (dot/herdr-terminal-notifier).
  # Config layer 3: $HERDR_PLUGIN_CONFIG_DIR/config.env, keyed on the plugin id.
  home.file.".config/herdr/plugins/config/dot.terminal-notifier/config.env".text = ''
    # Only Ghostty hosts herdr, so the frontmost check never mistakes another
    # app for the terminal. Static whitelist, never learned from what is
    # frontmost when an event fires.
    TERMINAL_APP_IDS="com.mitchellh.ghostty"

    # herdr 0.9.0 split pane focus from workspace focus: `agent focus` alone
    # leaves the active workspace untouched, so the click has to switch the
    # space itself. CLICK_COMMAND is prefixed with the resolved herdr binary
    # and run through a shell, hence the chain. Absolute paths: a click is
    # launched by the notifier app with a bare PATH.
    CLICK_COMMAND="agent focus {pane} && /opt/homebrew/bin/herdr workspace focus {workspace} && /usr/bin/open -a Ghostty"
  '';

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
