{
  pkgs,
  pkgs-unstable,
  ...
}: {
  home.packages = [
    pkgs.bat
    pkgs.btop
    pkgs.curl
    pkgs.devenv
    pkgs.dos2unix
    pkgs.fzf
    pkgs.gnused
    pkgs.imagemagick
    pkgs.jq
    pkgs.lazydocker
    pkgs-unstable.llmfit
    pkgs.mactop
    pkgs.ngrok
    pkgs.ripgrep
    pkgs.unzip
    pkgs.wget
  ];

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [];
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    colors = "auto";
    extraOptions = [];
    git = true;
    icons = "auto";
    theme = "tokyonight";
  };
}
