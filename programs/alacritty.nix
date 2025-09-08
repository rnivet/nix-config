{
  pkgs,
  hostConf,
  ...
}: {
  programs.alacritty = {
    enable = true;
    theme = "iterm";
    settings = {
      general = {
        working_directory = hostConf.homedir + "/projects";
      };
      window = {
        padding.x = 10;
        padding.y = 10;
        decorations = "Buttonless";
        opacity = 0.8;
        blur = true;
        startup_mode = "Maximized";
        option_as_alt = "OnlyLeft";
      };
      font = {
        normal = {
          family = "MesloLGS Nerd Font Mono";
          style = "Regular";
        };
        size = 14.5;
      };
      env = {
        TERM = "xterm-256color";
      };
      terminal = {
        shell = {
          program = "/bin/zsh";
          args = [
            "-l"
            "-c"
            "zellij attach --index 0 || zellij"
          ];
        };
      };
    };
  };
}
