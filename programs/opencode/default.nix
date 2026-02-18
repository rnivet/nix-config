{pkgs-unstable, ...}: {
  home.packages = [
    pkgs-unstable.opencode
  ];

  # home.file = {
  #   ".config/opencode/config.json".source =
  #     if hostConf.profile == "work"
  #     then ./config-work.json
  #     else ./config-personal.json;
  # };
  #
  # home.file = {
  #   ".config/opencode/AGENTS.md".source = ./AGENTS.md;
  # };

  # home.file."./.config/opencode/agent/" = {
  #   source = ./agent;
  #   recursive = true;
  # };
}
