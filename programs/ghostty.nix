{
  pkgs,
  hostConf,
  ...
}: {
  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty-bin;
    enableZshIntegration = true;
    clearDefaultKeybinds = true;
    settings = {
      theme = "TokyoNight Moon";
      macos-option-as-alt = true;
      font-family = "MesloLGS Nerd Font Mono";
      font-size = 14.5;
      working-directory = hostConf.homedir + "/projects";
      maximize = true;
      quit-after-last-window-closed = true;
    };
  };
}
