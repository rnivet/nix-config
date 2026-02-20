{
  pkgs,
  hostConf,
  ...
}: {
  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty-bin;
    enableZshIntegration = true;
    settings = {
      term = "xterm-256color";
      theme = "TokyoNight Moon";
      macos-option-as-alt = "left";
      font-family = "MesloLGS Nerd Font Mono";
      font-size = 14.5;
      working-directory = hostConf.homedir + "/projects";
      maximize = true;
      quit-after-last-window-closed = true;
      keybind = [
        "alt+t=unbind"
        "alt+arrow_left=unbind"
        "alt+arrow_right=unbind"
      ];
    };
  };
}
