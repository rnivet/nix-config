{
  pkgs,
  hostConf,
  ...
}: {
  programs.alacritty = {
    enable = false;
    settings = {
      working_directory = hostConf.homedir + "/projects";
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
      # ITerm theme
      colors = {
        primary = {
          background = "#101421";
          foreground = "#fffbf6";
        };
        normal = {
          black = "#2e2e2e";
          red = "#eb4129";
          green = "#abe047";
          yellow = "#f6c744";
          blue = "#47a0f3";
          magenta = "#7b5cb0";
          cyan = "#64dbed";
          white = "#e5e9f0";
        };
        bright = {
          black = "#565656";
          red = "#ec5357";
          green = "#c0e17d";
          yellow = "#f9da6a";
          blue = "#49a4f8";
          magenta = "#a47de9";
          cyan = "#99faf2";
          white = "#ffffff";
        };
      };
    };
  };
}
